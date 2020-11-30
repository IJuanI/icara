function tuned_freq = icara_tuner(freq, icara_data)
  tuned_freq = 440 * icara_data.notes.step^round(log(freq/440)/icara_data.notes.step_log);
endfunction