
function [minValue, minIndex, maxValue, maxIndex, display] = AlternativeAlgo(lastTenDays, currentDay, streakWithoutBuying)
    
    minValue = currentDay(144);
    minIndex = 144;
    constant = 20;
    constant2 = 10;
    smoothHistory = smooth(smooth(lastTenDays));
    streakDays = smoothHistory((10-streakWithoutBuying) * 390 + 1 : length(smoothHistory));
    diffStreakDays = diff(streakDays);
    decreasesHistory = find(diffStreakDays < 0);
    decreasesHistory = diffStreakDays(decreasesHistory);
    meanDecHist = mean(decreasesHistory);
    medianDecHist = median(decreasesHistory);
    trendOfCurrentDay = find(diff(smoothDay) > 0);
    for i = 144:390
            smoothDay = smooth(currentDay(i-constant:i));
            diffDay = diff(smoothDay);
            decreasesDay = find(diffDay(i-constant:i) < 0);
            decreasesDay = diffDay(decreasesDay);
            length = length(decreasesDay);
            if mean(decreasesDay(length-3:length)) < meanDecHist
               maxValue = currentDay(i);
               maxIndex = i;
               display = 'mean';
               return;
            elseif mean(decreasesDay(length-3:length)) < medianDecHist
               maxValue = currentDay(i);
               maxIndex = i;
               display = 'median';
               return;
            elseif i > 390 - constant2
                if currentDay(i) > mean(currentDay(i-10:i-1))
                    maxValue = currentDay(i);
                    maxIndex = i;
                    display = 'almostend';
                    return;
                elseif i == 390
                    maxValue = currentDay(i);
                    maxIndex = i;
                    display = 'end';
                    return;
                end                
            end
    end
    
    
    
    
