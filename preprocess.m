EEG.data = data.eeg{2}';
EEG.srate = 128;
EEG.nbchan = 32;

EEG.chanlocs = [];
EEG.chanlocs(1).labels = 'Cz';
% EEG.chanlocs(1).X = ...;
% EEG.chanlocs(1).Y = ...;
% EEG.chanlocs(1).Z = ...;

chan_names = data.dim.chan.eeg{1,1};

for i = 1:length(chan_names)
    EEG.chanlocs(i).labels = chan_names{i};  % 或 chan_names(i) 視格式而定
end

EEG = pop_chanedit(EEG, 'lookup','C:\\Users\\richi\\Downloads\\eeglab2023.1\\eeglab2023.1\\plugins\\dipfit\\standard_BEM\\elec\\standard_1005.elc','lookup','C:\\Users\\richi\\Downloads\\eeglab2023.1\\eeglab2023.1\\functions\\supportfiles\\channel_location_files\\eeglab\\Standard-10-20-Cap81.ced');
EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1,'interrupt','on');
EEG = pop_iclabel(EEG, 'default');



pop_viewprops






