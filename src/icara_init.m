if !exist('icara_data') || !isfield(icara_data, 'fm')
  icara_data.fm = 44100;
endif

if !isfield(icara_data, 'freq_min')
  icara_data.freq_min = 65.4;
endif

if !isfield(icara_data, 'redundancy')
  icara_data.redundancy = 6;
endif

if !isfield(icara_data, 'hps') || !isfield(icara_data.hps, 'harmonics')
  icara_data.hps.harmonics = 4;
endif

if !isfield(icara_data.hps, 'tolX')
  icara_data.hps.tolX = 1e-5^icara_data.hps.harmonics;
endif

if !isfield(icara_data.hps, 'tolY')
  icara_data.hps.tolY = 5e-5;
endif

if !isfield(icara_data.hps, 'threshold')
  icara_data.hps.threshold = 0.3;
endif

if !isfield(icara_data, 'eps')
  icara_data.eps = 1e-12;
endif

if !isfield(icara_data, 'mixer') || !isfield(icara_data.mixer, 'tolFreq')
  icara_data.mixer.tolFreq = 1;
endif

if !isfield(icara_data.mixer, 'tolTime')
  icara_data.mixer.tolTime = 4;
endif

if !isfield(icara_data.mixer, 'minLength')
  icara_data.mixer.minLength = .05;
endif

if exist('icara_profiling')
  icara_data.profiling = icara_profiling;
else
  icara_data.profiling = 0;
endif

if exist('icara_debug')
  icara_data.debug = icara_debug;
else
  icara_data.debug = false;
endif;

if !isfield(icara_data, 'calc_mhps')
  icara_data.calc_mhps = false;
endif

if icara_data.calc_mhps
  if !isfield(icara_data, 'mhps') || !isfield(icara_data.mhps, 'Npeaks')
    icara_data.mhps.Npeaks = 9;
  endif
  
  if !isfield(icara_data.mhps, 'b1')
    icara_data.mhps.b1 = 0.5;
  endif
  
  if !isfield(icara_data.mhps, 'b2')
    icara_data.mhps.b2 = 0.6;
  endif
endif

if isfield(icara_data, 'hash')
  icara_data.needs_update = !strcmp(icara_data.hash, icara_hash(icara_data));
else
  icara_data.needs_update = true;
endif

icara_reset;
