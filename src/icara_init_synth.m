function icara_data = icara_init_synth(icara_data)
  resource_path = '../resources/banks';
  instruments(1).nombre = 'piano';
  notes_count = [ 0 60 ];

  for inst = 1:length(instruments)
    nombre = instruments(inst).nombre;
    samples = [];
    inst_path = [resource_path '/' nombre '/'];

    for n = notes_count(inst, 1):notes_count(inst, 2)
      [x fm] = audioread([inst_path int2str(n) '.wav']);

      if fm != 44100
        error 'Todos los bancos deben estar muestreados a 44.1khz';
      endif

      samples(n+1, :) = x;
    endfor

    icara_data.note_bank.(nombre).samples = samples;
    icara_data.note_bank.(nombre).bounds = notes_count(inst, :);
  endfor
endfunction