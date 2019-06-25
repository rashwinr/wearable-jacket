%% Initialization section
delete(instrfind({'Port'},{'COM15'}))
clear all; close all;clc;
markers = ["lef","lbd","lelb","lelb1","lps","lie","lie1","ref","rbd","relb","relb1","rps","rie","rie1"];

SUBJECTID = 2410; 

%Kinect initialization script
addpath('F:\github\wearable-jacket\matlab\KInectProject\Kin2');
addpath('F:\github\wearable-jacket\matlab\KInectProject\Kin2\Mex');
addpath('F:\github\wearable-jacket\matlab\KInectProject');
k2 = Kin2('color','depth','body','face');

outOfRange = 4000;

sz1 = screensize(1);

c_width = sz1(3); c_height = sz1(4);COL_SCALE = 1;
color = zeros(c_height*COL_SCALE,c_width*COL_SCALE,3,'uint8');
c.h = figure('units', 'pixels', 'outerposition', sz1);
c.ax = axes;
color = imresize(color,COL_SCALE);
c.im = imshow(color, 'Parent', c.ax);

set( figure(1) , 'DoubleBuffer', 'on','keypress','k=get(gcf,''currentchar'');' );
%quaternion variables
qC = [1,0,0,0];qD = [1,0,0,0];qA = [1,0,0,0];qB = [1,0,0,0];qE = [1,0,0,0];
Cal_A = [0 0 0 0];Cal_B = [0 0 0 0];Cal_C = [0 0 0 0];Cal_D = [0 0 0 0];Cal_E = [0 0 0 0];
limuef = 0;rimuef = 0;lkinef = 0;rkinef = 0;
limubd = 0;rimubd = 0;lkinbdangle = 0;rkinbd = 0;
limuie = 0;rimuie = 10;lkinie = 0;rkinie = 0;
limuelb = 0;rimuelb = 0;lkinelb = 0;rkinelb = 0;
limuelb1 = 0;rimuelb1 = 0;lkinelb1 = 0;rkinelb1 = 0;
lshoangle = [0,0,0]';
rshoangle = [0,0,0]';
lwriangle = [0,0]';
rwriangle = [0,0]';

ls = 0;rs = 1350;lw = 475;H = 1080;rw = 570;     %rectangle coordinates
%COM Port details
delete(instrfind({'Port'},{'COM15'}))
ser = serial('COM15','BaudRate',115200,'InputBufferSize',100);
ser.ReadAsyncMode = 'continuous';
fopen(ser);k=[];
sz2 = screensize(2);
figure('units', 'pixels', 'outerposition', sz2)
%% find and fix the wearing offsets

G = [0,0,-1];
qI = [0,1,0,0];
qJ = [0,0,1,0];
qK = [0,0,0,1];

qEg = [1,0,0,0];
qEl = [1,0,0,0];

thl_old = 0;
thg_old = 0;

lshoangle_x = [0,0,0]';
rshoangle_x = [0,0,0]';

tol = 0.1;
    
lc=1;
while lc
    if ser.BytesAvailable
        
       [qA,qB,qC,qD,qEg] = DataReceive(ser,qA,qB,qC,qD,qEg,0,0);
       
       qX = quatmultiply(qEg,quatmultiply(qI,quatconj(qEg)));
       qY = quatmultiply(qEg,quatmultiply(qJ,quatconj(qEg)));
       
       thg = atan2(dot(G,qY(2:4)),dot(G,qX(2:4)));
       disp(strcat('Mounting offset: ',num2str(thg*180/pi)))
       
       [qA,qB,qC,qD,qEl] = DataReceive(ser,qA,qB,qC,qD,qEg,thg,0);
       
       qX = quatmultiply(qEl,quatmultiply(qI,quatconj(qEl)));
       qZ = quatmultiply(qEl,quatmultiply(qK,quatconj(qEl)));
       
       thl = atan2(dot(G,qZ(2:4)),dot(G,qX(2:4)));
       disp(strcat('Lumbar spine: ',num2str(thl*180/pi)))
       
       [qA,qB,qC,qD,qE] = DataReceive(ser,qA,qB,qC,qD,qE,thg,thl);
       
       lshoangle = get_Left_Arm(qE,qC);
       
       rshoangle = get_Right_Arm(qE,qD);
       
       if thl_old == thl && thg_old == thg && all(abs(lshoangle(1:2)-lshoangle_x(1:2))<tol) && all(abs(rshoangle(1:2)-rshoangle_x(1:2))<tol)
           lc = 0;
           lshoangle_x = lshoangle;
           rshoangle_x = rshoangle;
           disp(lshoangle_x)
           disp(rshoangle_x)
       else 
           thl_old = thl;
           thg_old = thg;
           lshoangle_x = lshoangle;
           rshoangle_x = rshoangle;
       end

    end
    
    validData = k2.updateData;
   if validData
       depth = k2.getDepth;color = k2.getColor;face = k2.getFaces;
       depth8u = uint8(depth*(255/outOfRange));depth8uc3 = repmat(depth8u,[1 1 3]);
       figure(1)
       color = imresize(color,COL_SCALE);c.im = imshow(color, 'Parent', c.ax);
       rectangle('Position',[0 0 475 1080],'LineWidth',3,'FaceColor','k');  
       rectangle('Position',[1350 0 620 1080],'LineWidth',3,'FaceColor','k');
       [bodies, fcp, timeStamp] = k2.getBodies('Quat');
       numBodies = size(bodies,2);
       if numBodies == 1
           pos2Dxxx = bodies(1).Position; 
           [lkinef,rkinef,lkinbdangle,rkinbd,lkinie,rkinie,lkinelb,rkinelb] = get_Kinect(pos2Dxxx);
           k2.drawBodies(c.ax,bodies,'color',3,2,1);k2.drawFaces(c.ax,face,5,false,20);
           
%            kin = lkinef; imu = limuef;
% %            updateWiseKinect('lef',kin,imu,telapsed,0,0)
%            
%            kin = rkinef; imu = rimuef;
% %            updateWiseKinect('ref',kin,imu,telapsed,0,0)
       end
       
       
       
   end
    
end

%%  Complete routine for updating data with 14 different angles

lshoangle_x(3) = 0;
rshoangle_x(3) = 0;

for i=1:14
arg = char(markers(i));    
[anline,anline1,fid] = TitleUpdate(arg,SUBJECTID);
lc=1;l=0;lflag = 0;telapsed=0;
while (lc) 
   tstart = tic;
   if ser.BytesAvailable
       [qA,qB,qC,qD,qE] = DataReceive(ser,qA,qB,qC,qD,qE,thg,thl);

       lshoangle = get_Left_Arm(qE,qC)-lshoangle_x;
       limuef = lshoangle(1);
       limubd = lshoangle(2);
       limuie = lshoangle(3); 
       
       rshoangle = get_Right_Arm(qE,qD)-rshoangle_x;
       rimuef = rshoangle(1);
       rimubd = rshoangle(2);
       rimuie = rshoangle(3);
       
       lwriangle = get_Left_Wrist(qC,qA);
       limuelb = lwriangle(1);
       limuelb1 = lwriangle(2);
       
       rwriangle = get_Right_Wrist(qD,qB);
       rimuelb = rwriangle(1);
       rimuelb1 = rwriangle(2);
       
   end
   validData = k2.updateData;
   if validData
       depth = k2.getDepth;color = k2.getColor;face = k2.getFaces;
       depth8u = uint8(depth*(255/outOfRange));depth8uc3 = repmat(depth8u,[1 1 3]);
       figure(1)
       color = imresize(color,COL_SCALE);c.im = imshow(color, 'Parent', c.ax);
       rectangle('Position',[0 0 475 1080],'LineWidth',3,'FaceColor','k');  
       rectangle('Position',[1350 0 620 1080],'LineWidth',3,'FaceColor','k');
       [bodies, fcp, timeStamp] = k2.getBodies('Quat');
       numBodies = size(bodies,2);
       if numBodies == 1
           pos2Dxxx = bodies(1).Position; 
           [lkinef,rkinef,lkinbdangle,rkinbd,lkinie,rkinie,lkinelb,rkinelb] = get_Kinect(pos2Dxxx);
           k2.drawBodies(c.ax,bodies,'color',3,2,1);k2.drawFaces(c.ax,face,5,false,20);
           switch arg
                case 'lef'
                    kin = lkinef; imu = limuef;
                    lim = kin;
                    tlow = 10; thigh=150;
                case 'lbd'
                    kin = lkinbdangle; imu = limubd;
                    lim = kin;
                    tlow = 20; thigh=150;
                case 'lelb'
                    kin = lkinelb; imu = limuelb;
                    lim = kin;
                    tlow = 20; thigh=130;
                case 'lelb1'
                    kin = lkinelb; imu = limuelb;
                    lim = kin;
                    tlow = 20; thigh=130;
                case 'lps'
                    kin = lkinelb1; imu = limuelb1;
                    lim = imu;
                    tlow = -45; thigh=45;
                case 'lie'
                    kin = lkinie; imu = limuie;
                    lim = imu;
                    tlow = -40; thigh=40;
                case 'lie1' 
                    kin = lkinie; imu = limuie;
                    lim = imu;
                    tlow = -40; thigh=40;
                case 'ref'
                    kin = rkinef; imu = rimuef;
                    lim = kin;
                    tlow = 10; thigh=150;
                case 'rbd'
                    kin = rkinbd; imu = rimubd;
                    lim = kin;
                    tlow = 20; thigh=150;
                case 'relb'
                    kin = rkinelb; imu = rimuelb;
                    lim = kin;
                    tlow = 20; thigh=130;
                case 'relb1'
                    kin = rkinelb; imu = rimuelb;
                    lim = kin;
                    tlow = 20; thigh=130;
                case 'rps'
                    kin = rkinelb1; imu = rimuelb1;
                    lim = imu;
                    tlow = -45; thigh=45;
                case 'rie'
                    kin = rkinie; imu = rimuie;
                    lim = imu;
                    tlow = -40; thigh=40;
                case  'rie1'
                    kin = rkinie; imu = rimuie;
                    lim = imu;
                    tlow = -40; thigh=40;
           end
           updateWiseKinect(arg,kin,imu,telapsed,anline,anline1)
           %'Timestamp','Kinect_LeftShoulder_Ext.-Flex.','IMU_LeftShoulder_Ext.-Flex.','Kinect_LeftShoulder_Abd.-Add.','IMU_
           % LeftShoulder_Abd.-Add.','Kinect_LeftShoulder_Int.-Ext.','IMU_LeftShoulder_Int.-Ext.','Kinect_LeftElbow_Ext.-Flex.','IMU_LeftElbow_Ext.-Flex.',
           % 'IMU_LeftElbow_Pro.-Sup.','Kinect_RightShoulder_Ext.-Flex.','IMU_RightShoulder_Ext.-Flex.','Kinect_RightShoulder_Abd.-Add.','IMU_RightShoulder_Abd.-Add.',
           %'Kinect_RightShoulder_Int.-Ext.','IMU_RightShoulder_Int.-Ext.','Kinect_RightElbow_Ext.-Flex.','IMU_RightElbow_Ext.-Flex.','IMU_RightElbow_Pro.-Sup.');
           fprintf( fid, '%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f\n',telapsed,...
           lkinef,limuef,lkinbdangle,limubd,lkinie,limuie,lkinelb,limuelb,limuelb1,rkinef,rimuef,...
           rkinbd,rimubd,rkinie,rimuie,rkinelb,rimuelb,rimuelb1);
       
           if lim<=tlow
              lflag = 1;
           end
           if (lim>=thigh) && lflag
               l=l+1;
               lflag =0;
               if l>=8
                   lc = 0;
                   [~,~] = system('taskkill /F /IM Video.UI.exe');
                   break;
               end
           end
       end

       if numBodies == 0
           figure(1)
           s1 = strcat('No persons in view');   
           text((1920/2) - 250,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
       end      
       if numBodies > 1
           figure(1)
           s1 = strcat('Too many people in view');
           text(1920/2,100,s1,'Color','red','FontSize',30,'FontWeight','bold');
       end      
       if ~isempty(k)
           if strcmp(k,'q') 
           k=[];
           break; 
           end
       end
   end
 pause(0.001);

 if telapsed>=60
     break;
 end

telapsed = telapsed+toc(tstart);
end
disp(telapsed);
fclose(fid);

clf(figure(2),'reset')
end

%% Closing everything 

close figure 1 figure 2
fclose(ser);
delete(ser);
close all;clear all;
delete(instrfind({'Port'},{'COM15'}))

