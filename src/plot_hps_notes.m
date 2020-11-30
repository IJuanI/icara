if !exist('g_combine')
  g_combine = false;
endif

gr_color = [.45 .20 .76];

g_N = size(icara_data.storage.hps_notes)(1);

g_T = [];
g_P = [];
g_base = icara_data.atime.bw / 2;
for i = 1:g_N;
  g_p = find(icara_data.storage.hps_notes(i,:) != 0);
  
  g_n = length(g_p);
  g_T = [g_T, g_base + ones(1,g_n) * i * icara_data.offset.bw];
  g_P = [g_P, icara_data.storage.hps_notes(i, g_p)];
endfor

g_max_freq = max(max(g_P));

if !g_combine
  figure;
else
  hold on;
endif
scatter(g_T, g_P, [], gr_color);
ylim([0, g_max_freq * 1.1]);