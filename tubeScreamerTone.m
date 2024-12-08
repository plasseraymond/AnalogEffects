% tubeScreamerTone.m
% Raymond Plasse
% AET-5895
% 11/1/2024

clear; clc; close all;

% initial values taken from electrosmash.com
Fs = 48000;
Ts = 1/Fs;

C1 = .22e-6;
R1 = Ts/(2*C1);

C2 = .22e-6;
R2 = Ts/(2*C2);

C3 = .22e-6;
R3 = Ts/(2*C3);

C4 = 1e-6;
R4 = Ts/(2*C4);

R5 = 220;
R6 = 1e3;
R7 = 1e3;
R8 = 220;
R9 = 1e3;

outPot = 0.5;
R10 = (1-outPot) * 100e3; % sometimes have to swap these
R11 = outPot * 100e3; % sometimes have to swap these

tonePot = 0.5; % can choose different values just not 0 or 1
P1 = tonePot * 20e3; 
P2 = (1-tonePot) * 20e3;

G2 = 1 + R2/P1 + R5/P1;
G3 = 1 + R3/P2 + R8/P2;
G0 = 1 + R10/R11 + R9/R11 + R4/R11;
Gx = 1 + R7/(G3*P2);
Gz = 1/R1 + 1/R6 + 1/(G2*P1);
Gr = P1/R2 + 1 + R5/R2;
Gs = 1 + P2/R3 + R8/R3;

b0 = Gx/(R6*Gz*G0);
b1 = Gx/(Gz*G0);
b2 = (R2*Gx)/(G2*Gz*G0*P1);
b3 = (-R3*R7)/(G3*G0*P2);
b4 = -R4/G0;

u = [1 ; zeros(2047,1)];

N = length(u);
y = zeros(N,1);

x1 = 0; x2 = 0; x3 = 0; x4 = 0;
for n = 1:N

    Vin = u(n,1);
    Vout = b0 * Vin + b1 * x1 + b2 * x2 + b3 * x3 + b4 * x4;

    % state updates
    Vx = Vin/(R6*Gz) + x1/Gz + (R2*x2)/(G2*Gz*P1);
    x1 = (2/R1) * Vx - x1;
    x2 = (2/R2) * (Vx/Gr + x2*((P1+R5)/Gr)) - x2;
    x3 = (2/R3) * (Vx/Gs + x3*((P2+R8)/Gs)) - x3;
    x4 = (2/R11) * Vout + x4;

    y(n,1) = Vout;

end

[H,W] = freqz(y,1,N,Fs);
semilogx(W,20*log10(abs(H)));
axis([20 20000 -50 5]);
