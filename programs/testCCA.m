function [correlations10] = testCCA(data,dataL,W,mu,sigma,COEFF,KK,K)
%% test if the inter-subject correlations/consistency observed from training
% data CCAs generalize over testing data
%   Date           Programmers               Description of change
%   ====        =================            =====================
%  09/10/2016     Qiong Zhang                 Original code
%% Citation
%  Zhang,Q., Borst,J., Kass, R.E., & Anderson, J.A. (2016) Between-Subject
%  Alignment of MEG Datasets at the Neural Representational Space. 

%% INPUT
% data - input training data to CCA (samples * sensors * subjects)
% dataL - testing data for CCA (samples * sensors * subjects)
% W - CCA weights that transform PCAs to CCAs for each subject (PCAs * CCAs * subjects)
% For each subject i:
% mu{i} - PCA mean 
% sigma{i} - PCA standard deviation
% COEFF{i} - PCA weights that tranform sensors to PCAs for each subject (sensors * PCAs)
% KK - number of PCAs to retain for each subject
% K - number of CCAs to retain

%% OUTPUT
% correlations10 - inter-subject correlations (averaged over every pair of subjects) over every CCA component
% (first row: training data;  second row: testing data)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dim = size(data,1); % nunber of sensors
num = size(data,2); % number of time points
sub = size(data,3); % number of subjects
mdata = zeros(K,num,sub);
mdataL = zeros(K,num,sub);
for i = 1:sub
   data(:,:,i) = (data(:,:,i)'*COEFF{i})'; % PCAs obtained
   dataL(:,:,i) = (dataL(:,:,i)'*COEFF{i})'; % PCAs obtained
   tmu = repmat(mu{i}',1,num);
   tsigma = repmat(sigma{i}',1,num);
   data(:,:,i) = (data(:,:,i)-tmu)./tsigma; % centered and normalized 
   mdata(:,:,i) = W(:,:,i)'*data(1:KK,:,i); % CCAs obtained
   dataL(:,:,i) = (dataL(:,:,i)-tmu)./tsigma; % centered and normalized 
   mdataL(:,:,i) = W(:,:,i)'*dataL(1:KK,:,i); % CCAs obtained
end
correlations10 = zeros(K,2);
for i = 1:K
   correlations10(i,1) = mean(mean(corr(squeeze(mdata(i,:,:))))); % inter-subject correlations over training data
   correlations10(i,2) = mean(mean(corr(squeeze(mdataL(i,:,:))))); % inter-subject correlations over testing data
end

end

