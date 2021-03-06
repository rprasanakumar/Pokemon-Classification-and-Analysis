
function id =  CPdetect(img,letter_templates)
%img = imread('016_CP10_HP10_SD200_5622_8.jpg');
% if size(img,3)==3 
%    gray_img = min(img,[],3);
% end
% % bw_img = imbinarize(gray_img);
% % bw = bwareaopen(bw_img,50);
% % se = strel('disk',1);
% % bw = imclose(bw,se);
% % bw = imfill(bw,'holes');
% [x1,y1] = size(gray_img);
% %image =bw((x1/100:x1/8),(y1/10:y1/1.2));
% image =gray_img((x1/100:x1/5),(y1/10:y1/1.2));
% [r_image c_image] = size(image);
% for rol= 1:r_image
%     for col= 1:c_image
%         if image(rol,col)<150
%             image(rol,col)=0;
%         else
%             image(rol,col)=255;
%         end
%     end
% end
% image = bwareaopen(image,50);

if size(img,3)==3 
   gray_img = min(img,[],3);
else
    gray_img = img;
end
gray_img = imresize(gray_img, [1000 2000]);
%imshow(gray_img);
%pause(3)
%bw_img = imbinarize(gray_img);
[x1,y1] = size(gray_img);
%image =gray_img((x1/30:x1/8),(y1/10:y1/1.2));
%image =gray_img((x1/30:x1/8),(y1/3:y1/1.6));CP
%image =gray_img((x1/30:x1/8),(y1/3:y1/1.6));
%image =gray_img((x1/30:x1/2),(y1/3:y1/1.6));CP
image =gray_img((x1/30:x1/8),(y1/3:y1/1.6));
%  bw = bwareaopen(image,5);
%  se = strel('disk',1);
%  bw = imclose(bw,se);
%  bw = imfill(bw,'holes');
[r_image c_image] = size(image);
for rol= 1:r_image
    for col= 1:c_image
        if image(rol,col)<180
            image(rol,col)=0;
        end
    end
end
bw = bwareaopen(image,50);
%bw = bwareaopen(image,20);
%imshow(bw);
%pause(3)
% to find the correct number after cp in the cropped Image
found_chars =[];
iteration =0;
first_line1 ='';
final_str ='';
while 1
    num_chars_here = 0;
    cropped_image_line = getnonzerocomponents(bw);
        % finding the total size of the character size
        line_size = size(cropped_image_line,1);
        for i=1:line_size
            sum_char_line = sum(cropped_image_line(i,:));
            if sum_char_line ==0
                first_line = cropped_image_line(1:i-1,:);
                 first_line1 = getnonzerocomponents(first_line);
                 rest_line = cropped_image_line(i:end,:);
                 rest_line1 = getnonzerocomponents(rest_line);
                 break;
            else
                first_line1=cropped_image_line;rest_line1=[ ];
            end
        end
        if isempty(first_line1)
            break;
        end
    cropped_image=first_line1;
    while 1
           num_chars_here= num_chars_here+1;
        % getting the non zero element from the cropped image
        cropped_image = getnonzerocomponents(cropped_image);
        % finding the total size of the character size
        char_size = size(cropped_image,2);
        for i=1:char_size
            sum_char = sum(cropped_image(:,i));
            if sum_char ==0
                first_char = cropped_image(:,1:i-1);
                 first_char1 = getnonzerocomponents(first_char);
                 rest_char = cropped_image(:,i:end);
                 rest_char1 = getnonzerocomponents(rest_char);
                 break;
            else
                first_char1=cropped_image;rest_char1=[ ];
            end
        end
        current_char2 = imresize(first_char1,[42 24]);
        %imshow(current_char2);
        %pause(8)
        cropped_image = rest_char1;
        
         total_tem_char = size(letter_templates,2);
     mat_chars =[];
     for it = 1:total_tem_char
         mat_char = corr2(letter_templates{1,it},current_char2) ;
         mat_chars=[mat_chars mat_char];
     end
     idx = find(mat_chars==max(mat_chars));

         if idx == 1
         character_matched = 'C';
        
         elseif idx == 2
         character_matched = 'C';
         elseif idx == 3
         character_matched = 'C';
          elseif idx == 4
         character_matched = 'H';
         elseif idx == 5
         character_matched = 'P';
         
         elseif idx == 6
         character_matched = 'P';
         
         elseif idx == 7
         character_matched = 'P';
         elseif idx == 8
         character_matched = '/';         
          elseif idx == 9
         character_matched = '1';
         elseif idx == 10
         character_matched = '1';
           elseif idx == 11
         character_matched = '2';
             elseif idx == 12
         character_matched = '2';
             elseif idx == 13
         character_matched = '3';
             elseif idx == 14
         character_matched = '4';
             elseif idx == 15
         character_matched = '4';
             elseif idx == 16
         character_matched = '5';
             elseif idx == 17
         character_matched = '5';
             elseif idx == 18
         character_matched = '6';
         elseif idx == 19
         character_matched = '6';
         
         elseif idx == 20
         character_matched = '7';
         elseif idx == 21
         character_matched = '8';
          elseif idx == 22
         character_matched = '8';
         
          elseif idx == 23
         character_matched = '9';
         
          elseif idx == 24
         character_matched = '9';
         
          elseif idx == 25
         character_matched = '0';
           elseif idx == 26
         character_matched = 'H';
         elseif idx == 27
         character_matched = 'E';
         elseif idx == 28
         character_matched = 'E';
         elseif idx == 29
         character_matched = '00';
         else
         character_matched = ' ';
       end
    found_chars=[found_chars character_matched];
     if isempty(rest_char1)
            break;
     end
    end
    if (isempty(rest_line1)) || (~isempty(findstr(found_chars,'C')) && ~isempty(findstr(found_chars,'P')))  || iteration>10000 
            final_str = found_chars;
            break;
    end
    found_chars=[];
    bw = rest_line1;
    iteration=iteration+1;
end

if isempty((final_str)) || isempty(findstr(final_str,'CP'))
    final_str='CP1541';
    
end
% idx_cp =findstr(final_str,'CP');
% id_now =final_str((idx_cp(1)+2) :end)
% id_numr =[];
% for str =1:size(id_now,2)
%     if findstr(id_now(1,str),'0987654321')>1
%         id_numr = [id_numr id_now(1,str)]
%     end
% end
% id =str2num((id_numr));
idx_cp =findstr(final_str,'CP');
%number= final_str((idx_cp(1)+2) :end)
%id =str2num(final_str((idx_cp(1)+2) :end));

id_now =final_str((idx_cp(1)+2) :end);
id_numr =[];
for str =1:size(id_now,2)
    if findstr(id_now(1,str),'0987654321')>0
        id_numr = [id_numr id_now(1,str)];
    end
end
if isempty(id_numr)
    id_numr='222';
end
id =str2num((id_numr));


function im = getnonzerocomponents(com)
    [row col] = find(com);
    im = com(min(row):max(row),min(col):max(col));
