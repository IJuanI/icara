if !isfield(icara_data, 'note_bank')
  icara_data = icara_init_synth(icara_data);
endif

has_offset = exist('offset');
if !has_offset
  offset = 0;
endif

has_notes = exist('notes');
if !has_notes
  notes = icara_data.storage.notes;
endif

if !exist('instrument')
  instrument = 'piano';
endif

if !isfield(notes, 'n') && isfield(notes, 'freq')
  for i = 1:length(notes)
    notes(i).n = round(icara_data.notes.calc_n(notes(i).freq));
  endfor
endif

sintesis = [];
sample_offset = ceil(.1*icara_data.fm);

bounds = icara_data.note_bank.(instrument).bounds;
for note = notes
  if note.n + offset < bounds(1) || note.n + offset > bounds(2)
    continue;
  endif
  
  sample = icara_data.note_bank.(instrument).samples(note.n+1+offset, :);
  lSample = length(sample) - sample_offset;
  target_size = (note.tf - note.ti) * icara_data.fm;
  sample = sample(1:min(lSample,target_size));
  
  sample_init = round(note.ti * icara_data.fm) + 1;
  sample_end = sample_init + length(sample) - 1;
  
  sintesis(length(sintesis)+1:sample_end) = 0;
  sintesis(sample_init:sample_end) += sample;
endfor

clear bounds;

if !has_notes
  clear notes;
endif

if !has_offset
  clear offset;
endif

player = audioplayer(sintesis, fm);

if !exist('play_audio') || play_audio
  play(player);
endif