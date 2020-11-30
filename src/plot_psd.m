if !exist('play_audio')
  play_audio = false;
endif

if !exist('play_speed')
  play_speed = 1;
endif

if !exist('lock_scale')
  lock_scale = true;
endif

Xplot = icara_data.storage.St(:, 1);
i = 1;

plot(icara_data.psd.F, Xplot, "ydatasource", "Xplot");
xlim([-440*6, 440*6]);

audio_duration = length(x) / fm / play_speed;
graph_step = icara_data.offset.bw / play_speed;
window_count = size(icara_data.storage.St)(2);
half_bw = icara_data.offset.bw / 2;

if play_audio
  player = audioplayer(x, fm * play_speed);
  play(player);
  time_init = time();
  pause(half_bw);
endif

delta = 0;

while (1)
  delta -= time();
  
  Xplot = icara_data.storage.St(:, i);
  if lock_scale
    ylim([0, 1e-14]);
  endif
  refreshdata(gcf, "caller");
  delta += time();
  
  if delta < graph_step
    pause(graph_step - delta);
    delta = 0;
  else
    delta -= graph_step;
    while delta > graph_step && i < window_count
      delta -= graph_step;
      ++i;
    endwhile
    
    pause(.005);
    delta += .005;
  endif
  
  ++i;
  
  if i > window_count
    i -= window_count;

    if play_audio
      pause(half_bw);
      stop(player);
      time_end = time();
      graph_elapsed = time_end - time_init;
      printf('Grafico: %d\n', graph_elapsed);
      printf('Audio: %d\n', audio_duration);
      printf('Coeficiende de desfase: %d\n', graph_elapsed / audio_duration);
    endif

    pause(.5);
    delta = 0;

    if play_audio
      play(player);
      time_init = time();
      pause(half_bw);
    endif
  endif
  
endwhile