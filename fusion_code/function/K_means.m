function [new_class_label]=K_means(data,k,change_threshold,iteration)
%dataΪ����ͼ������
%kΪ������cluster��
% change_threshold�仯��ֵ
%iterationΪ��������
[lines,columns,bands]=size(data);
tfl=lines*columns;
dat=zeros(tfl,bands);
for i=1:bands
    dat(:,i)=reshape(data(:,:,i),tfl,1);
end

old_seed=zeros(k,bands);
new_seed=zeros(k,bands);
%����k�����������Ϊң��ͼ������������Ԫ
index_record=zeros(1,k);
for i=1:k
    index_i=round(rand()*tfl);
    judge=find(index_record==index_i, 1);
    if isempty(judge)==0
        i=i-1;
        continue;
    end
    index_record(i)=index_i;
    %����ȡ�õ����ֵ��Ӧͼ������к�
    column_of_index_i=ceil(index_i/lines);
    line_of_index_i=index_i-(column_of_index_i-1)*lines;
    %�洢������Ԫ��b������ֵ
    old_seed(i,:)=data(line_of_index_i,column_of_index_i);
end

%������е�����������ηֱ��������µõ�����Ԫ��Ŀ�仯��change_threshold�ڣ�����Ϊ������ϡ�
n=1;
new_class_label=zeros(lines,columns);
while n
    distance_matrix=zeros(lines,columns);
    for kind=1:k
        sum=0;
        for i=1:bands
            temp=power(data(:,:,i)-old_seed(kind,i),2);
            sum=sum+temp;
        end
        %ÿ����Ԫ���ʼ7��������ĵ�ŷʽ����
        ou_distance=sqrt(sum);
        distance_matrix(:,:,kind)=ou_distance;
    end
    %�������ֵ����ע
    for i=1:lines
        for j=1:columns
            currentpixel_vector=distance_matrix(i,j,:);
            currentpixel_class=find(currentpixel_vector==min(currentpixel_vector));
            new_class_label(i,j)=currentpixel_class(1);
        end
    end
    %�����µ����е�
    for i=1:k
        id=find(new_class_label==i);
        for j=1:bands
            temp1=data(:,:,j);
            temp2=temp1(id);
            new_seed(i,j)=mean(temp2(:));
        end
    end
    %����ÿ��������ظ���
    new_class_pixcel_number=zeros(1,k);
    for i=1:k
        new_class_pixcel_number(i)=length(find(new_class_label(:)==i));
    end
    %change_threshold:0.05
    if n==1
        old_class_pixcel_number=ones(1,k);
    end
    if max(abs(new_class_pixcel_number-old_class_pixcel_number)./old_class_pixcel_number)<change_threshold || n>=iteration
        break;
    else
        old_class_pixcel_number=new_class_pixcel_number;
        old_seed=new_seed;
    end
    n=n+1;
end
    
        