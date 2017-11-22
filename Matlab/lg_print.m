function lg_print(name, varargin)

if(isempty(varargin))
    printwidth=20; %7.5 or 16
    printheight=15; %7.5 or 5
        h = gcf;

else
    printwidth=varargin{1};
    printheight=varargin{2};
    if length(varargin)>= 3
        h = varargin{3};
    else
        h = gcf;
    end
end

set(h, 'PaperUnits', 'centimeters');
set(h,'Units','centimeters');
set(h, 'PaperSize', [printwidth printheight]);
set(h, 'PaperPositionMode', 'manual');
set(h, 'PaperPosition', [0 0 printwidth printheight]);
set(h.CurrentAxes,'FontSize',9)
set(findall(h,'type','text'),'FontSize',9,'FontName','Helvetica')
set(h, 'Renderer','painters');
print(h, '-dpdf', name);
