if !exist('ti')
  ti = 0;
endif

if !exist('tf')
  tf = 20;
endif

if !exist("nombre_archivo")
  nombre_archivo = 'muestras/rec0_8';
endif

[x, fm] = audioread(['../resources/' nombre_archivo '.wav']);
x -= mean(x);
icara_data.fm = fm;

x = x(ti*fm+1:min(length(x), tf * fm));
N = length(x);
if size(x)(2) == 1
  x = x';
endif

printf('La senal dura: %d s\n', length(x) / fm);

icara_init;

% window_t = numero entre 20 y 30
window_t = 20 + rand*10;

% tomar ventana de n milisegundos, considerar fm
% @TODO Hacer esto mas aleatorio
Nw = floor(window_t*fm/1000);
vNw = 1:Nw;

icara_data = icara_setup(icara_data);
x = [zeros(1, floor(icara_data.atime.bw*fm)), x, zeros(1, floor(icara_data.offset.bw*fm*icara_data.mixer.tolTime))];

N0 = 0;
elapsed = 0;

while N0 <= N-Nw % @TODO enviar TODAS las muestras
  t_start = time();
  icara_data = icara(x(N0 + vNw), icara_data);
  elapsed += time() - t_start;
  
  N0 = N0 + Nw;
endwhile


printf('Tarda %d s\n', elapsed);
