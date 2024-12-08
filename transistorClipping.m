% transistorClipping.m
% Raymond Plasse
% AET-5420 HW1
% 1/31/2024

% This function performs transistor-like clipping designed to emulate
% analog circuit distortion behavior given a non-zero slope linear threshold

function [out] = transistorClipping(in,thresh)

slope = 0.00009; % initialize slope variable for linear threshold (very small value)
clipValue = 0; % initialize clip line value to trace slope of linear threshold
N = length(in); % find total number of samples in input signal

for n = 1:N % loop through all the samples

    x = in(n,1); % assign current input sample to variable x

    % perform check OUTSIDE region of operation
    if (x > thresh) % if input sample is above threshold
        out(n,1) = thresh - clipValue; % assign difference of threshold & clip value to output sample
        clipValue = clipValue + slope; % increment clip value by specified slope

    elseif (x < -thresh) % if input sample is below negative threshold
        out(n,1) = -thresh + clipValue; % assign sum of negative threshold & clip value to output sample
        clipValue = clipValue + slope; % increment clip value by specified slope

    else % otherwise, perform additional check INSIDE region of operation (similar steps)
        if (x > (thresh - clipValue)) % if input sample is above clip line with current slope
            out(n,1) = thresh - clipValue; % assign clip line value to output sample (continuing the line)
            clipValue = clipValue + slope; % increment clip value by specified slope

        elseif (x < (-thresh + clipValue)) % if input sample is below negative clip line with current slope
            out(n,1) = -thresh + clipValue; % assign negative clip line value to output sample (continuing the line)
            clipValue = clipValue + slope; % increment clip value by specified slope

        else % otherwise ...
            out(n,1) = x; % assign input sample to output sample
            clipValue = 0; % reset clip line value
        
        end
    end
end
