function checkNet(Lbl, pred)

warning('off', 'images:imshow:magnificationMustBeFitForDockedFigure');

clc

% === Parameters ==========================================================

year = 2020;
month = 10;
day = 7;
hour = 0; 

Str = IP.Images(year, month, day, hour);

% -------------------------------------------------------------------------

play = false;

% =========================================================================

% --- Processed & labels

tmp = load(Str.Files.label);
L = tmp.L;

% --- Localize errors

I = [Lbl(:).l]'~=pred;

x = [Lbl(I).x];
y = [Lbl(I).y];

% --- Display -------------------------------------------------------------

figure(1)
set(gcf, 'WindowStyle','docked')
clf
hold on

imshow(Str.getFrame(1));
caxis([0 3])

scatter(x, y, 'y+')

