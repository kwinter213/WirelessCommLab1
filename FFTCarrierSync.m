% Open the file containing the received samples
f2 = fopen('rx.dat', 'rb');

% read data from the file
tmp = fread(f2, 'float32');

% close the file
fclose(f2);


% since the USRP stores the data in an interleaved fashion
% with real followed by imaginary samples 
% create a vector of half the length of the received values to store the
% data. Make every other sample the real part and the remaining samples the
% imaginary part
y = zeros(length(tmp)/2,1);
y = tmp(1:2:end)+j*tmp(2:2:end);

y_start = 1;
y_end = length(y);
keep_looking = true;
abs_mean = abs(mean(real(y)));

for n = 1:length(y)
    if keep_looking && (abs(y(n)) >4.5e2 * abs_mean)
        y_start = n;
        keep_looking = false;
    end
end

keep_looking = true;

for n = length(y):-1:1
    if keep_looking && (abs(y(n)) > 6e2 * abs_mean)
        y_end = n;
        keep_looking = false;
    end
end

y_pkt = y((y_start):(y_end+4));

mag_h_est = rms(abs(y_pkt));

y_est = y_pkt/mag_h_est;
s_time = y_est.^4;
s_freq = fft(s_time);
[spikeVal, fourDelta] = max(s_freq);
delta = -1*(2*pi*(length(s_freq)-1)/length(s_freq))*(fourDelta-1)/((length(s_freq))*4);
theta = -angle(spikeVal)/4;

x_hat = zeros(length(y_est),1);
for k = 1:length(y_est)
    x_hat(k) = y_est(k)*exp(1i*(delta*(k-1)+theta));
end

rotation = exp(1i*pi/4);
x_hat = x_hat.*rotation;

x_adjust = zeros(length(x_hat),1);

for k = 1:length(x_hat)
   if real(x_hat(k)) < 0
      x_adjust(k) = x_adjust(k) - 1; 
   elseif real(x_hat(k)) > 0
      x_adjust(k) = x_adjust(k) + 1;
   end
   
   if imag(x_hat(k)) < 0
       x_adjust(k) = x_adjust(k) - 1*i;
   elseif imag(x_hat(k)) > 0
       x_adjust(k) = x_adjust(k) + 1*i;
   end
       
end

plot(real(x_hat))
title('Real xhat');
figure 
plot(imag(x_hat))
title('Imaginary xhat');
figure
%{
plot(real(y_pkt))
title('Real ypkt');
figure
%}
plot(real(x_hat),imag(x_hat),'.')

title('Constellation');
figure
plot(real(x_adjust));
title('Real Adjust');
figure
%plot(imag(x_adjust));
%title('Imaginary Adjust');
%figure
plot(real(TransmittedData));
