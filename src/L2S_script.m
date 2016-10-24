clc
clear all
close all

global c_sim;

tic

%% Initialize variables

L2S = true; % Flag for L2S simulation

% Maximum number of channel realizations
L2SStruct.maxChannRea = 20;
% Channel models
L2SStruct.chan_multipath = {'B'};
% Standards to simulate
L2SStruct.version = {'802.11n'};
% Channel bandwidths
L2SStruct.w_channel = [20];
% Cyclic prefixes
L2SStruct.cyclic_prefix = {'long'};
% Data length of PSDUs in bytes
L2SStruct.data_len = [1000];
% Beta range and resolution
L2SStruct.betas = 0.5:0.1:30;

% Display simulation status
L2SStruct.display = true;

L2SStruct.folderName = 'L2SResults3';

hsr_script; % Initialize c_sim

%% Simulate to calculate SNRps and PERs

L2S_simulate(L2SStruct,parameters);

toc

%% Optimize beta

tic

configNum = length(L2SStruct.chan_multipath)*length(L2SStruct.version)*...
    length(L2SStruct.w_channel)*length(L2SStruct.cyclic_prefix)*...
    length(L2SStruct.data_len);
totalSimNum = configNum*L2SStruct.maxChannRea;

for numSim = 1:L2SStruct.maxChannRea:(totalSimNum - L2SStruct.maxChannRea + 1)
    
    [SNRp_mtx,per_mtx,snrAWGN_mtx,perAWGN_mtx] = L2S_load(numSim,L2SStruct);
    [beta,rmse,rmse_vec] = L2S_beta(SNRp_mtx,per_mtx,snrAWGN_mtx,perAWGN_mtx,L2SStruct);
    
    filename = [L2SStruct.folderName '\L2S_beta_results_' ...
        num2str((numSim + L2SStruct.maxChannRea - 1)/L2SStruct.maxChannRea)...
        '.mat'];
    save(filename,'L2SStruct','beta','rmse','rmse_vec');
    
end

toc
disp('Done!');

%% Plot
for k = 1:configNum
    filename = [L2SStruct.folderName '\L2S_beta_results_' num2str(k) '.mat'];
    load(filename);
    figure(k);
    plot(L2SStruct.betas,rmse_vec,'LineWidth',2);
    legend('MCS0','MCS1','MCS2','MCS3','MCS4','MCS5','MCS6','MCS7');
    xlabel('\beta');
    ylabel('rmse');
    title(['Scenario ' num2str(k)]);
end