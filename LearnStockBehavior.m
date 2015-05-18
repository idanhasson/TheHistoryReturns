% currentDay is the stock price until "t1", the observation_time_to_buy
% lastTenDays is the entire data from the last 10 days
function [ minIndex, minValue, maxIndex, maxValue] = LearnStockBehavior(lastTenDays, currentDay, streakWithoutBuying)
    minValue = 0;
    minIndex  = 0;
    maxIndex  = 0;
    maxValue = 0;
    smoothHistory = smooth(smooth(lastTenDays));
    smoothDay = smooth(currentDay);
    streakDays = smoothHistory((10-streakWithoutBuying) * 390 + 1 : length(smoothHistory));
%     trendOfStreak = find(diff(streakDays) > 0);
%     trendOfCurrentDay = find(diff(smoothDay) > 0);
%     streakFactor = 0.8;
%     currentDayFactor = 0.6;
        
%     if mean(diff(streakDays))/ abs(median(diff(streakDays))) > 1.5
%         if mean(diff(smoothDay))/ abs(median(diff(smoothDay))) > 1.5
%             cumSumDay = cumsum(diff(smoothDay));
%             cumSumHistory = cumsum(cumsum(diff(streakDays)));
            [peaksHistory, indexes] = findpeaks(cumsum(diff(streakDays)));
            peaksHistory = smooth(smooth(peaksHistory));
%             smoothpeaks = cumsum(diff(peaksHistory));
            [pospeaks, posindexes] = findpeaks(peaksHistory);
            [negpeaks, negindexes] = findpeaks(-peaksHistory);
            completeIndex = 1 :390: 390*(streakWithoutBuying-1)+1;
            completeIndex = [completeIndex, 390 * streakWithoutBuying];
            completeIndex = [completeIndex'; posindexes; negindexes];
            completeIndex = sort(completeIndex);
            completePeaks = streakDays(completeIndex);
            completeIndex = completeIndex(1:length(completeIndex)-1);
%             maxChange = max(diff(completePeaks));
            final = reshape(completeIndex, 1, length(completeIndex));
            final = [final ; reshape(diff(completePeaks), 1, length(completePeaks)-1)]; 
            final = final';
            final(:,1) = mod(final(:,1), 390);
            final = sortrows(final);
            final = [mean(final(1:streakWithoutBuying,1)), mean(final(1:streakWithoutBuying, 2));
                    final(streakWithoutBuying+1:length(final(:,1)), :)];
            sumFinal = cumsum(final(:,2));
            [maxsum ,indsum] = max(findpeaks(sumFinal));
            if maxsum
                maxsum = max([maxsum, sumFinal(length(sumFinal))]);
            else
                maxsum = sumFinal(length(sumFinal));
            end
            indsum = find(sumFinal == maxsum);
            if indsum > 1
                bestsum = final(indsum,2);
                minIndex = indsum;
                for i = 1:indsum-1;
                temp = sum(final(indsum-i:indsum, 2));
                if temp > bestsum
                   bestsum = temp;
                   minIndex = indsum-i;
                end
                end
                minValue = currentDay(minIndex);
                if indsum == length(final(:,1))
                    maxIndex = final(indsum,1);
                else
                    maxIndex = final(indsum, 1) + ceil(0.3*(final(indsum+1, 1)-final(indsum, 1)));
                end
                maxValue = currentDay(maxIndex);
                if(maxValue < minValue)                    
                    sumFinal = cumsum(final(find(final(:, 1)> maxIndex, 1):length(final(:,1)),2));
                    if isempty(sumFinal)
                        return
                    elseif length(sumFinal) <= 2 
                        maxsum = sumFinal(1);
                    else
                    maxsum = max(findpeaks(sumFinal));
                    end
                    if maxsum
                        maxsum = max([maxsum, sumFinal(1), sumFinal(length(sumFinal))]);
                    else
                        maxsum = max([sumFinal(1), sumFinal(length(sumFinal))]);
                    end
                    indsum = find(sumFinal == maxsum);
                    if indsum == length(final(:,1))
                        maxIndex = final(indsum,1);
                    else
                        maxIndex = final(indsum, 1) + ceil(0.3*(final(indsum+1, 1)-final(indsum, 1)));
                    end
                    maxValue = currentDay(maxIndex);
                end
            else
                minIndex = 1;
                minValue = currentDay(minIndex);
                if indsum == length(final(:,1))
                    maxIndex = final(indsum,1);
                else
                    maxIndex = final(indsum, 1) + ceil(0.3*(final(indsum+1, 1)-final(indsum, 1)));
                end
                maxValue = currentDay(maxIndex);
            end
           
%         end
%     end
%         if (length(trendOfStreak) >= length(streakDays) * streakFactor)
%             if(length(trendOfCurrentDay) >= length(currentDay) * currentDayFactor)
%                 shouldBuy = 1;
%             end
%         end
end
