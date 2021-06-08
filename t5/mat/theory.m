%data
C1 = 220e-9;
C2 = 82.7e-9;
R1 = 1e3;
R2 = 1e3;
R3 = 130e3;
R4 = 1e3;

%NGSpice
file51sim = fopen ("t51.cir", "w");
fprintf(file51sim,"Ngspice Sim5 \n")
fprintf(file51sim,"*----------------------------------------------------------------------------- \n \n")
fprintf(file51sim,"*To use a subcircuit, the name must begin with 'X'.  For example: \n")
fprintf(file51sim,"* X1 1 2 3 4 5 uA741 \n \n")
fprintf(file51sim,"* connections:   non-inverting input \n")
fprintf(file51sim,"*                |  inverting input \n")
fprintf(file51sim,"*                |  |  positive power supply \n")
fprintf(file51sim,"*                |  |  |  negative power supply \n")
fprintf(file51sim,"*                |  |  |  |  output \n")
fprintf(file51sim,"*                |  |  |  |  | \n")
fprintf(file51sim,".subckt uA741    1  2  3  4  5 \n \n")
fprintf(file51sim,"c1   11 12 8.661E-12 \n")
fprintf(file51sim,"c2    6  7 30.00E-12 \n")
fprintf(file51sim,"dc    5 53 dx \n")
fprintf(file51sim,"de   54  5 dx \n")
fprintf(file51sim,"dlp  90 91 dx \n")
fprintf(file51sim,"dln  92 90 dx \n")
fprintf(file51sim,"dp    4  3 dx \n")
fprintf(file51sim,"egnd 99  0 poly(2) (3,0) (4,0) 0 .5 .5 \n")
fprintf(file51sim,"fb    7 99 poly(5) vb vc ve vlp vln 0 10.61E6 -10E6 10E6 10E6 -10E6 \n")
fprintf(file51sim,"ga    6  0 11 12 188.5E-6 \n")
fprintf(file51sim,"gcm   0  6 10 99 5.961E-9 \n")
fprintf(file51sim,"iee  10  4 dc 15.16E-6 \n")
fprintf(file51sim,"hlim 90  0 vlim 1K \n")
fprintf(file51sim,"q1   11  2 13 qx \n")
fprintf(file51sim,"q2   12  1 14 qx \n")
fprintf(file51sim,"r2    6  9 100.0E3 \n")
fprintf(file51sim,"rc1   3 11 5.305E3 \n")
fprintf(file51sim,"rc2   3 12 5.305E3 \n")
fprintf(file51sim,"re1  13 10 1.836E3 \n")
fprintf(file51sim,"re2  14 10 1.836E3 \n")
fprintf(file51sim,"ree  10 99 13.19E6 \n")
fprintf(file51sim,"ro1   8  5 50 \n")
fprintf(file51sim,"ro2   7 99 100 \n")
fprintf(file51sim,"rp    3  4 18.16E3 \n")
fprintf(file51sim,"vb    9  0 dc 0 \n")
fprintf(file51sim,"vc    3 53 dc 1 \n")
fprintf(file51sim,"ve   54  4 dc 1 \n")
fprintf(file51sim,"vlim  7  8 dc 0 \n")
fprintf(file51sim,"vlp  91  0 dc 40 \n")
fprintf(file51sim,"vln   0 92 dc 40 \n")
fprintf(file51sim,".model dx D(Is=800.0E-18 Rs=1) \n")
fprintf(file51sim,".model qx NPN(Is=800.0E-18 Bf=93.75) \n")
fprintf(file51sim,".ends \n \n")
fprintf(file51sim,".options savecurrents \n \n")
fprintf(file51sim,"Vcc vcc 0 10.0 \n")
fprintf(file51sim,"Vee vee 0 -10.0 \n")
fprintf(file51sim,"Vin vin 0 0 ac 1.0 sin(0 10m 1k) \n")
fprintf(file51sim,"X1 in_p inv_in vcc vee out uA741 \n")
fprintf(file51sim,"C1 vin in_p %e \n", C1)
fprintf(file51sim,"R1 in_p 0 %e \n", R1)
fprintf(file51sim,"R3 inv_in out %e \n", R3)
fprintf(file51sim,"R4 inv_in 0 %e \n", R4)
fprintf(file51sim,"R2 out vo %e \n", R2)
fprintf(file51sim,"C2 vo 0 %e \n \n", C2)
fprintf(file51sim,".op \n")
fprintf(file51sim,".end \n \n")
fprintf(file51sim,".control \n \n")
fprintf(file51sim,"*makes plots in color \n")
fprintf(file51sim,"set hcopypscolor=0 \n")
fprintf(file51sim,"set color0=white \n")
fprintf(file51sim,"set color1=black \n")
fprintf(file51sim,"set color2=red \n")
fprintf(file51sim,"set color3=rgb:0/9/9 \n")
fprintf(file51sim,"set color4=violet \n")
fprintf(file51sim,"set color5=rgb:3/8/0 \n")
fprintf(file51sim,"set color6=rgb:4/0/0 \n \n")
fprintf(file51sim,"ac dec 10 10 100MEG \n \n");
fprintf(file51sim,"hardcopy vo1f.ps vdb(vo) \n");
fprintf(file51sim,"echo vo1f_FIG \n \n")
fprintf(file51sim,"hardcopy vo2f.ps vp(vo)*180/pi \n")
fprintf(file51sim,"echo vo2f_FIG \n \n")
fprintf(file51sim,"let Av_db = vdb(vo)-vdb(vin) \n")
fprintf(file51sim,"meas ac GainDB MAX Av_db \n \n")
fprintf(file51sim,"let Av_m = vm(vo)/vm(vin) \n")
fprintf(file51sim,"meas ac Gain MAX Av_m \n \n")
fprintf(file51sim,"let Gain3 = GainDB-3 \n \n")
fprintf(file51sim,"meas ac lowf WHEN Av_db=Gain3 \n")
fprintf(file51sim,"meas ac highf WHEN Av_db=Gain3 CROSS=LAST \n \n")
fprintf(file51sim,"let cenf = sqrt(lowf*highf) \n \n")
fprintf(file51sim,"echo %s \n", '"simulation_TAB"')
fprintf(file51sim,"echo %s \n", '"Gain = $&GainDB dB"')
fprintf(file51sim,"echo %s \n", '"Low Frequency = $&lowf Hz"')
fprintf(file51sim,"echo %s \n", '"High Frequency = $&highf Hz"')
fprintf(file51sim,"echo %s \n", '"Central Frequency = $&cenf Hz"')
fprintf(file51sim,"echo %s \n \n", '"simulation_END"')
fprintf(file51sim,"let Zin = v(vin)[20]/vin#branch[20]/(-1) \n")
fprintf(file51sim,"let Zin_r = Re(Zin) \n")
fprintf(file51sim,"let Zin_i = Im(Zin) \n")
fprintf(file51sim,"let Zin_a = abs(Zin) \n \n")
fprintf(file51sim,"echo %s \n", '"Zin_TAB"')
fprintf(file51sim,"echo %s \n", '"Zin = $&Zin_r + $&Zin_i j Ohm"')
fprintf(file51sim,"echo %s \n", '"Zin (abs) = $&Zin_a Ohm"')
fprintf(file51sim,"echo %s \n \n", '"Zin_END"')
fprintf(file51sim,"let cost = 136.66 \n")
fprintf(file51sim,"let dev_gain = abs(GainDB - 40) \n")
fprintf(file51sim,"let dev_freq = abs(cenf - 1k) \n \n")
fprintf(file51sim,"let merit = 1/(cost*(dev_gain + dev_freq +1e-6)) \n \n")
fprintf(file51sim,"echo %s \n", '"merit_TAB"')
fprintf(file51sim,"echo %s \n", '"Cost = $&cost MU"')
fprintf(file51sim,"echo %s \n", '"Gain deviation = $&dev_gain dB"')
fprintf(file51sim,"echo %s \n", '"Central frequency deviation = $&dev_freq Hz"')
fprintf(file51sim,"echo %s \n", '"Merit = $&merit"')
fprintf(file51sim,"echo %s \n \n", '"merit_END"')
fprintf(file51sim,"quit \n")
fprintf(file51sim,".endc");
fclose (file51sim);

file52sim = fopen ("t52.cir", "w");
fprintf(file52sim,"Ngspice Sim5 \n")
fprintf(file52sim,"*----------------------------------------------------------------------------- \n \n")
fprintf(file52sim,"*To use a subcircuit, the name must begin with 'X'.  For example: \n")
fprintf(file52sim,"* X1 1 2 3 4 5 uA741 \n \n")
fprintf(file52sim,"* connections:   non-inverting input \n")
fprintf(file52sim,"*                |  inverting input \n")
fprintf(file52sim,"*                |  |  positive power supply \n")
fprintf(file52sim,"*                |  |  |  negative power supply \n")
fprintf(file52sim,"*                |  |  |  |  output \n")
fprintf(file52sim,"*                |  |  |  |  | \n")
fprintf(file52sim,".subckt uA741    1  2  3  4  5 \n \n")
fprintf(file52sim,"c1   11 12 8.661E-12 \n")
fprintf(file52sim,"c2    6  7 30.00E-12 \n")
fprintf(file52sim,"dc    5 53 dx \n")
fprintf(file52sim,"de   54  5 dx \n")
fprintf(file52sim,"dlp  90 91 dx \n")
fprintf(file52sim,"dln  92 90 dx \n")
fprintf(file52sim,"dp    4  3 dx \n")
fprintf(file52sim,"egnd 99  0 poly(2) (3,0) (4,0) 0 .5 .5 \n")
fprintf(file52sim,"fb    7 99 poly(5) vb vc ve vlp vln 0 10.61E6 -10E6 10E6 10E6 -10E6 \n")
fprintf(file52sim,"ga    6  0 11 12 188.5E-6 \n")
fprintf(file52sim,"gcm   0  6 10 99 5.961E-9 \n")
fprintf(file52sim,"iee  10  4 dc 15.16E-6 \n")
fprintf(file52sim,"hlim 90  0 vlim 1K \n")
fprintf(file52sim,"q1   11  2 13 qx \n")
fprintf(file52sim,"q2   12  1 14 qx \n")
fprintf(file52sim,"r2    6  9 100.0E3 \n")
fprintf(file52sim,"rc1   3 11 5.305E3 \n")
fprintf(file52sim,"rc2   3 12 5.305E3 \n")
fprintf(file52sim,"re1  13 10 1.836E3 \n")
fprintf(file52sim,"re2  14 10 1.836E3 \n")
fprintf(file52sim,"ree  10 99 13.19E6 \n")
fprintf(file52sim,"ro1   8  5 50 \n")
fprintf(file52sim,"ro2   7 99 100 \n")
fprintf(file52sim,"rp    3  4 18.16E3 \n")
fprintf(file52sim,"vb    9  0 dc 0 \n")
fprintf(file52sim,"vc    3 53 dc 1 \n")
fprintf(file52sim,"ve   54  4 dc 1 \n")
fprintf(file52sim,"vlim  7  8 dc 0 \n")
fprintf(file52sim,"vlp  91  0 dc 40 \n")
fprintf(file52sim,"vln   0 92 dc 40 \n")
fprintf(file52sim,".model dx D(Is=800.0E-18 Rs=1) \n")
fprintf(file52sim,".model qx NPN(Is=800.0E-18 Bf=93.75) \n")
fprintf(file52sim,".ends \n \n")
fprintf(file52sim,".options savecurrents \n \n")
fprintf(file52sim,"Vcc vcc 0 10.0 \n")
fprintf(file52sim,"Vee vee 0 -10.0 \n")
fprintf(file52sim,"Vin vin 0 0  \n")
fprintf(file52sim,"X1 in_p inv_in vcc vee out uA741 \n")
fprintf(file51sim,"C1 vin in_p %e \n", C1)
fprintf(file51sim,"R1 in_p 0 %e \n", R1)
fprintf(file51sim,"R3 inv_in out %e \n", R3)
fprintf(file51sim,"R4 inv_in 0 %e \n", R4)
fprintf(file51sim,"R2 out vo %e \n", R2)
fprintf(file51sim,"C2 vo 0 %e \n \n", C2)
fprintf(file52sim,"Vout vo 0 0 ac 1.0 sin(0 10m 1k)\n \n")
fprintf(file52sim,".op \n")
fprintf(file52sim,".end \n \n")
fprintf(file52sim,".control \n \n")
fprintf(file52sim,"ac dec 10 10 100MEG \n \n")
fprintf(file52sim,"let Zo=v(vo)[20]/vout#branch[20]/(-1) \n")
fprintf(file52sim,"let Zo_r = Re(Zo) \n")
fprintf(file52sim,"let Zo_i = Im(Zo) \n")
fprintf(file52sim,"let Zo_a = abs(Zo) \n \n")
fprintf(file52sim,"echo %s \n", '"Zo_TAB"')
fprintf(file52sim,"echo %s \n", '"Zo = $&Zo_r + $&Zo_i j Ohm"')
fprintf(file52sim,"echo %s \n", '"Zo (abs) = $&Zo_a Ohm"')
fprintf(file52sim,"echo %s \n \n", '"Zo_END"')
fprintf(file52sim,"quit \n")
fprintf(file52sim,".endc")
fclose (file52sim)

%data table
datatab = fopen ("datatab.tex", "w");
fprintf(datatab, "$C_{1}$ & %e $\\mu$ F \\\\ \\hline \n \n", C1);
fprintf(datatab, "$C_{2}$ & %e $\\mu$ F \\\\ \\hline \n \n", C2);
fprintf(datatab, "$R_{1}$ & %e Ohm \\\\ \\hline \n \n", R1);
fprintf(datatab, "$R_{2}$ & %e Ohm \\\\ \\hline \n \n", R2);
fprintf(datatab, "$R_{3}$ & %e Ohm \\\\ \\hline \n \n", R3);
fprintf(datatab, "$R_{4}$ & %e Ohm \\\\ \\hline \n \n", R4);
fclose (datatab);

% f=1000 Hz
f = 1000;
w = 2*pi*f;
Zc1 = -j*1/(w*C1);
Zc2 = -j*1/(w*C2);
Zin = Zc1+R1;
Zin_abs = abs(Zin);
Zout = 1/(1/R2+1/Zc2);
Zout_abs = abs(Zout);
Va = (1+R3/R4)*R1/(R1+Zc1);
Gain = abs(Zc2/(Zc2+R2)*Va);
Gain_db = 20*log10(Gain);

% f=1000 Hz table
analysistab = fopen ("analysistab.tex", "w");
fprintf(analysistab, "$Z_{in}$  & %d+i%d  Ohm\\\\ \\hline \n \n", real(Zin), imag(Zin));
fprintf(analysistab, "$|Z_{in}|$ & %f Ohm \\\\ \\hline \n \n", Zin_abs);
fprintf(analysistab, "$Z_{out}$ & %d+i%d Ohm \\\\ \\hline \n \n", real(Zout), imag(Zout));
fprintf(analysistab, "$|Z_{out}|$ & %f Ohm \\\\ \\hline \n \n", Zout_abs);
fprintf(analysistab, "Gain & %f dB \\\\ \\hline \n \n", Gain_db);
fclose (analysistab);

% f logspace
f = logspace(1, 8, 1000);
w = 2*pi*f; 
Zc1 = -j*1./(w*C1);
Zc2 = -j*1./(w*C2);
Zi = abs(Zc1+R1);
Zo = abs(1./(1/R2+1./Zc2));
Va = (1+R3/R4).*R1./(R1+Zc1);
Gain = Zc2./(Zc2+R2).*Va;
Gain_abs = abs(Gain);
Gain_db = 20*log10(Gain_abs);
Gain_max = max(Gain_db);
phase = angle(Gain)*180/pi;

for i=1:length(Gain_db)-1
	if (Gain_db(i) < Gain_max-3 && Gain_db(i+1)>Gain_db(i))
	  lcf = f(i);
	endif
	if (Gain_db(i) > Gain_max-3 && Gain_db(i+1)<Gain_db(i))
	  hcf = f(i+1);
	endif
endfor

centerf = sqrt(lcf*hcf);
% frequency table
frequencytab = fopen ("frequencytab.tex", "w");
fprintf(frequencytab, "Low Frequency & %f Hz \\\\ \\hline \n \n", lcf);
fprintf(frequencytab, "High Frequency & %f Hz \\\\ \\hline \n \n", hcf);
fprintf(frequencytab, "Central Frequency & %f Hz \\\\ \\hline \n \n", centerf);
fclose (frequencytab);

% gain graph
gaingraph = figure ();
plot(log10(f),Gain_db,"b");
title("Gain Frequency Response");
xlabel ("Frequency [Hz]");
ylabel ("Gain [dB]");
print (gaingraph, "gain.eps", "-depsc");

% phase graph
phasegraph = figure();
plot(log10(f),phase,"r");
title("Phase Frequency Response");
xlabel("Frequency [Hz]");
ylabel("Phase [Deg]");
print(phasegraph, "phase.eps", "-depsc");
