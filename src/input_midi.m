pkg load audio;

if !exist("nombre_archivo")
  nombre_archivo = 'muestras/rec0_7';
endif

data = midifileread(['../resources/', nombre_archivo, '.mid']);
midi_notes = [];
midi_open_notes = [];
for data_idx = 1:length(data)
  if strcmp(data(data_idx).Type, 'NoteOn')
    open_note.ti = data(data_idx).Timestamp;
    open_note.n = data(data_idx).Note;
    open_note.power = data(data_idx).Velocity / 127;
    midi_open_notes = [midi_open_notes, open_note];
  elseif strcmp(data(data_idx).Type, 'NoteOff')
    for open_note_idx = 1:length(midi_open_notes)
      if midi_open_notes(open_note_idx).n == data(data_idx).Note
        note = midi_open_notes(open_note_idx);
        midi_open_notes(open_note_idx) = [];
        note.n = note.n - 36;
        note.tf = data(data_idx).Timestamp;
        midi_notes = [midi_notes, note];
        break;
      endif
    endfor
  endif
endfor

clear data;
clear midi_open_notes;