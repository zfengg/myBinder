### A Pluto.jl notebook ###
# v0.14.8

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

# ╔═╡ 3e9a26b6-6c83-44d1-9149-a31476b98d91
begin
	
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add(["Plots", "PlutoUI"])

	using LinearAlgebra, Plots, PlutoUI
	
end

# ╔═╡ 7d9c6d18-8e11-437e-ac37-cd9331ef9fa7
numPts = 10000

# ╔═╡ 4be229d2-b16e-4518-aa97-615ae81a2c8c
md"""
`` x_{0} = `` $( @bind x0 Slider(-5:0.01:5; default=0, show_value=true) ) ``\quad``
`` y_{0} = `` $( @bind y0 Slider(0.01:0.01:5; default=1, show_value=true) ) 
"""

# ╔═╡ 2cea8a10-eebd-11eb-188f-6fce5b7d49d6
z0 = Complex(x0, y0)

# ╔═╡ 7d36894d-6316-4fc7-b858-04495b3924ca
Θ = range(0, 2pi; length=numPts)

# ╔═╡ 8fb883e5-6d2e-4f10-bb97-26e2f69427d3
h(z, θ) = (cos(θ) * z - sin(θ)) / (sin(θ) * z + cos(θ))

# ╔═╡ 93123a52-96d1-4b35-af08-d3012075c43a
orbit = h.(z0, Θ)

# ╔═╡ 15179e25-a558-47ee-a29c-3e8595c74cf1
begin
	fig_orb = plot(orbit; 
		label="orbit",
		xlims=(-2, 2),
		ylims=(0, 5),
		size=(750, 600))
	# plot!(fig_orb, z0)
	scatter!(fig_orb, (real(z0), imag(z0)), label="ini. pt")
end

# ╔═╡ Cell order:
# ╟─3e9a26b6-6c83-44d1-9149-a31476b98d91
# ╟─15179e25-a558-47ee-a29c-3e8595c74cf1
# ╟─4be229d2-b16e-4518-aa97-615ae81a2c8c
# ╟─2cea8a10-eebd-11eb-188f-6fce5b7d49d6
# ╟─7d36894d-6316-4fc7-b858-04495b3924ca
# ╟─8fb883e5-6d2e-4f10-bb97-26e2f69427d3
# ╟─7d9c6d18-8e11-437e-ac37-cd9331ef9fa7
# ╟─93123a52-96d1-4b35-af08-d3012075c43a
