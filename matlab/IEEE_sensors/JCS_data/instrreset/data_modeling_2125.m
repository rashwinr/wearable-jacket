%% Import data from text file
% Script for importing data from the following text file:
%
%    filename: F:\github\wearable-jacket\matlab\IEEE_sensors\JCS_data\instrreset\instrreset_WISE+JCS_02-04-2020 21-31.txt
%
% Auto-generated by MATLAB on 05-Feb-2020 07:22:03


opts = delimitedTextImportOptions("NumVariables", 13);

% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["VarName1", "VarName2", "VarName3", "VarName4", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
tbl = readtable("F:\github\wearable-jacket\matlab\IEEE_sensors\JCS_data\instrreset\instrreset_WISE+JCS_02-04-2020 21-25.txt", opts);


T = tbl.VarName1;
Lsp = tbl.VarName2;
Lse = tbl.VarName3;
Lie = tbl.VarName4;
Lca = tbl.VarName5;
Lelbfe = tbl.VarName6;
Lps = tbl.VarName7;
Rsp = tbl.VarName8;
Rse = tbl.VarName9;
Rie = tbl.VarName10;
Rca = tbl.VarName11;
Relbfe = tbl.VarName12;
Rps = tbl.VarName13;

clear opts tbl

%%

loc = find(round(T)==15);
T(1:loc)=[];
Lie(1:loc)=[];
Lse(1:loc)=[];
Lsp(1:loc)=[];
Lca(1:loc)=[];
Lelbfe(1:loc)=[];
Lps(1:loc)=[];


line = -180:1:180;
t = ones(size(line));

figure(1)
subplot(2,1,1)
axis([0 120 -120 180])
hold on
LSE = plot(T,Lse,'-r','LineWidth',2,'DisplayName','Shoulder Elevation')
LSP = plot(T,Lsp-50,'-g','LineWidth',2,'DisplayName','Shoulder Plane')
LIE = plot(T,Lie,'-b','LineWidth',2,'DisplayName','Shoulder Int.-Ext. Rotation')
plot(15*t,line,'--k','LineWidth',1)
xlabel('Time [s]','FontSize',15)
ylabel('Angle [deg^o]','FontSize',15)

subplot(2,1,2)
axis([0 120 -90 90])
hold on
LCA  = plot(T,Lca,'-c','LineWidth',2,'DisplayName','Carry angle')
LELBFE  = plot(T,Lelbfe,'-m','LineWidth',2,'DisplayName','Forearm Flex.-Ext.')
LPS = plot(T,Lps-80,'-k','LineWidth',2,'DisplayName','Forearm Pro.-Sup.')
plot(15*t,line,'--k','LineWidth',1)
xlabel('Time [s]','FontSize',15)
ylabel('Angle [deg^o]','FontSize',15)

lgd = legend([LSE,LSP,LIE,LELBFE,LPS,LCA],'FontSize',15);
lgd.Orientation = 'horizontal';

%%
