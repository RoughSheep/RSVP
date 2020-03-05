
function click_back(hObject,eventdata,handles)
    myhandles=guidata(gcf);
    pt = get(gcf,'CurrentPoint');
    myhandles.x = pt(1,1);
    myhandles.y = pt(1,2);
    guidata(handles,myhandles);
    uiresume(gcbf);
end