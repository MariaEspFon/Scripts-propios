function ventanas = enventanar(s_completa,fs,segs)
    % sample size of signal fragments
    n = fs*segs;
    % fragments of the same signal will be stored by colums in the
    % following array
    ventanas = zeros(n, ceil(length(s_completa)/n));
    % i is a moving index refering to each column of the array 
    i = 1;    
    % t is a moving index through the samples from the original signal
    t = 1;
    
    while t < (length(s_completa)-n)
      ventanas(:,i) = s_completa(t:t+n-1);
      t = t+n;
      i = 1+i;
    end
    % adding the last remaining samples of the original signal to a last
    % window of fewer samples
    resto = s_completa(t:end);
    ventanas(1:length(resto),end) = resto;
end