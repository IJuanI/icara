%% Este archivo esta repleto de trucos
%% para permitir vectorizar la mayor parte del algoritmo.

%% Recomiendo leer primero la inicializacion de v3
function [icara_data] = icara_setup(icara_data)
  
  if icara_data.needs_update
    %% Necesito este paquete
    pkg load signal;
    
    icara_data = data_globals(icara_data);
    icara_data = data_windowing(icara_data);
    icara_data = data_spectral_estimator(icara_data);
    icara_data = data_pitch_detector(icara_data);
    
    icara_data = data_locallity(icara_data);
    
    icara_data.hash = icara_hash(icara_data);    
    icara_data.needs_update = false;
  endif
  
endfunction

function icara_data = data_globals(icara_data)
  icara_data.dt = 1 / icara_data.fm;

  icara_data.notes.step = 2^(1/12);
  icara_data.notes.step_inv = 1 / 2^(1/12);
  icara_data.notes.step_log = log(icara_data.notes.step);
  icara_data.notes.step_base = icara_data.notes.step^(33)/440;
  
  icara_data.notes.calc_n = @(f) log(f .* icara_data.notes.step_base)./icara_data.notes.step_log;
endfunction

function icara_data = data_windowing(icara_data)
  note_min = icara_tuner(icara_data.freq_min, icara_data); % nota minima
  note_next = note_min * icara_data.notes.step;
  icara_data.deltaF = note_next - note_min;

  icara_data.atime.N = floor(icara_data.fm / icara_data.deltaF);
  icara_data.atime.vN = 1:icara_data.atime.N;
  icara_data.atime.bw = icara_data.atime.N / icara_data.fm;
  icara_data.atime.gauss_win = gausswin(icara_data.atime.N, icara_data.deltaF);
  
  icara_data.offset.N = ceil(icara_data.atime.bw * icara_data.fm / icara_data.redundancy);
  icara_data.offset.bw = icara_data.offset.N / icara_data.fm;
endfunction

function icara_data =  data_spectral_estimator(icara_data)
  icara_data.psd.inv_time_factor = icara_data.dt / icara_data.atime.N;
  icara_data.psd.a_weighting = @(x) ((12194^2 .* x.^4) ./ ( (x.^2+20.6^2) .* power((x.^2+107.7^2).*(x.^2+737.9^2), 1/2) .*(x.^2+12194^2)));
  % Optimizacion en el rendimiento del fft
  icara_data.psd.N = 2^nextpow2(ceil(icara_data.fm * icara_data.atime.bw));
  icara_data.psd.F = linspace(-icara_data.fm / 2 , icara_data.fm / 2, icara_data.psd.N);
  icara_data.df = icara_data.fm / icara_data.psd.N;
endfunction

function icara_data = data_pitch_detector(icara_data)
  icara_data.hps.N = floor(icara_data.psd.N / 2);
  icara_data.hps.vN = 1:icara_data.hps.N;
  icara_data.hps.vHarmonics = 1:icara_data.hps.harmonics;
  icara_data.hps.Nr = floor(icara_data.hps.N / icara_data.hps.harmonics);
  icara_data.hps.vNr = 1:icara_data.hps.Nr;
  icara_data.hps.F = icara_data.psd.F((icara_data.hps.N+1):icara_data.psd.N);
  
  if icara_data.calc_mhps
    icara_data.mhps.minN = floor(icara_data.hps.N / icara_data.mhps.Npeaks);
  endif
  
endfunction

function icara_data = data_locallity(icara_data)
  icara_data.notes.local_left = @(x) x .* (1 - icara_data.notes.step_inv) ./ 2;
  icara_data.notes.local_right = @(x) x .* (icara_data.notes.step - 1) ./ 2;

  locallity_left = icara_data.hps.vN - floor(icara_data.notes.local_left(icara_data.hps.F(icara_data.hps.vN)) / icara_data.df);
  locallity_right = icara_data.hps.vN + floor(icara_data.notes.local_right(icara_data.hps.F(icara_data.hps.vN)) / icara_data.df);
  icara_data.notes.locallity_left = locallity_left;
  icara_data.notes.locallity_right = locallity_right;

  % Lo de abajo es simplemente una optimizacion
  vertical_length = max(locallity_right - locallity_left)+1;

  locallity_matrix(1:vertical_length, icara_data.hps.vN) = icara_data.hps.N+1;
  for n = icara_data.hps.vN
    icara_data.note(n).locallity = max(min(locallity_left(n):locallity_right(n), icara_data.hps.N), 0);
    locallity_matrix(1:length(icara_data.note(n).locallity), n) = icara_data.note(n).locallity;
  endfor
  
  icara_data.notes.sub(1).locallity_matrix = locallity_matrix;
  if icara_data.calc_mhps
    harmonics = icara_data.mhps.Npeaks;
  else
    harmonics = icara_data.hps.harmonics;
  endif

  lSize = size(locallity_matrix);
  for harmonic = 2:harmonics
    irow = ((1:ceil(lSize(1)./harmonic)) - 1).*harmonic + 1;
    icol = ((1:ceil(lSize(2)./harmonic)) - 1).*harmonic + 1;
    icara_data.notes.sub(harmonic).locallity_matrix = ceil(locallity_matrix(irow, icol) ./ harmonic);
  endfor
endfunction
