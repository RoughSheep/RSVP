function save_fig(h1)

new_f_handle=figure('visible','off');
new_axes=copyobj(h1,new_f_handle);
set(new_axes,'units','default','position','default');
[filename,pathname fileindex]=uiputfile({'*.jpg';'*.bmp'},'save picture as');
if ~filename
    return
else
    file=strcat(pathname,filename);
    switch fileindex
        case 1
            print(new_f_handle,'-djpeg',file);
        case 2
            print(new_f_handle,'-dbmp',file);
    end
end
delete(new_f_handle);