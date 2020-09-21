
% --- Open serial connection

p = serialportlist("available");
s = serial(p); 
set(s,'BaudRate', 115200);
fopen(s);
fprintf('The serial connection is established.\n');

while true

    in = input('?> ', 's');

    % Break condition
    if isempty(in), break; end
       
    % Send command
    fprintf(s, in);
    
end
    
% --- Close the serial connection
fclose(s)
delete(s)
clear s

fprintf('The serial connection is closed.\n');