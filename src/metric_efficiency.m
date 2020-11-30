  notasMIDI = midi_notes;
  notasICARA = icara_data.storage.notes;
    NM = length(notasMIDI);
    NI = length(notasICARA);
    s_factor = icara_data.notes.step^(33)/440;
    
    idxIcaraEncontradas = [];
    errorTemporalV = [];
    
    for midi_idx = 1:NM
        nMIDI = notasMIDI(midi_idx).n;
        timeIni = notasMIDI(midi_idx).ti; 
        timeFin = notasMIDI(midi_idx).tf; 

        toli = 0.3;
        tolf = 0.1;
        
        for icara_idx = 1:NI
          % nICARA = icara_data.notes.step_log*notasICARA(icara_idx).freq;
          nICARA = round(log(notasICARA(icara_idx).freq * s_factor)/icara_data.notes.step_log);
          if(nMIDI == nICARA)
            if(notasICARA(icara_idx).ti >= timeIni-toli  && notasICARA(icara_idx).ti <= timeIni+toli)
##              if((timeFin - timeIni) < 0.4)
##                if(notasICARA(icara_idx).tf >= timeFin-tolf  && notasICARA(icara_idx).tf <= timeFin+tolf)
##                  %es la misma nota y comparamos.
##                  notasMIDI(midi_idx).similarity = icara_idx;
##                  notasICARA(icara_idx).similarity = midi_idx;
##                  errorTi = abs(notasMIDI(midi_idx).ti - notasICARA(icara_idx).ti);
##                  errorTf = abs(notasMIDI(midi_idx).tf - notasICARA(icara_idx).tf);
##                  errorTemporal = (3*errorTi + errorTf)/4;
##                  errorTemporalV(end+1) = errorTemporal;
##                  idxIcaraEncontradas(end+1) = icara_idx;
##                  break;
##                endif
##              else
                %if
                  notasMIDI(midi_idx).similarity = icara_idx;
                  notasICARA(icara_idx).similarity = midi_idx;
                  errorTi = abs(notasMIDI(midi_idx).ti - notasICARA(icara_idx).ti);
                  errorTemporal = errorTi;
                  errorTemporalV(end+1) = errorTemporal;
                  idxIcaraEncontradas(end+1) = icara_idx;
                  break;
                %endif
##              endif
            endif  
          endif
        endfor
    endfor

    %idxNotasNoEncontradas = find(1:NI != idxIcaraEncontradas);
    
    idxNotasNoEncontradas = setdiff(1:NI,idxIcaraEncontradas);
    
##    tiempoTotalError = 0;%sum(notasICARA(idxNotasNoEncontradas).tf-notasICARA(idxNotasNoEncontradas).ti);
##    if(length(idxIcaraEncontradas) != 0)
##      for no_encontrada=idxNotasNoEncontradas
##        tiempoTotalError += notasICARA(midi_idx).tf - notasICARA(midi_idx).ti;
##      endfor
##    endif
##    tiempoError = 1;
##    if(tiempoTotalError!=0)
##      tiempoError = tiempoTotalError/(tf-ti);
##    endif
##  
##    maxError = max(errorTemporalV);
##    errorTemporalPromedio = 1;
##    if(maxError!=0)
##      %errorTemporalV ./= max(errorTemporalV);
##      errorTemporalPromedio = mean(errorTemporalV);
##    endif
##    
    %error porcentaje no encontradas
    e_NE = (NM-length(idxIcaraEncontradas))/NM;
    
    %error porcentaje de tiempo de las no encontradas con respecto al tiempo total
    e_TNE = 0;
    for no_encontrada=idxNotasNoEncontradas
      e_TNE += notasICARA(no_encontrada).tf - notasICARA(no_encontrada).ti;
    endfor
    e_TNE = e_TNE/(tf-ti);
    
    %error temporal de notas correctas
    e_TNC = 0;
    maxError = max(errorTemporalV);
    if(maxError!=0)
      e_TNC = mean(errorTemporalV);
    endif
    
    e_max = max([e_NE, e_TNE, e_TNC]);
    
    errorTotal = 1;
    if(e_max != 1 && length(idxIcaraEncontradas)!=0)
      errorTotal = (8*e_NE + 3*e_TNE + e_TNC)/13;
    endif
##    errorTotal = (tiempoError + errorTemporalPromedio)/(2);

    eficiencia = 1 - errorTotal;

    eficiencia
%endfunction

%error x freq_min
%error x redundancy
%error por varias muestras
