### A Pluto.jl notebook ###
# v0.14.5

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ b080f1dc-bfc1-11eb-2f40-6d4c5cd5414b
begin
    import Pkg
	
    Pkg.activate(mktempdir())
    Pkg.add([
        Pkg.PackageSpec(name="Plots", version="1"),
		Pkg.PackageSpec(name="PlutoUI", version="0.7"),
		Pkg.PackageSpec(name="Latexify", version="0.15"),
		Pkg.PackageSpec(name="LaTeXStrings", version="1.2.1")	
    ])
	
    using Plots, PlutoUI, LinearAlgebra, LaTeXStrings, Latexify
end

# ╔═╡ 67fdf0d7-9daf-4dbf-9327-08cd6a58e3eb
TableOfContents()

# ╔═╡ 9264cab9-bf00-467c-9450-2e679e073864
md"""
# TA Workshop
## Orthogonal diagonalization
"""

# ╔═╡ b2a687fa-0e65-4a47-ac49-e5156601a077
md"""
`` O^{t} `` $(@bind flagDiagOrthoT CheckBox())
`` A `` $(@bind flagDiagSym CheckBox())
`` O `` $(@bind flagDiagOrtho CheckBox())
``\quad  D = O^{t}AO `` $(@bind flagDiag CheckBox())
`` \quad O `` $(@bind flagDecompOrtho CheckBox())
`` D `` $(@bind flagDecompDiag CheckBox())
`` O^{t} `` $(@bind flagDecompOrthoT CheckBox())
"""

# ╔═╡ 63ceee16-08b1-4497-80c4-09fa76c0431b
md"""
Initial ``\theta``: $(@bind iniTheta Slider(0:0.01:2pi; default=0, show_value=true)) ``\quad`` axis-limits $(@bind xyLimit NumberField(4:1:8; default=4)) 
"""

# ╔═╡ 7e135382-94a6-4f7b-aa5a-e6880a71151b
md"## misc"

# ╔═╡ 76494497-b59f-4f32-8199-c77988b08127
md"
``\begin{bmatrix} a & b \\ b & a \end{bmatrix}`` $(@bind flagAB CheckBox()) 
``\quad a=`` $(@bind a Slider(-10:0.2:10; default=2, show_value=true))
``\quad b=`` $(@bind b Slider(-10:0.2:10; default=1, show_value=true))
"

# ╔═╡ 9de9aaeb-9c75-48e4-b282-58bc3c20c1ce
begin
	if ! flagAB
		targetMat = [2 1; 1 2];
	else
		targetMat = [a b; b a];
	end
	println("")
end

# ╔═╡ d3ea1207-ccd0-4347-b9f1-c3802719b802
# generate vectors
begin
	ortho, diagVec, = svd(Symmetric(targetMat))
	orthoT = ortho'
	# ortho = [1/sqrt(2) 1/sqrt(2); -1/sqrt(2) 1/sqrt(2)]
	orthoDiag = [orthoT, targetMat, ortho] # ortho diag tuple
	diagMat = diagm(diagVec)
	orthoDecomp = [ortho, diagMat, orthoT] # ortho decomp tuple
	
	initialFrame = [cos(iniTheta) sin(-iniTheta);
					sin(iniTheta) cos(iniTheta)]
	mapsArr = [orthoDiag..., diagMat, orthoDecomp..., initialFrame]
	flagMaps = [flagDiagOrthoT, flagDiagSym, flagDiagOrtho, 
		flagDiag, 
		flagDecompOrtho, flagDecompDiag, flagDecompOrthoT, 
		true]
	mapToApply = prod(mapsArr[flagMaps])
	
	println("")
end

# ╔═╡ a124edce-00b6-478c-bba6-d3fb7193acb5
(A = latexify(targetMat; env=:inline), 
	O = latexify(ortho; env=:inline), D = latexify(diagMat; env=:inline))

# ╔═╡ dac68b1e-2510-4f4e-a536-8f4cd5f82f87
md"""
``A =``  $(latexify(targetMat; env=:inline)) 

`` O =`` $(latexify(ortho; env=:inline)) 

``D =`` $(latexify(diagMat; env=:inline))
"""

# ╔═╡ d106c542-6ce6-4be8-a74a-062f277f3b1e
function plot_2dframe(matVec, xyLimit=4)
	"""
	Description: plot two vectors with grid in plane.
	Input: mat of column vectors
	Output: the desired plot
	"""
	
	vecBlue = matVec[:,1]
	vecRed = matVec[:,2]
	
	# canvas settings
	# plot-canvas
	sizeCanvas=500
	# xyLimit=4
	# grid
	numGridLines = 50
	lengthGridLines = 50
	alphaGridLines = 0.2
	# slider
	stepLengthVec=1
	numStepLengths=xyLimit
	# initialize the canvas
	gridPlot = plot((0, 0);
					leg=false,
					showaxis=false,
					grid=false,
					xlims=(-xyLimit, xyLimit),
					ylims=(-xyLimit, xyLimit),
					size=(sizeCanvas, sizeCanvas)
					)
	
	# plot the grid
	lengthVec = [-lengthGridLines, lengthGridLines]
	for i in -numGridLines:numGridLines
		plot!(gridPlot,
			lengthVec .* vecBlue[1] .+ i * vecRed[1],
			lengthVec .* vecBlue[2] .+ i * vecRed[2];
			ls=:dash,
			alpha=alphaGridLines,
			color=:blue)
		
		plot!(gridPlot,
			lengthVec .* vecRed[1] .+ i * vecBlue[1],
			lengthVec .* vecRed[2] .+ i * vecBlue[2];
			ls=:dash,
			alpha=alphaGridLines,
			color=:red)
	end
	
	# plot the vectors
	plot!(gridPlot, [0, vecBlue[1]], [0, vecBlue[2]]; arrow=true, color=:blue)
	plot!(gridPlot, [0, vecRed[1]], [0, vecRed[2]]; arrow=true, color=:red)
	
	return gridPlot
end

# ╔═╡ 5a595519-bf2f-43c9-a6d9-f371e615d491
plot_2dframe(mapToApply, xyLimit)

# ╔═╡ Cell order:
# ╟─b080f1dc-bfc1-11eb-2f40-6d4c5cd5414b
# ╟─67fdf0d7-9daf-4dbf-9327-08cd6a58e3eb
# ╟─9264cab9-bf00-467c-9450-2e679e073864
# ╟─5a595519-bf2f-43c9-a6d9-f371e615d491
# ╟─b2a687fa-0e65-4a47-ac49-e5156601a077
# ╟─a124edce-00b6-478c-bba6-d3fb7193acb5
# ╠═dac68b1e-2510-4f4e-a536-8f4cd5f82f87
# ╟─9de9aaeb-9c75-48e4-b282-58bc3c20c1ce
# ╟─63ceee16-08b1-4497-80c4-09fa76c0431b
# ╟─7e135382-94a6-4f7b-aa5a-e6880a71151b
# ╟─76494497-b59f-4f32-8199-c77988b08127
# ╟─d3ea1207-ccd0-4347-b9f1-c3802719b802
# ╟─d106c542-6ce6-4be8-a74a-062f277f3b1e
