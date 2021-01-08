function prepareForFourier(filename, filepath)
    im = double (imread(fullfile(filepath, filename)))/255;

    bim = rgb2gray(im);

    bim = ~imbinarize(bim, 0.9);

    bim = imfill(bim, 'holes');
    bim = imopen(bim,ones(3));
    bim = imclose(bim,ones(3));
    %imshow(bim);

    eimage = edge(bim);

    X = [];
    Y = [];

    [r, c] = find(bim == 1);
    rowcolCoordinates = [mean(r), mean(c)];

    X = [];
    Y = [];
    coordsSize = 1;
    for i = 1:size(bim, 1)
        for j = 1:size(bim, 2)
            if(eimage(i,j))
                [theta,rho] = cart2pol(i - rowcolCoordinates(1),j - rowcolCoordinates(2));
                X(coordsSize) = theta;
                Y(coordsSize) = rho;
                coordsSize = coordsSize + 1;
            end   
        end
    end

    [X,sortIdx] = sort(X,'descend');
    Y = Y(sortIdx);
    

    [Y,X] = pol2cart(-X,-Y);
        
    % zapisujemy dane możliwe do narysowania jako .mat
    [filename, pathname] = uiputfile('*.mat','Zapisz zmienne do rysowania');
    data = fullfile(pathname, filename);
    save(data, 'X', 'Y');

    % wyświetlamy i zapisujemy obrazek jako .bmp
    figure;
    imshow(eimage);
    imsave;
end