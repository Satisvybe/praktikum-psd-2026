b = [0,0,0,0.25,-0.5,0.0625];
a = [1,-1,0.75,-0.25,0.0625];

[delta,n]=impseq(0,0,7);
x = filter(b,a,delta)

x = ((n-2).*(1/2).^(n-2).*cos(pi*(n-2)/3)).*stepseq(2,0,7)

function [x,n] = impseq(n0,n1,n2)
n = n1:n2;
x = (n == n0);
end

function x = stepseq(n0,n1,n2)
n = n1:n2;
x = double(n >= n0);
end
