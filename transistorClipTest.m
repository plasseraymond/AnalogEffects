% transistorClipTest.m
% Raymond Plasse
% AET-5420 HW1
% 1/31/2024

% Test script for function transistorClipping.m

clear; clc; close all;

[sig,Fs] = audioread('BassDI.wav'); % read in input signal
[LA3A,Fs] = audioread('LA3APrint.wav'); % read in comparison signal

outputTC = transistorClipping(sig,0.1); % invoke transistorClipping function on input signal passing 0.1 for threshold

% plot waveforms 
figure(1); subplot(1,2,1);
plot(outputTC); title('Transistor-clipping Test RP');
subplot(1,2,2); plot(LA3A); title('Transistor-clipping Test LA3A');

% listen and compare
sound([outputTC;LA3A],Fs);
