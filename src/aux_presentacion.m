## Divenire
icara_data.calc_mhps = false;
icara_data.redundancy = 15;
icara_data.freq_min = 160;
icara_data.mixer.minLength = .1;
nombre_archivo = 'muestras/rec0_8';
runner;

ploto_n;
ylim([35,55]);
xlim([2,10]);
ylabel('Frecuencia [Hz]');
xlabel('Tiempo [s]');
set(gca, 'fontsize', 18);

play_audio = false;
icara_synth;
audiowrite('../out/rec0_8.wav', sintesis, icara_data.fm);

input_midi;
notes = midi_notes;
icara_synth;
audiowrite('../out/rec0_8_midi.wav', sintesis, icara_data.fm);
clear notes;

## Mision Imposible
icara_data.calc_mhps = true;
icara_data.mixer.minLength = 0.05;
icara_data.redundancy = 16;
icara_data.freq_min = 80;
nombre_archivo = 'Mision Imposible - L7';
ti = 0;
tf = 40;
runner;

play_audio = false;
icara_synth;
audiowrite('../out/mision_imposible.wav', sintesis, icara_data.fm);

offset = -24;
icara_synth;
audiowrite('../out/mision_imposible_grave.wav', sintesis, icara_data.fm);
clear offset;