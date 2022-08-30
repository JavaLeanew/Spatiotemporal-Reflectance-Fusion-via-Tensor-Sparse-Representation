function NSCT_of_clusteri=construct_NSCT(data,width_of_patch,labels,cluster_i)
%dataΪԭʼ���������
%width_of_patchΪpatch�Ŀ��
%labelsΪ2ά������ǰ��ά������data��С��ͬ
%Authors WANG ZHI YUAN

[rows,cols,bands]=size(data);
id_rows=1:width_of_patch:rows;
id_cols=1:width_of_patch:cols;
%���ڻ�ȡͬһ���mask
mask=labels(id_rows,id_cols)==cluster_i;
%g�����NSCT�ķǾֲ�ά�ȴ�С
n_rows=length(find(mask==1));
%ע���NSCT�Ľṹ��NSCT(i,:,:)��һ��bands�У���rows*cols)�еľ���ÿ�б�ʾһ�����صĹ���ֵ
NSCT_of_clusteri=zeros(n_rows,width_of_patch*width_of_patch,bands);
%����NSCT
m=1;
 for i=1:size(mask,1)
    for j=1:size(mask,2)
        if mask(i,j)==1
            id_row=id_rows(i);
            id_col=id_cols(j);
            cube=data(id_row:id_row+width_of_patch-1,id_col:id_col+width_of_patch-1,:);
            NSCT_of_clusteri(m,:,:)=reshape(cube,width_of_patch*width_of_patch,[]);
            m=m+1;
        end      
    end      
end

end