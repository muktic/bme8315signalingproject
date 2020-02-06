% PMID 21402405 Figure 2
% Delayed Release
x = 24*[0.07, 0.34, 1.13, 2.12, 3.06, 4.05, 5.03];
y = [0, 8.99, 14.66, 15.64, 17.60, 21.51, 23.86];
p = polyfit(x, y, 1);
x1 = 0:1:120;
f = polyval(p, x1); 
figure ('color','white')
plot(x, y, 'o', x1, f, 'r');
title('Delayed Release')
xlabel('Time (hours)')
ylabel('Concentration Released')
legend('Literature Values', 'Fitted Curve')

% PMID 20674970 Figure 2B, left panel
% Sustained release
% f = @(x,xdata) x(1)*(xdata.^x(2));
f = @(x,xdata) x(1)*log(xdata+1) + x(2);
x = [3.06, 6.13, 24.07, 95.96];
y = [1.13, 1.66, 2.63, 3.07];
x0 = [100; -1];
[coeff] = lsqcurvefit(f, x0, x, y);
x1 = [0:1:100];
y1 = f(coeff, x1);
figure ('color','white')
plot(x, y, 'o', x1, y1);
title('Sustained Release')
xlabel('Time (hours)')
ylabel('Concentration released')
legend('Literature Values', 'Fitted Curve')
%%

% PMID 15020152 Figure 6a (open triangles)
% Burst release
x = 24*[1, 2.63, 4.21, 5.79];%, 7.43, 9.01, 10.62, 12.20, 13.83, 15.41, 17.05];
y = [40.44, 15.02, 12.07, 6.46];%, 4.77, 2.94, 0.56, 0.56, 0.56, 0.28, 0.14];
f = @(x,xdata) x(1)*log(xdata+1) + x(2);
x0 = [40; 1];
[coeff] = lsqcurvefit(f, x0, x, y);

%if we had made it exponential, originally was using this because the log
%func wasn't defined at 0 so throwing code off but fixed it
% A = [ones(length(x),1), x'];
% b = log(y');
% beta = A\b;
% coeff = [exp(beta(1)); beta(2)];

x1 = [0:1:140];
y1 = f(coeff, x1);
% y1 = coeff(1).*exp(x1*coeff(2));

figure ('color','white')
plot(x, y, 'o', x1, y1);
title('Burst Release')
xlabel('Time (hours)')
ylabel('Concentration released')
legend('Literature Values', 'Fitted Curve')