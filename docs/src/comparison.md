# ABM Framework Comparison
Many agent-based modeling frameworks have been constructed to ease the process of building and analyzing ABMs (see [here](http://dx.doi.org/10.1016/j.cosrev.2017.03.001) for a review).
Notable examples are [NetLogo](https://ccl.northwestern.edu/netlogo/), [Repast](https://repast.github.io/index.html), [MASON](https://journals.sagepub.com/doi/10.1177/0037549705058073), and [Mesa](https://github.com/projectmesa/mesa).

In the [ABM_Framework_Comparisons](https://github.com/JuliaDynamics/ABM_Framework_Comparisons) repository we compare Agents.jl with many other popular alternatives, to assess where Agents.jl excels and also may need some future improvement.

The results are characterised in two ways: how long it took each model to perform the same scenario (initial conditions, grid size, run length etc. are the same across all frameworks), and how many lines of code (LOC) it took to describe each model and its dynamics. We use this result as a metric to represent the complexity of learning and working with a framework.

Time taken is presented in normalised units, measured against the runtime of Agents.jl. In other words: the results can only vary slightly from the ones presented here with a different hardware.

For LOC, we use the following convention: code is formatted using standard practices & linting for the associated language. Documentation strings and in-line comments (residing on lines of their own) are discarded, as well as any benchmark infrastructure. NetLogo is assigned two values since its files have a code base section and an encoding of the GUI. Since many parameters live in the GUI, we must take this into account. Thus `375 (785)` in a NetLogo count means 375 lines in the code section, 785 lines total in the file. An additional complication to this value in NetLogo is that it stores plotting information (colours, shapes, sizes) as agent properties, and as such the number outside of the bracket may be slightly inflated.

The latest results are available at the `README.md` of the [ABM_Framework_Comparisons](https://github.com/JuliaDynamics/ABM_Framework_Comparisons) repository, where you can also find inside each model subfolder a `DECLARATION.md` file with the details on the parameters used for each comparison.

In the majority of cases, Agents.jl's performance is exceptional whilst using the least amount of code. This removes many frustrating barriers-to-entry for new users, and streamlines the development process for established ones.

## Table-based comparison

In our [paper discussing Agents.jl](https://arxiv.org/abs/2101.10072), we compiled a comparison over a large list of features and metrics from the four frameworks discussed above.
The tables below transcribe that comparison into Markdown (versions as in the paper: Agents.jl 4.2, Mesa 0.8, NetLogo 6.2, Mason 20.0).
For up-to-date **runtime / LOC** benchmarks, prefer the live tables in [ABM_Framework_Comparisons](https://github.com/JuliaDynamics/ABM_Framework_Comparisons).

**Legend (paper colouring):** class leader / particularly strong · good · basic / partial · poor / none.

### Spaces, models, and ecosystem

| Category | Agents.jl 4.2 | Mesa 0.8 | NetLogo 6.2 | Mason 20.0 |
| --- | --- | --- | --- | --- |
| Continuous space | Yes | Yes | Yes | Yes |
| Graph space | Yes (mutable) | Unidirectional only | Link agents (not a space) | Networks (not a space) |
| Grid space | Yes | Yes (+ hexagonal) | Yes | Yes (+ hexagonal, triangular) |
| OpenStreetMap space | Yes | No | No | No |
| Dimensionality | Any | 2D | 2D & 3D (separate apps) | 2D & 3D (3D install complex) |
| License | MIT | Apache-2.0 | GPL-2.0 | Academic Free License |
| Mixed-agent models | Yes | Yes | Yes | Yes |
| Simulation termination | After `n` steps or user boolean | Explicit user loop | Manual / `stop` | Schedule empty / finish fn |
| Parameter types | Anything | Anything | Limited (Float64, lists, …) | Anything |
| Same language for modeling & analysis | Yes (Julia) | Yes (Python) | No | Yes (Java; console/GUI focus) |
| Max memory | Hardware limits | Hardware limits | ~1 GB JVM (expandable) | ~1 GB JVM (expandable) |
| Distributed computing | Yes | No (multithread batch only) | No (multithread BehaviorSpace) | Yes |
| Interop with external libraries | Strong (Python/R/C/…) | Strong (Python ecosystem) | Partial (extensions API) | Partial (no simple user API) |
| Language ecosystem integration | By design (DiffEq, optim, …) | Any Python tools | Complex (plugins) | Discouraged vs custom types |
| Browser-based online execution | No | No | Yes (NetLogo Web) | No |
| Data collection | Flexible (map / aggregate / filter) | Aggregate (limited conditionals) | Bool/number/string/lists | Inspectors / checkpointing |

### API, utilities, and subjective properties

| Category | Agents.jl 4.2 | Mesa 0.8 | NetLogo 6.2 | Mason 20.0 |
| --- | --- | --- | --- | --- |
| Scheduling | Flexible (property, type, filtered, random, custom, …) | As added / random / staged | Custom | Custom |
| Nearest neighbors | Same API all spaces; custom ranges | All spaces | Graphs + grid/continuous neighbourhoods | Cardinal / radial (limited 3D continuous) |
| Adding agents to space | Position / random / random empty / fill | Position / random empty | Specified position | Specified position |
| Autocreate agents from attributes | Yes | No | Yes | No |
| Moving agents | Unified API (+ planned routes) | Unified API | Position (turtles) | Position (+ GUI drag) |
| Removing agents | Individual / all / by predicate | Individual / all | Individual / all / by predicate | Individual / all |
| Random distributions | Any | Any | Normal, Poisson, Exp, Gamma | Uniform, Gaussian |
| Agent sample & replacement | Yes | No | No | No |
| GIS data | No (at paper time) | No | GIS extension | GeoMason |
| Parameter scanning | Yes | Yes | Yes | Yes |
| New space types API | Yes | No | No | No |
| Advanced continuous-space API | Yes | No | No | No |
| Path-finding | Yes | No | No | No |
| Low-level data collection API | Yes | No | Yes | Checkpoint-oriented |
| GUI for simulation setup | No | User-built | Yes | User-built |
| Ease of installation | Julia + one package command | Python + one package command | One-click JRE + jar | Complex (esp. Java3D) |
| Documentation quality | Tutorials + many executable examples | Tutorial; weaker space docs | Extensive but split sites | Long PDF; hard to navigate |
| Model code complexity | Simple | Moderate | Simple | High |
| Visualization complexity | Simple API (~5 LOC) | Simple plot / complex interaction | Simple | Complex API |

!!! note
    Framework capabilities evolve. Treat the Markdown tables as a faithful reading of the published comparison rather than a live scoreboard; check each project’s current docs for new features (for example GIS or browser tooling added after the paper).
