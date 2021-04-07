close all
clear all
format long

% Data read
dirdata = '..'
dados=fopen (fullfile(dirdata,'data.txt'),'r');
data=fscanf(dados, '%f', [inf]);
data = data';
fclose(dados);

% Data write (.tex)
datatex = fopen ("data.tex", "w");
fprintf(datatex, "$R_1$ & %.11f \\\\ \\hline \n", data(1));
fprintf(datatex, "$R_2$ & %.11f \\\\ \\hline \n", data(2));
fprintf(datatex, "$R_3$ & %.11f \\\\ \\hline \n", data(3));
fprintf(datatex, "$R_4$ & %.11f \\\\ \\hline \n", data(4));
fprintf(datatex, "$R_5$ & %.11f \\\\ \\hline \n", data(5));
fprintf(datatex, "$R_6$ & %.11f \\\\ \\hline \n", data(6));
fprintf(datatex, "$R_7$ & %.11f \\\\ \\hline \n", data(7));
fprintf(datatex, "$V_s$ & %.11f \\\\ \\hline \n", data(8));
fprintf(datatex, "$C$ & %.11f \\\\ \\hline \n", data(9));
fprintf(datatex, "$K_b$ & %.11f \\\\ \\hline \n", data(10));
fprintf(datatex, "$K_d$ & %.11f \\\\ \\hline \n", data(11));
fclose (datatex);
%%%%%%%%%%%%%%%%%%%%%% 1 %%%%%%%%%%%%%%%%%%%%%%

% NGSpice
dir = '../sim';
sim1 = fopen (fullfile(dir,"1.cir"), "w");
fprintf(sim1, "ngspice 1 \n \n");
fprintf(sim1, ".options savecurrents \n \n");
fprintf(sim1, "Vs n1 GND %.11f \n", data(8));
fprintf(sim1, "V0 GND n4 0 \n");
fprintf(sim1, "R1 n2 n1 %.11fk \n", data(1));
fprintf(sim1, "R2 n3 n2 %.11fk \n", data(2));
fprintf(sim1, "R3 n2 n5 %.11fk \n", data(3));
fprintf(sim1, "R4 n5 GND %.11fk \n", data(4));
fprintf(sim1, "R5 n6 n5 %.11fk \n", data(5));
fprintf(sim1, "R6 n7 n4 %.11fk \n", data(6));
fprintf(sim1, "R7 n8 n7 %.11fk \n", data(7));
fprintf(sim1, "H1 n5 n8 V0 %.11fk \n", data(11));
fprintf(sim1, "G1 n6 n3 n2 n5 %.11fm \n", data(10));
fprintf(sim1, "C1 n6 n8 %.11fu \n \n", data(9));
fprintf(sim1, ".control \n \n op \n");
fprintf(sim1, "echo %s \n", '"1_TAB"');
fprintf(sim1, "print all \n");
fprintf(sim1, "echo %s \n \n", '"1_END"');
fprintf(sim1, "quit \n .endc \n \n .end");
fclose (sim1);

% Theory
R1 = (str2num(sprintf('%.11f', data(1))));
R2 = (str2num(sprintf('%.11f', data(2))));
R3 = (str2num(sprintf('%.11f', data(3))));
R4 = (str2num(sprintf('%.11f', data(4))));
R5 = (str2num(sprintf('%.11f', data(5))));
R6 = (str2num(sprintf('%.11f', data(6))));
R7 = (str2num(sprintf('%.11f', data(7))));
Vs = str2num(sprintf('%.11f', data(8)));
C = (str2num(sprintf('%.11f', data(9))));
Kb = (str2num(sprintf('%.11f', data(10))));
Kd = (str2num(sprintf('%.11f', data(11))));

G1=1/R1;
G2=1/R2;
G3=1/R3;
G4=1/R4;
G5=1/R5;
G6=1/R6;
G7=1/R7;

A1 = [ 1, 0, 0, 0, 0, 0, 0, 0;...
      G1, -G1-G2-G3, G2, 0, G3, 0, 0, 0;...
      0, G2+Kb, -G2, 0, -Kb, 0, 0, 0;...
      0, 0, 0, 1, 0, 0, 0, 0;...
      -G1, G1, 0, -G4, G4-1/Kd, 0, 0, 1/Kd;... 
      0, -Kb, 0, 0, G5+Kb, -G5, 0, 0;...
      0, 0, 0, G6, -1/Kd, 0, -G6, 1/Kd;...
      0, 0, 0, 0, -1/Kd, 0, G7, -G7+1/Kd];
       
B1 = [ Vs; 0; 0; 0; 0; 0; 0; 0];

Sol1 = A1\B1;

% Voltage in all nodes
V1 = Sol1(1)
V2 = Sol1(2)
V3 = Sol1(3)
V4 = Sol1(4)
V5 = Sol1(5)
V6 = Sol1(6)
V7 = Sol1(7)
V8 = Sol1(8)
Vx = V6-V8 % alinea 2
V6e = V6 % alinea 5
% Current in all branches
I1 = (V2-V1)*G1
I2 = (V3-V2)*G2
I3 = (V5-V2)*G3
I4 = (V5-V4)*G4
I5 = (V6-V5)*G5
I6 = (V7-V4)*G6
I7 = (V8-V7)*G7
Is = I1
Ib = (V2-V5)*Kb
Ic = 0
Id = (V5-V8)/Kd

% Voltages Table
voltages1 = fopen ("1voltages.tex", "w");
fprintf(voltages1, "$V_1$ & %e \\\\ \\hline \n", V1);
fprintf(voltages1, "$V_2$ & %e \\\\ \\hline \n", V2);
fprintf(voltages1, "$V_3$ & %e \\\\ \\hline \n", V3);
fprintf(voltages1, "$V_4$ & %e \\\\ \\hline \n", V4);
fprintf(voltages1, "$V_5$ & %e \\\\ \\hline \n", V5);
fprintf(voltages1, "$V_6$ & %e \\\\ \\hline \n", V6);
fprintf(voltages1, "$V_7$ & %e \\\\ \\hline \n", V7);
fprintf(voltages1, "$V_8$ & %e \\\\ \\hline \n", V8);
fclose (voltages1);

% Currents Table
currents1 = fopen ("1currents.tex", "w");
fprintf(currents1, "$I_1$ & %e \\\\ \\hline \n", I1);
fprintf(currents1, "$I_2$ & %e \\\\ \\hline \n", I2);
fprintf(currents1, "$I_3$ & %e \\\\ \\hline \n", I3);
fprintf(currents1, "$I_4$ & %e \\\\ \\hline \n", I4);
fprintf(currents1, "$I_5$ & %e \\\\ \\hline \n", I5);
fprintf(currents1, "$I_6$ & %e \\\\ \\hline \n", I6);
fprintf(currents1, "$I_7$ & %e \\\\ \\hline \n", I7);
fprintf(currents1, "$I_s$ & %e \\\\ \\hline \n", Is);
fprintf(currents1, "$I_b$ & %e \\\\ \\hline \n", Ib);
fprintf(currents1, "$I_c$ & %e \\\\ \\hline \n", Ic);
fprintf(currents1, "$I_d$ & %e \\\\ \\hline \n", Id);
fclose (currents1);

%%%%%%%%%%%%%%%%%%%%%% 2 %%%%%%%%%%%%%%%%%%%%%%

% NGSpice
dir = '../sim';
sim2 = fopen (fullfile(dir,"2.cir"), "w");
fprintf(sim2, "ngspice 2 \n \n");
fprintf(sim2, ".options savecurrents \n \n");
fprintf(sim2, "Vs n1 GND %.11f \n", 0);
fprintf(sim2, "V0 GND n4 0 \n");
fprintf(sim2, "R1 n2 n1 %.11fk \n", data(1));
fprintf(sim2, "R2 n3 n2 %.11fk \n", data(2));
fprintf(sim2, "R3 n2 n5 %.11fk \n", data(3));
fprintf(sim2, "R4 n5 GND %.11fk \n", data(4));
fprintf(sim2, "R5 n6 n5 %.11fk \n", data(5));
fprintf(sim2, "R6 n7 n4 %.11fk \n", data(6));
fprintf(sim2, "R7 n8 n7 %.11fk \n", data(7));
fprintf(sim2, "H1 n5 n8 V0 %.11fk \n", data(11));
fprintf(sim2, "G1 n6 n3 n2 n5 %.11fm \n", data(10));
fprintf(sim2, "Vx n6 n8 %.11f \n \n", Vx);
fprintf(sim2, ".control \n \n op \n");
fprintf(sim2, "echo %s \n", '"2_TAB"');
fprintf(sim2, "print all \n");
fprintf(sim2, "echo %s \n \n", '"2_END"');
fprintf(sim2, "quit \n .endc \n \n .end");
fclose (sim2);

% Theory
A2 = [ 1, 0, 0, 0, 0, 0, 0, 0, 0;...
      G1, -G1-G2-G3, G2, 0, G3, 0, 0, 0, 0;...
      0, G2+Kb, -G2, 0, -Kb, 0, 0, 0, 0;...
      0, 0, 0, 1, 0, 0, 0, 0, 0;...
      -G1, G1, 0, -G4, G4-1/Kd, 0, 0, 1/Kd, 0;... 
      0, -Kb, 0, 0, G5+Kb, -G5, 0, 0, Vx;...
      0, 0, 0, G6, -1/Kd, 0, -G6, 1/Kd, 0;...
      0, 0, 0, 0, -1/Kd, 0, G7, -G7+1/Kd, 0;...
      0, 0, 0, 0, 0, 1, 0, -1, 0];

B2 = [ 0; 0; 0; 0; 0; 0; 0; 0; Vx];

Sol2 = A2\B2;

%Voltage in all nodes and Equivelent Resistance
V1 = Sol2(1)
V2 = Sol2(2)
V3 = Sol2(3)
V4 = Sol2(4)
V5 = Sol2(5)
V6 = Sol2(6)
V7 = Sol2(7)
V8 = Sol2(8)
Req = 1/Sol2(9)

%Current in all branches
I1 = (V2-V1)*G1
I2 = (V3-V2)*G2
I3 = (V5-V2)*G3
I4 = (V5-V4)*G4
I5 = (V6-V5)*G5
I6 = (V7-V4)*G6
I7 = (V8-V7)*G7
Is = I1
Ib = (V2-V5)*Kb
Ix = Vx/Req
Id = (V5-V8)/Kd

% Voltages and Equivelent Resistance Table
voltages2 = fopen ("2voltages.tex", "w");
fprintf(voltages2, "$V_1$ & %e \\\\ \\hline \n", V1);
fprintf(voltages2, "$V_2$ & %e \\\\ \\hline \n", V2);
fprintf(voltages2, "$V_3$ & %e \\\\ \\hline \n", V3);
fprintf(voltages2, "$V_4$ & %e \\\\ \\hline \n", V4);
fprintf(voltages2, "$V_5$ & %e \\\\ \\hline \n", V5);
fprintf(voltages2, "$V_6$ & %e \\\\ \\hline \n", V6);
fprintf(voltages2, "$V_7$ & %e \\\\ \\hline \n", V7);
fprintf(voltages2, "$V_8$ & %e \\\\ \\hline \n", V8);
fprintf(voltages2, "$R_eq$ & %e \\\\ \\hline \n", Req);
fclose (voltages2);

% Currents Table
currents2 = fopen ("2currents.tex", "w");
fprintf(currents2, "$I_1$ & %e \\\\ \\hline \n", I1);
fprintf(currents2, "$I_2$ & %e \\\\ \\hline \n", I2);
fprintf(currents2, "$I_3$ & %e \\\\ \\hline \n", I3);
fprintf(currents2, "$I_4$ & %e \\\\ \\hline \n", I4);
fprintf(currents2, "$I_5$ & %e \\\\ \\hline \n", I5);
fprintf(currents2, "$I_6$ & %e \\\\ \\hline \n", I6);
fprintf(currents2, "$I_7$ & %e \\\\ \\hline \n", I7);
fprintf(currents2, "$I_s$ & %e \\\\ \\hline \n", Is);
fprintf(currents2, "$I_b$ & %e \\\\ \\hline \n", Ib);
fprintf(currents2, "$I_x$ & %e \\\\ \\hline \n", Ix);
fprintf(currents2, "$I_d$ & %e \\\\ \\hline \n", Id);
fclose (currents2);

%%%%%%%%%%%%%%%%%%%%%% 3 %%%%%%%%%%%%%%%%%%%%%%

%NGSpice
dir = '../sim';
sim3 = fopen (fullfile(dir,"3.cir"), "w");
fprintf(sim3, "ngspice 3 \n \n");
fprintf(sim3, ".options savecurrents \n \n");
fprintf(sim3, "Vs n1 GND %.11f \n", 0);
fprintf(sim3, "V0 GND n4 0 \n");
fprintf(sim3, "R1 n2 n1 %.11fk \n", data(1));
fprintf(sim3, "R2 n3 n2 %.11fk \n", data(2));
fprintf(sim3, "R3 n2 n5 %.11fk \n", data(3));
fprintf(sim3, "R4 n5 GND %.11fk \n", data(4));
fprintf(sim3, "R5 n6 n5 %.11fk \n", data(5));
fprintf(sim3, "R6 n7 n4 %.11fk \n", data(6));
fprintf(sim3, "R7 n8 n7 %.11fk \n", data(7));
fprintf(sim3, "H1 n5 n8 V0 %.11fk \n", data(11));
fprintf(sim3, "G1 n6 n3 n2 n5 %.11fm \n", data(10));
fprintf(sim3, "C1 n6 n8 %.11fu \n \n", data(9));
fprintf(sim3, ".ic v(n6) = %.11f v(n8) = 0 \n \n", Vx);
fprintf(sim3, ".control \n \n");
fprintf(sim3, "op \n");
fprintf(sim3, "echo %s \n", '"Transient Analysis"');
fprintf(sim3, "tran 0.1m 20m uic \n");
fprintf(sim3, "set hcopypscolor=0 \n set color0=white \n set color1=black \n set color2=red \n set color3=blue \n set color4=violet \n set color5=rgb:3/8/0 \n set color6=rgb:4/0/0 \n");
fprintf(sim3, "hardcopy 3.ps v(n6)  \n");
fprintf(sim3, "echo 3_FIG \n");
fprintf(sim3, "quit \n .endc \n \n .end");
fclose (sim3);

%Theory
int = 0:0.1:20;
V6n = Vx*exp(-int/Req*C);
fig1 = figure();
plot(int, V6n)
xlabel ("t (ms)")
ylabel ("V6n (V)")
title ("Natural Solution V6n(t)")
print (fig1, "3.eps", "-depsc");

%%%%%%%%%%%%%%%%%%%%%% 4 %%%%%%%%%%%%%%%%%%%%%%
%NGSpice
dir = '../sim';
sim4 = fopen (fullfile(dir,"4.cir"), "w");
fprintf(sim4, "ngspice 4 \n \n");
fprintf(sim4, ".options savecurrents \n \n");
fprintf(sim4, "Vs n1 GND 0  ac 1 sin(0 1 1k)\n");
fprintf(sim4, "V0 GND n4 0 \n");
fprintf(sim4, "R1 n2 n1 %.11fk \n", data(1));
fprintf(sim4, "R2 n3 n2 %.11fk \n", data(2));
fprintf(sim4, "R3 n2 n5 %.11fk \n", data(3));
fprintf(sim4, "R4 n5 GND %.11fk \n", data(4));
fprintf(sim4, "R5 n6 n5 %.11fk \n", data(5));
fprintf(sim4, "R6 n7 n4 %.11fk \n", data(6));
fprintf(sim4, "R7 n8 n7 %.11fk \n", data(7));
fprintf(sim4, "H1 n5 n8 V0 %.11fk \n", data(11));
fprintf(sim4, "G1 n6 n3 n2 n5 %.11fm \n", data(10));
fprintf(sim4, "C1 n6 n8 %.11fu \n \n", data(9));
fprintf(sim4, ".ic v(n6) = %.11f v(n8) = 0 \n \n", Vx);
fprintf(sim4, ".control \n \n op \n");
fprintf(sim4, "echo %s \n", '"Transient Analysis"');
fprintf(sim4, "tran 0.1m 20m uic \n");
fprintf(sim4, "set hcopypscolor=0 \n set color0=white \n set color1=black \n set color2=red \n set color3=blue \n set color4=violet \n set color5=rgb:3/8/0 \n set color6=rgb:4/0/0 \n");
fprintf(sim4, "hardcopy 4.ps v(n6) v(n1) \n");
fprintf(sim4, "echo 4_FIG \n");
fprintf(sim4, "quit \n .endc \n \n .end");
fclose (sim4);

%Theory
f=1000
w=2*pi*f
Zc=1000/(w*C*j)

A4 = [ 1, 0, 0, 0, 0, 0, 0, 0;...
      G1, -G1-G2-G3, G2, 0, G3, 0, 0, 0;...
      0, G2+Kb, -G2, 0, -Kb, 0, 0, 0;...
      0, 0, 0, 1, 0, 0, 0, 0;...
      -G1, G1, 0, -G4, G4-1/Kd, 0, 0, 1/Kd;... 
      0, -Kb, 0, 0, G5+Kb, -G5-1/Zc, 0, 1/Zc;...
      0, 0, 0, G6, -1/Kd, 0, -G6, 1/Kd;...
      0, 0, 0, 0, -1/Kd, 0, G7, -G7+1/Kd];
       
B4 = [ j; 0; 0; 0; 0; 0; 0; 0];
Sol4 = A4\B4;

%Voltage in all nodes
V1 = Sol4(1)
V2 = Sol4(2)
V3 = Sol4(3)
V4 = Sol4(4)
V5 = Sol4(5)
V6 = Sol4(6)
V7 = Sol4(7)
V8 = Sol4(8)

%Current in all branches
I1 = (V2-V1)*G1
I2 = (V3-V2)*G2
I3 = (V5-V2)*G3
I4 = (V5-V4)*G4
I5 = (V6-V5)*G5
I6 = (V7-V4)*G6
I7 = (V8-V7)*G7
Is = I1
Ib = (V2-V5)*Kb
Ic = (V6-V8)/Zc
Id = (V5-V8)/Kd

AV1 = abs(V1)
AV2 = abs(V2)
AV3 = abs(V3)
AV4 = abs(V4)
AV5 = abs(V5)
AV6 = abs(V6)
AV7 = abs(V7)
AV8 = abs(V8)
PV1 = angle(V1) 
PV2 = angle(V2) 
PV3 = angle(V3) 
PV4 = angle(V4) 
PV5 = angle(V5) 
PV6 = angle(V6) 
PV7 = angle(V7) 
PV8 = angle(V8) 

V6f = AV6*cos(int*2*pi - PV6);

hf1 = figure ();
plot(int, V6f)
xlabel ("t (ms)")
ylabel ("V6f (V)")
title ("Forced Solution V6f(t)")
print (hf1, "4.eps", "-depsc");

abs4 = fopen ("4absolute.tex", "w");
fprintf(abs4, "$V_1$ & %e \\\\ \\hline \n", AV1);
fprintf(abs4, "$V_2$ & %e \\\\ \\hline \n", AV2);
fprintf(abs4, "$V_3$ & %e \\\\ \\hline \n", AV3);
fprintf(abs4, "$V_3$ & %e \\\\ \\hline \n", AV4);
fprintf(abs4, "$V_5$ & %e \\\\ \\hline \n", AV5);
fprintf(abs4, "$V_6$ & %e \\\\ \\hline \n", AV6);
fprintf(abs4, "$V_7$ & %e \\\\ \\hline \n", AV7);
fprintf(abs4, "$V_8$ & %e \\\\ \\hline \n", AV8);
fclose (abs4);

ph4 = fopen ("4phase.tex", "w");
fprintf(ph4, "$Ph_1$ & %e \\\\ \\hline \n", PV1);
fprintf(ph4, "$Ph_2$ & %e \\\\ \\hline \n", PV2);
fprintf(ph4, "$Ph_3$ & %e \\\\ \\hline \n", PV3);
fprintf(ph4, "$Ph_4$ & %e \\\\ \\hline \n", PV4);
fprintf(ph4, "$Ph_5$ & %e \\\\ \\hline \n", PV5);
fprintf(ph4, "$Ph_6$ & %e \\\\ \\hline \n", PV6);
fprintf(ph4, "$Ph_7$ & %e \\\\ \\hline \n", PV7);
fprintf(ph4, "$Ph_8$ & %e \\\\ \\hline \n", PV8);
fclose (ph4);

%%%%%%%%%%%%%%%%%%%%%% 5 %%%%%%%%%%%%%%%%%%%%%%
%NGSpice
dir = '../sim';
sim5 = fopen (fullfile(dir,"5.cir"), "w");
fprintf(sim5, "ngspice 5 \n \n");
fprintf(sim5, ".options savecurrents \n \n");
fprintf(sim5, "Vs n1 GND 0  ac 1 sin(0 1 1k)\n");
fprintf(sim5, "V0 GND n4 0 \n");
fprintf(sim5, "R1 n2 n1 %.11fk \n", data(1));
fprintf(sim5, "R2 n3 n2 %.11fk \n", data(2));
fprintf(sim5, "R3 n2 n5 %.11fk \n", data(3));
fprintf(sim5, "R4 n5 GND %.11fk \n", data(4));
fprintf(sim5, "R5 n6 n5 %.11fk \n", data(5));
fprintf(sim5, "R6 n7 n4 %.11fk \n", data(6));
fprintf(sim5, "R7 n8 n7 %.11fk \n", data(7));
fprintf(sim5, "H1 n5 n8 V0 %.11fk \n", data(11));
fprintf(sim5, "G1 n6 n3 n2 n5 %.11fm \n", data(10));
fprintf(sim5, "C1 n6 n8 %.11fu \n \n", data(9));
fprintf(sim5, ".ic v(n6) = %.11f v(n8) = 0 \n \n", Vx);
fprintf(sim5, ".control \n \n");
fprintf(sim5, "op \n");
fprintf(sim5, "echo %s \n", '"Frequency Analysis"');
fprintf(sim5, "ac dec 1000 0.1 1MEG \n");
fprintf(sim5, "set hcopypscolor=0 \n set color0=white \n set color1=black \n set color2=red \n set color3=blue \n set color4=violet \n set color5=rgb:3/8/0 \n set color6=rgb:4/0/0 \n");
fprintf(sim5, "hardcopy 5a.ps vdb(n6) vdb(n1) xlimit 1 1000k \n");
fprintf(sim5, "echo 5a_FIG \n");
%fprintf(sim5, "hardcopy finalsimb.ps cph(n6) cph(n1) xlimit 1 1000k \n");
%fprintf(sim5, "echo finalsimb_FIG \n");
fprintf(sim5, "let outd(V6) = 180/PI*cph(n6)+90 \n let outd(Vs) = 180/PI*cph(n1)+90 \n");
fprintf(sim5, "hardcopy 5b.ps outd(V6) outd(Vs) xlimit 1 1000k \n");
fprintf(sim5, "echo 5b_FIG \n");
fprintf(sim5, "quit \n .endc \n \n .end");
fclose (sim5);

%Theory

t1 = 0:0.1:20;
Vst1 = sin(2*pi*t1);
V6t1 = V6n + V6f;

t2 = -5:0.1:0;
Vst2 = Vs+0*t2;
V6t2 = V6e+0*t2;

t3=[t2,t1];
Vst3 = [Vst2 Vst1];
V6t3 = [V6t2, V6t1];

fig3 = figure ();
plot(t3, Vst3, 'r', t3, V6t3, 'b')
xlabel ("t (ms)")
ylabel ("Voltage (V)")
title ("Total Solution V6(t)")
print (fig3, "5.eps", "-depsc");

%%%%%%%%%%%%%%%%%%%%%% 6 %%%%%%%%%%%%%%%%%%%%%%

tlog=logspace(-1, 6, 100)

for k=1:100
 Zc = 1000/(j*2*pi*tlog(k)*C)

A6 = [ 1, 0, 0, 0, 0, 0, 0, 0;...
      G1, -G1-G2-G3, G2, 0, G3, 0, 0, 0;...
      0, G2+Kb, -G2, 0, -Kb, 0, 0, 0;...
      0, 0, 0, 1, 0, 0, 0, 0;...
      -G1, G1, 0, -G4, G4-1/Kd, 0, 0, 1/Kd;... 
      0, -Kb, 0, 0, G5+Kb, -G5-1/Zc, 0, 1/Zc;...
      0, 0, 0, G6, -1/Kd, 0, -G6, 1/Kd;...
      0, 0, 0, 0, -1/Kd, 0, G7, -G7+1/Kd];
       
B6 = [ j; 0; 0; 0; 0; 0; 0; 0];
Sol6 = A6\B6;

%Voltage in all nodes
V1 = Sol6(1)
V2 = Sol6(2)
V3 = Sol6(3)
V4 = Sol6(4)
V5 = Sol6(5)
V6 = Sol6(6)
V7 = Sol6(7)
V8 = Sol6(8)
Vsfre(k) = V1
V6fre(k) = V6
Vcfre(k) = V6-V8
endfor

fig4 = figure ();
plot(log10(tlog), 20*log10(abs(Vcfre)), 'g');
hold on
plot(log10(tlog), 20*log10(abs(Vsfre)), 'b');
plot(log10(tlog), 20*log10(abs(V6fre)), 'r');
xlabel ("log scale f (Hz)");
ylabel ("Magnitude (dB)");
ylim([-5 1])
title ("Frequency Response")
print (fig4, "6a.eps", "-depsc");

fig5 = figure ();
plot(log10(tlog), (angle(Vcfre))*180/pi, 'g');
hold on
plot(log10(tlog), (angle(Vsfre))*180/pi, 'b');
hold on
plot(log10(tlog), (angle(V6fre))*180/pi, 'r');
xlabel ("log scale f (Hz)");
ylabel ("Phase (degrees)");
title ("Frequency Response")
print (fig5, "6b.eps", "-depsc");
