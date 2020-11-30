if !exist('g_combine')
  g_combine = false;
endif

has_color = exist('g_color');
if !has_color
  g_color = 1;
endif

has_notes = exist('notes');
if !has_notes
  notes = icara_data.storage.notes;
endif

g_linewidth = 3;
g_colors = [
  .26 .53 .96;
   1  .53 .96;
  .26 .53  0 ;
  .26  1  .56;
  .26  0  .96;
   1  .53  0 ;
  .26  1   0 ;
   1  .53  1 ;
  .95 .4  .3
];

if !isfield(notes, 'freq') && isfield(notes, 'n')
  for i = 1:length(notes)
    notes(i).freq = 440 * icara_data.notes.step^(notes(i).n - 33);
  endfor
endif

for i = 1:length(notes)
  notes(i).alternative = false;
endfor

g_tolX = (max([notes.tf]) - min([notes.ti])) * 1.1 / 120;

g_x = g_y = [];
g_max_freq = max([notes.freq]);

if !g_combine
  figure;
else
  hold on;
endif

ylim([0, g_max_freq * 1.1]);
s_factor = icara_data.notes.step^(33)/440;

for i = 1:length(notes)
  note = notes(i);
  
  % Reviso si tengo una nota pegada, para mostrar otro color
  n = round(log(note.freq * s_factor)/icara_data.notes.step_log);
  alternative = false;
  for other = notes
    if other.ti == note.ti && other.tf == note.tf && other.freq == note.freq
      continue;
    endif
    if (other.ti < note.tf) && (other.tf > (note.ti - g_tolX))
      n2 = round(log(other.freq * s_factor) / icara_data.notes.step_log);
      if n == n2
        if !other.alternative
          alternative = !alternative;
        endif
      endif
    endif
  endfor
 
  curr_color = g_colors(g_color, :);
  % El color alternativo es una version
  % un poco mas clara o mas oscura del original.
  if alternative
    if dot(curr_color, curr_color) > .5
      curr_color *= 1.25;
    else
      curr_color *= .75;
    endif
    notes(i).alternative = true;
  endif
  
  % Lo mantengo dentro de valores normalitos
  extra = norm (min([1 1 1], curr_color) - curr_color);
  if extra > 0
    idx = find(curr_color <= 1);
    curr_color(idx) += extra / length(idx);
  endif
  curr_color = min([1 1 1], curr_color);
  
  line([note.ti note.tf], [note.freq note.freq], 'color', curr_color, 'linewidth', g_linewidth);
endfor

if !has_notes
  clear notes;
else
  notes = rmfield(notes, 'alternative');  
endif

if !has_color
  clear g_color;
endif

clear has_notes;
