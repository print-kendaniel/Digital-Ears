% DIGITAL EARS: Basic Emotion Detection from Voice Signal
% Author: (Insert your name here)

clc; clear; close all;

%% STEP 1: Load a voice sample
% Make sure may .wav file ka sa folder
[signal, fs] = audioread('voice_sample.wav'); % <<-- Palitan mo ng filename mo kung iba

% Play the audio
sound(signal, fs);
disp('Playing audio...');

%% STEP 2: Preprocessing
% Normalize the signal
signal = signal / max(abs(signal));

%% STEP 3: Feature Extraction (Simple)
% Get basic features: Energy and Pitch
frameLength = round(0.03 * fs); % 30ms frames
overlap = round(0.02 * fs); % 20ms overlap

% Pitch extraction
try
    pitchVal = pitch(signal, fs, 'WindowLength', frameLength, 'OverlapLength', overlap);
catch
    warning('Pitch function not available. Check if Audio Toolbox is installed.');
    pitchVal = mean(abs(signal)); % fallback simple value
end

avgPitch = mean(pitchVal); % average pitch

% Energy extraction
energy = sum(signal.^2) / length(signal); % average energy

%% STEP 4: Simple Emotion Detection (Using rules)

% Sample Thresholds (kailangan i-tune ito sa real project)
if avgPitch > 200 && energy > 0.01
    emotion = 'Happy';
elseif avgPitch < 150 && energy < 0.005
    emotion = 'Sad';
elseif avgPitch > 250
    emotion = 'Angry';
else
    emotion = 'Neutral';
end

%% STEP 5: Output the result
disp(['Detected Emotion: ' emotion]);

%% (Optional) Plot the signal
figure;
plot(signal);
title('Voice Signal');
xlabel('Time');
ylabel('Amplitude');
