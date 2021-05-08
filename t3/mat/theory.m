close all
clear all
format long

%%% Data read %%%
dirdata = '..'
dados=fopen (fullfile(dirdata,'data.txt'),'r');
data=fscanf(dados, '%f', [inf]);
data = data';
fclose(dados);

R1 = data(1);
C = data(2);
f = data(3);
vI = data(4);
R2 = data(5);
n1 = data(6);
n2 = data(7);
vt = data(8);
Is = data(9);
new = data(10);
A = vI/n1;
vDiodes = 12/n2;

%%% NGSpice %%%

file4sim = fopen ("t3.cir", "w");
fprintf(file4sim,"Ngspice Sim3 \n")
fprintf(file4sim,"Vi 1 0 0 sin(0 %f %f 0 0 90) \n", vI, f)
fprintf(file4sim,"D1 2 4 Default \n")
fprintf(file4sim,"D2 GND 2 Default \n")
fprintf(file4sim,"D3 3 4 Default \n")
fprintf(file4sim,"D4 GND 3 Default \n")
fprintf(file4sim,"R1 GND 4 %f \n", R1)
fprintf(file4sim,"R2 5 4 %f \n", R2)
fprintf(file4sim,"C 4 GND %f \n", C)
fprintf(file4sim,"DS 5 GND Default_s \n")
fprintf(file4sim,"F 1 0 E %f \n",1/n1)
fprintf(file4sim,"E 3 2 1 0 %f \n",1/n1)
fprintf(file4sim,".model Default D \n")
fprintf(file4sim,".model Default_s D (n=%f) \n", n2)
fprintf(file4sim,".control \n")
fprintf(file4sim,"set hcopypscolor=0 \n")
fprintf(file4sim,"set color0=white \n")
fprintf(file4sim,"set color1=black \n")
fprintf(file4sim,"set color2=red \n")
fprintf(file4sim,"set color3=blue \n")
fprintf(file4sim,"set color4=violet \n")
fprintf(file4sim,"set color5=rgb:3/8/0 \n")
fprintf(file4sim,"set color6=rgb:4/0/0 \n")
fprintf(file4sim,"op \n")
fprintf(file4sim,"tran 0.0002 400m 200m \n");
fprintf(file4sim,"meas tran avg_evo AVG v(4) from=0.001 to=0.4 \n")
fprintf(file4sim,"meas tran max_evo MAX v(4) from=0.001 to=0.4 \n")
fprintf(file4sim,"meas tran min_evo MIN v(4) from=0.001 to=0.4 \n")
fprintf(file4sim,"meas tran avg_reg AVG v(5) from=0.001 to=0.4 \n")
fprintf(file4sim,"meas tran max_reg MAX v(5) from=0.001 to=0.4 \n")
fprintf(file4sim,"meas tran min_reg MIN v(5) from=0.001 to=0.4 \n")
fprintf(file4sim,"let RipEnv = max_evo-min_evo \n");
fprintf(file4sim,"let vEnvAvg = avg_evo \n");
fprintf(file4sim,"let RipReg = max_reg-min_reg \n");
fprintf(file4sim,"let vRegAvg = avg_reg \n");
fprintf(file4sim,"echo %s \n", "sim_TAB");
fprintf(file4sim,"print RipEnv \n")
fprintf(file4sim,"print vEnvAvg \n");
fprintf(file4sim,"print RipReg \n")
fprintf(file4sim,"print vRegAvg \n");
fprintf(file4sim,"echo %s \n", "sim_END");
fprintf(file4sim,"let avg12_reg = abs(mean(v(5)-12)) \n");
fprintf(file4sim,"let Merit = 1/ (37.4* ((max_reg-min_reg) + avg12_reg + 10e-6)) \n");
fprintf(file4sim,"echo %s \n", "merit_TAB");
fprintf(file4sim,"print Merit \n");
fprintf(file4sim,"echo %s \n", "merit_END");
fprintf(file4sim,"let v4 = v(4)-2*v(2)[0] \n")
fprintf(file4sim,"hardcopy simcomp.ps v(3)-v(2) v4 v(5) \n")
fprintf(file4sim,"echo simcomp_FIG \n")
fprintf(file4sim,"hardcopy simdev.ps v(5)-12 \n")
fprintf(file4sim,"echo simdev_FIG \n")
fprintf(file4sim,"quit \n")
fprintf(file4sim,".endc");
fclose (file4sim);


%%% Theoretical Analysis %%%
% Envelope Voltage
t=linspace(0, 10/f, 50000);
w=2*pi*f;
vCos = A * cos(w*t);
vEnv = t*0;
tOff = 1/w * atan(1/w/R1/C);
vOn = A*cos(w*tOff)*exp(-(t-tOff)/R1/C);

for i=1:length(t)
  if t(i) < tOff
    vEnv(i) = abs(vCos(i));
  elseif vOn(i) > abs(vCos(i))
    vEnv(i) = vOn(i);
  else
    tOff = tOff + 1/(f*2);
    vOn = A*abs(cos(w*tOff))*exp(-(t-tOff)/R1/C);
    vEnv(i) = abs(vCos(i));
  endif
endfor

% Envelope Average Voltage and Ripple
vEnvAvg = mean(vEnv)
RipEnv = max(vEnv) - min(vEnv)

% Regulator Voltage
vReg = t*0;
VRegD = 0;
VRegA = t*0;

if vEnvAvg >= vDiodes*n2
  VRegD = vDiodes*n2;
else
  VRegD = vEnvAvg;
endif

rd = new*vt/(Is*exp(vDiodes/(new*vt)))

for i = 1:length(t)
  if vEnv(i) >= n2*vDiodes
    VRegA(i) = n2*rd/(n2*rd+R2) * (vEnv(i)-vEnvAvg);
  else
    VRegA(i) = vEnv(i)-vEnvAvg;
  endif
endfor

vReg = VRegD + VRegA;

% Regulator Average Voltage and Ripple
vRegAvg = mean(vReg)
RipReg = max(vReg)-min(vReg)

% Graphs

graph1 = figure(1);
title('Regulator and envelope output voltage v_o(t)')
plot (t*1000, vCos, ";vs_{transformer}(t);", t*1000,vEnv, ";vo_{envelope}(t);", t*1000,vReg, ";vo_{regulator}(t);");
xlabel ("t [ms]")
ylabel ("v_O [Volts]")
legend('Location','northeast');
print (graph1, "all_vout.eps", "-depsc");

graph2 = figure(2);
title('Deviations from desired DC voltage')
plot (t*1000,(vReg-12)*1000, ";vo_{regulator}-12(t);");
xlabel ("t [ms]")
ylabel ("v_O [mV]")
legend('Location','northeast');
print (graph2, "deviation.eps", "-depsc");

% Cost and Merit Tables
cost = R1/1000 + R2/1000 + C*1e6 + n2*0.1*2 +0.4; 
merit = 1/(cost*(RipReg + abs(vRegAvg - 12) + 1e-6))

RipAvg = fopen ("RipAvg.tex", "w");
fprintf(RipAvg, "Ripple Envelope & %e \\\\ \\hline \n", RipEnv);
fprintf(RipAvg, "Average Envelope & %e \\\\ \\hline \n", vEnvAvg);
fprintf(RipAvg, "Ripple Regulator & %e \\\\ \\hline \n", RipReg);
fprintf(RipAvg, "Average Regulator & %e \\\\ \\hline \n", vRegAvg);
fclose (RipAvg);

MeritTable = fopen ("MeritTable.tex", "w");
fprintf(MeritTable, "Merit & %e \\\\ \\hline \n", merit);
fclose (MeritTable);
