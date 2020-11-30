function [notes, icara_data] = icara_pitch_detector(St, icara_data)
  St(find(St < icara_data.hps.tolX)) = 0;
  y = ones(1, icara_data.hps.Nr);
  
  if icara_data.calc_mhps
    % El mhps entero es costoso para una ejecucion normal
    % pero se puede habilitar si se lo quiere probar

    % Parametros del MHPS
    Npeaks = 9;
    b1 = 0.5;
    b2 = 0.6;

    V = zeros(1, icara_data.hps.Nr);
    for harmonic = icara_data.hps.vHarmonics
      
      v = sum(St(icara_data.notes.sub(harmonic).locallity_matrix(:,icara_data.hps.vNr)));
      y .*= v;
      V += v;
    endfor
  
    y_max = max(y);
    if y_max == 0
      notes = [];
      if icara_data.calc_hps
        hps_notes = [];
        hps_notes(20) = 0;
        icara_data.storage.hps_notes = [icara_data.storage.hps_notes; hps_notes'];
      endif
      return;
    endif

    y ./= y_max;
    y(find(y < icara_data.hps.tolY)) = 0;
    [p, loc] = findpeaks(y);
    [m, idx] = sort(p, 'descend');

    filtro_1 = m >= icara_data.hps.threshold;
    frp = idx(find(filtro_1));

    if icara_data.debug
      hps_notes = icara_data.hps.F(loc(idx(frp)));
      hps_notes(20) = 0;
      hps_notes(21:end) = [];
      icara_data.storage.hps_notes = [icara_data.storage.hps_notes; hps_notes];
    endif
        
    fup = idx(find(!filtro_1));
    
    mS = b1 * max(V);
    V2 = sum(St(icara_data.notes.sub(1).locallity_matrix(:, loc(idx))));
    mY = b2 * max(V2);
    
    fup = fup(find(loc(fup) <= icara_data.mhps.minN));
    filtro_2 = ones(size(fup));
    for harmonic = 2:icara_data.mhps.Npeaks
      filtro_2 &= sum(St(icara_data.notes.sub(harmonic).locallity_matrix(:, loc(fup)))) > 0;
    endfor
    frp = [frp, fup(find(filtro_2))];
    fsp = fup(find(!filtro_2));
    filtro_3 = V(loc(fsp)) > mS;
    filtro_4 = V2(fsp) > mY;

    frp = [frp, fsp(find(filtro_3 & filtro_4))];
  else
    for harmonic = icara_data.hps.vHarmonics
      y .*= sum(St(icara_data.notes.sub(harmonic).locallity_matrix(:,icara_data.hps.vNr)));
    endfor
  
    y_max = max(y);
    if y_max == 0
      notes = [];
      if icara_data.calc_hps
        hps_notes = [];
        hps_notes(20) = 0;
        icara_data.storage.hps_notes = [icara_data.storage.hps_notes; hps_notes'];
      endif
      return;
    endif

    y ./= y_max;
    y(find(y < icara_data.hps.tolY)) = 0;
    [p, loc] = findpeaks(y);
    [m, idx] = sort(p, 'descend');
    frp = idx(find(m >= icara_data.hps.threshold));
  endif

  notes = icara_data.hps.F(loc(frp));
endfunction