function [minValue, minIndex, maxValue, maxIndex, couldFindMin] = PillaiAlgo(DailyStockValues, minimumValue)
    t1 = 144;
    minutesPerDay = 390;
    couldFindMin = 0;
    minValue = 0;
    minIndex = 0;
    maxValue = 0;
    maxIndex = 0;
    smooth_data = smooth(smooth(DailyStockValues));
    temp_index1 = find(DailyStockValues(t1+1:minutesPerDay)<= minimumValue ,1);
    if temp_index1
        while temp_index1 + t1 < minutesPerDay - 1
            if ((smooth_data (temp_index1+t1) < smooth_data(temp_index1+t1-1))|| smooth_data (temp_index1+t1) < smooth_data (temp_index1+t1-2))
               temp_index1 = temp_index1 + 1; 
           else
               break;
           end
        end        
        if (temp_index1 + t1 >= minutesPerDay - 1)
            return
        end
        minValue = DailyStockValues(t1+temp_index1);
        minIndex = temp_index1+t1;
        t2 = ceil((minutesPerDay-minIndex)/exp(1))+minIndex;
        maximumValue = max (DailyStockValues(minIndex+1:t2));
        tempIndex2 = find(DailyStockValues(t2+1:minutesPerDay)>= maximumValue,1);
        if tempIndex2
            while tempIndex2 + t2 < minutesPerDay - 1
                if ((smooth_data (tempIndex2+t2) > smooth_data(tempIndex2+t2-1))|| smooth_data (tempIndex2+t2) > smooth_data (tempIndex2+t2-2))
                   tempIndex2 = tempIndex2 + 1; 
                else
                   break;
                end
            end
            maxValue = DailyStockValues(t2+tempIndex2);
            maxIndex = tempIndex2+t2;
        else
            for j = 1:10
                space = minutesPerDay-t2-1;
                x1 = ceil(t2+(j-1)/10*space+1);
                x2 = ceil(t2+j/10*space+1);
                tempIndex2 = find(DailyStockValues(x1:x2) >= ((1 - j/10)*(maximumValue-minValue)+minValue),1);
                if tempIndex2
                    maxValue = DailyStockValues(x1-1 + tempIndex2);
                    maxIndex = tempIndex2+x1-1;
                    break;
                end
                if j == 10
                    maxValue = DailyStockValues(minutesPerDay);
                    maxIndex = minutesPerDay;
                end
            end
        end
        couldFindMin = 1;
    end

end
