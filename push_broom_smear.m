% Simulación y corrección de efecto "Smear" en cargas útiles LEO
clear; clc; close all;

% 1. Generar una imagen de prueba (Patrón de tablero para simular alto contraste costero/urbano)
I_original = checkerboard(20, 5, 5);
I_original = I_original(1:150, 1:150); % Recortar

% 2. Simular el "Smear" (borrosidad por movimiento orbital)
% Satélite moviéndose rápido en una dirección durante el tiempo de integración
longitud_movimiento = 15; % Píxeles de arrastre
angulo_orbita = 45; % Ángulo de la trayectoria respecto al sensor
psf_movimiento = fspecial('motion', longitud_movimiento, angulo_orbita);

I_borrosa = imfilter(I_original, psf_movimiento, 'conv', 'circular');
I_ruidosa = imnoise(I_borrosa, 'gaussian', 0, 0.001); % Añadir ruido del sensor

% 3. Restauración de imagen (Filtro de Wiener)
ruido_estimado = 0.001;
I_restaurada = deconvwnr(I_ruidosa, psf_movimiento, ruido_estimado);

% 4. Visualización
figure('Name', 'Telemetría Óptica - Deconvolución', 'Color', 'w', 'Position', [100 100 900 300]);
subplot(1,3,1); imshow(I_original); title('Imagen Original (Terreno)');
subplot(1,3,2); imshow(I_ruidosa); title('Captura LEO (Smear + Ruido)');
subplot(1,3,3); imshow(I_restaurada); title('Restauración (Filtro Wiener)');