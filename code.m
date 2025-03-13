clc;
clear all;
%Loading the carotid pulse signal
y = readtable('PWs_Carotid.txt');
y = table2array(y);
y = y(21,:);
y = y(2:488);
figure(1)
subplot(221)
plot(y);
title('Carotid Pulse Signal');
xlabel('sample');
ylabel('y(n) signal');
N = length(y);
%second order derivative
for n=3:N-2
     p(n) = 2*y(n-2) + y(n-1)-2*y(n)-y(n+1)+ 2*y(n+2);
end

subplot(222)
plot(p);
title('p(n)');
xlabel('sample');
ylabel('p(n)');
p = p.*p;
M =16;
s = zeros(1,N-2);
% calculating the featured signal s(n)
for  n = 1:length(p)-113
    for k =1:M
        w(k) = M-k+1;      
        s(n)= s(n) + p(k+n+1)*w(k);        
    end
end
subplot(223)
plot(s);
title('featured signal, s(n)');
xlabel('sample');
ylabel('s(n)');

% 16th order butterworth filter
fc = 15;
fs = 256;
[b,a] = butter(16,fc/(fs/2));
s = filter(b,a,s);
subplot(224)
plot(s);
title(' s(n) signal after filtering by 16 order Butterworth filter');
xlabel('sample');
ylabel('s(n)');
figure(2)
%peak searching algorithm
threshold1 = 210;
threshold2= 380;
peaks = zeros(1,length(s));
for i = 2:length(s)-1
    if(s(i)> threshold1 && s(i)< threshold2 && s(i-1)<s(i) && s(i+1)<s(i))
        peaks(i) = 1;
    end
end

%plotting the dicrotic notch peak 
plot(peaks);
title('Detection of position dicrotic notch in carotid pulse');
xlabel('sample');
ylabel('peaks');
