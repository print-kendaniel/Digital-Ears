% DIGITAL EARS: Basic Emotion Detection from Voice Samples (Folder Version)
clc; clear; close all;

%% STEP 1: Setup
baseFolder = 'C:\Users\Ken Llamanzares\Desktop\DigitalEars';
categories = {'Angry', 'Happy', 'Sad'};

% Para magstore ng features and labels
features = [];
labels = [];

%% STEP 2: Load voice samples from folders
for i = 1:length(categories)
    emotionFolder = fullfile(baseFolder, categories{i});
    audioFiles = dir(fullfile(emotionFolder, '*.wav')); % Lahat ng .wav sa folder

    for j = 1:length(audioFiles)
        filePath = fullfile(emotionFolder, audioFiles(j).name);
        [signal, fs] = audioread(filePath);

        % Preprocess: Normalize
        signal = signal / max(abs(signal));

        % Feature extraction: pitch and energy
        frameLength = round(0.03 * fs); % 30ms frames
        overlap = round(0.02 * fs); % 20ms overlap

        try
            pitchVal = pitch(signal, fs, 'WindowLength', frameLength, 'OverlapLength', overlap);
            avgPitch = mean(pitchVal);
        catch
            avgPitch = mean(abs(signal)); % fallback simple value
        end

        energy = sum(signal.^2) / length(signal);

        % Combine features
        featureVector = [avgPitch, energy];
        features = [features; featureVector];
        labels = [labels; i]; % 1 = Angry, 2 = Happy, 3 = Sad
    end
end

disp('Finished loading and extracting features!');
disp('Features:');
disp(features);

%% STEP 3: Train simple classifier (SVM)
model = fitcsvm(features, labels);

%% STEP 4: Test with a new voice sample
% (Sample: kumuha tayo ng isang file manually para i-test)
[testSignal, testFs] = audioread('C:\Users\Ken Llamanzares\Desktop\DigitalEars\Happy\sample1.wav');

% Preprocessing
testSignal = testSignal / max(abs(testSignal));

% Feature extraction
try
    testPitch = pitch(testSignal, testFs, 'WindowLength', frameLength, 'OverlapLength', overlap);
    avgTestPitch = mean(testPitch);
catch
    avgTestPitch = mean(abs(testSignal));
end
testEnergy = sum(testSignal.^2) / length(testSignal);

testFeature = [avgTestPitch, testEnergy];

% Predict
predictedLabel = predict(model, testFeature);

% Convert label to emotion text
predictedEmotion = categories{predictedLabel};

%% STEP 5: Output the result
disp(['Detected Emotion: ' predictedEmotion]);
sound(testSignal, testFs);
