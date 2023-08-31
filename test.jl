using BenchmarkTools
using DataFrames
using DelimitedFiles
using CSV
using XLSX

C = CSV.read("C:/Users/arik/Documents/Github/JuliaAndBigData/programminglanguages.csv", DataFrame)
@show typeof(C)

@btime C = CSV.read("C:/Users/arik/Documents/Github/JuliaAndBigData/programminglanguages.csv", DataFrame; header=true);
@btime P,H = readdlm("C:/Users/arik/Documents/Github/JuliaAndBigData/programminglanguages.csv", ','; header=true);

first(C, 5)
println("number of rows: $size(C)[1]")

CSV.write("C:/Users/arik/Documents/Github/JuliaAndBigData/programminglanguages_ed.csv", C)

T = XLSX.readxlsx("J:/Cai_data/TCFD/locations/ITC_Dec2022/temp_out_1.xlsx")#, # file name
T = XLSX.readtable("J:/Cai_data/TCFD/locations/ITC_Dec2022/temp_out_1.xlsx", "temp_out_1") # sheet name
T = XLSX.readdata("J:/Cai_data/TCFD/locations/ITC_Dec2022/temp_out_1.xlsx", "temp_out_1", "A1:D100") # cell range

T
typeof(T)
DataFrame(T[1], T[2])
T[2]
T[1][1]

D = DataFrame(T...)

foods = ["apple", "cucumber", "tomato", "banana"]
calories = [105, 47, 22, 105]
prices = [0.85, 1.6, 0.8, 0.6]
dataframe_calories = DataFrame(item=foods, calories=calories)
dataframe_prices = DataFrame(item=foods, price=prices)

DF = rightjoin(dataframe_calories, dataframe_prices, on=:item)

DataFrames.eachcol(DF)
XLSX.writetable("writefile_using_XLSX2___.xlsx", DataFrames.eachcol(DF), DataFrames.names(DF))
XLSX.writetable("writefile_using_XLSX2__.xlsx", collect(DataFrames.eachcol(DF)), DataFrames.names(DF))

# importing data from a diff programming language
Pkg.add("JLD")
Pkg.add("RData")
Pkg.add("RCall")
using JLD
using RCall
using RData