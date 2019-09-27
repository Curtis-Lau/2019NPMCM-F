%
function dij_out = Dijkstra3(graph_in,graph_in2,para,type,start,tmp,start_temp,type2)
%% parameter
    max_value=inf;
    alpha1=para(1);
    alpha2=para(2);
    beta1=para(3);
    beta2=para(4);
    theta=para(5);
    deta=para(6);
    dij_out.path=[];
    N=size(graph_in,1);
    SQ=ones(1,N);%S���Ϻ�Q����,0->S,1->Q
    SQ(start)=0;
    w=max_value*ones(1,N);
    w(start)=0;
    path_last=zeros(1,N);%����ǰ��
    path_last(start)=start;
    errh=zeros(1,N);%У�������
    errv=zeros(1,N);
    errh2=zeros(1,N);%У��ǰ���
    errv2=zeros(1,N);
    errh(start)=tmp(1);
    errv(start)=tmp(2);
    errh2(start)=tmp(3);
    errv2(start)=tmp(4);
    %% iter
    ii=start;
    while sum(SQ)>0&&ii~=N
        errhtmp=zeros(1,N);
        errvtmp=zeros(1,N);
        errhtmp2=zeros(1,N);
        errvtmp2=zeros(1,N);
        errflag=zeros(1,N);
        for jj=1:N
            if graph_in(ii,jj)==max_value||jj==ii||SQ(jj)==0%û��·�����S�У�����
                continue;
            end
            w_temp=w(ii)+graph_in(ii,jj);
            errhtmp(jj)=errh(ii)+graph_in(ii,jj)*deta;
            errvtmp(jj)=errv(ii)+graph_in(ii,jj)*deta;
            errhtmp2(jj)=errhtmp(jj);
            errvtmp2(jj)=errvtmp(jj);
            if type(jj)==0%h
                if errvtmp(jj)<beta1&&errhtmp(jj)<beta2
%                     errhtmp(jj)=0;
                     if type2(jj)==1
                         errhtmp(jj)=min([errhtmp(jj),5]); 
                      %% �ڶ���ͼ��
%                          if rand<0.3%�ڶ���ͼ
%                             errhtmp(jj)=0; 
%                          end
                     else
                         errhtmp(jj)=0; 
                     end
                end
            elseif type(jj)==1%v
                 if errvtmp(jj)<alpha1&&errhtmp(jj)<alpha2
%                     errvtmp(jj)=0;
                     if type2(jj)==1
                         errvtmp(jj)=min([errvtmp(jj),5]);
                      %% �ڶ���ͼ��
%                          if rand<0.3%�ڶ���ͼ
%                              errvtmp(jj)=0; 
%                          end
                     else
                         errvtmp(jj)=0; 
                     end
                 end
            end
            flag=0;%1->�����Գ���
            if errvtmp(jj)<theta&&errhtmp(jj)<theta
                flag=1;
            end
            if(w_temp< w(jj))&&flag==1%����Ȩ�غ�ǰ��
                w(jj)=w_temp;
                errh(jj)=errhtmp(jj);
                errv(jj)=errvtmp(jj);
                errh2(jj)=errhtmp2(jj);
                errv2(jj)=errvtmp2(jj);
                path_last(jj)=ii;
            end
            if flag==0
                 errflag(jj)=1;
            end
        end
        min_temp=max_value;
        min_pos=N;
        for kk=1:N        
            if SQ(kk)==1&&min_temp>w(kk)&&errflag(kk)==0
                min_pos=kk;
                min_temp=w(kk);
            end
        end
        SQ(min_pos)=0;%���¼���
        ii=min_pos;
    end
    dij_out.w=w;
    dij_out.path_last=path_last;
    %% 
%% ����δ�ҵ�N
min_pos=start;
min_v=max_value;

%% �����ʸ��� ��������
flag=0;
% for ii=1:N
%     if  path_last(ii)~=0&&min_v>graph_in2(ii,N)&&sum(graph_in(ii,:)~=inf)>5&&sum(start_temp==ii)==0&&type2(ii)~=1%ͼ1
% %     if  path_last(ii)~=0&&((errh(ii)==0&&errv(ii)<5)||(errv(ii)==0&&errh(ii)<5))&&sum(start_temp==ii)==0&&sum(graph_in(ii,:)~=inf)>1
%         disp('33')
%         min_v=graph_in2(ii,N);
%         min_pos=ii;
%         flag=1;
%     end
% end

%%

if flag==0
min_pos=start;
min_v=max_value;
   for ii=1:N
    if  path_last(ii)~=0&&min_v>graph_in2(ii,N)&&errh(ii)<5&&errv(ii)<5&&sum(graph_in(ii,:)~=inf)>5&&sum(start_temp==ii)==0%ͼ1
        min_v=graph_in2(ii,N);
        min_pos=ii;
        flag=1;
    end
   end
end
if flag==0
    min_pos=start;
    min_v=max_value;
   for ii=1:N
    if path_last(ii)~=0&&min_v>graph_in2(ii,N)&&sum(start_temp==ii)==0&&errh(ii)<15&&errv(ii)<15
        min_v=graph_in2(ii,N);
        min_pos=ii;
        flag=1;
    end
   end 
end
if flag==0
    disp('error')
end
stop=min_pos;
    path=path_last(stop);
    while path(1)~=start
        path=[path_last(path(1)),path];
    end
    path=[path,stop];
    dij_out.path=path;
    %У��ǰ���
    dij_out.err.h=errh2(path);%horizontal
    dij_out.err.v=errv2(path);%vertical
    dij_out.stop=stop;
    dij_out.errend=[errh(path(end)),errv(path(end))];%У�������
end

