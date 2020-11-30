if !exist('midi_notes')
  input_midi;
endif

if !isfield(icara_data.storage.notes, 'n')
  for i = 1:length(icara_data.storage.notes)
    icara_data.storage.notes(i).n = round(icara_data.notes.calc_n(icara_data.storage.notes(i).freq));
  endfor
endif

function similitude = calc_similitude(notes_a, notes_b, offset)
  offset -= min([notes_b.ti]);
  similitude = 0;
  for note_b = notes_b
    tib = note_b.ti + offset;
    tfb = note_b.tf + offset;
    for note_a = notes_a
      if note_a.n == note_b.n && tib <= note_a.tf && note_a.ti <= tfb
        similitude += min(note_a.tf, tfb) - max(note_a.ti, tib);
      endif
    endfor
  endfor
endfunction

mnotes = sort([midi_notes.ti], 'ascend');
last_similitude = 0;
for s_mnote = 1:length(mnotes)
  curr_similitude = calc_similitude(midi_notes, icara_data.storage.notes, mnotes(s_mnote));
  
  if curr_similitude < last_similitude
    break;
  endif
  last_similitude = curr_similitude;
endfor
max_similitude = sum([midi_notes.tf] - [midi_notes.ti]);
printf('Similitud: %d\n', last_similitude / max_similitude);

offset = min([icara_data.storage.notes.ti]) - mnotes(s_mnote-1);
for s_mnote = 1:length(midi_notes)
  midi_notes(s_mnote).ti += offset;
  midi_notes(s_mnote).tf += offset;
endfor

clear offset;