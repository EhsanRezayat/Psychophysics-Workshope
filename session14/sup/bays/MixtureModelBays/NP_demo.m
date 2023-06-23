function NP_demo
% NP_Demo 
%   Demonstrates how to use NP functions to evaluate and exclude swap
%   (non-target) errors.
%
%   Ref: Bays, Sci Rep 6, 2016.
%
%   Paul Bays | bayslab.com | Licence GPL-2.0 | 2015-12-09 

clear all; close all;

%% Simulate data

reps = 1000; ndata = 500; a = [0.7 0.25 0.05]; m = length(a);
A = 0.9; B = 0.5; G = 0.4; D0 = 0.2;

f = randwrapstable(ndata, A, B, G, D0);
for rep = 1:reps
    T{rep} = rand(ndata,m)*2*pi - pi;
    r = rand(ndata,1);
    ix = sum(bsxfun(@gt,r,cumsum(a)),2)+1;
    xs = wrap(bsxfun(@plus,f,T{rep}));
    X{rep} = xs(sub2ind([ndata m],[1:ndata]',ix));
end
r = exp(-G.^A);
d = wrap(D0 + B*tan(pi*A/2)*[G^A-G]);
x = circspace(1000); p = wrapstablepdf(x, A, B, G, D0);

% plot
figure(1); clf;
for i=1:m
    subplot(3,1,i); hold on;
    [hh xx] = hist(wrap(X{1}-T{1}(:,i)),circspace(25));
    h = bar(xx,hh,1); h.FaceColor = [0.8 0.8 0.8];
    plot(x, ( a(i)*p*(2*pi) + (1-a(i)) )*ndata/1000*40)
    axis([-pi pi 0 ndata/(2*pi)]);
    set(gca,'xtick',[-pi 0 pi],'xticklabel',{'-\pi','0','\pi'});
    xlabel(['Response deviation from item ' num2str(i)]); ylabel('freq.');
    if i==1, title('Simulated data'); end
end

%% Estimate mixture parameters

for rep = 1:reps
    a_est(rep,:) = NP_alpha(X{rep}, T{rep});
end

% plot
figure(2); clf; hold on;
for i=1:m
    h(1) = plot([i-0.5 i+0.5],[a(i) a(i)],'r--');
end

h(2) = errorbar(mean(a_est),std(a_est),'ko','markerfacecolor','white');

title('Mixture parameters (NP\_alpha)'); xlabel('item'); ylabel('probability, \alpha');
set(gca,'xtick',[1:m]);
legend(h,'true','estimate'); 

%% Estimate probability function

for rep = 1:reps
    [p_est(rep,:) xx] = NP_pdf(X{rep}, T{rep});
end

% plot
figure(3); clf; hold on;
h(1) = plot(x, p, 'r--');

h(2) = errorbar(xx, mean(p_est), std(p_est), 'ko', 'markerfacecolor', 'white');

title('Error distribution (NP\_pdf)'); xlabel('error'); ylabel('prob. density, f(x)');
xlim([-pi pi]); set(gca,'xtick',[-pi -pi/2 0 pi/2 pi],'xticklabel',{'-\pi','-\pi/2','0','\pi/2','\pi'});
legend(h,'true','estimate'); 

%% Estimate 1st circular moment

for rep = 1:reps
    m_est = NP_moment(X{rep},T{rep},1);
    d_est(rep) = angle(m_est);
    r_est(rep) = abs(m_est);
end

% plot
figure(4); clf; hold on;

h(1) = plot([0.5 1.5],[d d],'r--');
plot([1.5 2.5],[r r],'r--');

h(2) = errorbar(1,mean(d_est),std(d_est),'ko','markerfacecolor','white');
errorbar(2,mean(r_est),std(r_est),'ko','markerfacecolor','white');

set(gca,'xtick',[1 2],'xticklabel',{'mean','resultant length'}); ylim([0 1]);
legend(h,'true','estimate','location','northwest'); 
title('1st circular moment (NP\_moment)');

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function X = randwrapstable (N, A, B, G, D0)
% RANDWRAPSTABLE (N, A, B, G, D)
%    Generates N random samples from a wrapped stable distribution (S0 
%    parameterization) with parameters:
%       A  (shape, 0 < A <= 2), 
%       B  (skewness, -1 <= B <= 1), 
%       G  (scale, G > 0), 
%       D0 (location, -pi <= D <= pi)
%
%    See also WRAPSTABLEPDF.

n = prod(N);

if A==1
    D1 = D0 - B*log(G)*G*2/pi;
else
    D1 = D0 - B*G*tan(pi*A/2);
end

X = wrap(stblrnd(A,B,G,D1,[N 1]));

if prod(N)~=N(1), X = reshape(X,N); end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Y = wrapstablepdf(X,A,B,G,D0)
% WRAPSTABLEPDF Wrapped stable probability density function (pdf)
%   Y = WRAPSTABLEPDF(THETA,A,B,G,D) returns the pdf of the wrapped stable 
%   distribution (S0 parameterization) with parameters:
%       A  (shape, 0 < A <= 2), 
%       B  (skewness, -1 <= B <= 1), 
%       G  (scale, G > 0), 
%       D0 (location, -pi <= D <= pi)
%   evaluated at the values in THETA (given in radians).
%
%   WRAPSTABLEPDF(X,2,0,G,D0) corresponds to the normal distribution with
%   mean D0 and variance 2*G^2;
%
%   See Pewsey A, Computational Statistics & Data Analysis, 52, 1516-1523 
%   (2008).

if A<=0 || A>2 || B<-1 || B>1 || G<=0 || D0>pi || D0<-pi, Y = nan(size(X)); return; end

Y = zeros(size(X));
rho = exp(-G.^A);

p = 0;
while(1)
    p = p + 1;
    
    rho_p = rho^(p^A);
    
    if (A==1)
        mu_p = wrap(p*D0 - 2/pi*p*B*G*log(p*G));
    else
        mu_p = wrap(p*D0 + B*tan(pi*A/2)*((p*G)^A-p*G));
    end
    
    f = 2*rho_p*cos(p*X-mu_p);
    
    Y = Y + f;
    
    if max(abs(f))<eps, break; end
    
    if (p>10^4) warning('wrapstablepdf:MaxIterExceeded','Maximum iterations exceeded.'); Y = nan(size(X)); return; end;
end

Y = (Y + 1)/(2*pi);

Y(X<-pi | X>pi) = NaN;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function r = stblrnd(alpha,beta,gamma,delta,varargin)
%STBLRND alpha-stable random number generator.
% R = STBLRND(ALPHA,BETA,GAMMA,DELTA) draws a sample from the Levy 
% alpha-stable distribution with characteristic exponent ALPHA, 
% skewness BETA, scale parameter GAMMA and location parameter DELTA.
% ALPHA,BETA,GAMMA and DELTA must be scalars which fall in the following 
% ranges :
%    0 < ALPHA <= 2
%    -1 <= BETA <= 1  
%    0 < GAMMA < inf 
%    -inf < DELTA < inf
%
%
% R = STBLRND(ALPHA,BETA,GAMMA,DELTA,M,N,...) or 
% R = STBLRND(ALPHA,BETA,GAMMA,DELTA,[M,N,...]) returns an M-by-N-by-... 
% array.   
% 
%
% References:
% [1] J.M. Chambers, C.L. Mallows and B.W. Stuck (1976) 
%     "A Method for Simulating Stable Random Variables"  
%     JASA, Vol. 71, No. 354. pages 340-344  
%
% [2] Aleksander Weron and Rafal Weron (1995)
%     "Computer Simulation of Levy alpha-Stable Variables and Processes" 
%     Lec. Notes in Physics, 457, pages 379-392
%

if nargin < 4
    error('stats:stblrnd:TooFewInputs','Requires at least four input arguments.'); 
end

% Check parameters
if alpha <= 0 || alpha > 2 || ~isscalar(alpha)
    error('stats:stblrnd:BadInputs',' "alpha" must be a scalar which lies in the interval (0,2]');
end
if abs(beta) > 1 || ~isscalar(beta)
    error('stats:stblrnd:BadInputs',' "beta" must be a scalar which lies in the interval [-1,1]');
end
if gamma < 0 || ~isscalar(gamma)
    error('stats:stblrnd:BadInputs',' "gamma" must be a non-negative scalar');
end
if ~isscalar(delta)
    error('stats:stblrnd:BadInputs',' "delta" must be a scalar');
end


% Get output size
[err, sizeOut] = genOutsize(4,alpha,beta,gamma,delta,varargin{:});
if err > 0
    error('stats:stblrnd:InputSizeMismatch','Size information is inconsistent.');
end


%---Generate sample----

% See if parameters reduce to a special case, if so be quick, if not 
% perform general algorithm

if alpha == 2                  % Gaussian distribution 
    r = sqrt(2) * randn(sizeOut);

elseif alpha==1 && beta == 0   % Cauchy distribution
    r = tan( pi/2 * (2*rand(sizeOut) - 1) ); 

elseif alpha == .5 && abs(beta) == 1 % Levy distribution (a.k.a. Pearson V)
    r = beta ./ randn(sizeOut).^2;

elseif beta == 0                % Symmetric alpha-stable
    V = pi/2 * (2*rand(sizeOut) - 1); 
    W = -log(rand(sizeOut));          
    r = sin(alpha * V) ./ ( cos(V).^(1/alpha) ) .* ...
        ( cos( V.*(1-alpha) ) ./ W ).^( (1-alpha)/alpha ); 

elseif alpha ~= 1                % General case, alpha not 1
    V = pi/2 * (2*rand(sizeOut) - 1); 
    W = - log( rand(sizeOut) );       
    const = beta * tan(pi*alpha/2);
    B = atan( const );
    S = (1 + const * const).^(1/(2*alpha));
    r = S * sin( alpha*V + B ) ./ ( cos(V) ).^(1/alpha) .* ...
       ( cos( (1-alpha) * V - B ) ./ W ).^((1-alpha)/alpha);

else                             % General case, alpha = 1
    V = pi/2 * (2*rand(sizeOut) - 1); 
    W = - log( rand(sizeOut) );          
    piover2 = pi/2;
    sclshftV =  piover2 + beta * V ; 
    r = 1/piover2 * ( sclshftV .* tan(V) - ...
        beta * log( (piover2 * W .* cos(V) ) ./ sclshftV ) );      
          
end
    
% Scale and shift
if alpha ~= 1
   r = gamma * r + delta;
else
   r = gamma * r + (2/pi) * beta * gamma * log(gamma) + delta;  
end

end


%====  function to find output size ======%
function [err, commonSize, numElements] = genOutsize(nparams,varargin)
    try
        tmp = 0;
        for argnum = 1:nparams
            tmp = tmp + varargin{argnum};
        end
        if nargin > nparams+1
            tmp = tmp + zeros(varargin{nparams+1:end});
        end
        err = 0;
        commonSize = size(tmp);
        numElements = numel(tmp);

    catch
        err = 1;
        commonSize = [];
        numElements = 0;
    end
end