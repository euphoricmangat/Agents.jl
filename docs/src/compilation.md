# Compiling Agents.jl applications

Agents.jl models can be turned into standalone executables with
[PackageCompiler.jl](https://julialang.github.io/PackageCompiler.jl/stable/).
This is useful for distributing educational demos, classroom tools, or
GUI apps (e.g. an SIR model with `abmplot`) without requiring users to
install Julia or resolve packages themselves.

## Overview

PackageCompiler builds a Julia *sysimage* (or full app) that includes your
project code and dependencies. Cold start becomes much faster, and the
result can be shipped as a folder with a `bin/` launcher.

Expect a large footprint: a Makie-based ABM app is typically on the order of
**~2 GB** total (`lib/` + `share/` dominate). That is normal for Julia
sysimages that include plotting stacks.

## Minimal workflow

1. Put your model in a Julia package (or project) with a clear entry point.
2. Write a short *precompile execution script* that exercises the hot paths
   (create the model, call `step!` / `run!`, optionally open `abmplot`).
3. Call `create_app` (or `create_sysimage`) from PackageCompiler.

Example (adapted from community discussion in
[#1182](https://github.com/JuliaDynamics/Agents.jl/issues/1182)):

```julia
using PackageCompiler

create_app(
    "path/to/YourABMPackage",   # package root with Project.toml
    "path/to/YourABMCompiled";  # output directory
    filter_stdlibs = false,
    incremental = true,
    force = true,
    precompile_execution_file = "path/to/warmup.jl",
)
```

`warmup.jl` should import your package and run a representative simulation,
for example:

```julia
using YourABMPackage
model = YourABMPackage.initialize_model()
step!(model, 10)
# If you ship a GUI, also construct abmplot once so Makie code is traced:
# fig, ax, abmobs = abmplot(model)
```

## Practical tips for Agents.jl

- Prefer a **named package** for the model rather than a loose script, so
  PackageCompiler can resolve a proper project environment.
- Include **CairoMakie** or **GLMakie** in the project if the executable should
  plot or open interactive windows; the binary size grows accordingly.
- Keep `precompile_execution_file` close to real usage: call `add_agent!`,
  `nearby_agents`, `step!`, and any custom scheduler you rely on.
- Set `filter_stdlibs = false` when Makie / OpenGL stacks misbehave with a
  filtered sysimage (common for GUI apps).
- Test the compiled app on a clean machine (or container) that does **not**
  have your development environment loaded.

## Where this fits in the docs

This page is aimed at end users who want a distributable binary, not only
library developers. For extending Agents.jl itself, see [Developer's Docs](@ref).

## Further reading

- [PackageCompiler.jl manual](https://julialang.github.io/PackageCompiler.jl/stable/)
- Upstream discussion: [#1182](https://github.com/JuliaDynamics/Agents.jl/issues/1182),
  request for this page: [#1184](https://github.com/JuliaDynamics/Agents.jl/issues/1184)
