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
    if keep_looking && (y(n) > 2e3 * abs_mean)
        y_start = n;
        keep_looking = false;
    end
end

keep_looking = true;

for n = length(y):-1:1
    if keep_looking && (y(n) > 2e3 * abs_mean)
        y_end = n;
        keep_looking = false;
    end
end

y_pkt = y(y_start:y_end);

mag_h_est = rms(abs(y_pkt));

y_est = y_pkt/mag_h_est;
s_time = y_est.^2;
s_freq = fft(s_time);
[spikeVal, twoDelta] = max(s_freq);
delta = -1*2*pi*(twoDelta-1)/(length(s_freq)*2);
theta = angle(spikeVal)/2;

x_hat = zeros(length(y_est),1);
for k = 1:length(y_est)
    x_hat(k) = y_est(k)*exp(i*(delta*k+theta));
end
plot(real(x_hat))
