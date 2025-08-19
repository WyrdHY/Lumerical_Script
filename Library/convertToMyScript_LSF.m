filepath = 'C:\Users\EricY\Desktop\Lumerical_Simulation\Library\ScriptToConvert\FDTD_Grating_Setup.txt';
varName = 'myscript';

convertToMyScript(filepath,varName);





function convertToMyScript(inputFile, varName)
% convertToMyScript  Wrap each line of inputFile into:
%   varName = varName + "…\n";
% and write to [inputName '_output' ext].
%
% Usage:
%   convertToMyScript('in.txt')
%   convertToMyScript('in.txt','myscript')

    if nargin<2
        varName = 'myscript';
    end

    % derive output file name
    [pathstr, name, ext] = fileparts(inputFile);
    if isempty(ext)
        ext = '.txt';
    end
    outputFile = fullfile(pathstr, [name '_output' ext]);

    % open files
    fidIn  = fopen(inputFile, 'r');
    assert(fidIn>0, 'Cannot open %s for reading', inputFile);
    fidOut = fopen(outputFile,'w');
    assert(fidOut>0,'Cannot open %s for writing', outputFile);

    % write initializer
    fprintf(fidOut, '%s = \"\";\n\n', varName);

    % process each line
    while ~feof(fidIn)
        line = fgetl(fidIn);
        if ~ischar(line), continue; end

        % escape backslashes and quotes
        lineEsc = strrep(line, '\', '\\');
        lineEsc = strrep(lineEsc, '"', '\"');

        % write out
        fprintf(fidOut, '%s = %s + \"%s\\n\";\n', ...
                varName, varName, lineEsc);
    end

    fclose(fidIn);
    fclose(fidOut);

    fprintf('Wrote formatted script to %s\n', outputFile);
end
