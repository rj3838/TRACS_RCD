# This is written in the Julia programming language.

using Dates

include("test_octave_frequencies.jl")
include("test_transverse_points.jl")
include("format_checking.jl")
include("test_record_S1_5.jl")
include("test_record_S1_4.jl")
include("test_record_S1_1_to_3.jl")

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
                                    geometric_chainage_interval = test_record_S1_4(rcd_contents[next_test_record + 1])
    println("S1.4 test result: $S1_4_test_result")

    next_test_record += 2 # move the index to the next record after S1.4, which is S1.5 if it exists, so we add 2 to skip over the S1.4 record and move to the next one

    # the next record to test would be S1.5, which is at index next_test_record + 2, and so on for the rest of the records in the RCD file
    # but it will not exist if the field in the S1.4 record at position 18-29 contains zero (-0.000000000)

    if process_S1_5
        #next_test_record += 1
        S1_5_test_result = test_record_S1_5(rcd_contents[next_test_record])
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
    number_of_s3_1_records = div(total_survey_length, geometric_chainage_interval) 

    for i in 1:number_of_s3_1_records
        println(rcd_contents[next_test_record], " s3.1 record count: $i")
        #s3_1_test_result = test_record_S3_1(rcd_contents[next_test_record])
        #println("S3.1 test result for record $i: $s3_1_test_result")
        next_test_record += 1
    end
end

main() 
 