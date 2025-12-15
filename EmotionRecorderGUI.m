function EmotionRecorderGUI
    % Create the GUI figure
    f = figure('Name','Emotion Recorder','Position',[500 400 400 300]);

    uicontrol('Style','text','Position',[100 250 200 30], ...
        'String','Select Emotion and Press Record','FontSize',12);

    % Dropdown menu
    emotionMenu = uicontrol('Style','popupmenu','Position',[100 210 200 30], ...
        'String',{'Select Emotion','Happy','Angry','Sad'},'FontSize',12);

    % Record button
    uicontrol('Style','pushbutton','Position',[150 160 100 40],'String','🎙 Record',...
        'FontSize',12,'Callback',@recordCallback);

    function recordCallback(~,~)
        emotions = {'Happy','Angry','Sad'};
        idx = emotionMenu.Value;

        if idx == 1
            msgbox('❗Please select an emotion first.');
            return;
        end

        selectedEmotion = emotions{idx - 1};
        fs = 44100;
        recObj = audiorecorder(fs, 16, 1);

        msgbox(['🎙 Recording 3 seconds of "' selectedEmotion '"...']);
        recordblocking(recObj, 3);
        y = getaudiodata(recObj);
        y = y / max(abs(y)); % Normalize

        % Fixed path for your folder
        baseFolder = 'C:\Users\ken llamanzares\Desktop\Digital ears1';
        folderPath = fullfile(baseFolder, selectedEmotion);
        if ~exist(folderPath, 'dir')
            mkdir(folderPath);
        end

        filename = fullfile(folderPath, ['sample_' datestr(now,'HHMMSS') '.wav']);
        audiowrite(filename, y, fs);

        msgbox(['✅ File saved at: ' filename],'Success');
        disp(['✅ Saved: ' filename]);
    end
end
