warning('off', 'images:imshow:magnificationMustBeFitForDockedFigure');

clc

% === Parameters ==========================================================

year = 2020;
month = 10;
day = 07;
hour = 12;

i = 437;

% -------------------------------------------------------------------------

DS = DataSource;

% =========================================================================

% --- Load data file ------------------------------------------------------

dDir = [DS.Data num2str(year, '%04i') filesep num2str(month, '%02i') filesep  num2str(day, '%02i') filesep];
fname = [dDir 'video_' num2str(hour, '%02i') '.dat'];       
mmf = memmapfile(fname, 'Format', {'double' [1 1] 't' ; 'uint8' [512 640] 'frame' });
iload = @(id) double(mmf.Data(id).frame);


% --- Get background ------------------------------------------------------

Bkg = iload(1);
for j = 101:100:1001
    Bkg = min(Bkg, iload(j));
end

% --- Process frames ------------------------------------------------------

Img = iload(i);

% --- Binarization

Res = Img - Bkg;

Res = imgaussfilt(Res, 1.5)>15;



% === Display =============================================================

figure(1)
clf
hold on

imshowpair(Img, Res);

% imshow(Res);
% caxis auto
% colorbar

title("Frame " + i + " / " + numel(mmf.Data))

