function resultado=guardarCSV(nombreCompleto_csv,Datos)
exito=false;   
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
            fprintf(fid,'%f|',Datos{i,j});  
        elseif ~isnumeric(Datos{i,j}) && ...
                isscalar(Datos{i,j}) && ...
                islogical(Datos{i,j})
            fprintf(fid,'%o|',Datos{i,j});
        end
    end    
    fprintf(fid,'%s\n',Datos{i,columnas}); 
end
fclose(fid);
resultado=exito;
end