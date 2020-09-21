clear
clc
%I = imread('����ͼ��\Airplane_1.tiff'); %Jetplane
% I = imread('����ͼ��\Lake.tiff');
I = imread('����ͼ��\Lena.tiff');
% I = imread('����ͼ��\Man.tiff');
% I = imread('����ͼ��\Peppers.tiff'); 

%I = imread('����ͼ��\Airplane_0.tiff');
% I = imread('����ͼ��\Baboon.tiff');
% I = imread('����ͼ��\Tiffany.tiff');

% I = imread('����ͼ��\gpic1.tif'); %�ߴ磺512*384
% I = imread('����ͼ��\gpic2.tif'); %�ߴ磺384*512
%I = imread('����ͼ��\gpic1049.tif');%�ߴ磺384*512
origin_I = double(I); 
%% ������������������
num_D = 3000000;
rand('seed',0); %��������               
D = round(rand(1,num_D)*1); %�����ȶ������
%% ������Կ
K_en = 1; %ͼ�������Կ
K_sh = 2; %ͼ���ϴ��Կ
K_hide=3; %����Ƕ����Կ
%% ���ò���
Block_size = 4; %�ֿ��С���洢�ֿ��С�ı�������Ҫ������Ŀǰ��Ϊ4bits��
L_fix = 3; %�����������
L = 4; %��ͬ���������Ȳ���,�����޸�
%% �ճ�ͼ��ռ䲢���ܻ�ϴͼ�����������ߣ�
[ES_I,num_Of,PL_len,PL_room,total_Room] = Vacate_Encrypt(origin_I,Block_size,L_fix,L,K_en,K_sh);
%% ���غɿռ����num������²Ž�������Ƕ�루������ѹ���ռ䣩
[row,col] = size(origin_I); %����origin_I������ֵ
num = ceil(log2(row))+ceil(log2(col))+2; %��¼��ѹ���ռ��С��Ҫ�ı�����
if total_Room>=num %��Ҫnum���ؼ�¼��ѹ���ռ��С
    %% �ڼ��ܻ�ϴͼ����Ƕ�����ݣ�����Ƕ���ߣ�
    [stego_I,emD] = Data_Embed(ES_I,K_sh,K_hide,D); 
    num_emD = length(emD);
    %% ������ͼ������ȡ������Ϣ�������ߣ�
    [exD] = Data_Extract(stego_I,K_sh,K_hide,num_emD);
    %% �ָ�����ͼ�񣨽����ߣ�
    [recover_I] = Image_Recover(stego_I,K_en,K_sh);
    %% ͼ��Ա�
    figure(1);
    H=GetHis(origin_I);
    plot(0:255,H);
    area(0:255,H,'FaceColor','b')
    figure(2);
    H=GetHis(ES_I);
    plot(0:255,H);
    area(0:255,H,'FaceColor','b')
    figure(3);
    H=GetHis(stego_I);
    plot(0:255,H);
    area(0:255,H,'FaceColor','b')
    figure(4);
    subplot(141);imshow(origin_I,[]);title('ԭʼͼ��');
    subplot(142);imshow(ES_I,[]);title('����ͼ��');
    subplot(143);imshow(stego_I,[]);title('����ͼ��');
    subplot(144);imshow(recover_I,[]);title('�ָ�ͼ��');
    %% ����ͼ��Ƕ����
    [m,n] = size(origin_I);
    bpp = num_emD/(m*n);
    %% ����ж�
    check1 = isequal(emD,exD);
    check2 = isequal(origin_I,recover_I);
    if check1 == 1
        disp('��ȡ������Ƕ��������ȫ��ͬ��')
    else
        disp('Warning��������ȡ����')
    end
    if check2 == 1
        disp('�ع�ͼ����ԭʼͼ����ȫ��ͬ��')
    else
        disp('Warning��ͼ���ع�����')
    end
    %---------------������----------------%
    if check1 == 1 && check2 == 1
        disp(['Embedding capacity equal to : ' num2str(num_emD) ' bits'] )
        disp(['Embedding rate equal to : ' num2str(bpp) ' bpp'])
        fprintf(['�ò���ͼ��------------ OK','\n\n']);
    else
        fprintf(['�ò���ͼ��------------ ERROR','\n\n']);
    end  
else %��ͼ��̫���ӣ����Ԥ�����̫�࣬���¸�����Ϣ����ѹ���ռ�
    disp('������Ϣ����ѹ���ռ䣬�����޷��洢���ݣ�') 
    fprintf(['�ò���ͼ��------------ ERROR','\n\n']);
end
