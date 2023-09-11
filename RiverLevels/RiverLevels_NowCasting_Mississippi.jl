using ArchGDAL
using GeoInterface
using Pkg
Pkg.test("ArchGDAL")

sqrt(131)

waterWaysFolder = "J:/Cai_data/Waterways/"
waterWaysPath = waterWaysFolder * "USwaterways.gdb"
using ArchGDAL
ArchGDAL.registerdrivers() do
   ArchGDAL.read(waterWaysPath) do  waterWaysDb
   end
end
print(waterWaysDb)

    # Drop the Z and M coordinates using the GeoInterface package
using GeoInterface
waterWaysDb_noM = GeoInterface.dropzm(waterWaysDb)

# Print the first row of the data
println(waterWaysDb_noM[1])


using ArchGDAL 
waterWaysFolder = “J:\\Cai_data\Waterways\\”
waterWaysPath = joinpath(waterWaysFolder, “USwaterways.gdb”)
ArchGDAL.registerdrivers() do waterWaysDb = ArchGDAL.read(waterWaysPath) # Your code to manipulate the waterWaysDb object goes here end


using Shapefile

waterWaysFolder = "J:\\Cai_data\\Waterways\\"
waterWaysPath = joinpath(waterWaysFolder, "waterways_2023-08-01.gpkg")
waterWaysDb = Shapefile.read(waterWaysPath)

waterWaysDb_noM = Shapefile.st_zm(waterWaysDb, drop = true, what = "ZM")
waterWaysDb_noM[1,:]
