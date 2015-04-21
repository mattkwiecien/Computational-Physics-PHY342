function [  ] = audiofft( filename, in_freq )
%% time bounds of file input
s1=66;
s2=71;
%reading in audio data
[y, rate]=audioread(filename, [s1 s2]*44100 + 1 );
[samples, ~]= size(y);
%taking all frequencies above the nyquist frequency and shifting them to
%the left
freq = (rate/(samples)) * ( (1:samples)-ceil(samples/2) )  ;

%% forward transforms
L = fft(y(:,1));
R = fft(y(:,2));
fL=fftshift(L);
fR=fftshift(R);
%filtering out frequencies above in_rate
filter = find(abs(freq) > in_freq);
fL(filter)=0;
fR(filter)=0;
%getting new sound data and using inverse fftshift
newL = ifft(ifftshift(fL));
newR = ifft(ifftshift(fR));

%% plotting the original fourier transform and original data
figure
hold on

%left and right transforms
subplot(2,2,1)
plot( freq , fftshift(abs(L)), 'r')
xlim([-20000,20000])
title('Raw FFT of Left Channel')
ylabel('|Y(f)|')
xlabel('Frequency')
subplot(2,2,2)
plot( freq , fftshift(abs(R)), 'b');
xlim([-20000,20000])
title('Raw FFT of Right Channel')
ylabel('|Y(f)|')
xlabel('Frequency')

%left and right channels
subplot(2,2,3)
plot( freq, y(:,1), 'r')
xlim([-20000,20000])
title('Left Channel')
ylabel('Amplitude')
xlabel('Frequency')
subplot(2,2,4)
plot(freq, y(:,2), 'b')
xlim([-20000,20000])
title('Right Channel')
ylabel('Amplitude')
xlabel('Frequency')

%% plotting the filtered fourier transform and new data
figure
hold on

%left and right transforms
subplot(2,2,1)
plot( freq , abs(fL), 'r')
xlim([-20000,20000])
title('Filtered FFT of Left Channel')
ylabel('|Y(f)|')
xlabel('Frequency')
subplot(2,2,2)
plot( freq , abs(fR), 'b');
xlim([-20000,20000])
title('Filtered FFT of Right Channel')
ylabel('|Y(f)|')
xlabel('Frequency')

%left and right channels
subplot(2,2,3)
plot( freq, (newL), 'r')
xlim([-20000,20000])
title('Filtered Left Channel')
ylabel('Amplitude')
xlabel('Frequency')
subplot(2,2,4)
plot(freq, (newR), 'b')
xlim([-20000,20000])
title('Filtered Right Channel')
ylabel('Amplitude')
xlabel('Frequency')

%%  Play new sound
newY=horzcat(newL,newR);
pause
sound(y, 44100)
pause
sound(real(newY),44100)

end

