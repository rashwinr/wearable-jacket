function WISEKINECTtesting = importWISEKINECT(filename, dataLines)
%IMPORTFILE1 Import data from a text file
%  WISEKINECTTESTING061420192059LEF = IMPORTFILE1(FILENAME) reads data
%  from text file FILENAME for the default selection.  Returns the data
%  as a string array.
%
%  WISEKINECTTESTING061420192059LEF = IMPORTFILE1(FILE, DATALINES) reads
%  data for the specified row interval(s) of text file FILENAME. Specify
%  DATALINES as a positive scalar integer or a N-by-2 array of positive
%  scalar integers for dis-contiguous row intervals.
%
%  Example:
%  WISEKINECTtesting061420192059lef = importfile1("F:\github\wearable-jacket\matlab\kinect+imudata\619_WISE+KINECT_testing_06-14-2019 20-59_lef.txt", [1, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 19-Jun-2019 12:32:47

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [1, Inf];
end

%% Setup the Import Options
opts = delimitedTextImportOptions("NumVariables", 19);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Timestamp", "Kinect_LeftShoulder_ExtFlex", "IMU_LeftShoulder_ExtFlex", "Kinect_LeftShoulder_AbdAdd", "IMU_LeftShoulder_AbdAdd", "Kinect_LeftShoulder_IntExt", "IMU_LeftShoulder_IntExt", "Kinect_LeftElbow_ExtFlex", "IMU_LeftElbow_ExtFlex", "IMU_LeftElbow_ProSup", "Kinect_RightShoulder_ExtFlex", "IMU_RightShoulder_ExtFlex", "Kinect_RightShoulder_AbdAdd", "IMU_RightShoulder_AbdAdd", "Kinect_RightShoulder_IntExt", "IMU_RightShoulder_IntExt", "Kinect_RightElbow_ExtFlex", "IMU_RightElbow_ExtFlex", "IMU_RightElbow_ProSup"];
opts.VariableTypes = ["string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string"];
opts = setvaropts(opts, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19], "EmptyFieldRule", "auto");
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
WISEKINECTtesting = readtable(filename, opts);

%% Convert to output type
WISEKINECTtesting = table2array(WISEKINECTtesting);
end