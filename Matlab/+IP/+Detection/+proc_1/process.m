function [pos, Res] = process(Img, Bkg)

[H,W] = size(Img);

Res = imgaussfilt(Img - Bkg, 1.5);

% Res = imgaussfilt(Res, 1);

R = regionprops(Res>0.4, {'Area', 'Centroid'});

A = [R(:).Area];
R = R(A>5 & A<200); 

pos = reshape([R(:).Centroid], [2 numel(R)])';

% Remove close to corners
pos((pos(:,1)<=5 | pos(:,1)>=W-4) & (pos(:,2)<=5 | pos(:,2)>=H-4),:) = [];

% pos = [];
