function resultado=guardarCSV(nombreCompleto_csv,Datos)
[filas,columnas]=size(Datos);
fid=fopen(nombreCompleto_csv,'wt');
fprintf(fid,'%s\n','sep=|');
for i=1:filas
    for j=1:columnas-1
        if ~isnumeric(Datos{i,j}) && ...
                ~islogical(Datos{i,j})
            fprintf(fid,'%s|',Datos{i,j});  
        elseif isnumeric(Datos{i,j}) && ...
                ~isscalar(Datos{i,j}) && ...
                ~islogical(Datos{i,j})
            fprintf(fid,'%s|',Datos{i,j});  
        elseif isnumeric(Datos{i,j}) && ...
                isscalar(Datos{i,j}) && ...
                ~islogical(Datos{i,j})
            fprintf(fid,'%12.16G|',Datos{i,j});  
        elseif ~isnumeric(Datos{i,j}) && ...
                isscalar(Datos{i,j}) && ...
                islogical(Datos{i,j})
            fprintf(fid,'%o|',Datos{i,j});
        end
    end    
    fprintf(fid,'%s\n',Datos{i,columnas}); 
end
output=fclose(fid);
exito=~logical(output);
resultado=exito;
end