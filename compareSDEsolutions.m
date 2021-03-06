clear all;
close all;

% time frame
T=2;
deltaT = 0.01;

t=0:deltaT:T;

% paths parameters
nbPaths = 10;
nbPoint = length(t);

% parameters
X0 = 100;
a=0.05;
b=0.2;

% compute the brownian motion for different path
W = zeros(nbPoint + 1,nbPaths);
Z = randn(nbPoint,nbPaths);
deltaW = zeros(nbPoint + 1,nbPaths);

for i = 1 : nbPoint
  W(i+1,:)= W(i,:) + sqrt(deltaT) * Z (i,:);
  deltaW(i+1,:) = W(i+1,:) - W(i,:);
endfor;

% compute the exact solution
Xr = X0 * ones(nbPoint + 1,nbPaths);

[nbRow,NbCol] = size(Xr);
for i=1 : nbRow -1
  for j=1:NbCol
    Xr(i+1,j) = X0 * exp((a-b*b/2)*i*deltaT + b * W(i+1,j));
  endfor;
endfor;

figure(1)
plot(Xr)
title("Exact solution")

% compute the solution according to Euler approach
Xe = X0*ones(nbPoint+1,nbPaths);
S = 0.01;
for i = 1 : nbPoint
  Xe(i+1,:) = Xe(i,:) .* (1 + a * S + b * deltaW(i+1,:));
endfor;

figure(2)
plot(Xe)
title("Euler approach")

% compute the solution according to Milstein approach
Xm = X0*ones(nbPoint+1,nbPaths);
S = 0.01;
for i = 1 : nbPoint
  Xm(i+1,:) = Xm(i,:) .* (1 + a * S + b * deltaW(i+1,:) + (0.5*b*b*((deltaW(i+1,:).*deltaW(i+1,:))-S) ));
endfor;

figure(3)
plot(Xm)
title("Milstein approach")

% Show the error for one of the path

Ee = abs(Xr-Xe);
Em = abs(Xr-Xm);

figure(4)
plot(Ee(:,4),'r')
hold on
plot(Em(:,4),'b')
title("Absolute error of Milstein and Euler approach")
legend('Euler error', "Milstein error")
