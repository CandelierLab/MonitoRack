function Sub = getSub(this, t, x, y, ws)

% === Input ===============================================================

dt = 1;                     % Integration time
fillingMethod = 'zeros';    % 'zeros', 'median'
sf = 0;                     % Gaussian smoothing size
xval = [0 1];               % Rescaling
% xval = [0.25 0.5];          % Rescaling

% =========================================================================

i1 = max(1, round(y) - (ws-1)/2);
i2 = min(this.H, round(y) + (ws-1)/2);
j1 = max(1, round(x) - (ws-1)/2);
j2 = min(this.W, round(x) + (ws-1)/2);

Sub = zeros(ws, ws);
% nf = 0;

for ti = t-(dt-1)/2:t+(dt-1)/2
    
    if ti<1 || ti>this.T, continue; end
    
    Tmp = double(this.map.processed.Data(ti).frame(i1:i2, j1:j2))/255;    
    % Tmp = double(this.map.data.Data(ti).frame(i1:i2, j1:j2))/255;    
    
    switch fillingMethod
        
        case 'zeros'
            
            if i1==1, Tmp = [zeros(ws-size(Tmp,1),size(Tmp,2)) ; Tmp]; end
            if i2==this.H, Tmp = [Tmp ; zeros(ws-size(Tmp,1),size(Tmp,2))]; end
            if j1==1, Tmp = [zeros(size(Tmp,1),ws-size(Tmp,2)) Tmp]; end
            if j2==this.W, Tmp = [Tmp zeros(size(Tmp,1),ws-size(Tmp,2))]; end
    
        case 'median'
       
            if i1==1, Tmp = [median(Tmp(:))*ones(ws-size(Tmp,1),size(Tmp,2)) ; Tmp]; end
            if i2==this.H, Tmp = [Tmp ; median(Tmp(:))*ones(ws-size(Tmp,1),size(Tmp,2))]; end
            if j1==1, Tmp = [median(Tmp(:))*ones(size(Tmp,1),ws-size(Tmp,2)) Tmp]; end
            if j2==this.W, Tmp = [Tmp median(Tmp(:))*ones(size(Tmp,1),ws-size(Tmp,2))]; end
            
    end
    
    if sf
        Tmp = imgaussfilt(Tmp, sf);
    end
    
    if dt>1
        Sub = max(Sub,Tmp);
    else
        Sub = Tmp;
    end
    
    % % %             Spl = Spl.*Sub;
    % % %             nf = nf+1;
    
end

Sub = (Sub-xval(1))/(xval(2)-xval(1));
Sub(Sub>1) = 1;
Sub(Sub<0) = 0;