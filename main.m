% % 
% % load big_mod_data;
% % mod_data = big_mod_data;
t = 1:1:390;
numberOfDays = 88;
t1 = 144;
counter = 0;
Days = 1:1:numberOfDays;
last_itt = 1;
stringArray = [];
% figure
% plot(t, mod_data(:, 1));
minimum = min(mod_data(1:t1, Days));
smooth_data = smooth(smooth(mod_data));
smooth_data = reshape(smooth_data, 390, numberOfDays);
min_value = zeros(numberOfDays,1);
min_index = zeros(numberOfDays,1);
max_value = zeros(numberOfDays,1);
max_index = zeros(numberOfDays,1);
for  i = 1:numberOfDays
    [min_value(i), min_index(i), max_value(i), max_index(i), couldFindMin] = PillaiAlgo (mod_data(1:390, i), minimum(i));    
    if couldFindMin
        continue;
    else
        if last_itt == i - 1
            counter = counter + 1;
            if counter >= 2
                if i > 10
                    [min_index(i),min_value(i),  max_index(i), max_value(i)] = LearnStockBehavior(mod_data(:, i-10:i-1), mod_data(:,i), counter);
%                     if shouldBuy
%                         [min_value(i), min_index(i), max_value(i), max_index(i), display] = AlternativeAlgo(mod_data(:, i-10:i-1), mod_data(:,i), counter);
%                         stringArray = [stringArray, 'at ' + i + display];
%                     end
                end
            end
        else
            counter = 1;
        end
        last_itt = i;
    end         
end

ind = find (min_value);
indend = find (max_index == 390);
diff = (max_value(ind) - min_value(ind))./min_value(ind);
diff = diff * 100;
mean(diff)
posdiff = diff(find(diff > 0));
negdiff = diff(find(diff <= 0));
length(posdiff);
length(negdiff);
%%


    figure
    num = 73;
    plot(t, mod_data(1:390, num))
    y1=get(gca,'ylim');
    hold on
    plot([144 144],y1)
    sdf = min_index(num)+ceil((390-min_index(num))/exp(1));
    hold on
    plot([sdf sdf], y1)
%     
%             temp = smooth(smooth(mod_data(1:minn_index+t1, i)));
%             if( (temp(minn_index+t1) < temp(minn_index+t1 - 1)) || (temp(minn_index+t1) < temp(minn_index+t1-2)))
%                 minn_index = minn_index + 1;
%             else
%                 break;
%             end
%             
%             temp = smooth(smooth(mod_data(1:minn_index+t1, i)));
%             if( (temp(minn_index+t1) < temp(minn_index+t1 - 1)) || (temp(minn_index+t1) < temp(minn_index+t1-2)))
%                 minn_index = minn_index + 1;
%             else
%                 break;
%             end
%%
