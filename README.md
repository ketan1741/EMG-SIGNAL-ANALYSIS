# EMG-SIGNAL-ANALYSIS

# DATASET DESCRIPTION:
The data of the emg signal was obtained from the website- http://zju-capg.org/myo/data/ and preprocessed. The rms value of the EMG data from multiple channels were taken and split into train-test data. The classification dataset which classifies movement with 1 and rest position with 0 was split into train-test data set according to the EMG signal values.

# DATA ANALYSIS AND PROCESSING:
Fourier analysis of the data was performed to analyze the noise in the EMG signal.
The analyzed data was passed through as band pass filter to eliminate the noise and obtain the EMG signal.

# Classification analysis:
The data processed was trained using Logistic Regression and the best results were obtained. So any new EMG signal passed through the Regression Model will classify the EMG signal with Movement as 1 and rest position as 0.
