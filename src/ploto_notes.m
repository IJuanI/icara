if exist('g_combine')
  old_combine = g_combine;
endif

if !exist('midi_notes')
  input_midi;
endif

icara_synchronize;

if !exist('g_combine') || !g_combine
  figure;
endif

g_combine = true;
g_color = 2;
notes = midi_notes;
plot_notes;

clear notes;
g_color = 1;
plot_notes;

if exist('old_combine')
  g_combine = old_combine;
  clear old_combine;
else
  clear g_combine;
endif

clear g_color;
