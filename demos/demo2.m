%% This file demonstrates how to split your data into halves to evalute the obtained CCAs when regularization is added
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
load('averageDataEven.mat')
% dataEven: 1600(16 conditions * (50 stimulus locked samples averaged over even trials  + 50
% response locked samples averaged over even trials)) x 306 (sensors) x 18 (subjects)
load('averageDataOdd.mat')
% dataOdd: same format as dataEven but averaged over odd trials 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%       Step 1: apply M-CCA to half of the data (training)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

KK = 50; % number of PCAs to retain for each subject (can be adjusted)
K = 20;  % number of CCAs to retain (can be adjusted)
l = [0 10 20 50 100 200 500]
clear W mu sigma COEFF
for i = 1:length(l)
    [W{i},mu{i},sigma{i},COEFF{i}] = obtainCCA(dataEven,KK,K,1,l(i));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      Step 2: testing on left-out half of the data (testing)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
correlations20 = zeros(length(l),K,2);
for i = 1:length(l)
    [correlations20(i,:,:)] = testCCA(dataEven,dataOdd,W{i},mu{i},sigma{i},COEFF{i},KK,K);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      Step 3: visualize the CCA performance (inter-subject correlations over testing data
%%%              averaged over the first 10 CCA)                  
%%%      This plot demonstrates that obtained CCAs generalizes well to testing data up
%%%      to lambda = 100; one would need to compbine this information with
%%%      the inter-subject classification performance and the CCA weight maps to decide the best
%%%      value of regularization 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure,plot(squeeze(mean(correlations20(:,1:10,:),2)))
h = legend('training','testing')
set(h,'box','off');
set(gca,'XTick', 1:7);
set(gca,'XTickLabel', l);
xlabel('Regularization (\lambda)')
ylabel('averaged inter-subject correlations')
