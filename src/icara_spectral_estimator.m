function St = icara_spectral_estimator(x, icara_data)

  % De momento usamos una simple STFT
  % Se podría mejorar con Multi-Tapers
  X = fftshift(fft(x, icara_data.psd.N));
  X = icara_data.psd.a_weighting(X);
  St = abs(X).^2 * icara_data.psd.inv_time_factor;

endfunction