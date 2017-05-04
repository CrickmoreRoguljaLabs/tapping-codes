%%
im = zeros(128,128,100,5);
im(:,:,:,1) = A;
im(:,:,:,2) = B;
im(:,:,:,3) = C;
im(:,:,:,4) = D;
im(:,:,:,5) = E;

spacing = 30;
time = ((1:100)' - 25) * 0.256;
time_mat = repmat(time, [1 5]);

for i = 2 : 5
    time_mat(:,i) = time_mat(:,i-1) + spacing;
end

time_mat2 = time_mat([1:24, 28:100],:);
intensityvec_roi2 = intensityvec_roi([1:24, 28:100],:);
intensityvec_background2 = intensityvec_background([1:24, 28:100],:);

time_mat2(end+1, :) = NaN;
intensityvec_roi2(end+1, :) = NaN;
intensityvec_background2(end+1, :) = NaN;

intensityvec_roi_n = intensityvec_roi2(:)/intensityvec_roi2(24);
intensityvec_background_n = intensityvec_background2(:)/intensityvec_background2(24);
timevec = time_mat2(:);

index_mat = reshape(1:490, [98 5]);
index_mat(28:100,:) = index_mat(25:97,:);
index_mat(25:27,:) = repmat(index_mat(24,:),[3,1]);
%%
loc = 'C:\Users\steph\OneDrive\Documents\MATLAB\GitHub\Lab\tapping codes\output\';

hfig = figure('Position',[50 50 900 700],'color', [1 1 1]);

im0 = double(median(A(:,:,18:23),3));

counter = 1;
for ii = 1 : 5
    for i = 1 : 100

        subplot(2,2,1)
        fig1 = imagesc(im(:,:,i,ii),[0 400]);
        text1 = text(3, 120, ['Session: ', num2str(ii), ', Time: ', num2str((i-25)*0.256), ' sec'], 'Color', [1 1 1]);
        set(gca,'xtick',[])
        set(gca,'ytick',[])
        xlabel('Raw data (F)')
        colorbar

        subplot(2,2,2)
        fig2 = imagesc(im(:,:,i,ii) ./ im0,[0 4]);
        text2 = text(3, 120, ['Session: ', num2str(ii), ', Time: ', num2str((i-25)*0.256), ' sec'], 'Color', [1 1 1]);
        set(gca,'xtick',[])
        set(gca,'ytick',[])
        xlabel('Normalized data (F/F_0)')
        colorbar


        timeend = index_mat(i,ii);

        subplot(2,2,3:4)
        plot(timevec(1:timeend), [intensityvec_roi_n(1:timeend),intensityvec_background_n(1:timeend)])
        hold on

        if ii > 1
            for j = 1 : (ii-1)
                plot([spacing spacing] * (j-1), [3 3.2], 'r')
                text(spacing * (j-1) + 2, 3.1, 'Pulse')
            end
        end
        
        if i >= 25
            plot([spacing spacing] * (ii-1), [3 3.2], 'r')
            text(spacing * (ii-1) + 2, 3.1, 'Pulse')
        end

        hold off

        xlim([-10 145])
        ylim([0.8 4])
        set(gca,'xtick',[])
        set(gca,'ytick',[1 2 3 4])
        ylabel('GCaMP6s fluorescence (F/F_0)')
        xlabel('Time')

        legend({'P1';'Background'})
        
               
        if counter < 10
            saveas(hfig, [loc,'00', num2str(counter),'.tif'],'tif')
        elseif counter < 100
            saveas(hfig, [loc, '0', num2str(counter),'.tif'],'tif')
        else
            saveas(hfig, [loc, num2str(counter),'.tif'],'tif')
        end
        
        counter = counter + 1;
   end
end