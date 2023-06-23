function rmsd = mle_gaussian_sample(b,y)

rmsd = -1*sum(log((1/(sqrt(2*pi*b(2))))*exp(-1*((y-b(1))/(2*b(2))).^2)));
 