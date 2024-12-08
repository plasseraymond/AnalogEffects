% sallenKeyLPF.m
% Raymond Plasse
% AET-5895
% 10/30/2024

clear; clc; close all;

Fs = 48000;
Ts = 1/Fs;

% Component values
C1 = .1e-6;
R1 = Ts/(2*C1); % substitution for DK method
C2 = .1e-6;
R2 = Ts/(2*C2); % substitution for DK method
R3 = 10e3;
R4 = 10e3; % could make this a potentiometer but not entirely decoupled from R3
RA = 10e3;
RB = 5.5e3;

% Define coefficients
Gy = (1/R2) + (1/R3) + (1/R4);
a0 = Gy * (RB/(RA+RB)) * (R4/R1 + 1) - 1/R2 - RB/(R4*(RA+RB));
b0 = 1/(R3*a0);
b1 = (R4/a0)*Gy;
b2 = 1/a0;

% Initialize states
x1 = 0;
x2 = 0;

u = [1 ; zeros(2047,1)]; % impulse signal
N = length(u);
y = zeros(N,1);

for n = 1:N

    Vin = u(n,1);
    
    Vout = b0 * Vin + b1 * x1 + b2 * x2;

    % update states
    Vx = Vout * (RB/(RA+RB));
    Vy = Vout * (RB/(RA+RB)) * (R4/R1 + 1) - (R4*x1);

    x1 = 2/R1 * Vx - x1;
    x2 = 2/R2 * (Vy - Vout) - x2;

    y(n,1) = Vout;

end

[H,W] = freqz(y,1,N,Fs);
semilogx(W,20*log10(abs(H)));
axis([20 20000 -20 30]);
