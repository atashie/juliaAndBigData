using Pkg
Pkg.add("ArchGDAL")
Pkg.add("GeoInterface")
using ArchGDAL
using GeoInterface

using Pkg
Pkg.update("GDAL")
Pkg.update("GeoInterface")
Pkg.update("Colors")
Pkg.update("GPKG")
Pkg.add("Types")
Pkg.update("Operations")
Pkg.update("ArchGDAL")
Pkg.test("GeoInterface")
Pkg.test("GDAL")
Pkg.test("ArchGDAL")

using Pkg
Pkg.rm(GDAL) # remove GDAL from your Project.toml
pkg"add ArchGDAL; add GDAL"

sqrt(131)


using ArchGDAL

# Register all known drivers
GDAL.allregister()

pp = ArchGDAL.read("C:/Users/18033/Documents/CaiData/geospatialFiles/BasinATLAS_Data_v10/BasinATLAS_v10.gdb")
gg = ArchGDAL.read("C:/Users/18033/Documents/CaiData/geospatialFiles/Waterways.gdb")
#ArchGDAL.write(pp, "C:/Users/18033/Documents/CaiData/geospatialFiles/BasinATLAS_Data_v10/BasinATLAS_v10_test.gdb")

print(pp)
print(gg)

waterWaysFolder = "C:/Users/18033/Documents/CaiData/geospatialFiles/BasinATLAS_Data_v10/"#J:/Cai_data/Waterways/"
waterWaysPath = waterWaysFolder * "BasinATLAS_Data_v10.gdb"#"USwaterways.gdb"
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
