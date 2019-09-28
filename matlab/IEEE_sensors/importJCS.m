function MaleWISEJCS081020191911 = importJCS(filename, dataLines)
%IMPORTFILE1 Import data from a text file
%  MALEWISEJCS081020191911 = IMPORTFILE1(FILENAME) reads data from text
%  file FILENAME for the default selection.  Returns the numeric data.
%
%  MALEWISEJCS081020191911 = IMPORTFILE1(FILE, DATALINES) reads data for
%  the specified row interval(s) of text file FILENAME. Specify
%  DATALINES as a positive scalar integer or a N-by-2 array of positive
%  scalar integers for dis-contiguous row intervals.
%
%  Example:
%  MaleWISEJCS081020191911 = importfile1("F:\github\wearable-jacket\matlab\IEEE_sensors\JCS_data\Male\Male_WISE+JCS_08-10-2019 19-11.txt", [1, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 10-Aug-2019 19:49:33

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [1, Inf];
end

%% Setup the Import Options
opts = delimitedTextImportOptions("NumVariables", 13);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["VarName1", "VarName2", "VarName3", "VarName4", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
MaleWISEJCS081020191911 = readtable(filename, opts);

%% Convert to output type
MaleWISEJCS081020191911 = table2array(MaleWISEJCS081020191911);
end