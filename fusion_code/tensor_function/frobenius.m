function f=frobenius(A)
%��������A��f����

a=reshape(A,1,[]);
b=power(a,2);
c=cumsum(b);
f=sqrt(c(end));


end