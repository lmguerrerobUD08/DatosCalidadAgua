%Modelo 4
%datosdouble - input data
%Variables a estimar (target data):
%{'1.Temp','2.pH','3.CE','4.OD','5.Color','6.Turb','7.Nit','8.Sul','9.Fost','10.Stotales','11,SST',...
%'12.Cloruros','13.DQO','14.DBO','15.Coliformes','16.Ecoli'};

clear all
close all
clc
load('datosdouble.mat')
load('datosmuestras.mat')
%load('datosdoubleclima.mat')%Este esta con el mismo nombre datosdouble


x = datosdouble';
t = datosmuestras(:,16)';%cambiar con variables a estimar

% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.

trainFcn = 'trainlm';  % Levenberg-Marquardt backpropagation.

Experimentos = 1000;

%Save loop
Psave = cell(length(Experimentos),1);
Rsave = cell(length(Experimentos),1);
Esave = cell(length(Experimentos),1);
Trsave = cell(length(Experimentos),1);
Ysave = cell(length(Experimentos),1);

for i=1:Experimentos
    % Create a Fitting Network
    hiddenLayerSize = 1;
    net = fitnet(hiddenLayerSize,trainFcn);

    % Setup Division of Data for Training, Validation, Testing
    net.divideParam.trainRatio = 70/100;
    net.divideParam.valRatio = 15/100;
    net.divideParam.testRatio = 15/100;

    % Train the Network
    [net,tr] = train(net,x,t);

    % Test the Network
    y = net(x);
    e = gsubtract(t,y);
    performance = perform(net,t,y);
    R = corr2(t,y);

    %Save loop cells
    Psave{i} = performance;
    Rsave{i} = R;
    Esave{i} = e;
    Trsave{i} = tr;
    Ysave{i} = y;
end

BestRmax =max(cell2mat(Rsave))
BestRmin =min(cell2mat(Rsave))
BestRPos =find(ismember(cell2mat(Rsave),max(cell2mat(Rsave))));
BestP = Psave{BestRPos}

% View the Network
% view(net)

% Plots
% Uncomment these lines to enable various plots.
%figure, plotperform(tr)
%figure, plottrainstate(tr)
%figure, ploterrhist(e)
%figure, plotregression(t,y)
%figure, plotfit(net,x,t)

%Retrocalculo
load('vdatos.mat')

xnew = vdatos';
tnew = net(vdatos');

%Save loop retrocalculo
Psaver = cell(length(Experimentos),1);
Rsaver = cell(length(Experimentos),1);
Esaver = cell(length(Experimentos),1);
Trsaver = cell(length(Experimentos),1);
Ysaver = cell(length(Experimentos),1);

for j = 1:Experimentos
    netnew = fitnet(hiddenLayerSize,trainFcn);

    % Setup Division of Data for Training, Validation, Testing
    netnew.divideParam.trainRatio = 70/100;
    netnew.divideParam.valRatio = 15/100;
    netnew.divideParam.testRatio = 15/100;

    % Train the Network
    [netnew,trnew] = train(netnew,xnew,tnew);

    % Test the Network
    ynew = netnew(xnew);
    enew = gsubtract(tnew,ynew);
    performancenew = perform(netnew,tnew,ynew);
    Rnew = corr2(tnew,ynew);

    %Save loop cells
    Psaver{j} = performancenew;
    Rsaver{j} = Rnew;
    Esaver{j} = enew;
    Trsaver{j} = trnew;
    Ysaver{j} = ynew;
end

BestRnewmax =max(cell2mat(Rsaver))
BestRnewmin =min(cell2mat(Rsaver))
BestRPosnew =find(ismember(cell2mat(Rsaver),max(cell2mat(Rsaver))));
BestPnew = Psaver{BestRPosnew}


%Para plotear
% [imagen, R1] = geotiffread('subset_0_of_S2B_MSIL2A_20190317T151659_N0207_R125_T18NYM_20190317T201703_resampled.tif');%Lectura de la imagen
% dobleimg = im2double(imagen);
% f1 = reshape(dobleimg,[],12);
% yfinal = netnew(f1');
% concentr=reshape(yfinal,1320,1320);
% imagesc(concentr)
