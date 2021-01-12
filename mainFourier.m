function mainFourier(data_x, data_y)

    % Wybieramy kolor krzywej, którą będziemy rysować
    color = uisetcolor([0, 1, 0], 'Wybierz kolor obrazu');

    % Obliczamy dyskretną transformatę Fouriera
    Z = complex(data_x(:), data_y(:));
    Y = fft(Z, length(Z));

    % Częstotliwość
    frequency = 0:1:length(Z) - 1;     

    % Promień
    radius = abs(Y);   
    
    % Faza
    phase = angle(Y);   

    % Sortujemy po promieniu
    [radius, idx] = sort(radius, 'descend');

    Y = Y(idx);
    frequency = frequency(idx);
    phase = phase(idx);

    time_step = 2 * pi / length(Y);

    % Rysowanie
    time = 0;

    % + 2, aby zakończyć w początkowym punkcie
    wave = NaN(length(Y) + 2, 2);

    iteration = 1;
    h = figure;
    handle = axes('Parent', h);
    
    while iteration < length(Y)+2
        [x, y] = calculateAndDrawCircles(frequency, radius, phase, time, wave, handle, color);

        % Dodajemy dolejny piksel do tablicy z krzywą
        wave(iteration, :) = [x,y];
        
        time = time + time_step;
        iteration = iteration + 1;
    end
end

% Zwracamy x i y, będzie się tam znajdować kolejny punkt z naszej krzywej
function [next_center_x, next_center_y] = calculateAndDrawCircles(frequency, radius, phase, time, wave, handle, color)

    % Następne współrzędne koła 
    next_center_x = 0;  
    next_center_y = 0;
    
    % W tym miejscu moglibyśmy policzyc również długość
    % zmiennych frequency i phase, ponieważ jest ona taka sama
    N = length(radius);
    
    % Tablica przechowująca środki kół
    centers_array = NaN(N, 2); 

    % Tablica przechowująca promienie
    radii_array = NaN(N, 4); 

    for i = 1:1:N

        % Zachowujemy środki aktualnych (poprzednich) kół
        center_x = next_center_x;
        center_y = next_center_y;
        
        % Liczymy środek następnego koła
        next_center_x = next_center_x + radius(i) * cos(frequency(i) * time + phase(i));
        next_center_y = next_center_y + radius(i) * sin(frequency(i) * time + phase(i));
        
        % Wypełniamy tablice
        centers_array(i,:) = [center_x, center_y];
        radii_array(i,:) = [center_x, next_center_x, center_y, next_center_y];
    end    
    
    % Czyścimy obiekty
    cla; 
    
    % Rysujemy koła
    viscircles(handle, centers_array, radius, 'Color', [0, 0, 0], 'LineWidth', 0.1);
    hold on;
    
    % Rysujemy promienie
    plot(handle, radii_array(:,1:2), radii_array(:,3:4), 'Color', [0, 0, 0], 'LineWidth', 0.1);
    hold on;
    
    % Rysujemy krzywą
    if ~isempty(wave), plot(handle, wave(:,1), wave(:,2), 'k','Color', color, 'LineWidth', 2); hold on; end
    
    % Zwróćmy uwagę, że w tym miejscu środek kolejnego kola (zmienne x i y)
    % jest punktem, w którym znajduję się kolejny piksel naszej krzywej
    
    % Rysujemy kropkę na nowo dorysowanym punkcie
    plot(handle, next_center_x, next_center_y, 'or', 'MarkerFaceColor', 'r');
    hold off;
   
    axis equal;
    axis off;
    drawnow;
end