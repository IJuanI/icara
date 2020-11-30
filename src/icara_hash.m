% Genera un hash con los cambios importantes.
% Estos cambios implicaran recalcular el icara_data
function hashed = icara_hash(icara_data)

  values = [ num2str(icara_data.fm), ',', num2str(icara_data.freq_min), ',', num2str(icara_data.redundancy), ',', num2str(icara_data.hps.harmonics), ',', num2str(icara_data.calc_mhps)];

  if icara_data.calc_mhps
    values = [values, ',', num2str(icara_data.mhps.Npeaks)];
  endif
  
  hashed = hash('md5', values);
endfunction
