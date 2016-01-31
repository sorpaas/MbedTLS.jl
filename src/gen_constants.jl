include_dir = joinpath(homedir(), ".julia/v0.4/MbedTLS/deps/src/mbedtls-2.1.0/include/mbedtls")
headers = filter(x->splitext(x)[2]==".h", readdir(include_dir))
r=r"#define (\w+)\s+(-?(0x)?[\dA-F]+)"

c = Dict{ASCIIString, Cint}()

for header in headers
    s=readall(joinpath(include_dir, header))
    for m in eachmatch(r, s)
        c[m.captures[1]] = parse(Cint, m.captures[2])
    end
end

outfile = joinpath(dirname(@__FILE__), "constants.jl")

open(outfile, "w") do f
    today = Dates.today()
    date = join([Dates.day(today), Dates.month(today), Dates.year(today)], "/")
    println(f, "# Auto-generated by gen_constants.jl on $date")
    for (key,val) in c
        println(f, "const $key=$val")
    end
end
