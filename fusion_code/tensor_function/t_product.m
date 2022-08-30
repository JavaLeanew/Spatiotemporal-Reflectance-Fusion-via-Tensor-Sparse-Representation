function C=t_product(A,B)
%A��B��Ϊ3-D����
%C=A*B������*Ϊ������

% ��ȡ������С
[l,p,n]=size(A);dimA=[l,p,n];
[p,m,n]=size(B);dimB=[p,m,n];
dimC=[l,m,n];

% ��A��B����unfoldչ������
ufold_A=reshape(permute(A,[2,1,3]),dimA(2),[])';
ufold_B=reshape(permute(B,[2,1,3]),dimB(2),[])';

% ��A����ѭ������
bcirc_A=zeros([l*n,p*n]);
for i=1:n
    bcirc_A(:,(1:p)+(i-1)*p)=circshift(ufold_A,l*(i-1),1);
end

% bcirc(A)��unfold(B)
AB=bcirc_A*ufold_B;

% ��ԭ����ά��
C=ipermute(reshape(AB',dimC([2,1,3])),[2,1,3]);
end

