%REDUNDANCIAS
icara_data.calc_mhps = true;
nombres_archivos(1).nombre = 'muestras/rec0_1';
nombres_archivos(2).nombre = 'muestras/rec0_5';
nombres_archivos(3).nombre = 'muestras/rec0_8';
nombres_archivos(4).nombre = 'muestras/rec0_9';
nombres_archivos(5).nombre = 'muestras/rec0_16';
nombres_archivos(6).nombre = 'muestras/rec0_33';
redundancias = [1:5];
eficiencias = zeros(length(redundancias), length(nombres_archivos));
for m_red=redundancias
  icara_data.redundancy = m_red;
  for m_arch=1:length(nombres_archivos)
    nombre_archivo = nombres_archivos(m_arch).nombre;
    input_midi;
    runner;
    metric_efficiency;
    eficiencias(m_red, m_arch) = eficiencia;
  endfor
endfor

figure;
hold on;
for m_arch=1:length(nombres_archivos)
  plot(redundancias, eficiencias(:, m_arch),'linewidth',2);
endfor

ylabel('Eficiencia');
xlabel('Redundancia');







%FRECUENCIA MINIMA
##frecuencias = [50,120,200,300,400,600,800,1100];
####frecuencias = [50,120,200];
####frecuencias = [15,25,35,45,50:5:90,100:15:190,200:20:400,450:50:700,800:100:1400];
##eficiencias = zeros(length(frecuencias), length(nombres_archivos));
##icara_data.redundancy = 3;
##for freq_idx=1:length(frecuencias)
##  m_red = frecuencias(freq_idx);
##  icara_data.freq_min = m_red;
##  for m_arch=1:length(nombres_archivos)
##    nombre_archivo = nombres_archivos(m_arch).nombre;
##    input_midi;
##    runner;
##    metric_efficiency;
##    eficiencias(freq_idx, m_arch) = eficiencia;
##  endfor
##endfor
##
##figure;
##hold on;
##for m_arch=1:length(nombres_archivos)
##  plot(frecuencias, eficiencias(:, m_arch),'linewidth',2);
##endfor
##
##ylabel('Eficiencia');
##xlabel('Frecuencia Mínima');
##set(gca,'linewidth',2);

##icara_data.redundancy = 3;
##eficiencias = [];
##%frecuencias = [40,50,65.4,75,92,140,220];
####frecuencias = [40,50,65.4,75,92,220,350,500,650,800,1000,1200,1400];
##frecuencias = [15,25,35,45,50:5:90,100:15:190,200:20:400,450:50:700,800:100:1400];
##for i=1:length(frecuencias)
##  icara_data.freq_min = frecuencias(i);
##  runner;
##  calc_efficiency;
##  eficiencias=[eficiencias,eficiencia];
##endfor
##
##plot(frecuencias,eficiencias);
##ylabel('Eficiencia');
##xlabel('Frecuencia Mínima');