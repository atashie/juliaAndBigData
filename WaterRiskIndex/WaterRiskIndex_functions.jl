########################
# Section 0: Customer data
using CSV
using DataFrames
ncFileLoc = "J:/Cai_data/WaterIndex/"
customerFolder = "J:/Cai_data/Rabo/Locations/"
clientName = "AutomatedWRI_test"
customerTable = CSV.File(joinpath(customerFolder, clientName, "Customer Onboarding Information_test.csv"), header=2) |> DataFrame

#########################
# Section 1:
# function_f

customerTable_input = customerTable
customerFolder_input = customerFolder
clientName_input = clientName
graceDataLoc = "J:/Cai_data/Rabo/GRACE/GRCTellus.JPL.200204_202211.GLO.RL06.1M.MSCNv03CRI.nc"

using NCDatasets
# Open the GRACE NetCDF file
gracieNC = Dataset(graceDataLoc)

# Read latitude and longitude data
nc_lat = gracieNC["lat"][:]  # lat is given from high to low
nc_lon = gracieNC["lon"][:]  # given from 0.25 to 359.75, so need to convert to neg / pos
nc_lon[nc_lon .> 180] .= -(360 .- nc_lon[nc_lon .> 180])

# Read time data
graceDates = gracieNC["time"][:]

# Read lwe_thickness data and convert from cm to mm
lweThickLand = gracieNC["lwe_thickness"][:] .* 10  # convert cm to mm

# Mask water tiles
nc_landMask = gracieNC["land_mask"][:]


# Read uncertainty data and convert from cm to mm
nc_uncertainty = gracieNC["uncertainty"][:] .* 10  # convert cm to mm

# Initialize arrays for holding climate data
graceDataTable = DataFrame(Location = missing, Lat = missing, Lon = missing, LWE_Depth_Median = missing, LWE_Depth_SD = missing, Date = missing)
graceTrends = DataFrame(Location = missing, Lat = missing, Lon = missing, Slope = missing)

# Loop over each location in customerTable_input
for thisLoc in 1:nrow(customerTable_input)
    closestLat = argmin(abs.(nc_lat .- customerTable_input.Latitude[thisLoc]))
    closestLon = argmin(abs.(nc_lon .- customerTable_input.Longitude[thisLoc]))

    # Smoothing / downscaling and reweighting based on distance
    closeishLats = repeat(closestLat .+ [-2, -1, 0, 1, 2], inner = 5)
    closeishLons = repeat(closestLon .+ [-2, -1, 0, 1, 2], outer = 5)
    closeishLatsVals = (nc_lat[closeishLats] .- customerTable_input.Latitude[thisLoc]).^2
    closeishLonsVals = (nc_lon[closeishLons] .- customerTable_input.Longitude[thisLoc]).^2
    thisExponent = 2  # You may want to revisit weighting, but this should be standard
    distanceBox = sqrt.(closeishLatsVals .+ closeishLonsVals)
    boxWeighting = maximum(vcat(distanceBox, 1)) .- distanceBox

    # Un-weighting water / ocean tiles
    for thisIter in 1:length(closeishLats)
        if ismissing(nc_landMask[closeishLons[thisIter], closeishLats[thisIter], 1])
            boxWeighting[thisIter] = 0
            lweThickLand[closeishLons[thisIter], closeishLats[thisIter], :] .= 0
            uncertLand[closeishLons[thisIter], closeishLats[thisIter], :] .= 0
        end
    end

    # Normalizing weighting
    boxWeighting = boxWeighting.^thisExponent ./ sum(boxWeighting.^thisExponent, na.rm = true)

    # Initializing arrays for holding
    theseLweThickLand = lweThickLand[closeishLons[1], closeishLats[1], :] .* boxWeighting[1]
    theseUncertLand = uncertLand[closeishLons[1], closeishLats[1], :] .* boxWeighting[1]

    # Accounting for ocean tiles
    if any(ismissing.(theseLweThickLand))
        theseLweThickLand[ismissing.(theseLweThickLand)] .= 0
        theseUncertLand[ismissing.(theseUncertLand)] .= 0
    end

    for thisWeight in 2:length(boxWeighting)
        nextLweThickLand = lweThickLand[closeishLons[thisWeight], closeishLats[thisWeight], :]
        nextUncertLand = uncertLand[closeishLons[thisWeight], closeishLats[thisWeight], :]

        if any(ismissing.(nextLweThickLand))
            nextLweThickLand[ismissing.(nextLweThickLand)] .= 0
            nextUncertLand[ismissing.(nextUncertLand)] .= 0
        end
    end
end












using Shapefile

cropsGlobal = Shapefile.read("J:\\Cai_data\\WaterIndex\\crop_info\\global_crops\\global_crops.shp")
test = Shapefile.read("J:\\Cai_data\\BasinATLAS_Data_v10\\BasinATLAS_v10.shp\\BasinAtlas_v10_lev01.shp")

plot(cropsGlobal[1:20,50])

cropsTable = Shapefile.Table("J:\\Cai_data\\WaterIndex\\crop_info\\global_crops\\global_crops.shp")
testTable = Shapefile.Table("J:\\Cai_data\\BasinATLAS_Data_v10\\BasinATLAS_v10.shp\\BasinAtlas_v10_lev01.shp")

cropsGeom = Shapefile.shapes(cropsTable)
testGeom = Shapefile.shapes(testTable)


using Shapefile
path = joinpath(dirname(pathof(Shapefile)), "..", "test", "shapelib_testcases", "test.shp")
table = Shapefile.Table(path)
# If you only want the geometries and not the metadata in the DBF file:
geoms = Shapefile.shapes(table)
# You can retrieve whole columns by their name from the table.



























