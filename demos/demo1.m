%% This file demonstrates how to split your data into halves to evalute how well the obtained CCAs are
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
currentpath = cd('..');
parentpath = pwd();
addpath(genpath(parentpath))
load('averageDataEven.mat')
% dataEven: 1600(16 conditions * (50 stimulus locked samples averaged over even trials  + 50
% response locked samples averaged over even trials)) x 306 (sensors) x 18 (subjects)
load('averageDataOdd.mat')
% dataOdd: same format as dataEven but averaged over odd trials 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%       Step 1: apply M-CCA (training) to half of the data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

KK = 50; % number of PCAs to retain for each subject (can be adjusted)
K = 20;  % number of CCAs to retain (can be adjusted)
[W,mu,sigma,COEFF] = obtainCCA(dataEven,KK,K,0,0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      Step 2: testing on left-out half of the data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[correlations20] = testCCA(dataEven,dataOdd,W,mu,sigma,COEFF,KK,K);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      Step 3: visualize the CCA performance (inter-subject correlations over testing data)
%%%      This gives the same plot as Figure 4 in the paper
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure,plot(correlations20)
legend('training','testing')
xlabel('CCA components')
ylabel('averaged inter-subject correlations')



