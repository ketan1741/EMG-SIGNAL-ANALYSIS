
clc 
close all
close 
%Respected sir,
% Please do read the comment lines for clear understanding of our
% implementation and algorithm of emg signal data analysis.
fq = 1000; 
load('001-001-dataset.mat')
time=[0.001:0.001:104600*0.001]';

%Run the dataset '.m' file provided in the zip file to generate the dataset
%variable data
data1 = rms(abs(data),2);

%the data is amplified by a factor of 1000 and the raw data is plotted.
figure; 
plot(time, data1.*1000); 
xlabel('Time/s','fontsize', 14); ylabel('Signal magnitude', 'fontsize', 14); 
title('Raw Data from EMG ', 'fontsize', 14);set(gca,'FontSize',14);

%the frequency response of the EMG signal.
shEMG1 = data1.*1000; %amplified by 1000
sEMG1_fft = fft(shEMG1); 
sEMG1_fft = fftshift(sEMG1_fft);
n = length(shEMG1);  
a_f = (-n/2:n/2-1)*fq/n; % zero-centered frequency range
abs_fft_sEMG1 = abs(sEMG1_fft);
figure; 
plot(a_f, abs_fft_sEMG1 ); axis([a_f(1) a_f(end) 0 1000]); 
xlabel('Frequency/Hz','fontsize', 14); ylabel('X(jw) magnitude','fontsize', 14); 
title('Frequency Domain ','fontsize', 14);
set(gca,'FontSize',14);


%generating a bandpass filter of (-450,-50) and (50,450)
highpass = 50;   
lowpass = 450;  

cutoff1 = ceil((fq/2-highpass)/(fq/length(shEMG1))); cutoff2 = ceil((fq/2-lowpass)/(fq/length(shEMG1)));
cutoff3 = ceil((highpass+fq/2)/(fq/length(shEMG1))); cutoff4 = ceil((lowpass+fq/2)/(fq/length(shEMG1)));

shEMG1 = data1; 
H0 = zeros(length(shEMG1),1);
H0(cutoff2:cutoff1) = 1; 
H0(cutoff3:cutoff4) = 1; 

figure; 
plot(a_f, H0); set(gca,'YLim',[0 2]); 
xlabel('Freqeuncy/Hz','fontsize', 14); ylabel('Amplitude','fontsize', 14);
title('Bandpass filter','fontsize', 14);set(gca,'FontSize',14);

%generally the significant activity of emg signals occurs in frequency range of 50 to 450 hz
ytt0=sEMG1_fft.*H0;
ytt1 = ifftshift(ytt0); 
ytt1 = ifft(ytt1);
t = 1/fq*(1:length(ytt1));
figure;
plot(a_f, abs(ytt0),'r');
ylabel('Amplitude','fontsize', 15);
xlabel('Frequency/Hz','fontsize', 15); 
title('Signal after bandpass filter ','fontsize', 15);
set(gca,'FontSize',15);

figure;
plot(t, real(ytt1),'r');
xlabel('Time/s','fontsize', 15); ylabel('Amplitude','fontsize', 15); 
title('Signal after bandpass filter ','fontsize', 15);set(gca,'FontSize',15);

%Finding the Mean Absolute Value of the Emg signal.
filter_bandpass = ones(20,1);
filter_bandpass = filter_bandpass/length(filter_bandpass);
MAV12 = zeros(length(ytt1),1);
v1 = zeros(length(ytt1),1);
MAV = conv(abs(real(ytt1)),filter_bandpass,'same');

%Plotting all the responses
figure;
hold on; 
plot(time,real(ytt1),'r');
plot(time,MAV,'linewidth',2); 
 
legend('EMG signal','MAV', 'location', 'Northeast');
xlabel('Time/s'); ylabel('Signal Amplitude'); title('Bicep'); grid on;
axis([0 round(max(time)) min(real(ytt1)) max(real(ytt1))]);
set(gca,'FontSize',15);
hold off;
figure;
plot(time,MAV,'linewidth',2); 
xlabel('Time/s'); ylabel('Signal Amplitude'); title('Mean Absolute Value of Signal');

%a threshold of MAV value=30 can be taken for movement detection

% Servo Motor Roatation according to the MAV graph, a threshold of 9 volt
% can be used to determine the movement of the limb. 

port = 'COM3';
board = 'Uno';
arduino_board = arduino(port, board, 'Libraries', 'Servo');

servo_motor = servo(arduino_board, 'D8');

MAV2=MAV;
for i=1:length(MAV2)
    if MAV2(i)>=30
        MAV2(i)=30;
    end
    if MAV2(i)<=15
        MAV2(i)=0;
    end
end

for i=1:length(MAV2)
    
    j=(double(MAV2(i)))/15;
   writePosition(servo_motor,j);

   current_position = readPosition(servo_motor);

   current_position = current_position * 180;   
   if(current_position>=140)
       fprintf('Arm at full flex. \n')
   end
   if((current_position<140) &(current_position>0))
       fprintf('Arm is flexing. \n')
   end
   if(current_position==0)
       fprintf('Arm is at rest. \n')
   end

   fprintf('Current position is %d\n', current_position);   

   pause(0.015);

end

writePosition(servo_motor, 0);

