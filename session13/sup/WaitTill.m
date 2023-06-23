% [key, secs] = WaitTill (tillSecs);
% This is the same as WaitSecs('UntilTime',tillSecs), but it returns the
% first pressed keys during the wait and key press time, and allows user to
% exit with ESC.
% 
% [key, secs] = WaitTill (KEYS);
% Wait till any key defined in KEYS is pressed. Return key and key press
% time. KEYS can be a string for a key name, or cell string for multiple
% key names. This will detect only keys in KEYS, so provide a way to ignore
% those stuck keys in some computers. To detect any key, pass '' for KEYS.
% WaitTill uses consistent name across Windows, MAC and Linux for the keys
% they share. To get list of key names, use next command.
% 
% allKeys = WaitTill('KeyNames');
% Return all key names (sorted) for your system.
% 
% [key, secs] = WaitTill (tillSecs, KEYS [, keyReturn=1]);
% [key, secs] = WaitTill (KEYS, tillSecs [, keyReturn=1]);
% Wait till either tillSecs reaches or a key in KEYS is pressed. Return the
% first pressed keys, or empty if none, and time. The optional third
% argument, default ture, tells whether the function will return when a key 
% is detected. If it is false, the function will wait till tillSecs even if
% a key is detected.
% 
% In case more than one keys in KEYS are pressed simultaneously, all of
% them will be returned in key as a cellstr, as by ReadKey. It is your
% responsibility to deal with this special case by yourself. For example,
% you could deal with different number of keys like this: 
% 
% if isempty(key), continue; % no key press, continue next trial in a loop
% elseif iscellstr(key), key=key{1}; % more than one key, take the 1st?
% end
% 
% In any case, ESC will abort execution unless 'esc' is included in KEYS.
%
% To avoid CPU overload in Windows, WaitSecs(0.01) is inserted in KbCheck
% loop. This might be a problem for some keyboards, such as fORP, so
% WaitSecs(0.01) is disable by default. If you are not using fORP in
% Windows, run next line in command line or insert it in your code to avoid
% CPU overload.
% global fORP; fORP=false;
% 
% See also ReadKey KbCheck

% Xiangrui Li, 4/2006 wrote it
% Xiangrui Li, 2/2009, made syntax more flexible
% Xiangrui Li, 5/2009, added fORP global
% Xiangrui Li, 6/2009, added multi-key detection, acutually in ReadKey.m
function varargout = WaitTill (varargin)
tnow=GetSecs;
global fORP; if isempty(fORP), fORP=true; end
persistent isPCWIN; if isempty(isPCWIN), isPCWIN=strncmp(computer,'PCWIN',5); end
switch nargin
    case 0, help(mfilename); return;
    case 1
        if isnumeric(varargin{1}), tillSecs=varargin{1}; keys=''; keyReturn=0;
        else tillSecs=inf; keys=varargin{1}; keyReturn=1;
        end
    case 2
        if isnumeric(varargin{1}), tillSecs=varargin{1}; keys=varargin{2};
        else tillSecs=varargin{2}; keys=varargin{1};
        end
        keyReturn=1;
    case 3
        if isnumeric(varargin{1}), tillSecs=varargin{1}; keys=varargin{2};
        else tillSecs=varargin{2}; keys=varargin{1};
        end
        keyReturn=varargin{3};
    otherwise, error('Too many input arguments.');
end
if isempty(tillSecs), tillSecs=inf; end
key=''; secs=tillSecs;
while tnow<tillSecs
    if isPCWIN && (~fORP) && tillSecs-tnow>0.1 , WaitSecs(0.01); end
    [kk, tnow]=ReadKey(keys);
    if ~isempty(kk) && isempty(key)
        key=kk; secs=tnow; 
        if keyReturn, break; end
    end
end
if nargout, varargout={key, secs}; end
