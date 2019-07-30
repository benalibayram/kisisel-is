function deneyciz

% bu deneyde Null ve 4 ï¿½eï¿½it uyaran var fakat uyaranlarï¿½n hepsi iki farklï¿½
% ï¿½ekilde kodlanmï¿½ï¿½ yani 4 uyaranï¿½n farklï¿½ rengi ve yï¿½ksekliï¿½i var ve aynï¿½
% renkte ve yï¿½kseklikte olup ï¿½erï¿½eve ï¿½izgisi daha kalï¿½n 4 tane daha var.

col(1,:) = [.5 .5 .5];
col(2,:) = [1 0 0];
col(3,:) = [0 1 0];
col(4,:) = [0 0 1];
col(5,:) = [1 0 1];
col(6,:) = [1 0 0];
col(7,:) = [0 1 0];
col(8,:) = [0 0 1];
col(9,:) = [1 0 1];
hght = [1 2 3 4 5 2 3 4 5];
linew = [1 3 3 3 3 1 1 1 1];
LegendNames = {'NULL','Event 1','Event 2','Event 3','Event 4'};

[file,path] = uigetfile('*.par','Par dosyalarýný seçiniz!','','MultiSelect','on');
if isequal(file,0)
    return
end

dosyalar = fullfile(path,file);
if ~isa(dosyalar,'cell')
    dosyalar = {dosyalar};
end
[~, maxindexim] = size(dosyalar);
indexim = 1;

legend_typs = [];
[x, dur, typ]=veriguncelle(dosyalar{indexim});

Fig1H = figure('Units', 'normalized', 'Position', [0, .7, 1, .2],   'Name', 'Deney Deseni');

ButtonL=uicontrol('Parent',Fig1H,'Style','pushbutton','String','Önceki','Units','normalized','Position',[0.90 0.2 0.02 0.2],'Visible','on','Callback', @oncekine);
ButtonR=uicontrol('Parent',Fig1H,'Style','pushbutton','String','Sonraki','Units','normalized','Position',[0.93 0.2 0.02 0.2],'Visible','on','Callback', @sonrakine);
TextN=uicontrol('Parent',Fig1H,'Style','text','Units','normalized','Position',[0.90 0.4 0.05 0.2],'Visible','on');
[~,dosya_ismi,~] = fileparts(dosyalar{indexim});
TextN.String = sprintf('%d/%d:\n%s',indexim,maxindexim,dosya_ismi);
axis off
cizsene(gca)

    function [x, dur, typ, nams]=veriguncelle(dosya)
        a = fopen(dosya);
        c = textscan(a,'%f %u %f %*f %s');
        fclose(a);
        
        x = c{1};
        dur = c{3};
        typ = c{2} + 1;
    end

    function cizsene(ax)
        for i = 1:length(x)
            patch(ax,'vertices',[x(i), 0; (x(i)+dur(i)), 0; (x(i)+dur(i)), hght(typ(i)); x(i), hght(typ(i))],...
                'faces', [1, 2, 3, 4],...
                'FaceColor', col(typ(i),:),...
                'LineWidth', linew(typ(i)),...
                'FaceAlpha',.4)
        end
        legend_typs = unique(typ);
        %if 
        [~,h_legend] = legend(LegendNames,'Position',[0.05 0.1 0.05 0.8],'Units','normalized');
        PatchInLegend = findobj(h_legend, 'type', 'patch');
        for i=1:length(LegendNames)
            set(PatchInLegend(i), 'FaceColor', col(legend_typs(i),:), 'FaceAlpha', 0.4);
        end
        legend('boxoff')
        %legend({'cos(x)','cos(2x)','cos(3x)','cos(4x)'},'NumColumns',2)
    end

    function oncekine(source,event)
        if  indexim > 1
            indexim = indexim - 1;
            % Update interface
            [~,dosya_ismi,~] = fileparts(dosyalar{indexim});
            TextN.String = sprintf('%d/%d:\n%s',indexim,maxindexim,dosya_ismi);
            [x, dur, typ]=veriguncelle(dosyalar{indexim});
            cla
            cizsene(gca)
        end
    end

    function sonrakine(source,event)
        if  indexim < maxindexim
            indexim = indexim + 1;
            % Update interface
            [~,dosya_ismi,~] = fileparts(dosyalar{indexim});
            TextN.String = sprintf('%d/%d:\n%s',indexim,maxindexim,dosya_ismi);
            [x, dur, typ]=veriguncelle(dosyalar{indexim});
            cla
            cizsene(gca)
        end
    end

end