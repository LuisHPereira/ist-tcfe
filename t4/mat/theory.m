clear all

%Data
VT = 25e-3;
BFN = 178.7;
VAFN = 69.7;
RE1 = 100;
RC1 = 2500;
RB1 = 25000;
RB2 = 1600;
VBEON = 0.7;
VCC = 12;
RS = 100;
Ci = 500e-06;
CB = 500e-06;
Co = 300e-6;
Vin = 0.01;
BFP = 227.3;
VAFP = 37.2;
RE2 = 100;
VEBON = 0.7;

%NGSpice
file4sim = fopen ("t4.cir", "w");
fprintf(file4sim,"Ngspice Sim4 \n")
fprintf(file4sim,"* PHILIPS BJT'S \n")
fprintf(file4sim,".MODEL BC557A PNP(IS=2.059E-14 ISE=2.971f ISC=1.339E-14 XTI=3 BF=227.3 BR=7.69 IKF=0.08719 IKR=0.07646 XTB=1.5 VAF=37.2 VAR=11.42 VJE=0.5912 VJC=0.1 RE=0.688 RC=0.6437 RB=1 RBM=1 IRB=1E-06 CJE=1.4E-11 CJC=1.113E-11 XCJC=0.6288 FC=0.7947 NF=1.003 NR=1.007 NE=1.316 NC=1.15 MJE=0.3572 MJC=0.3414 TF=7.046E-10 TR=1m2 ITF=0.1947 VTF=5.367 XTF=4.217 EG=1.11) \n")
fprintf(file4sim,".MODEL BC547A NPN(IS=1.533E-14 ISE=7.932E-16 ISC=8.305E-14 XTI=3 BF=178.7 BR=8.628 IKF=0.1216 IKR=0.1121 XTB=1.5 VAF=69.7 VAR=44.7 VJE=0.4209 VJC=0.2 RE=0.6395 RC=0.6508 RB=1 RBM=1 IRB=1E-06 CJE=1.61E-11 CJC=4.388p XCJC=0.6193 FC=0.7762 NF=1.002 NR=1.004 NE=1.436 NC=1.207 MJE=0.3071 MJC=0.2793 TF=4.995E-10 TR=1m2 ITF=0.7021 VTF=3.523 XTF=139 EG=1.11) \n \n")
fprintf(file4sim,"Vcc vcc 0 %f \n", VCC)
fprintf(file4sim,"Vin in 0 0 ac 1.0 sin(0 10m 1k) \n")
fprintf(file4sim,"Rin in in2 100 \n \n")
fprintf(file4sim,"Ci in2 base %f \n \n",Ci)
fprintf(file4sim,"R1 vcc base %f \n", RB1)
fprintf(file4sim,"R2 base 0 %f \n \n", RB2)
fprintf(file4sim,"Q1 coll base emit BC547A \n")
fprintf(file4sim,"Rc vcc coll %f \n", RC1)
fprintf(file4sim,"Re emit 0 100 \n \n", RE1)
fprintf(file4sim,"Cb emit 0 %f \n \n", CB)
fprintf(file4sim,"Q2 0 coll emit2 BC557A \n")
fprintf(file4sim,"Rout emit2 vcc 200 \n \n")
fprintf(file4sim,"Co emit2 out %f \n \n", Co)
fprintf(file4sim,"RL out 0 8 \n \n")
fprintf(file4sim,".op \n")
fprintf(file4sim,".end \n \n")
fprintf(file4sim,".control \n")
fprintf(file4sim,"op \n")
fprintf(file4sim,"echo %s \n", '"NPN_TAB"')
fprintf(file4sim,"let Vce=v(coll)-v(emit) \n")
fprintf(file4sim,"echo %s \n", '"Vce = $&Vce"')
fprintf(file4sim,"let Vbe=v(base)-v(emit) \n")
fprintf(file4sim,"echo %s \n", '"Vbe = $&Vbe"')
fprintf(file4sim,"if (Vce>Vbe) \n")
fprintf(file4sim,"echo %s \n", '"Vce greater than Vbe = True"')
fprintf(file4sim,"else \n")
fprintf(file4sim,"echo %s \n", '"Vce greater than Vbe = False"')
fprintf(file4sim,"endif \n")
fprintf(file4sim,"echo %s \n \n", '"NPN_END"');
fprintf(file4sim,"echo %s \n", '"PNP_TAB"');
fprintf(file4sim,"let Vec=v(emit2) \n");
fprintf(file4sim,"echo %s \n", '"Vec = $&Vec"')
fprintf(file4sim,"let Veb=v(emit2)-v(coll) \n")
fprintf(file4sim,"echo %s \n", '"Veb = $&Veb"')
fprintf(file4sim,"if (Vec>Veb) \n")
fprintf(file4sim,"echo %s \n", '"Vec greater than Veb = True"')
fprintf(file4sim,"else \n")
fprintf(file4sim,"echo %s \n", '"Vec greater than Veb = False"')
fprintf(file4sim,"endif \n")
fprintf(file4sim,"echo %s \n \n", '"PNP_END"')
fprintf(file4sim,"tran 1e-5 1e-2 \n");
fprintf(file4sim,"plot v(coll) \n");
fprintf(file4sim,"hardcopy vo1.ps vdb(coll) \n");
fprintf(file4sim,"echo vo1_FIG \n \n");
fprintf(file4sim,"ac dec 10 10 100MEG \n");
fprintf(file4sim,"plot vdb(coll) \n");
fprintf(file4sim,"plot vp(coll) \n");
fprintf(file4sim,"hardcopy vo1f.ps vdb(coll) \n");
fprintf(file4sim,"echo vo1f_FIG \n \n");
fprintf(file4sim,"plot vdb(out) \n");
fprintf(file4sim,"plot vp(out) \n");
fprintf(file4sim,"hardcopy vo2f.ps vdb(out) \n");
fprintf(file4sim,"echo vo2f_FIG \n \n");
fprintf(file4sim,"meas ac max MAX vdb(out) from=10 to=100MEG \n")
fprintf(file4sim,"let range = max - 3 \n")
fprintf(file4sim,"meas AC minimum WHEN vdb(out) = range \n")
fprintf(file4sim,"meas AC maximum WHEN vdb(out) = range CROSS=LAST \n \n")
fprintf(file4sim,"let bandwidth = maximum-minimum \n");
fprintf(file4sim,"let gain = 10^(max/20) \n");
fprintf(file4sim,"let gaindb = max \n");
fprintf(file4sim,"let Cof= minimum \n \n");
fprintf(file4sim,"echo %s \n", '"sim_TAB"');
fprintf(file4sim,"echo %s \n", '"GainDB = $&gaindb dB"');
fprintf(file4sim,"echo %s \n", '"Bandwidth = $&bandwidth Hz"');
fprintf(file4sim,"echo %s \n", '"FreqCout = $&Cof Hz"');
fprintf(file4sim,"echo %s \n \n", '"sim_END"');
fprintf(file4sim,"let zin = -v(in2)[40]/vin#branch[40] \n");
fprintf(file4sim,"plot abs(v(in2)[40]/vin#branch[40]/(-1000)) \n \n")
fprintf(file4sim,"echo %s \n", '"Zin_TAB"')
fprintf(file4sim,"echo %s \n", '"Zin = $&zin Ohm"')
fprintf(file4sim,"echo %s \n \n", '"Zin_END"')
fprintf(file4sim,"let quality = bandwidth*gain/Cof \n");
fprintf(file4sim,"let cost = 824.608 \n");
fprintf(file4sim,"let merit = quality/cost \n \n");
fprintf(file4sim,"echo %s \n", '"Merit_TAB"');
fprintf(file4sim,"echo %s \n", '"Cost = $&cost"');
fprintf(file4sim,"echo %s \n", '"Quality = $&quality"');
fprintf(file4sim,"echo %s \n", '"Merit = $&merit"');
fprintf(file4sim,"echo %s \n \n", '"Merit_END"');
fprintf(file4sim,"quit \n")
fprintf(file4sim,".endc");
fclose (file4sim);

file4sim = fopen ("t42.cir", "w");
fprintf(file4sim,"Ngspice Sim4 \n")
fprintf(file4sim,"* PHILIPS BJT'S \n")
fprintf(file4sim,".MODEL BC557A PNP(IS=2.059E-14 ISE=2.971f ISC=1.339E-14 XTI=3 BF=227.3 BR=7.69 IKF=0.08719 IKR=0.07646 XTB=1.5 VAF=37.2 VAR=11.42 VJE=0.5912 VJC=0.1 RE=0.688 RC=0.6437 RB=1 RBM=1 IRB=1E-06 CJE=1.4E-11 CJC=1.113E-11 XCJC=0.6288 FC=0.7947 NF=1.003 NR=1.007 NE=1.316 NC=1.15 MJE=0.3572 MJC=0.3414 TF=7.046E-10 TR=1m2 ITF=0.1947 VTF=5.367 XTF=4.217 EG=1.11) \n")
fprintf(file4sim,".MODEL BC547A NPN(IS=1.533E-14 ISE=7.932E-16 ISC=8.305E-14 XTI=3 BF=178.7 BR=8.628 IKF=0.1216 IKR=0.1121 XTB=1.5 VAF=69.7 VAR=44.7 VJE=0.4209 VJC=0.2 RE=0.6395 RC=0.6508 RB=1 RBM=1 IRB=1E-06 CJE=1.61E-11 CJC=4.388p XCJC=0.6193 FC=0.7762 NF=1.002 NR=1.004 NE=1.436 NC=1.207 MJE=0.3071 MJC=0.2793 TF=4.995E-10 TR=1m2 ITF=0.7021 VTF=3.523 XTF=139 EG=1.11) \n \n")
fprintf(file4sim,"Vcc vcc 0 %f \n", VCC)
fprintf(file4sim,"Vin in 0 0 ac 1.0 sin(0 10m 1k) \n")
fprintf(file4sim,"Rin in in2 100 \n \n")
fprintf(file4sim,"Ci in2 base %f \n \n", Ci)
fprintf(file4sim,"R1 vcc base %f \n", RB1)
fprintf(file4sim,"R2 base 0 %f \n \n", RB2)
fprintf(file4sim,"Q1 coll base emit BC547A \n")
fprintf(file4sim,"Rc vcc coll %f \n", RC1)
fprintf(file4sim,"Re emit 0 %f \n \n", RE1)
fprintf(file4sim,"Cb emit 0 %f \n \n", CB)
fprintf(file4sim,"Q2 0 coll emit2 BC557A \n")
fprintf(file4sim,"Rout emit2 vcc 200 \n \n")
fprintf(file4sim,"Co emit2 out %f \n \n", Co)
fprintf(file4sim,"VL out 0 ac 1.0 sin(0 10m 1k) \n \n")
fprintf(file4sim,".op \n")
fprintf(file4sim,".end \n \n")
fprintf(file4sim,".control \n \n")
fprintf(file4sim,"ac dec 10 10 100MEG \n \n");
fprintf(file4sim,"let Zout = -v(out)[40]/i(VL)[40] \n \n");
fprintf(file4sim,"echo %s \n", '"Zout_TAB"')
fprintf(file4sim,"echo %s \n", '"Zout = $&Zout Ohm"')
fprintf(file4sim,"echo %s \n \n", '"Zout_END"')
fprintf(file4sim,"quit \n")
fprintf(file4sim,".endc");
fclose (file4sim);


%Initial Values Table
IV = fopen ("IV.tex", "w");
fprintf(IV, "R1 & %e Ohm \\\\ \\hline \n \n", RB1);
fprintf(IV, "R2 & %e Ohm \\\\ \\hline \n \n", RB2);
fprintf(IV, "RC & %e Ohm \\\\ \\hline \n \n", RC1);
fprintf(IV, "Re & %e Ohm \\\\ \\hline \n \n", RE1);
fprintf(IV, "Rout & %e Ohm \\\\ \\hline \n \n", RE1);
fprintf(IV, "Ci & %e F \\\\ \\hline \n \n", Ci);
fprintf(IV, "CB & %e F \\\\ \\hline \n \n", CB);
fprintf(IV, "Co & %e F \\\\ \\hline \n \n", Co);
fclose (IV);

%Gain Stage
f = logspace(1,8, 100);
w = 2*pi*f;
Zci = 1./(j*w*Ci);
ZcB = 1./(j*w*CB);
RB=1/(1/RB1+1/RB2);
VEQ=RB2/(RB1+RB2)*VCC;
IB1=(VEQ-VBEON)/(RB+(1+BFN)*RE1);
IC1=BFN*IB1;
IE1=(1+BFN)*IB1;
VE1=RE1*IE1;
VO1=VCC-RC1*IC1;
VCE=VO1-VE1;
gm1=IC1/VT;
rpi1=BFN/gm1;
ro1=VAFN/IC1;
R_sum = RB+RS;

%Gain Stage Matrix
for k=1:length(w)
Z_sum = Zci(k)+ZcB(k); 
X = [RE1 + ro1 + RC1, 0, -ro1, -RE1, 0;
    0, -RB, 0, 0, R_sum;
    -RE1, -ZcB(k), 0, RE1 + ZcB(k), 0; 
    0, RB+Z_sum+rpi1, 0, -ZcB(k), -RB
    0, gm1*rpi1, 1, 0, 0;];
Y = [0; Vin; 0; 0; 0];
Res = X\Y;
VGS(k) = abs(RC1 * Res(1));
AV1(k) = VGS(k)/Vin;
endfor

%Gain Stage Impedences
ZI1 = 1/(1/RB + 1/rpi1);
ZO1 = 1/(1/ro1+1/RC1);

%Gain Stage Table
GS = fopen ("GS.tex", "w");
fprintf(GS, "Input impedance & %e Ohm \\\\ \\hline \n \n", ZI1);
fprintf(GS, "Output impedance & %e Ohm \\\\ \\hline \n \n", ZO1);
fprintf(GS, "Gain & %e V \\\\ \\hline \n \n", mean(abs(AV1)));
fprintf(GS, "Gain (dB) & %e dB \\\\ \\hline \n \n", 20*log10(mean(abs(AV1))));
fclose (GS);


%Output Stage

VI2 = VO1;
IE2 = (VCC-VEBON-VI2)/RE2;
IC2 = BFP/(BFP+1)*IE2;
VO2 = VCC - RE2*IE2;
gm2 = IC2/VT;
go2 = IC2/VAFP;
gpi2 = gm2/BFP;
ge2 = 1/RE2;

%Output Stage Matrix
I2 = [];
vo2 = [];
AV2 = [];
for k=1:length(w)
X1 = [1/gpi2+RE2,-RE2, 0;
      gm2*1/gpi2, 0, 1; 
      -RE2, RE2+1/go2, -1/go2];
Y1 = [VGS(k); 0; 0];
Res1 = X1\Y1;
VOS(k) = abs((Res1(1)-Res1(2))*RE2);
AV2(k) = VOS(k)/VGS(k);
endfor

%Output Stage Impedences
ZI2 = (gm2+gpi2+go2+ge2)/gpi2/(gpi2+go2+ge2);
ZO2 = 1/(gm2+gpi2+go2+ge2);

%Total Results
gB = 1/(1/gpi2+ZO1);
ZI=ZI1;
ZO = 1/(go2+gm2/gpi2*gB+ge2+gB);
AVtot = (gB+gm2/gpi2*gB)/(gB+ge2+go2+gm2/gpi2*gB)*AV1;

%Output Stage Table
OS = fopen ("OS.tex", "w");
fprintf(OS, "Input Impedance & %e Ohm \\\\ \\hline \n \n", ZI2);
fprintf(OS, "Output Impedance & %e Ohm \\\\ \\hline \n \n", ZO2);
fprintf(OS, "Gain & %e V \\\\ \\hline \n \n", mean(abs(AV2)));
fprintf(OS, "Gain (dB) & %e dB \\\\ \\hline \n \n", 20*log10(mean(abs(AV2))));
fclose (OS);

%Gain Graph
graph = figure();
plot(log10(f),20*log10(AVtot),'b');
xlabel ("Frequency (Hz)");
ylabel ("Gain (dB)");
print(graph, "gain.eps", "-color");

%Total Table
TOTAL = fopen ("TOTAL.tex", "w");
fprintf(TOTAL, "Input Impedance & %e Ohm \\\\ \\hline \n \n", ZI);
fprintf(TOTAL, "Output Impedance & %e Ohm \\\\ \\hline \n \n", ZO);
fprintf(TOTAL, "Gain & %e V \\\\ \\hline \n \n", mean(abs(AVtot)));
fprintf(TOTAL, "Gain (dB) & %e dB \\\\ \\hline \n \n", 20*log10(mean(abs(AVtot))));
fclose (TOTAL);
