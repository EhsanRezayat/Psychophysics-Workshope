function [B, LL, W] = mixtureFunction (X, T, NT, B0)
% mixtureFunction (X, T, NT, B0) 
%   Expectation Maximization function called by mixtureFit with starting parameters specified in B0.
%
%   Paul Bays | bayslab.com | Licence GPL-2.0 | 2017-02-20

if (nargin<2 || size(X,2)>1 || size(T,2)>1 || size(X,1)~=size(T,1) || nargin>2 && ~isempty(NT) && (size(NT,1)~=size(X,1) || size(NT,1)~=size(T,1)))     
    error('Input is not correctly dimensioned');
    return; 
end

if (nargin>3 && (B0(1)<0 || any(B0(2:4)<0) || any(B0(2:4)>1) || abs(sum(B0(2:4))-1) > 10^-6))
    error('Invalid model parameters');
    return;
end

MaxIter = 10^4; MaxdLL = 10^-4;

n = size(X,1); 

if (nargin<3) 
    NT = zeros(n,0); nn = 0;
else
    nn = size(NT,2);
end

% Default starting parameters
if (nargin<4)    
    K = 5; Pt = 0.5; 
    if (nn>0) Pn = 0.3; else Pn = 0; end
    Pu = 1-Pt-Pn;
else
    K = B0(1); 
    Pt = B0(2); Pn = B0(3); Pu = B0(4);
end

E  = X-T; E = mod(E + pi, 2*pi) - pi;
NE = repmat(X,1,nn)-NT; NE = mod(NE + pi, 2*pi) - pi;

LL = nan; dLL = nan; iter = 0;

while (1)
    iter = iter + 1;
    
    Wt = Pt * vonmisespdf(E,0,K);
    Wu = Pu * ones(n,1)/(2*pi);

    if nn==0
        Wn = zeros(size(NE));
    else
        Wn = Pn/nn * vonmisespdf(NE,0,K);
    end
    
    W = sum([Wt Wn Wu],2);
    
    dLL = LL-sum(log(W));
    LL = sum(log(W));
    if (abs(dLL) < MaxdLL | iter > MaxIter) break; end
    
    Pt = sum(Wt./W)/n;
    Pn = sum(sum(Wn,2)./W)/n; 
    Pu = sum(Wu./W)/n;
            
    rw = [(Wt./W) (Wn./repmat(W,1,nn))]; 
    
    S = [sin(E) sin(NE)]; C = [cos(E) cos(NE)];
    r = [sum(sum(S.*rw)) sum(sum(C.*rw))];
    
    if sum(sum(rw))==0
        K = 0;
    else
        R = sqrt(sum(r.^2))/sum(sum(rw));        
        K = fastA1inv(R);
    end
    
    if n<=15
        if K<2
            K = max(K-2/(n*K), 0);
        else
            K = K * (n-1)^3/(n^3+n);
        end
    end       
end

if iter>MaxIter
    warning('mixtureFunction:MaxIter','Maximum iteration limit exceeded.');
    B = [NaN NaN NaN NaN]; LL = NaN; W = NaN;
else  
    B = [K Pt Pn Pu]; W = [Wt sum(Wn,2) Wu];%./sum([Wt Wn Wu],2);
end