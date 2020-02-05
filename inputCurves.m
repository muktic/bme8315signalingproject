% PMID 21402405 Figure 2
% Delayed release
x_delayed = 24*[0.07, 0.34, 1.13, 2.12, 3.06, 4.05, 5.03];
y_delayed = [0, 8.99, 14.66, 15.64, 17.60, 21.51, 23.86];
p_delayed = polyfit(x_delayed, y_delayed, 1);
x1_delayed = 0:1:120;
f_delayed = polyval(p_delayed, x1_delayed); 
plot(x_delayed, y_delayed, 'o', x1_delayed, f_delayed, 'r');

% PMID 20674970 Figure 2B, left panel
% Sustained release
f_sustained = @(x,xdata) x(1)*(xdata.^x(2));
x_sustained = [3.06, 6.13, 24.07, 95.96];
y_sustained = [1.13, 1.66, 2.63, 3.07];
x0 = [100; -1];
[coeff_sustained] = lsqcurvefit(f_sustained, x0, x_sustained, y_sustained);
x1_sustained = [0:1:120];
y1_sustained = f_sustained(coeff_sustained, x1_sustained);
plot(x_sustained, y_sustained, 'o', x1_sustained, y1_sustained);

% PMID 15020152 Figure 6a (open triangles)
% Burst release
x_burst = 24*[1, 2.63, 4.21, 5.79];%, 7.43, 9.01, 10.62, 12.20, 13.83, 15.41, 17.05];
y_burst = [40.44, 15.02, 12.07, 6.46];%, 4.77, 2.94, 0.56, 0.56, 0.56, 0.28, 0.14];
f_burst = @(x,xdata) x(1)*log(xdata) + x(2);
x0_burst = [1; 1];
[coeff_burst] = lsqcurvefit(f_burst, x0_burst, x_burst, y_burst);
x1_burst = [0:1:120];
y1_burst = f(coeff, x1);
plot(x_burst, y_burst, 'o', x1_burst, y1_burst);

% Pulse like release, based on burst release 
y1_pulse = [y1_burst(1:(length(y1_burst)/2)+1)  y1_burst(1:(length(y1_burst)/2))];
plot(x1_burst, y1_pulse);