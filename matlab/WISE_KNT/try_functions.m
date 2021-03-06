clear all, close all, clc

qC = [1,0,0,0];qD = [1,0,0,0];qA = [1,0,0,0];qB = [1,0,0,0];qE = [1,0,0,0];

%COM Port details

delete(instrfind({'Port'},{'COM15'}))

ser = serial('COM15','BaudRate',115200,'InputBufferSize',100);
ser.ReadAsyncMode = 'continuous';
fopen(ser);

while true
    if ser.BytesAvailable
       [qA,qB,qC,qD,qE] = DataReceive(ser,qA,qB,qC,qD,qE,0,0);
       
       Lsho = get_Left_Arm(qE,qC);
       Lext_flex = Lsho(1);
       Labd_add = Lsho(2);
       Lint_ext = Lsho(3);
       
       Rsho = get_Right_Arm(qE,qD);
       Rext_flex = Rsho(1);
       Rabd_add = Rsho(2);
       Rint_ext = Rsho(3);
       
       
       Lwri = get_Left_Wrist(qC,qA);
       Lelb = Lwri(1);
       Lelb1 = Lwri(2);
       
       rwriangle = get_Right_Wrist(qD,qB);
       Relb = rwriangle(1);
       Relb1 = rwriangle(2);
       
       disp(strcat('L int ext',num2str(Lsho(3))))
    end
end
