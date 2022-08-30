function patches=img2patches(data,width_of_patches)
% data��һ�������ͼ��
%width_of_patches��ÿ����Ŀ��
%patches��һ������ÿ�б�ʾһ��patch
%data�����ܹ�����width
%Authors WANG ZHI YUAN


[rows,cols,bands]=size(data);
num_of_rows=rows/width_of_patches;
num_of_cols=cols/width_of_patches;
idx_of_rows=((1:num_of_rows)-1)*width_of_patches;
idx_of_cols=((1:num_of_rows)-1)*width_of_patches;
patches=zeros(num_of_rows*num_of_cols,power(width_of_patches,2)*bands);

id_patches=1;
for i=1:width_of_patches
    for j=1:width_of_patches
        patchOnePixel=data(idx_of_rows+i,idx_of_cols+j,:);
        patchOnePixel=reshape(patchOnePixel,num_of_cols*num_of_rows,bands);
        patches(:,id_patches:id_patches+bands-1)=patchOnePixel;
        id_patches=id_patches+bands;
    end
end














end