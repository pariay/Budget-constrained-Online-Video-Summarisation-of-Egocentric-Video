function features  = extract_ColorLayout(img, blocks)

% This function extract one of descriptors of the standard MPEG-7,
% called Color Layout.
%
% The extraction process of this color descriptor consists of four stages:
% 1 - Image partitioning :RGB2Lab , then divided into 64 blocks
% 2 - Representative color selection : the standard recommends the use of
%                              the average of the pixel colors in a block
% 3 - DCT transformation : 64 DCT coefficients
% 4 - Zigzag scanning
% 
% INPUTS:
%      img : image in RGB
%      blocks : number of the desired partions (in total). e.g, 64
% OUTPUT:
%      features : extracted color layout feature


% Paria Yousefi 11/05/2018
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------

d = size(img);
if d(3) == 3
    img = im2double(img);
    blocks = round(sqrt(blocks)); 
    row = round(linspace(1,d(1),blocks+1));
    col = round(linspace(1,d(2),blocks+1));
    img_new = zeros(blocks,blocks,d(3));
    for i=1:blocks
        for j = 1:blocks
            partImg = img(row(i):row(i+1)-1,col(j):col(j+1)-1,:);
            img_new(i,j,:) = partion_img(partImg);
        end
    end
    features = CLDdescriptors(img_new);
end
end

%%
function img_new = partion_img(I)
Ilab = rgb2lab(I);
L = Ilab(:,:,1);
A = Ilab(:,:,2);
B = Ilab(:,:,3);
img_new = zeros(1,1,3);
img_new(:,:,1) = mean(L(:));
img_new(:,:,2) = mean(A(:));
img_new(:,:,3) = mean(B(:));
end

%%
function features = CLDdescriptors(I)
% DCT 64 coefficients
f = @(block)dct2(block.data);
zL = zigzag(blockproc(I(:,:,1),[8 8],f));
zA = zigzag(blockproc(I(:,:,2),[8 8],f));
zB = zigzag(blockproc(I(:,:,2),[8 8],f));

features = [zL zA zB];
end

%%
% Zigzag scan of a matrix
% Argument is a two-dimensional matrix of any size,
% not strictly a square one.
% Function returns a 1-by-(m*n) array,
% where m and n are sizes of an input matrix,
% consisting of its items scanned by a zigzag method.
%
% Alexey S. Sokolov a.k.a. nICKEL, Moscow, Russia
% June 2007
% alex.nickel@gmail.com

function output = zigzag(in)

% initializing the variables
%----------------------------------
h = 1;
v = 1;

vmin = 1;
hmin = 1;

vmax = size(in, 1);
hmax = size(in, 2);

i = 1;

output = zeros(1, vmax * hmax);
%----------------------------------

while ((v <= vmax) & (h <= hmax))
    
    if (mod(h + v, 2) == 0)                 % going up
        
        if (v == vmin)
            output(i) = in(v, h);        % if we got to the first line
            
            if (h == hmax)
                v = v + 1;
            else
                h = h + 1;
            end
            
            i = i + 1;
            
        elseif ((h == hmax) & (v < vmax))   % if we got to the last column
            output(i) = in(v, h);
            v = v + 1;
            i = i + 1;
            
        elseif ((v > vmin) & (h < hmax))    % all other cases
            output(i) = in(v, h);
            v = v - 1;
            h = h + 1;
            i = i + 1;
        end
        
    else                                    % going down
        
        if ((v == vmax) & (h <= hmax))       % if we got to the last line
            output(i) = in(v, h);
            h = h + 1;
            i = i + 1;
            
        elseif (h == hmin)                   % if we got to the first column
            output(i) = in(v, h);
            
            if (v == vmax)
                h = h + 1;
            else
                v = v + 1;
            end
            
            i = i + 1;
            
        elseif ((v < vmax) & (h > hmin))     % all other cases
            output(i) = in(v, h);
            v = v + 1;
            h = h - 1;
            i = i + 1;
        end
        
    end
    
    if ((v == vmax) & (h == hmax))          % bottom right element
        output(i) = in(v, h);
        break
    end
    
end
end