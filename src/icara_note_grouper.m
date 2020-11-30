function clean_notes = icara_note_grouper(notes, St, icara_data)

  note_freq = icara_tuner(notes(1), icara_data) * (2^(-13/12) + .5);
  clean_notes = [];
  note_group = [];

  for n = notes
    if n > note_freq
      if length(note_group) > 0
        clean_notes = [clean_notes, flush_group(note_group, St, icara_data)];
        note_group = [];
      endif

      % Podria eliminar este loop con un par de logaritmos,
      % pero el coste de computar los logaritmos haria
      % mas lento al algoritmo. Por lo que no vale la pena
      while n > note_freq
        note_freq *= icara_data.notes.step;
      endwhile
    endif
    note_group = [note_group, n];
  endfor
  
  if length(note_group) > 0
    clean_notes = [clean_notes, flush_group(note_group, St, icara_data)];
  endif

endfunction

function notes = flush_group(note_group, St, icara_data)
  notes_idx = floor(note_group / icara_data.df);
  [~, i] = max(sum(St(icara_data.notes.sub(1).locallity_matrix(:, notes_idx))));
  notes = note_group(i);
end
