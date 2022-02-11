%Este script pretende extraer los valores segun una muestra homogenea
%de las estaciones
clear, clc, close
[imagen, R1] = geotiffread('subset_0_of_S2B_MSIL2A_20190725T151709_N0208_R125_T18NYM_20190725T201144_resampled');%Lectura de la imagen
info1 = geotiffinfo('subset_0_of_S2B_MSIL2A_20190725T151709_N0208_R125_T18NYM_20190725T201144_resampled');%Informacion de la imagen

%Tamaño de la muestra
aguatotal = 541071;% shaperead('pixel.shp');%Lectura de las estaciones en .shp
N= aguatotal;%size(aguatotal);
e = 0.05;%precision
n = round(N(1)/(1+N(1)*(e^2)));%numero de muestras %%%citar: http://sociology.soc.uoc.gr/socmedia/papageo/metaptyxiakoi/sample_size/samplesize1.pdf
nestaciones = n/8; %Entre el numero de estaciones
nbandas = round(nestaciones/12);%Entre el numero de bandas
% topix =nbandas/2;

%double
dobleimg = im2double(imagen);
Estaciones = shaperead('Coordenadas_Pixel.shp');%Lectura de las estaciones en .shp
lat = ([Estaciones.Y]');%Coordenadas Y de las estaciones
log = ([Estaciones.X]');%Coordenadas X de las estaciones
[X1 Y1]=map2pix(info1.RefMatrix,log,lat);%Calculo de las posiciones en los pixeles de la imagen segun las coordenadas

[filas,columnas,dimn] = size(imagen);%Calculo del tama?o y dimensiones de la imagen
[filascoor columcoor] = size(lat);%Calculo de la cantidad de estaciones

for i=1:filascoor%Desde la estacion 1 hasta la 8
    for k = 1:dimn%Desde la banda 1 hasta la banda 12
     V1{i,k} =dobleimg((X1(i)-nbandas):(X1(i)+nbandas),(Y1(i)-nbandas):(Y1(i)+nbandas),k);%Segun el tamaño de la muestra, para este caso 121 datos por estacion
    end%Ciclo que termina en el numero de bandas
end%Ciclo que termina en el numero de estaciones

LlanoAlarcon = [V1{1,1}(:) V1{1,2}(:) V1{1,3}(:) V1{1,4}(:) V1{1,5}(:) V1{1,6}(:) V1{1,7}(:) V1{1,8}(:) V1{1,9}(:) V1{1,10}(:) V1{1,11}(:) V1{1,12}(:)];
ElTunel = [V1{2,1}(:) V1{2,2}(:) V1{2,3}(:) V1{2,4}(:) V1{2,5}(:) V1{2,6}(:) V1{2,7}(:) V1{2,8}(:) V1{2,9}(:) V1{2,10}(:) V1{2,11}(:) V1{2,12}(:)];
Piscicol = [V1{3,1}(:) V1{3,2}(:) V1{3,3}(:) V1{3,4}(:) V1{3,5}(:) V1{3,6}(:) V1{3,7}(:) V1{3,8}(:) V1{3,9}(:) V1{3,10}(:) V1{3,11}(:) V1{3,12}(:)];
LaCustodia = [V1{4,1}(:) V1{4,2}(:) V1{4,3}(:) V1{4,4}(:) V1{4,5}(:) V1{4,6}(:) V1{4,7}(:) V1{4,8}(:) V1{4,9}(:) V1{4,10}(:) V1{4,11}(:) V1{4,12}(:)];
PlayaBlanca = [V1{5,1}(:) V1{5,2}(:) V1{5,3}(:) V1{5,4}(:) V1{5,5}(:) V1{5,6}(:) V1{5,7}(:) V1{5,8}(:) V1{5,9}(:) V1{5,10}(:) V1{5,11}(:) V1{5,12}(:)];
Centro = [V1{6,1}(:) V1{6,2}(:) V1{6,3}(:) V1{6,4}(:) V1{6,5}(:) V1{6,6}(:) V1{6,7}(:) V1{6,8}(:) V1{6,9}(:) V1{6,10}(:) V1{6,11}(:) V1{6,12}(:)];
SantaInes = [V1{7,1}(:) V1{7,2}(:) V1{7,3}(:) V1{7,4}(:) V1{7,5}(:) V1{7,6}(:) V1{7,7}(:) V1{7,8}(:) V1{7,9}(:) V1{7,10}(:) V1{7,11}(:) V1{7,12}(:)];
SanPedro = [V1{8,1}(:) V1{8,2}(:) V1{8,3}(:) V1{8,4}(:) V1{8,5}(:) V1{8,6}(:) V1{8,7}(:) V1{8,8}(:) V1{8,9}(:) V1{8,10}(:) V1{8,11}(:) V1{8,12}(:)];

zdatos = [LlanoAlarcon;ElTunel;Piscicol;LaCustodia;PlayaBlanca;Centro;SantaInes;SanPedro];
% zdatos = [LlanoAlarcon;ElTunel;Piscicol;LaCustodia;PlayaBlanca;SantaInes;SanPedro];%20160206
% zdatos = [ElTunel;Piscicol;PlayaBlanca;SantaInes;SanPedro];%20161122
% zdatos = [LlanoAlarcon;ElTunel;Centro;SantaInes;SanPedro]; %20170814
% zdatos = [PlayaBlanca;Centro;SanPedro];%20171102
% zdatos = [LlanoAlarcon;ElTunel;Piscicol;PlayaBlanca];%20180312
% zdatos = [Piscicol;LaCustodia;PlayaBlanca;SantaInes;SanPedro];%20190317

