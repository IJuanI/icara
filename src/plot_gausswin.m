[x, fm] = audioread(['../resources/' nombre_archivo '.wav']);

step = .001;
step_factor = 0.0025;
% Los streams suelen ir a 24fps
% por lo que con 8fps se debería ver bien.
fps = 8;
g_stepT = 1/fps;

g_tf = icara_data.atime.bw*4;
x = x(1:g_tf*fm);

N = g_tf*fm;
Nbase = Nwin = floor(icara_data.atime.bw*fm);
Nstep = floor(step * fm);
Nti = 0;

figure;
hold on;
plot((1:N)/fm, x, 'color', [.92 .25 .20]);
Xwin = x(1:Nbase) .* icara_data.atime.gauss_win;
Fwin = (1:Nbase)/fm;
plot(Fwin, Xwin, 'xdatasource', 'Fwin', 'ydatasource', 'Xwin', 'color', [.30 .24 .8]);

delta = 0;
count = 0;
g_mode = true;
Ndelta = floor(Nbase / 12);
while (1)
  delta -= time();
  Nti += floor(step*(Nwin*step_factor)*fm);

  if g_mode
    if ++count > 6
      g_mode = !g_mode;
    endif
  else
    if --count < -6
      g_mode = !g_mode;
    endif
  endif
  
  Nwin = Nbase + Ndelta * count;
  if Nti > N - Nwin
    Nti -= N-Nwin;
  endif
  
  Xwin = x(Nti+(1:Nwin)) .* gausswin(Nwin, icara_data.deltaF);
  Fwin = (Nti+(1:Nwin))/fm;
  refreshdata();
  delta += time();
  
  
  if delta < g_stepT
    pause(g_stepT - delta);
    delta = 0;
  else
    delta -= g_stepT;
    while delta > g_stepT
      delta -= g_stepT;
      Nti += floor(step*(Nwin*step_factor)*fm);
      if g_mode
        if ++count > 6
          g_mode = !g_mode;
        endif
      else
        if --count < -6
          g_mode = !g_mode;
        endif
      endif
  
    Nwin = Nbase + Ndelta * count;
      if Nti > N - Nwin
        Nti -= N-Nwin;
      endif
    endwhile
    
    pause(.005);
    delta += .005;
  endif
endwhile

clear delta;