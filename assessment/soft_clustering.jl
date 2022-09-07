using PyCall
py"""
import sklearn
"""
py"""
from sklearn.linear_model import LogisticRegression
"""
function get_accuracy(q, idx, labels)
    q_cut = q[idx, :]
    q_df = DataFrame(q_cut, :auto)
    q_df.pop = CategoricalArray(labels)

    py"""
    model = LogisticRegression(multi_class='multinomial', solver='lbfgs')
    X = $(q_cut)#[:, :-1]
    y = $(q_df.pop.refs .- 1)
    model.fit(X, y)
    """
    py"""
    pred = model.predict(X)
    pred 
    import numpy as np
    np.savetxt("tmp", pred)
    """
    r = reshape(Int.(readdlm("tmp")) .+ 1, :)
    count(r .== q_df.pop.refs) / length(r)
end
function get_crossentropy(q, idx, labels)
    q_cut = q[idx, :]
    q_df = DataFrame(q_cut, :auto)
    q_df.pop = CategoricalArray(labels)
    py"""
    model = LogisticRegression(multi_class='multinomial', solver='lbfgs')
    X = $(q_cut)#[:, :-1]
    y = $(q_df.pop.refs .- 1)
    model.fit(X, y)
    """
    py"""
    import numpy as np
    prob = model.predict_proba(X)
    r = sum([-np.log(prob[i, y[i]]) for i in range(len(y))])
    np.savetxt("tmp", [r])
    """
    r = readdlm("tmp")[1]
end

using JuMP
using HiGHS
function jac!(m, q1, q2; cutoff = 1e-5)
    I, K = size(q1)
    @assert size(m) == (K, K)
    @assert size(q2) == (I, K)
    @inbounds for k2 in 1:K
        for k1 in 1:K
            cnt = 0
            s = zero(eltype(m))
            for i in 1:I
                if q1[i, k1] > cutoff || q2[i, k2] > cutoff
                    cnt += 1
                    s += (q1[i, k1] - q2[i, k2]) ^ 2
                end
            end
            m[k1, k2] = 1 - sqrt(s / 2cnt)
        end
    end
    m
end
function jac(q1, q2; cutoff=1e-5)
    I, K = size(q1)
    m = Matrix{Float64}(undef, K, K)
    jac!(m, q1, q2; cutoff=cutoff)
end
function permute_q2(q1, q2; cutoff=1e-5)
    I, K = size(q1)    
    m = jac(q1, q2; cutoff=cutoff)
    model = Model(HiGHS.Optimizer)
    @variable(model, 0 <= x[1:K, 1:K] <= 1)
    @objective(
        model,
        Max,
        sum(m[i, j] * x[i, j] for i in 1:K, j in 1:K)
    )
    @constraint(model, sum(x[1:K, j] for j in 1:K) .== 1)
    @constraint(model, sum(x[i, 1:K] for i in 1:K) .== 1)
    optimize!(model)
    perm = value.(x)
    collect(transpose(perm * transpose(q2)))
end
rmse_(q1, q2) = sqrt(sum((q1 .- q2).^2)/prod(size(q1)))
