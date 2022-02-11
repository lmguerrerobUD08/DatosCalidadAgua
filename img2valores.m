%Este script obtiene los valores los niveles digitales segun la ubicacion
%de las estaciones
clear, clc, close
[imagen, R1] =geotiffread('subset_0_of_S2B_MSIL2A_20190725T151709_N0208_R125_T18NYM_20190725T201144_resampled.tif');%Lectura de la imagen
info1 = geotiffinfo('subset_0_of_S2B_MSIL2A_20190725T151709_N0208_R125_T18NYM_20190725T201144_resampled');%Informacion de la imagen

ndwi1 = (double(imagen(:,:,3)) - double(imagen(:,:,8))) ./ (double(imagen(:,:,3)) + double(imagen(:,:,8)));
ndwi2 = (double(imagen(:,:,8)) - double(imagen(:,:,11))) ./ (double(imagen(:,:,8)) + double(imagen(:,:,11)));
ndvi = (double(imagen(:,:,8)) - double(imagen(:,:,4))) ./ (double(imagen(:,:,8)) + double(imagen(:,:,4)));
msi = double(imagen(:,:,11)) ./ double(imagen(:,:,8));
indices = cat(4,ndwi1,ndwi2,ndvi,msi);
% dobleimg = entropyfilt(indices); %entropia indices
% dobleimg = stdfilt(indices); %desviacion estandar local indices
% dobleimg = im2double(imagen);%double
% dobleimg = entropyfilt(imagen); %entropia
% dobleimg = rangefilt(imagen); %rango local
% dobleimg = stdfilt(imagen); %desviacion estandar local

Estaciones = shaperead('Coordenadas_Pixel.shp');%Lectura de las estaciones en .shp
lat = ([Estaciones.Y]');%Coordenadas Y de las estaciones
log = ([Estaciones.X]');%Coordenadas X de las estaciones
[X1 Y1]=map2pix(info1.RefMatrix,log,lat);%Calculo de las posiciones en los pixeles de la imagen segun las coordenadas

% [filas,columnas,dimn] = size(imagen);%Calculo del tama?o y dimensiones de
% la imagen solo para la imagen original
[filas,columnas,dimn] = size(indices);%Calculo del tama?o y dimensiones de la imagen para los indices

[filascoor columcoor] = size(lat);%Calculo de la cantidad de estaciones

TF = isnan(indices);

indices2 = zeros(filas,columnas,dimn);

for m = 1:filas
    for n = 1:columnas
        for o = 1:dimn
            if TF(m,n,o) == 1
               indices2(m,n,o) = 0;
            else 
                indices2(m,n,o) = indices(m,n,o);
            end
        end
    end
end
indices2;
dobleimg = rangefilt(indices2); %rango local indices

for i=1:filascoor%Desde la estacion 1 hasta la 8
    for k = 1:dimn%Desde la banda 1 hasta la banda 12
     V1{i,k} =dobleimg(X1(i),Y1(i),k);
    end;%Ciclo que termina en el numero de bandas
end;%Ciclo que termina en el numero de estaciones

[m,n]=size(V1);
u1 = zeros(m,n);

for r = 1:m
    for t = 1:n
        u1(r,t) = cell2mat(V1(r,t));
    end
end%Se calculan los valres de formato celda a matriz

valores = u1;%muestra los valores segun la ubicacion de las estaciones
% xlswrite('20160206.xlsx',valores);%Cambiar nombre

% xlswrite('20190725.xls',valores)%Cambiar nombre por la fecha de la imagen
%Mostrar la imagen
B2 = imagen(:,:,2);
B3 = imagen(:,:,3);
B4 = imagen(:,:,4);
layerstack = cat(3,B4,B3,B2);
J = imadjust(layerstack,stretchlim(layerstack),[]);
figure,mapshow(J,R1)
title('RGB S2B MSI L2A 20190725')
hold on
mapshow(Estaciones)
text(double(cell2mat({Estaciones.X}))+1,double(cell2mat({Estaciones.Y}))+1,{Estaciones.Name},'color','white')
saveas(figure,'UbicacionEstaciones.png')