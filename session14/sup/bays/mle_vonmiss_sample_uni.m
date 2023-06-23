function rmsd = mle_vonmiss_sample_uni(b,y)
mu= b(1);
k = b(2);
rmsd = -1*sum(log(exp(k.*cos(y-mu) - log(2*pi) - besseliln(0,k))+b(3)*(1/(2*pi))));


