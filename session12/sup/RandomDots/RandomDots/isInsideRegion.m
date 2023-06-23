
function inside = isInsideRegion(pos, region)
% 
% function in = isInsideRegion(pos, region)
% 
% checks if pos is inside a specified region
% 
% Input
%     pos       [x y] or two-column matrix 
%     region is a structure with the following two fields 
%       type    can be 'rect' or 'ellipse'
%       spec    if type is 'rect' spec defines a rectangle [xmin ymin xmax ymax]
%               if type is 'ellipse' spec defines an ellipse. in this case spec is
%               a structure with these fields
%                   center      the center of the ellipse [x y]
%                   radius      horizontal and vertical radii of the ellipse [rx ry]
%
% Output
%   inside      1 if pos is inside the region, 0 otherwise
% 

% 
% 09/26/07,  Roozbeh Kiani
% 

switch region.type
    case 'rect'
        inside = pos(:,1)>=region.spec(1) && pos(:,1)<region.spec(3) && ...
                 pos(:,2)>=region.spec(2) && pos(:,2)<region.spec(4);
    case 'ellipse'
        n = size(pos,1);
        d = ((pos-repmat(region.spec.center,n,1))./repmat(region.spec.radius,n,1));
        inside = sqrt(sum(d.^2,2))<=1;
    otherwise
        error('region type is not recognized');
end





