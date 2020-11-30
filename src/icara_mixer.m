function [detected, icara_data] = icara_mixer(notes_info, icara_data)

  if !isfield(icara_data.storage,'mix_notes')
    icara_data.storage.mix_notes = [];
  endif

  tm = icara_data.ti + icara_data.atime.bw / 2;
  N = length(icara_data.storage.mix_notes);

  % #####################
  % #  Almacenar Notas  #
  % #####################
  for note = notes_info
    note_exists = false;

    for i = 1:N
      stored_note = icara_data.storage.mix_notes(i);

      last_freq = stored_note.last_freq;
      lower_bound = last_freq - icara_data.notes.local_left(last_freq) ./ icara_data.mixer.tolFreq;  % cota inferior
      upper_bound = last_freq + icara_data.notes.local_right(last_freq) ./ icara_data.mixer.tolFreq;  % cota superior

      if lower_bound < note.freq && note.freq < upper_bound
        % La nota ya existe
        stored_note.tf = tm;
        stored_note.last_freq = note.freq;
        stored_note.timestamp = icara_data.tick;
        stored_note.freq = [ stored_note.freq; note.freq ];
        % stored_note.power = [ stored_note.power, note.power ];
        icara_data.storage.mix_notes(i) = stored_note;
        note_exists = true;
        break;
      endif
      
    endfor

    if !note_exists
      % Nota Nueva
      new_note.ti = tm;
      new_note.tf = tm;
      new_note.timestamp = icara_data.tick;
      new_note.last_freq = note.freq;
      new_note.freq = note.freq;
      % new_note.power = note.power;

      icara_data.storage.mix_notes(++N) = new_note;
    endif
  endfor


  % ########################
  % #  Buscar Finalizadas  #
  % ########################
  detected = [];

  i = 1;
  while i <= N
    stored_note = icara_data.storage.mix_notes(i);

    if icara_data.tick - stored_note.timestamp > icara_data.mixer.tolTime
      icara_data.storage.mix_notes(i) = [];
      --N;

      if 1 - (stored_note.tf - stored_note.ti) / icara_data.mixer.minLength < icara_data.eps
        stored_note = rmfield(stored_note, 'timestamp');
        stored_note = rmfield(stored_note, 'last_freq');
        stored_note.freq = median(stored_note.freq);

        detected = [detected, stored_note];
      endif
    else
      ++i;
    endif
  endwhile
endfunction