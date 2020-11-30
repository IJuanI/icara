icara_debug = true;
icara_data.calc_mhps = true;
icara_data.redundancy = 10;
icara_data.freq_min = 80;
nombre_archivo = 'muestras/rec0_8';
runner;

g_combine = true;

figure;
title 'HPS vs MHPS';
plot_raw_notes;
plot_hps_notes;
ylim([500,1400]);
xlim([2,10]);
ylabel('Frecuencia [Hz]');
xlabel('Tiempo [s]');
set(gca, 'fontsize', 18);

figure;
title 'HPS vs MHPS';
plot_raw_notes;
plot_hps_notes;
plot([1.5 1.5 5 5 1.5], [550 1000 1000 550 550], 'linestyle', '--', 'color', [.95 .4 .3], 'linewidth', 4);
ylim([500,1400]);
xlim([2,10]);
ylabel('Frecuencia [Hz]');
xlabel('Tiempo [s]');
set(gca, 'fontsize', 18);

figure;
title 'HPS vs MHPS';
plot_raw_notes;
plot_hps_notes;
plot([1.5 1.5 5 5 1.5], [550 1000 1000 550 550], 'linestyle', '--', 'color', [.95 .4 .3], 'linewidth', 4);
ylim([550,1000]);
xlim([1.5,5]);
ylabel('Frecuencia [Hz]');
xlabel('Tiempo [s]');
set(gca, 'fontsize', 18);


figure;
title 'Agrupamiento';
plot_raw_notes;
plot_group_notes;
ylim([500,1400]);
xlim([2,10]);
ylabel('Frecuencia [Hz]');
xlabel('Tiempo [s]');
set(gca, 'fontsize', 18);

figure;
title 'Agrupamiento';
plot_raw_notes;
plot_group_notes;
plot([6 6 9 9 6], [400 1400 1400 400 400], 'linestyle', '--', 'color', [.95 .4 .3], 'linewidth', 4);
ylim([500,1400]);
xlim([2,10]);
ylabel('Frecuencia [Hz]');
xlabel('Tiempo [s]');
set(gca, 'fontsize', 18);

figure;
title 'Agrupamiento';
plot_raw_notes;
plot_group_notes;
plot([2.5 2.5 5.5 5.5 2.5], [500 820 820 500 500], 'linestyle', '--', 'color', [.26 .53 .96], 'linewidth', 4);
ylim([500,1400]);
xlim([2,10]);
ylabel('Frecuencia [Hz]');
xlabel('Tiempo [s]');
set(gca, 'fontsize', 18);

figure;
title 'Agrupamiento';
plot_raw_notes;
plot_group_notes;
plot([6 6 9 9 6], [400 1400 1400 400 400], 'linestyle', '--', 'color', [.95 .4 .3], 'linewidth', 4);
ylim([400,1400]);
xlim([6,9]);
ylabel('Frecuencia [Hz]');
xlabel('Tiempo [s]');
set(gca, 'fontsize', 18);

figure;
title 'Agrupamiento';
plot_raw_notes;
plot_group_notes;
plot([2.5 2.5 5.5 5.5 2.5], [500 820 820 500 500], 'linestyle', '--', 'color', [.26 .53 .96], 'linewidth', 4);
ylim([500,820]);
xlim([2.5,5.5]);
ylabel('Frecuencia [Hz]');
xlabel('Tiempo [s]');
set(gca, 'fontsize', 18);


figure;
title 'Estabilizacion';
plot_group_notes;
g_color = 5;
plot_notes;
ylabel('Frecuencia [Hz]');
xlabel('Tiempo [s]');
ylim([500,1400]);
xlim([2,10]);
set(gca, 'fontsize', 18);

figure;
title 'Estabilizacion';
plot_group_notes;
g_color = 5;
plot_notes;
plot([7 7 9.5 9.5 7], [850 1100 1100 850 850], 'linestyle', '--', 'color', [.95 .4 .3], 'linewidth', 4);
ylabel('Frecuencia [Hz]');
xlabel('Tiempo [s]');
ylim([500,1400]);
xlim([2,10]);
set(gca, 'fontsize', 18);

figure;
title 'Estabilizacion';
plot_group_notes;
g_color = 5;
plot_notes;
plot([7 7 9.5 9.5 7], [850 1100 1100 850 850], 'linestyle', '--', 'color', [.95 .4 .3], 'linewidth', 4);
ylabel('Frecuencia [Hz]');
xlabel('Tiempo [s]');
ylim([850,1100]);
xlim([7,9.5]);
set(gca, 'fontsize', 18);
