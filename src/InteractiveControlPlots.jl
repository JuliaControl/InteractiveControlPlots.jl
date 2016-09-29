module InteractiveControlPlots

using ControlSystems, GtkInteract, Immerse
import Colors, Reactive, Measures, Compose

export bode_immerse, nyquist_immerse, pzmap_immerse, timeplot_immerse
export labelf, null_theme
export example_minimal, example_fo_sys


# package code goes here
include("framework.jl")
include("plots.jl")

examples = ["minimal", "fo_sys"]
for ex in examples
    funcname = Symbol("example_$(ex)")
    @eval begin
        function $funcname()
          pdir = joinpath(Pkg.dir("InteractiveControlPlots"),"src")
          include(joinpath(Pkg.dir("InteractiveControlPlots"),"src/examples/"*$ex*".jl"))
        end
    end
end
# function example_minimal()
#     include(joinpath(pdir,"examples/minimal.jl"))
# end
# function example_fo_sys()
#     include(joinpath(pdir,"examples/fo_sys.jl"))
# end


end # module
