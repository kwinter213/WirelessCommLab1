%signal=read_usrp_file;
%%trim here --cross correlate with header


%%estimate/divide out magnitude of h
mag_h_est=rms(abs(signal));
ybar=signal/mag_h_est;

%Square signal b/c of BPSK
sigbar=ybar.^2;

%take fft
est=fft(sigbar);
plot(abs(est));

[spikeVal, twofdelta]=max(est);

%extract fdelta
fdelta= -1*twofdelta/2;

%extract theta
theta=angle(spikeVal)/2;
xbar=zeros(1,length(ybar));
for k=1:length(ybar)
    xbar(k)=ybar(k)*exp(fdelta*k*i)*exp(theta*i);
end
plot(real(xbar))