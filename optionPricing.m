%In this program we compare two different ways to price an option:
% - Black-Scholes
% - Monte Carlo
%
%Monte Carlo is useful if:
% - Differential equation cannot be solved (see Milstein and Euler solution)
% - options which are stronly path-dependant
% - high dimensionality
%
clear all;
close all;

%------------------- parameters -----------------

%free risk interest rate
r = 0.05;

%volatility
sigma = 0.2;

%initial stock price
S0 = 110;

%strike
K=100;

%maturity date
T = 1;

%------------------------------------------------

%compute d1 and d2 for Black Scholes formula
d1 = (log(S0/K) + r * T) / (sigma*sqrt(T)) + 0.5*sigma*sqrt(T);
d2 = d1 - sigma * sqrt(T);

Nd1 = stdnormal_cdf(d1);
Nd2 = stdnormal_cdf(d2);

%Black-Scholes option price:
Ce = S0 * Nd1 - K*exp(-r*T)*Nd2;

%simulation parameters
nbPoint = 300;
deltaT = T / nbPoint;

%define how much tests we should perform and how much paths we should consider
%each column (x,y) will be:
%  x the number of random paths to simulate
%  y the price of the option
optionPrices = 1:5:3000;
nbTests = length(optionPrices);

%the zeros will be filled with the prices for each simulation
optionPrices=[optionPrices;zeros(1,nbTests)];
error = optionPrices;
%start calculating
for j=1:nbTests
  nbPath = optionPrices(1,j);
  Scurrent = S0 * ones(nbPath,1);

  Snext = zeros(nbPath,1);

  for i = 1:nbPoint
    dW = sqrt(deltaT) * randn(nbPath,1);
    Snext = Scurrent + r * Scurrent * deltaT + sigma * Scurrent .* dW;
    Scurrent = Snext;
  endfor;

  Ca = exp(-r * T) * mean (max(0,Scurrent-K));
  optionPrices(2,j) = Ca;
  error(2,j) = abs(Ca - Ce)/Ce;
endfor;

figure(1)
hold on;
plot(optionPrices(1,:),optionPrices(2,:),'r')
plot(optionPrices(1,:),Ce*ones(1,nbTests),'--b')
legend("Monte Carlo","Black-Scholes")
title ("Compare two methods of option pricing");
xlabel ("Number of simulations");
ylabel ("Option price");
hold off;
print -djpg output/prices.jpg

figure(2)
plot(error(1,:),error(2,:),'r')
title ("Relative error of Monte Carlo approach");
xlabel ("Number of simulations");
ylabel ("Error");
print -djpg output/error.jpg