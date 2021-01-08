function mainFourier(curve_x, curve_y, no_circles)
    % obliczenei dyskretnej transformaty fourieria
    Z = complex(curve_x(:), curve_y(:));
    % Discrete Fourier Transform
    Y = fft(Z, length(Z));
    freq = 0:1:length(Z)-1;     % częstotliwość
    radius = abs(Y);    % promień
    phase = angle(Y);   % faza

    % sortujemy po promieniu, ale czemu?????????????????
    % i dalej to juz nie ogarniam :(
    [radius, idx] = sort(radius, 'descend');
    Y = Y(idx);
    freq = freq(idx);
    phase = phase(idx);

    time_step = 2*pi/length(Y);

    % Draw the result
    time = 0;
    wave = [];
    generation = 1;
    h = figure;
    handle = axes('Parent',h);
    
    while generation < length(Y)+2
        [x, y] = draw_epicycles(freq, radius, phase, time, wave, handle);

        % Add the next computed point to the wave curve
        wave = [wave; [x,y]];

        % Increment time and generation
        time = time + time_step;
        generation = generation + 1;
    end
end

function [x, y] = draw_epicycles(freq, radius, phase, time, wave, handle)
    % Compute coordinates
    x = 0;      
    y = 0;
    N = length(freq);
    centers = NaN(N,2);
    radii_lines = NaN(N,4);
    for i = 1:1:N
        % Store the previous coordinates, which will be the center of the
        % new circle
        prevx = x;
        prevy = y;
        
        % Get the new coordinates of the joint point
        x = x + radius(i) * cos(freq(i)*time + phase(i));
        y = y + radius(i) * sin(freq(i)*time + phase(i));
        
        % Circle centers
        centers(i,:) = [prevx, prevy];
        
        % Radii lines
        radii_lines(i,:) = [prevx, x, prevy, y];
    end    
    
    % Plotting
    cla;        % IMPORTANT: Clearing axes
                % Note that viscircles do not clear the axes and thus, they
                % should be cleared in order to avoid lagging issues due to
                % the amount of objects that are stacked
    % Circles
    viscircles(handle, centers, radius, 'Color', 0.5 * [1, 1, 1], 'LineWidth', 0.1);
    hold on;
    
    % Lines that join the center with the tangent points
    plot(handle, radii_lines(:,1:2), radii_lines(:,3:4), 'Color', 0.5*[1 1 1], 'LineWidth', 0.1);
    hold on;
    
    % Result line
    if ~isempty(wave), plot(handle, wave(:,1), wave(:,2), 'k', 'LineWidth', 2); hold on; end
    
    % Pointer
    plot(handle, x, y, 'or', 'MarkerFaceColor', 'r');
    hold off;
    
    % Plot limits
    %xmax = sum(radius);
    %axis([-xmax xmax -xmax xmax]);
   
    axis equal;
    axis off;
    drawnow;
end