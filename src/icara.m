function icara_data = icara(x, icara_data)

  icara_data = icara_setup(icara_data);
    
  [windows, icara_data] = icara_window(x, icara_data);
  
  notes_detected = [];
  for i = 1:size(windows)(2)

    St = icara_spectral_estimator(windows(:, i), icara_data);
    if icara_data.debug
      icara_data.storage.St = [icara_data.storage.St, St];
    endif
    
    max_St = max(St);
    if max_St == 0
      continue;
    endif
    Stn = St ./ max_St;
    
    St_positive = St(icara_data.hps.N+1:end);
    St_positive(icara_data.hps.N+1) = 0;
    Stn_positive = Stn(icara_data.hps.N+1:end);
    Stn_positive(icara_data.hps.N+1) = 0;
  
    [notes, icara_data] = icara_pitch_detector(Stn_positive, icara_data);
    if icara_data.debug
      m = notes;
      m(20) = 0;
      m(21:end) = [];
      icara_data.storage.raw_notes = [icara_data.storage.raw_notes, m'];
    endif
    
    notes_info = [];
    if length(notes) > 0
      notes = icara_note_grouper(notes, Stn_positive, icara_data);
      
      if icara_data.debug
        m = notes;
        m(20) = 0;
        m(21:end) = [];
        icara_data.storage.group_notes = [icara_data.storage.group_notes, m'];
      endif

      for j = 1:length(notes)
        notes_info(j).freq = notes(j);
        % @TODO buscar potencia
      endfor
    endif

    [detected, icara_data] = icara_mixer(notes_info, icara_data);
    
    icara_data.storage.notes = [icara_data.storage.notes, detected];

    icara_data.ti += icara_data.offset.bw;
    ++icara_data.tick;
  endfor
endfunction