function mainFourier(curve_x, curve_y)
    % obliczenei dyskretnej transformaty fourieria
    Z = complex(curve_x(:), curve_y(:));
    % Discrete Fourier Transform
    Y = fft(Z, length(Z));
    freq = 0:1:length(Z)-1;     % częstotliwość
    radius = abs(Y);    % promień
    phase = angle(Y);   % faza

    [radius, idx] = sort(radius, 'descend');
    Y = Y(idx);
    freq = freq(idx);
    phase = phase(idx);

    time_step = 2*pi/length(Y);

    % Rysowanie
    time = 0;

                    % + 2, aby zakończyć w początkowym punkcie
    wave = NaN(length(Y)+2, 2);
    iter = 1;
    h = figure;
    handle = axes('Parent',h);
    
    while iter < length(Y)+2
        [x, y] = calculateAndDrawCircles(freq, radius, phase, time, wave, handle);

        % Dodajemy dolejny piksel do tablicy z krzywą
        wave(iter,:) = [x,y];
        
        time = time + time_step;
        iter = iter + 1;
    end
end

% zwracamy x i y, będzie się tam znajdować kolejny punkt z naszej krzywej
function [x, y] = calculateAndDrawCircles(freq, radius, phase, time, wave, handle)
    % następne współżędne koła 
    x = 0;  
    y = 0;
    
    N = length(freq);
    
    centers = NaN(N,2); %tablica przechowująca środki kół
    radii_lines = NaN(N,4); %tablica przechowująca promienie
    for i = 1:1:N
        % zachowujemy środki aktualnych kół
        prevx = x;
        prevy = y;
        
        % liczymy środek najtępnego koła
        x = x + radius(i) * cos(freq(i)*time + phase(i));
        y = y + radius(i) * sin(freq(i)*time + phase(i));
        
        centers(i,:) = [prevx, prevy];
        
        radii_lines(i,:) = [prevx, x, prevy, y];
    end    
    
    
    cla; 
    % Rysujemy koła
    viscircles(handle, centers, radius, 'Color', 0.5 * [1, 1, 1], 'LineWidth', 0.1);
    hold on;
    
    % Rysujemy promienie
    plot(handle, radii_lines(:,1:2), radii_lines(:,3:4), 'Color', 0.5*[1 1 1], 'LineWidth', 0.1);
    hold on;
    
    % Rysujemy krzywą
    if ~isempty(wave), plot(handle, wave(:,1), wave(:,2), 'k', 'LineWidth', 2); hold on; end
    
    % Zwróćmy uwagę, że w tym miejscu środek kolejnego kola (zmienne x i y)
    % jest punktem, w którym znajduję się kolejny piksel naszej krzywej
    
    % Rysujemy kropkę na nowo dorysowanym punkcie
    plot(handle, x, y, 'or', 'MarkerFaceColor', 'r');
    hold off;
   
    axis equal;
    axis off;
    drawnow;
end