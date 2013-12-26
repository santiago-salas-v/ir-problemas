function [resultado,Datos]=cargarCSV(nombreCompleto_csv)
fid=fopen(nombreCompleto_csv);
if fid < 3
    ME=MException('FILE_READ:ERROR',['Cannot open file. ',...
        ' Is it open outside of Matlab?']);
    throw(ME);
end
i=1;
primeraLinea=deblank(fgetl(fid));
sepChar=primeraLinea(end);
Datos=[{} {} {}];
while ~feof(fid)
    Datos(i,:)=regexp(fgetl(fid),['\',sepChar],'split');
    i=i+1;
end
fclose(fid);
exito=false;
resultado=exito;
end