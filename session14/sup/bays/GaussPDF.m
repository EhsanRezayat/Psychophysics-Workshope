%%% This function try to Calculate the Density for the Gaussian

function dens = GaussPDF(y, mu, sigma)

dens = (1./2*pi*sigma) .* exp(-1/2*((y-mu)./sigma).^2);

