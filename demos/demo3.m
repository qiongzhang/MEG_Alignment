%% This file demonstrates how to use CCA weights caculated from averaged data to obtain single-trial CCAs
%   Date           Programmers               Description of change
%   ====        =================            =====================
%  09/10/2016     Qiong Zhang                 Original code

%% Citation
%  Zhang,Q., Borst,J., Kass, R.E., & Anderson, J.A. (2016) Between-Subject
%  Alignment of MEG Datasets at the Neural Representational Space. 

%% Copyright 
%This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%       Step 0: load and format data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('averageData.mat') % dataAll: 1600{16 conditions * (50 stimulus locked samples averaged over all trials  + 50
                        % response locked samples averaged over all trials)} * 306 (sensors) * 18 (subjects)
load('singleTrials.mat')
data = temp(:,3:end); % singla trial data (samples * sensors);
prefix = temp(:,1:2); % data index (first column: subject index; second column: which sample of the trial)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%       Step 1: apply M-CCA to averaged data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

KK = 50; % number of PCAs to retain for each subject (can be adjusted)
K = 10;  % number of CCAs to retain (can be adjusted)
[W,mu,sigma,COEFF] = obtainCCA(dataAll,KK,K);
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      Step 2: transform single-trial data from sensor dimensions to CCA
%%%      dimensions (toy example: first 2 trials of subject 1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[CCAs] = tranformTrials(data,prefix,W,mu,sigma,COEFF,KK,K);
% dimensions in 'CCAs' are assumed to align from subject to subject


