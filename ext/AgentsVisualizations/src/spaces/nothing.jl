# We need to implement plotting for a `nothing` space,
# so that the data collection GUI can work for it, even if there is
# nothing to plot for the space itself.
# Return an empty limit tuple so dimensionality is 0 (no blank space Axis) (#935).

Agents.space_axis_limits(::Nothing) = ()

function Agents.agentsplot!(ax, model::T, args...) where {T <: Observable{A} where {A <: ABM{<:Nothing}}}
    return nothing
end
