import CommonSolve
using CommonSolve: step!
export step!, dummystep

"""
    step!(model::ABM)

Perform one simulation step for the `model`.
For continuous time models, this means to run to the model
up to the next event and perform that.

    step!(model::ABM, t::Real)

Step the model forwards until there is a temporal difference `≥ t`
from the current model time. I.e., step the model forwards for at least `t` time.
For discrete time models like [`StandardABM`](@ref) `t` must be integer
and evolves the model for _exactly_ `t` steps.

    step!(model::ABM, f::Function)

Step the model forwards until `f(model, t)` returns `true`,
where `t` is the current amount of time the model has been evolved
for, starting from the model's initial time.

See also [Advanced stepping](@ref advanced_stepping).
"""
function CommonSolve.step!(model::AgentBasedModel, args...)
    error(lazy"`step!` not implemented yet for model of type $(typeof(model)).")
    return model
end

# Generic functions that are used in the stepping of all types of models
# Dispatch on agent container: Dict models may remove agents; vector containers do not.
agent_not_removed(id, model::ABM) = agent_not_removed(id, model, agent_container(model))
agent_not_removed(id, model::ABM, ::AbstractDict) = hasid(model, id)
agent_not_removed(::Int, ::ABM, ::AbstractVector) = true
agent_not_removed(id, model::ABM, _) = hasid(model, id)
# this one just checks until when we should step in a `while` loop
until(t1, t0, n::Real, ::ABM) = t1 < t0 + n
until(t1, t0, f, model::ABM) = !f(model, t1 - t0)
