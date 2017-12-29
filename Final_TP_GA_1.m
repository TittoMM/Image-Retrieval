%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Selecting the input query images
% **********************************% 

[p,f]=uigetfile('*jpg;*.bmp;*.tif;*.png');

% converting to gray scale image
% *****************************%

tic
I=imread([f p]);
J=rgb2gray(I);
load('dfac.mat')

% displaying the gary scale image and original image
% *************************************************%

subplot(2,1,1);
imshow(I);
title('Original Image');
subplot(2,1,2);
imshow(J);
title('Gray scale image');

% Preprocessing Stage (using filters)
% **********************************%

H = fspecial('unsharp',1.0); %// unsharp contrast enhancement filter//%
S = imfilter(J,H,'replicate'); %imfilter is more memory efficient than
                               % some other filtering operations in that it outputs an array of the same data type as the input image array.//%
% subplot(5,5,1); imshow(I); 
% title('Input Image Query');

%Shape Feature Extraction
%************************%
Ibw = im2bw(J);
CC = bwconncomp(J);
L = labelmatrix(CC);
%L2 = bwlabel(Ibw);
stat = regionprops(L,'area','eccentricity','Eulernumber','convexArea','perimeter','orientation');

% Texture feature extraction
%***************************%

[pixelCount,GLs] = imhist(J);
numberOfPixels = sum(pixelCount);
meanGL = sum(GLs .* pixelCount) / numberOfPixels;
varianceGL = sum((GLs - meanGL) .^ 2 .* pixelCount) / (numberOfPixels-1);
sd = sqrt(varianceGL);
kurtosis = sum((GLs - meanGL) .^ 4 .* pixelCount) / ((numberOfPixels - 1) * sd^4);
skew = sum((GLs - meanGL) .^ 3 .* pixelCount) / ((numberOfPixels - 1) * sd^3);

%features of query image
%***********************%

fq1 = [stat];
% c = struct2cell(s)
numb_array_query = struct2cell(fq1);
r = transpose(numb_array_query);
s2 = cell2mat(r);
fq = [meanGL varianceGL kurtosis skew s2];
% for m=1:10
%     if dec1(m)=='0'
%         fq(m)=0;
%     end
% end


%similarity measurement using Euclidian distance%
%***********************************************%

de=[];
for t = 1:989
%     m{t} = cell2mat(dfac(t));%coverting cell to matrix
    de = [de;sqrt(sum((fq-dfac(t,:)).^2))];%euclidian distance measurement
end 

f = de(:);%Taking transpose of the matrix 'd'
[ord1,ind1]=sortrows(f);

 
%Displaying the most relevant retrieved images%
%*********************************************%
ne=0;
ind=ind1(1:12);
way_1 = 'D:\MATLAB\Projects\Bel\Database';
folder_num = dir(way_1);
             for j=1:12
                 
                   data=imread([way_1 '\' folder_num(ind(j)).name]);
                   figure,imshow(data);
%                    if ind(j)<197 && ind(j)>296
%                        ne=ne+1;
%                    end
             end
% ne = input('Enter the number of misclassifications if more than 5 are misclassified'); 
% f = -(k*log(10)+ne*log(988));
% fc=[fc f];
% n=[n ne];
% close all;
% end
% 
% %%%%%%%% next GA iteration %%%%%%%
% 
% dk=[];
% el=[];
% [fc1,I]=sort(fc,'descend');
% for b=1:10
%     dec_ch=dec_chrom((I(b)*10-9:I(b)*10));
%     dk=[dk;dec_ch];
% end
% dk1=dk';
% cross_point=6;
% dk2=dk1(1:10);
% dk3=dk1(11:20);
% ex1=dk2(cross_point:10);
% ex2=dk2(1:cross_point-1);
% ex3=dk3(cross_point:10);
% ex4=dk3(1:cross_point-1);
% new_dk2=[ex2 ex3];
% new_dk3=[ex4 ex1];
% new_GA=[dk2;dk3;new_dk2;new_dk3];
% 
% dk4=dk1(21:30);
% dk5=dk1(31:40);
% ex4=dk4(cross_point:10);
% ex5=dk4(1:cross_point-1);
% ex6=dk5(cross_point:10);
% ex7=dk5(1:cross_point-1);
% new_dk4=[ex5 ex6];
% new_dk5=[ex7 ex4];
% new_GA=[new_GA;new_dk4;new_dk5];
% 
% dk6=dk1(31:40);
% dk7=dk1(41:50);
% ex8=dk6(cross_point:10);
% ex9=dk6(1:cross_point-1);
% ex10=dk7(cross_point:10);
% ex11=dk7(1:cross_point-1);
% new_dk6=[ex8 ex9];
% new_dk7=[ex10 ex7];
% new_GA=[new_GA;new_dk6;new_dk7];
% 
% dk8=dk1(41:50);
% dk9=dk1(51:60);
% ex12=dk8(cross_point:10);
% ex13=dk8(1:cross_point-1);
% ex14=dk9(cross_point:10);
% ex15=dk9(1:cross_point-1);
% new_dk8=[ex13 ex14];
% new_dk9=[ex15 ex12];
% new_GA=[new_GA;new_dk8;new_dk];
% new_GA1=new_GA';
% end;