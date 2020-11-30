function [windows, icara_data] = icara_window(x, icara_data)
  buffer = [icara_data.storage.win_buffer, x];
  
  windows = [];
  t = length(buffer) / icara_data.fm;
  while t >= icara_data.atime.bw
    windows = [windows, buffer(icara_data.atime.vN)'];
    buffer = buffer(icara_data.offset.N+1:end);
    t -= icara_data.offset.bw;
  endwhile
    
  if length(windows) > 0
    windows = windows .* icara_data.atime.gauss_win;
  endif

  icara_data.storage.win_buffer = buffer;
endfunction