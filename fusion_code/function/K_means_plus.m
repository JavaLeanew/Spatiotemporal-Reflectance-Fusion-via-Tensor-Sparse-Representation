function [new_class_label, Central_Position]=K_means_plus(data,k,change_threshold,iteration)
%dataΪ����ͼ������
%kΪ������cluster��
% change_threshold�仯��ֵ
%iterationΪ��������
%Authors WANG ZHI YUAN

[samples,arrtibutes]=size(data);
old_seed=zeros(k,arrtibutes);
new_seed=zeros(k,arrtibutes);

%%
%�洢���ĵ�
index_record=zeros(1,k);
%�����ʼ����һ����
index_1=round(rand()*samples);
index_record(1)=index_1;


old_seed(1,:)=data(index_1,:);
%ʹ��k-means++��������ʣ���k-1���е�
for i=2:k
    dist=zeros(samples,1);
    for p=1:samples
        point=data(p,:);
        d=realmax;
        for j=1:i-1
             temp_dist=point-data(index_record(j),:);
             temp_dist=dot(temp_dist,temp_dist);
             d=min(d,temp_dist);
        end
        dist(p)=d;
    end
    [~,posion]=max(dist);
    index_record(i)=posion;
    old_seed(i,:)=data(posion);

end



%%
%������е�����������ηֱ��������µõ�����Ԫ��Ŀ�仯��change_threshold�ڣ�����Ϊ������ϡ�
n=1;
new_class_label=zeros(samples,1);
while true
    distance_matrix=zeros(samples,k);
    for kind=1:k
        tmp=data-old_seed(kind,:);
        tmp=dot(tmp,tmp,2);
        %ÿ����Ԫ���ʼ7��������ĵ�ŷʽ����
        ou_distance=sqrt(tmp);
        distance_matrix(:,kind)=ou_distance;
    end
    %�������ֵ����ע
    for i=1:samples
        currentpixel_vector=distance_matrix(i,:);
        [~, index_of_value]=min(currentpixel_vector);
        currentpixel_class=index_of_value;
        new_class_label(i,1)=currentpixel_class;
    end
    
    %�����µ����е�
    
    for i=1:k
        id=new_class_label==i;
        temp1=data(id,:);
        new_seed(i,:)=mean(temp1);
    end
    
    Central_Position=new_seed;
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
    
        