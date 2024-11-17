function OutResults(Archive)
    Archive_costs=GetCosts(Archive);
    Archive_posi=GetPosition(Archive);
    
    disp("Optimal_solution X[1:" + num2str(size(Archive_posi, 1)) + "]")
    disp(num2str(Archive_posi'));
    disp("")
    disp("Optimal_cost Y[1:" + num2str(size(Archive_costs, 1)) + "]");
    disp(num2str(Archive_costs'));
    
    if(size(Archive_costs, 1 ) == 2)
        y1 = Archive_costs(1, :);
        y2 = Archive_costs(2, :);
        scatter(y1, y2, 100, 'b', 'filled');
        xlabel('Object 1'); ylabel('Object 2');
        title('Pareto Front');
    end
    
    if(size(Archive_costs, 1) == 3)
        y1 = Archive_costs(1, :); 
        y2 = Archive_costs(2, :);
        y3 = Archive_costs(3, :);
        scatter3(y1, y2, y3, 100, 'b', 'filled');
        xlabel('Object 1'); ylabel('Object 2'); zlabel('Object 3');
        title('Pareto Front');
    end
    
    if(size(Archive_costs, 1) == 4)
        y1 = Archive_costs(1, :); 
        y2 = Archive_costs(2, :);
        y3 = Archive_costs(3, :);
        y4 = Archive_costs(4, :);
        scatter3(y1, y2, y3, 100, y4, 'filled');
        cbar  = colorbar;
        cbar.Title.String = 'Object 4'; % Thêm tiêu đề cho colorbar
        xlabel('Object 1'); ylabel('Object 2'); zlabel('Object 3');
        title('Pareto Front');
    end
    
    if(size(Archive_costs, 1) == 5)
        y1 = Archive_costs(1, :); 
        y2 = Archive_costs(2, :);
        y3 = Archive_costs(3, :);
        y4 = Archive_costs(4, :);
        y5 = Archive_costs(5, :);
        scatter3(y1, y2, y3, y5, y4, 'filled');
        cbar  = colorbar;
        cbar.Title.String = 'Object 4'; % Thêm tiêu đề cho colorbar
        xlabel('Object 1'); ylabel('Object 2'); zlabel('Object 3');
        title('Pareto Front');
    end
    
end