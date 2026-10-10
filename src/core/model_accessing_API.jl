# Container-type dispatch helpers.
# Prefer `agent_container(model)` over hardcoding concrete ABM types
# (StandardABM / EventQueueABM / …), so custom `AgentBasedModel`s with Dict/Vector
# containers get the same `nextid` / `maxid` behavior. See #1218.
agent_container_type(model::ABM) = typeof(agent_container(model))

nextid(model::ABM) = nextid(model, agent_container(model))
nextid(model::ABM, ::AbstractDict) = getfield(model, :maxid)[] + 1
nextid(model::ABM, ::AbstractVector) = nagents(model) + 1
nextid(model::ABM, _) = notimplemented(model)

hasid(model::ABM, id::Int) = hasid(model, id, agent_container(model))
hasid(model::ABM, id::Int, ::AbstractDict) = haskey(agent_container(model), id)
hasid(model::ABM, id::Int, ::AbstractVector) = id ≤ nagents(model)
hasid(model::ABM, id::Int, _) = haskey(agent_container(model), id)

function add_agent_to_container!(agent::AbstractAgent, container::AbstractDict)
    return if haskey(container, getid(agent))
        error(lazy"Can't add agent to container. There is already an agent with id=$(getid(agent))")
    else
        container[getid(agent)] = agent
    end
end

function add_agent_to_container!(agent::AbstractAgent, container::AbstractVector)
    getid(agent) != length(container) + 1 && error(lazy"Cannot add agent of ID $(getid(agent)) in a vector container of $(length(container)) agents. Expected ID == $(length(container)+1).")
    return push!(container, agent)
end

function add_agent_to_container!(agent::AbstractAgent, model::ABM)
    add_agent_to_container!(agent, agent_container(model))
    update_maxid_after_add!(model, agent, agent_container(model))
    return
end

function update_maxid_after_add!(model::ABM, agent, ::AbstractDict)
    maxid = getfield(model, :maxid)
    if maxid[] < getid(agent)
        maxid[] = getid(agent)
    end
    return
end
update_maxid_after_add!(::ABM, agent, ::AbstractVector) = nothing
update_maxid_after_add!(::ABM, agent, _) = nothing

# This is extended for event based models
extra_actions_after_add!(agent, model::StandardABM) = nothing
function extra_actions_after_add!(agent, model::EventQueueABM{S, A, <:Union{AbstractDict, AbstractVector}} where {S, A})
    return getfield(model, :autogenerate_on_add) && add_event!(agent, model)
end
function extra_actions_after_add!(agent, model::EventQueueABM{S, A, <:StructVector} where {S, A})
    return getfield(model, :autogenerate_on_add) && add_event!(model[getid(agent)], model)
end
extra_actions_after_add!(agent, model::ReinforcementLearningABM) = nothing

function remove_agent_from_container!(agent::AbstractAgent, model::ABM)
    return remove_agent_from_container!(agent, model, agent_container(model))
end
function remove_agent_from_container!(agent::AbstractAgent, model::ABM, ::AbstractDict)
    delete!(agent_container(model), getid(agent))
    return
end
function remove_agent_from_container!(agent::AbstractAgent, model::ABM, ::AbstractVector)
    error("Cannot remove agents in a model with a vector container.")
end
remove_agent_from_container!(agent::AbstractAgent, model::ABM, _) = notimplemented(model)

# Internal utility for retrieving agents by id from a container
retrieve_agent(container::StructVector, id::Int, ::Type{A}) where {A} = AgentWrapperSoA{A}(container, id)
retrieve_agent(container, id::Int, ::Type) = container[id]

# Dict containers: sampling a Dict yields a pair; vector/other use `allids`.
random_id(model::ABM) = random_id(model, agent_container(model))
random_id(model::ABM, ::AbstractDict) = rand(abmrng(model), agent_container(model)).first
random_id(model::ABM, _) = rand(abmrng(model), allids(model))

getid(agent) = agent.id
