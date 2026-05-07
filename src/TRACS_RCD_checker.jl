# This is written in the Julia programming language.

using Dates

include("test_octave_frequencies.jl")
include("test_transverse_points.jl")
include("format_checking.jl")
include("analyse_file.jl")
include("test_record_S5_1.jl")
include("test_record_S3_1.jl")
include("test_record_S1_5.jl")
include("test_record_S1_4.jl")
include("test_record_S1_1_to_3.jl")

const XSECT_CODE = Dict("L" => 1, "R" => 1, "B" => 2, "N" => 0, "F" => 3)

function select_file_to_read()
    # Implementation for selecting a file to read
    file_to_read = "C:\\Users\\rjaques\\OneDrive - TRL Limited\\Development\\TRACS_rcd\\test_data\\001_A1_NB_L1_A_R18_250906113702_tracs5.rcd"
    return file_to_read
end

function read_rcd_file(rcd_file_name)::Vector{String}
    # Open the RCD file for reading
    rcd_to_return = Vector{String}()
    open(rcd_file_name, "r") do file
        # Read the contents of the file
        rcd_to_return = readlines(file)
        # Process the contents as needed (e.g., parse data, extract information)
        # For demonstration, we will just print the contents
        #println(rcd_to_return)
    end
    return rcd_to_return  
end

function main()
    rcd_file_name = select_file_to_read()
    rcd_contents = read_rcd_file(rcd_file_name)
    
    # Print number of lines
    println("Read $(length(rcd_contents)) lines")
    
    # Print first few lines as example
    for (i, line) in enumerate(rcd_contents[1:min(5, length(rcd_contents))])
        println("Line $i: $line")
    end

    
    S1_1_test_result, num_S1_2_records= test_record_S1_1(rcd_contents[1])

    println("S1.1 test result: $S1_1_test_result, Number of S1.2 records: $num_S1_2_records")
    
    S1_2_test_result = test_record_S1_2(rcd_contents[2:1+num_S1_2_records])
    println("S1.2 test result: $S1_2_test_result")

    next_test_record = 2 + num_S1_2_records
    println("Next test record index for S1.3: $next_test_record")

    S1_3_test_result, total_survey_length = test_record_S1_3(rcd_contents[next_test_record])
    println("S1.3 test result: $S1_3_test_result")

    S1_4_test_result, process_S1_5, number_of_transverse_profile_points, 
                                    number_of_transverse_rmst_points, 
                                    interior_noise_points, 
                                    exterior_noise_points,
                                    number_of_location_markers,
                                    retro_positions,
                                    long_profile_chainage_interval,
                                    geometric_chainage_interval = test_record_S1_4(rcd_contents[next_test_record + 1])
    println("S1.4 test result: $S1_4_test_result")

    next_test_record += 2 # move the index to the next record after S1.4, which is S1.5 if it exists, so we add 2 to skip over the S1.4 record and move to the next one

    # the next record to test would be S1.5, which is at index next_test_record + 2, and so on for the rest of the records in the RCD file
    # but it will not exist if the field in the S1.4 record at position 18-29 contains zero (-0.000000000)

    if process_S1_5
        #next_test_record += 1
        S1_5_test_result, points_in_retro_profile,
                        width_of_retro_profile,
                        length_of_retro_profile = test_record_S1_5(rcd_contents[next_test_record])
        println("S1.5 test result: $S1_5_test_result")
        next_test_record += 1
    else
        #next_test_record += 1
        println("No S1.5 records to test based on S1.4 data")
    end

    if number_of_transverse_profile_points > 0
        
        next_test_record = test_transverse_points("S1.6",number_of_transverse_profile_points, rcd_contents, next_test_record)
    end

    if number_of_transverse_rmst_points > 0
        next_test_record = test_transverse_points("S1.7",number_of_transverse_rmst_points, rcd_contents, next_test_record)
    end

    # next check for S1.8 and S1.9records here if there are interior and exterior noise points specified in the S1.4 record
    if tryparse(Int, interior_noise_points) > 0
        s1_8_test_result,next_test_record = test_octave_frequencies("S1.8", rcd_contents, next_test_record)
        println("S1.8 test result: $s1_8_test_result")
    end
    
    if tryparse(Int, exterior_noise_points) > 0
        s1_9_test_result,next_test_record = test_octave_frequencies("S1.9", rcd_contents, next_test_record)
        println("S1.9 test result: $s1_9_test_result")
    end
    
    # Continue with testing other records as needed, using the next_test_record index to keep track of which record to test next
    #
    # Now working with the location data at S2.1. there is a S2.1 for each marker defined in S1.4 position 1-5
    # if it's zero don't process any S2.1 records

    if tryparse(Int, number_of_location_markers) > 0
        for marker in 1:tryparse(Int, number_of_location_markers)
            println(rcd_contents[next_test_record])
            #s2_1_test_result = test_record_S2_1(rcd_contents[next_test_record])
            #println("S2.1 test result for marker $marker: $s2_1_test_result")
            next_test_record += 1
        end
    end
    #
    # Geometric data in S3.1 records repeated as necessary to provide number of measurements as defined by length of survey and spacing of values
    #
    #number_of_s3_1_records = ceil(Int, total_survey_length / geometric_chainage_interval) # calculate the number of S3.1 records needed based on the total survey length
    #println("Total survey length: $total_survey_length, Geometric chainage interval: $geometric_chainage_interval, Number of S3.1 records needed: $number_of_s3_1_records")

    #println(divrem(total_survey_length, geometric_chainage_interval))
    #println(div(total_survey_length, geometric_chainage_interval))
    number_of_s3_1_records = Int(div(total_survey_length, geometric_chainage_interval))

    println("total_survey_length: $total_survey_length, geometric_chainage_interval: $geometric_chainage_interval, number_of_s3_1_records: $number_of_s3_1_records")

    record_S3_1_check = test_record_S3_1(rcd_contents, next_test_record, number_of_s3_1_records)

    next_test_record += number_of_s3_1_records # move the index to the next record after the S3.1 records

    # calculate how many S4.1 records to expect.

    # first calculate the number of profiles in the length of the survey, which is the total survey length divided by the chainage interval between retro profiles defined in S1.4 record at position 18-29, and then round up to the nearest whole number as there will be a S4.1 record for each profile, and if there is a partial profile at the end of the survey there will still be a S4.1 record for it
    number_of_retro_profiles = ceil(total_survey_length /  parse(Float64, string(length_of_retro_profile)))

    # calculate the number of profile points in a profile
    profile_points_in_retro_profile = tryparse(Int, (points_in_retro_profile))

    retro_devices = Int(get(XSECT_CODE, retro_positions, 0)) # 0 as default for unrecognised values

    retro_points_in_survey = number_of_retro_profiles * profile_points_in_retro_profile * retro_devices

    #println("total_survey_length: $total_survey_length, 
    #           geometric_chainage_interval: $geometric_chainage_interval, 
    #           number_of_s4_1_records: $number_of_s4_1_records")

    #the number of S4.1 records to expect is the number of retro profiles in the survey, 
    #which is the total survey length divided by the chainage interval between retro profiles, 
    #and then round up to the nearest whole number as there will be that number of profile readings 
    #and if there is a partial profile at the end of the survey there will still be a S4.1 record for it

    number_of_s4_1_records = ceil(Int, retro_points_in_survey / 28) # there are 28 points in each S4.1 record, so divide the total number of retro points in the survey by 28 to get the number of S4.1 records needed, and round up to the nearest whole number as there will be that number of profile readings and if there is a partial profile at the end of the survey there will still be a S4.1 record for it
    println("total_survey_length: $total_survey_length, 
                length_of_retro_profile: $length_of_retro_profile,
               geometric_chainage_interval: $geometric_chainage_interval, 
               number_of_retro_profiles: $number_of_retro_profiles, 
               profile_points_in_retro_profile: $profile_points_in_retro_profile, 
               retro_devices: $retro_devices, 
               retro_points_in_survey: $retro_points_in_survey, 
               number_of_s4_1_records: $number_of_s4_1_records")

    number_of_profiles_in_survey = ceil(Int, total_survey_length / parse(Float64, length_of_retro_profile))
    println("number_of_profiles_in_survey: $number_of_profiles_in_survey") 

    number_of_retro_values_in_survey = number_of_profiles_in_survey * profile_points_in_retro_profile * retro_devices
    println("number_of_retro_values_in_survey: $number_of_retro_values_in_survey")  

    next_test_record = analyse_file(rcd_contents, next_test_record)

    println("Next test record index after format checking: $next_test_record")

    number_of_s5_1_points = ceil(Int, total_survey_length / long_profile_chainage_interval)
    number_of_s5_1_records = ceil(Int, number_of_s5_1_points / 4) # there are 4 blocks of test values in each S5.1 record, so divide the total number of S5.1 points by 4 to get the number of S5.1 records needed, and round up to the nearest whole number as there will be that number of profile readings and if there is a partial profile at the end of the survey there will still be a S5.1 record for it

    next_test_record = test_record_S5_1(rcd_contents, next_test_record, number_of_s5_1_records)
    last_test_record = next_test_record - 1
    println("Last test record index after S5.1 testing: $last_test_record")
    println("length of last_test_record: $(length(rcd_contents[last_test_record]))")
    println("Next test record index after S5.1 testing: $next_test_record")
    println("length of next_test_record: $(length(rcd_contents[next_test_record]))")
end

main() 
 