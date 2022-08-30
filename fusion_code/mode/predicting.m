
clear;
clc;
load("dic_parameters.mat");

model_parameter.lambda_m=0.6;
%获取一些模型参数
r=model_parameter.r;
rmax=model_parameter.rmax;
maxIP=model_parameter.maxIP;
mu=model_parameter.mu;
lambda_s=model_parameter.lambda_s;
lambda_x=model_parameter.lambda_x;
lambda_y=model_parameter.lambda_y;
lambda_m=model_parameter.lambda_m;
beta_x=model_parameter.beta_x;
beta_y=model_parameter.beta_y;
beta_w=model_parameter.beta_w;
ksi=model_parameter.ksi;
filename_of_HSR_t1= 'L7SR.05-24-01.r-g-nir.tif';
filename_of_LSR_t1='MOD09GHK.05-24-01.r-g-nir.tif';
filename_of_LSR_t2="MOD09GHK.07-11-01.r-g-nir.tif";

HSR_t1=imread(filename_of_HSR_t1);
LSR_t1=imread(filename_of_LSR_t1);
LSR_t2=imread(filename_of_LSR_t2);
%初始化HSR_T2
HSR_t2=LSR_t2;
%计算HSR_DI21和LSR_DI21
LSR_DI21=LSR_t2-LSR_t1;

%Xs存储输出的NSCT
Xs={};
for k=1:model_parameter.K
   
    if isempty(Dxs{k})
        Xs{k}=[];
        continue;
    end
    
    Y=construct_NSCT(LSR_DI21,model_parameter.width_of_patch,label_of_HSR_DI31,k);  
    %初始化B
    B=initB(Y,Dys{k},model_parameter.lambda_y);
    A=t_product(Ws{k},B);
    X=t_product(Dxs{k},A);
    W=Ws{k};
    D_x=Dxs{k};
    D_y=Dys{k};
    M=Ms{k};
    A2=A;B3=B;B4=B;
    V2=zeros(size(B));U3=zeros(size(B));U4=zeros(size(B));
    while i<model_parameter.maxIP
        %更新A和B
        s_1=mu.*(A2+V2)+lambda_s.*(t_product(W,B4)); %分子
        s_1=s_1./(mu+lambda_s);
        s_2=lambda_x/(2*(mu+lambda_s));
        A=soft(s_1,s_2);
        ss_1=mu.*(B3+B4+U3+U4)./(2*mu);
        ss_2=lambda_y/(4*mu);
        B=soft(ss_1,ss_2);
        
        %更新A2,B3,B4
        dig_Dx=tensor2bdiag_DFT(D_x);
        n_eye=size(dig_Dx,2);
        p1=transpose(dig_Dx)*dig_Dx+mu*eye(n_eye,n_eye);
        p2=transpose(dig_Dx)*tensor2bdiag_DFT(X)+mu*(tensor2bdiag_DFT(A)-tensor2bdiag_DFT(V2));
        dig_A2=pinv(p1)*p2;
        [rows_t,cols_t,bands_t]=size(A2);
        A2=bdiag_DFT2tensor(dig_A2,rows_t,cols_t,bands_t);           %更新A2

        dig_Dy=tensor2bdiag_DFT(D_y);
        n_eye=size(dig_Dy,2);
        p1=transpose(dig_Dy)*dig_Dy+mu*eye(n_eye,n_eye);
        p2=transpose(dig_Dy)*tensor2bdiag_DFT(Y)+mu*(tensor2bdiag_DFT(B)-tensor2bdiag_DFT(U3));
        dig_B3=pinv(p1)*p2;  
        [rows_t,cols_t,bands_t]=size(B3);
        B3=bdiag_DFT2tensor(dig_B3,rows_t,cols_t,bands_t);           %更新B3

        dig_W=tensor2bdiag_DFT(W);
        n_eye=size(dig_W,2);
        p1=lambda_s*transpose(dig_W)*dig_W+mu*eye(n_eye,n_eye);
        p2=lambda_s*transpose(dig_W)*tensor2bdiag_DFT(A)+mu*(tensor2bdiag_DFT(B)-tensor2bdiag_DFT(U4));
        dig_B4=pinv(p1)*p2;
        [rows_t,cols_t,bands_t]=size(B4);
        B4=bdiag_DFT2tensor(dig_B4,rows_t,cols_t,bands_t);           %更新B4
        
        if isempty(Ms{k})
            %不可映射块
            X=t_product(D_x,A2);
            
        else
            %可映射块??????
            [~,y_m]=construct_X_y(X,Y);
            p1=( eye(size(M,2))+lambda_m*transpose(M)*M );
            O=t_product(D_x,A2);
           
            %沿模式1矩阵化O
            [O_1,~]=construct_X_y(O,O);
            p2=O_1+lambda_m*transpose(M)*y_m;
            X_m=inv(p1)*p2;
            X=x_m2NSCT(X_m,size(X,1),size(X,2),size(X,3));
        end
        
        V2=V2-(A-A2);
        U3=U3-(B-B3);
        U4=U4-(B-B4);
        
        i=i+1;
    end
        
    Xs{k}=real(X);
    
end
save("predicting.mat");
%%
%将NSCT还原为图像

HSR_DI21=NSCTs2img(Xs,label_of_HSR_DI31,model_parameter.width_of_patch,model_parameter.K);
HSR_t2_1=double(HSR_t1)+HSR_DI21;

output=real(HSR_t2_1);

output=uint16(HSR_t2_1);

imwrite(output,"output.tif");













