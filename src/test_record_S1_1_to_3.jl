function test_record_S1_1(line::String)
    # Implementation for testing the first line of the RCD file
    # split the line by charecter position and check the values
    p1 = line[1:5]  # Example: characters 1-5 should contain 'TRACS'
    p2 = line[6:13] # Example: characters 6-13 machine identifier
    p3 = line[14:21] # Example: characters 14-21 file format version
    p4 = line[22:32] # Example: characters 22-32 date at start of survey
    p5 = line[33:37] # Example: characters 33-37 time at start of survey
    p6 = line[38:48] # Example: characters 38-48 date at end of survey
    p7 = line[49:53] # Example: characters 49-53 time at end of survey
    p8 = line[54:55] # Example: characters 54-55 number of S1.2 records
    
    # This is a placeholder for the actual test logic
    println("Testing line: $line")
    p1_valid = (p1 == "TRACS")
    p2_valid = true # it's always a string
    p3_valid = (p3 == "Ver12.00") # Example check for file format version
    p4_valid = is_valid_date(p4::String) # Example check for date at start of survey
    p5_valid = is_valid_time(p5::String) # Example check for time at start of survey
    p6_valid = is_valid_date(p6::String) # Example check for date at end of survey
    p7_valid = is_valid_time(p7::String) # Example check for time at end of survey
    p8_valid = is_valid_int_1_to_99(p8::String) # Example check for number of S1.2 records
    # Return true if all are valid, false if not, and also return the number of S1.2 records as an integer
    println("Validation results: p1_valid=$p1_valid, p2_valid=$p2_valid, p3_valid=$p3_valid, p4_valid=$p4_valid, p5_valid=$p5_valid, p6_valid=$p6_valid, p7_valid=$p7_valid, p8_valid=$p8_valid")
    return all_valid(p1_valid, p2_valid, p3_valid, p4_valid, p5_valid, p6_valid, p7_valid, p8_valid), parse(Int, p8)
end

function test_record_S1_2(lines::Vector{String})
    # Implementation for testing the S1.2 records of the RCD file
    S1_2_valid = all_strings_valid_length(lines, 80)
    println("Testing S1.2 records: $lines" , "Validation result: $S1_2_valid")
    return S1_2_valid #  return value
end

function test_record_S1_3(line::String)
    # Implementation for testing the S1.3 record of the RCD file
    # This is a placeholder for the actual test logic
    println("Testing S1.3 line: $line")

    p1 = line[1:11] # Example: characters 1-11 should contain a float11.3 value
    p2 = line[12:22] # Example: characters 12-22 should contain a float11.3 value
    p3 = line[23:31] # Example: characters 23-31 should contain a float9.3 value
    p4 = line[32:42] # Example: characters 32-42 should contain a float9.3 value
    p5 = line[43:53] # Example: characters 43-53 should contain a float11.3 value
    p6 = line[54:64] # Example: characters 54-64 should contain a float11.3 value
    p7 = line[65:73] # Example: characters 65-73 should contain a float9.3 value

    p1_valid = is_valid_f11_3(p1::String) # Example check for float11.3 value
    p2_valid = is_valid_f11_3(p2::String) # Example check for float11.3 value
    p3_valid = is_valid_f9_3(p3::String) # Example check for float9.3 value
    p4_valid = is_valid_f11_3(p4::String) # Example check
    p5_valid = is_valid_f11_3(p5::String) # Example check
    p6_valid = is_valid_f11_3(p6::String) # Example check
    p7_valid = is_valid_f9_3(p7::String) # Example check

    S1_3_valid = all_valid(p1_valid, p2_valid, p3_valid, p4_valid, p5_valid, p6_valid, p7_valid)
    println("Validation result for S1.3: $S1_3_valid")
    total_survey_length = tryparse(Float64, strip(p4)) # using the value in p4 as the total survey length, stripping any leading/trailing whitespace and converting to a float
    return S1_3_valid, total_survey_length # return value
end