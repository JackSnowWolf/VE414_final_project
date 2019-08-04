module visualization
using Plots, PyPlot

function scatter_plot(x, y, name, output=false, output_path=NaN)
    scatter(x, y, label=name)
    if output
        savefig(output_path)
    end
end

function scatter3d_plot(x, y, z, file_name, view_x=35, view_y=25)

    ax = gca(projection="3d")
    fig = scatter3D(x, y, z, alpha=0.01, color=:blue)
    ax[:view_init](view_x, view_y)
    PyPlot.savefig(file_name)
end

end  # module visualization
