function toolbox_in_use = check_toolboxes(func_name)
[~, pList] = matlab.codetools.requiredFilesAndProducts(func_name);
if (size({pList, Name}', 1)>1)
    toolbox_in_use = ture;
    displ('Toolbox wird verwendet')
else
    toolbox_in_use = false;
    displ('Keine Toolboxen werden verwendet')
end
end
