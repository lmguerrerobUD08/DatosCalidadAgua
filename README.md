# DatosCalidadAgua
Este repositorio contiene scripts elaborados en MATLAB para obtener datos de imágenes satelitales y estimar concentraciones fisicoquímicas

# Obtener datos de las imágenes satelitales
Para esto es necesario descargar las imágenes del siguiente link: https://drive.google.com/drive/folders/1kdND4qLn-z8DB1BGEd3QL05zwMUa0Wbq (debe tener credenciales de la Universidad Distrital Francisco José de Caldas)
El código img2valores ingresa las coordenadas que se encuentran en el archivo comprimido .zip y la imagen de interés donde se obtienen los datos por píxel según la ubicación de la estación de monitoreo

# Aumentar el tamaño de la muestra
El código img2muestra ingresa las coordenadas y la imágen el cual tiene una rutina similar al código img2valores agregando una fórmula para aumentar el tamaño de la muestra de la imagen.

# Obtener datos de concentraciones fisicoquímicas
Los códigos son los modelos 1 al 12 donde ingresa la variable datosdouble el cual contiene los valores de píxel obtenidos del código img2valores, la variable datosmuestras que son las concentraciones fisicoquímicas a estimar y vdatos que valores de píxel obtenidos del código img2muestra
