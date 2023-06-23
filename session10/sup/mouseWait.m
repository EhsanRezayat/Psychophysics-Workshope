function mouseWait ()
buttons = 0;

while ~buttons
    [x,y,buttons] = GetMouse();
end

fprintf ('you clicked button %d\n',find(buttons));
end