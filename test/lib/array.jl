using ChainRulesTestUtils
using LinearAlgebra
using Zygote: ZygoteRuleConfig

# issue 897

test_rrule(ZygoteRuleConfig(), x->sum(sin, Diagonal(x)), ones(2); rrule_f=rrule_via_ad, check_inferred=false)
test_rrule(ZygoteRuleConfig(), x->sum(sin, Diagonal(x)), rand(3); rrule_f=rrule_via_ad, check_inferred=false)

@testset "dictionary comprehension" begin
    d = Dict(1 => 5, 2 => 6)
    @test gradient(d -> sum([v^2 for (_,v) in d]), d) == (Dict(1 => 10, 2 => 12),)
end

@testset "collect dictionary" begin
    d = Dict(1 => 5, 2 => 6)
    k = 2
    i = findfirst(p -> p[1] == k, collect(d))    
    
    @test_broken gradient(d -> collect(d)[i][2], d)[1][k] == 1
    @test_broken gradient(d -> sum(v^2 for (_,v) in collect(d)), d) == (Dict(1 => 10, 2 => 12),)
end
