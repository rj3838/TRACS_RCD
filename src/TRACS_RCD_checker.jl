# This is written in the Julia programming language.

using Dates

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

    S1_3_test_result = test_record_S1_3(rcd_contents[next_test_record])
    println("S1.3 test result: $S1_3_test_result")

    S1_4_test_result, process_S1_5, number_of_transverse_profile_points = test_record_S1_4(rcd_contents[next_test_record + 1])
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
        
        # There are $number_of_transverse_profile_points transverse profile points, so there will be $number_of_transverse_profile_points S1.6 records to test
        # the records contain 10 of F6.3 per line
        S1_6_record_count, remaining_values_in_last_record = divrem(number_of_transverse_profile_points, 10) # each S1.6 record can contain 60 characters, which is 10 F6.3 values 
                                                                                                # each F6.3 value is 8 characters including the decimal point and 3 decimal places)
                                                                                                # the divrem function will give us the number of full S1.6 records and the
                                                                                                #number of remaining values that will be in the last S1.6 record if there are any

        # if there are remaining values in the last record then we need to add one more record to the count
        if remaining_values_in_last_record > 0
            S1_6_record_count += 1
        end
        
        println("There are $transverse_profile_points transverse profile points, so there will be $(S1_6_record_count) S1.6 records to test")

        for i in 1:(S1_6_record_count)
            
            println("Testing S1.6 record at index: $next_test_record")
            # S1_6_test_result = test_record_S1_6(rcd_contents[next_test_record])
            println("S1.6 record content: ", rcd_contents[next_test_record])
            #println("S1.6 test result for record $i: $S1_6_test_result")
            next_test_record += 1
        end
    else
        println("No transverse profile points, so no S1.6 records to test")
    end
end

function is_valid_date(date_str::String)
    try
        Date(uppercase(date_str), "dd-uuu-yyyy")
        return true
    catch
        return false
    end
end

function is_valid_time(time_str::String)
    try
        Time(time_str, "HH:MM")
        return true
    catch
        return false
    end
end
function is_valid_int_1_to_99(str::String)
    try
        num = parse(Int, str)
        return 1 <= num <= 99
    catch
        return false
    end
end

function is_valid_int_0_to_99(str::String)
    try
        num = parse(Int, str)
        return 0 <= num <= 99
    catch
        return false
    end
end

function is_valid_int_0_to_999(str::String)
    try
        num = parse(Int, str)
        return 0 <= num <= 999
    catch
        return false
    end
end

function is_valid_int_0_to_99999(str::String)
    try
        num = parse(Int, str)
        return 0 <= num <= 99999
    catch
        return false
    end
end

function is_valid_int_0_to_9999999(str::String)
    try
        num = parse(Int, str)
        return 0 <= num <= 9999999
    catch
        return false
    end
end

function all_valid(vars...)
    return all(vars)   
end

function all_strings_valid_length(vec::Vector{String}, string_length::Int)
    for str in vec
        if length(str) < 1 || length(str) > string_length
            return false
        end
    end
    return true
end

function is_valid_f11_3(str::String)
    # F11.3: 11 total chars, 3 decimal places
    # Format: optional leading spaces, digits, decimal point, 3 decimal digits = 11 chars
    # Example: 1234567.890
    return length(str) == 11 && occursin(r"^\s*\d+\.\d{3}$", str)
end

function is_valid_f12_9(str::String)
    # F12.9: 12 total chars, 9 decimal places
    # Format: optional leading spaces, digits, decimal point, 9 decimal digits = 12 chars
    # Example: 1234567.890123456
    return length(str) == 12 && occursin(r"^\s*\d+\.\d{9}$", str)
end

function is_valid_f6_3(str::String)
    # F6.3: 6 total chars, 3 decimal places
    # Format: optional leading spaces, digits, decimal point, 3 decimal digits = 6 chars
    # Example: 12.345
    return length(str) == 6 && occursin(r"^\s*[+-]?\d+\.\d{3}$", str)
    
end

function is_valid_f5_3(str::String)
    
    # Format: optional leading spaces, digits, decimal point, 3 decimal digits = 5 chars
    # Example: 12.345
    return length(str) == 5 && occursin(r"^\s*\d+\.\d{3}$", str)
end

function is_valid_f9_3(str::String)
    # F9.3: 9 total chars with sign, 3 decimal places
    # Format: optional leading spaces, optional +/- sign, digits, decimal point, 3 decimals
    # Example: +12345.678 or -12345.678
    return length(str) == 9 && occursin(r"^\s*[+-]?\d+\.\d{3}$", str)
end

function is_valid_float_format(str::String)
    return is_valid_f11_3(str) || is_valid_f9_3(str)
end

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
    return S1_3_valid # return value
end

function test_record_S1_4(line::String)
    # Implementation for testing the S1.4 record of the RCD file
    p1 = line[1:5] # Example: characters 1-5
    p2 = line[6:17] # Example: characters 6-17
    p3 = line[18:29] # will be used to determine if there is retro reflectivity data if zero there will be no record S1.5
    p4 = line[30:30] # single char
    p5 = line[31:42] # Example: characters 31-42
    p6 = line[43:48] # Example: characters 43-48
    p7 = line[49:54] # Example: characters 49-54
    p8 = line[55:66] # Example: characters 55-66
    p9 = line[67:69] # number of transverse profile points
    p10 = line[70:81] # Example: characters 70-81
    p11 = line[82:93] # Example: characters 82-93
    p12 = line[94:105] # Example: characters 94-105
    p13 = line[106:111] # Example: characters 106-111
    p14 = line[112:112] # Example: characters 112-112
    p15 = line[113:118] # Example: characters 124-129
    p16 = line[119:119] # Example: characters 119-119
    p17 = line[120:125] # Example: characters 120-125
    p18 = line[126:126] # Example: characters 126-126
    p19 = line[127:138] # Example: characters 127-138
    p20 = line[139:140] # Example: characters 139-141
    p21 = line[141:145] # Example: characters 141-145
    p22 = line[146:150] # Number of offside studs
    p23 = line[151:151] # Example: characters 151-151
    p24 = line[152:152] # Example: characters 152-152
    p25 = line[153:164] # Example: characters 153-164
    p26 = line[165:166] # Example: characters 165-166
    p27 = line[167:178] # Example: characters 167-178
    p28 = line[179:180] # Example: characters 179-180
    p29 = line[181:191] # Example: characters 181-191
    p30 = line[192:197] # Example: characters 192-197
    p31 = line[198:199] # Example: characters 194-199
    p32 = line[200:204] # Example: characters 200-210
    p33 = line[205:211] # Example: characters 206-207
    p34 = line[212:216] # Number of visual defects

    # validity tests
    p1_valid = is_valid_int_0_to_99999(p1::String)
    p2_valid = is_valid_f12_9(p2::String)
    p3_valid = is_valid_f12_9(p3::String)
    #print("p3 value: '$p3'") # Debug print to check the value of p3
    p4_valid = (p4 == "L" || p4 == "R" || p4 == "B" || p4 == "N" || p4 == "F")
    p5_valid = is_valid_f12_9(p5::String) # Example check for float12.9 value
    p6_valid = is_valid_f6_3(p6::String) # Example check for float6.3 value
    p7_valid = is_valid_f6_3(p7::String) # Example check for float6.3 value
    p8_valid = is_valid_f12_9(p8::String) # Example check for float12.9 value
    p9_valid = is_valid_int_0_to_999(p9::String) # Example check for int 0-999
    p10_valid = is_valid_f12_9(p10::String) # Example check for float12.9 value
    p11_valid = is_valid_f12_9(p11::String) # Example check for float12.9 value
    p12_valid = is_valid_f12_9(p12::String) # Example check for float12.9 value
    p13_valid = is_valid_f6_3(p13::String) # Example check for float6.3 value
    p14_valid = (p14 == "Y" || p14 == "N")
    p15_valid = is_valid_f6_3(p15::String) # Example check for float6.3 value
    p16_valid = (p16 == "Y" || p16 == "N")
    p17_valid = is_valid_f6_3(p17::String) # Example check for float12.9 value
    #print("p17 value: '$p17'") # Debug print to check the value of p17
    p18_valid = (p18 == "Y" || p18 == "N") #is_valid_int_0_to_99(p18::String) # Example check for int 0-99
    #print("p18 value: '$p18'") # Debug print to check the value of p18
    p19_valid = is_valid_f12_9(p19::String) #|| p19 == "   -1" # 
    #print("p19 value: '$p19'") # Debug print to check the value of p19
    p20_valid = is_valid_int_0_to_99(p20::String) # Example check for int 0-99
    #print("p20 value: '$p20'") # Debug print to check the value of p20
    #p21_valid = (p21 == "I" || p21 == "E" || p21 == "B" || p21 == "N") # Example check for specific char values
    p21_valid = is_valid_int_0_to_99999(p21::String) || p21 == "   -1"
    #print("p21 value: '$p21'") # Debug print to check the value of p21
    #p22_valid = (p22 == "A" || p22 == "C")
    p22_valid = is_valid_int_0_to_99999(p22::String) || p22 == "   -1"
    #print("p22 value: '$p22'") # Debug print to check the value of p22
    #p23_valid = is_valid_f12_9(p23::String) # Example check for float12.9 value
    p23_valid = (p23 == "I" || p23 == "E" || p23 == "B" || p23 == "N") # Example check for specific char values
    #print("p23 value: '$p23'") # Debug print to check the value of p23
    #p24_valid = is_valid_int_0_to_99(p24::String) # Example check for int 0-99
    p24_valid = (p24 == "A" || p24 == "C")
    p25_valid = is_valid_f12_9(p25::String) # Example check for float12.9 value
    p26_valid = is_valid_int_0_to_99(p26::String) # Example check for int 0-99
    p27_valid = is_valid_f12_9(p27::String) # Example check for float11.3 value
    #print("p27 value: '$p27'") # Debug print to check the value of p27
    #p28_valid = is_valid_f6_3(p28::String) # Example check for float6.3 value
    #print("p28 value: '$p28'") # Debug print to check the value of p28
    p28_valid = is_valid_int_0_to_99(p28::String) # Example check for int 0-999
    #print("p29 value: '$p29'") # Debug print to check the value of p29
    p29_valid = is_valid_f11_3(p29::String) # Example check for float6.3 value
    p30_valid = is_valid_f6_3(p30::String) # Example check for float12.9 value
    #print("p30 value: '$p30'") # Debug print to check the value of p30
    p31_valid = is_valid_int_0_to_99(p31::String)
    p32_valid = is_valid_f5_3(p32::String) # Example check for float6.3 value
    p33_valid = is_valid_int_0_to_9999999(p33::String) # Example check for float6.3 value
    p34_valid = is_valid_int_0_to_99999(p34::String) # Example check for float12.9 value

    #println("Validation Results: ", "p1_valid=$p1_valid, p2_valid=$p2_valid, p3_valid=$p3_valid, p4_valid=$p4_valid, p5_valid=$p5_valid, p6_valid=$p6_valid, p7_valid=$p7_valid, p8_valid=$p8_valid, p9_valid=$p9_valid, p10_valid=$p10_valid, p11_valid=$p11_valid, p12_valid=$p12_valid, p13_valid=$p13_valid, p14_valid=$p14_valid, p15_valid=$p15_valid, p16_valid=$p16_valid, p17_valid=$p17_valid, p18_valid=$p18_valid, p19_valid=$p19_valid, p20_valid=$p20_valid, p21_valid=$p21_valid, p22_valid=$p22_valid, p23_valid=$p23_valid, p24_valid=$p24_valid, p25_valid=$p25_valid, p26_valid=$p26_valid, p27_valid=$p27_valid, p28_valid=$p28_valid, p29_valid=$p29_valid, p30_valid=$p30_valid, p31_valid=$p31_valid, p32_valid=$p32_valid, p33_valid=$p33_valid, p34_valid=$p34_valid")

    retro_data_exists = (p3_valid && p3 != "-0.000000000") # if the field in the S1.4 record at position 18-29 contains zero (-0.000000000) then there will be no record S1.5
    transverse_profile_points = parse(Int, p9) # number of transverse profile points is used to determine how many S1.6 records there are
    S1_4_valid = all_valid(p8_valid, p9_valid, p10_valid, p11_valid, p12_valid, p13_valid, p14_valid, p15_valid, p16_valid, p17_valid, p18_valid, p19_valid, p20_valid, p21_valid, p22_valid, p23_valid, p24_valid, p25_valid, p26_valid, p27_valid, p28_valid, p29_valid, p30_valid, p31_valid, p32_valid, p33_valid, p34_valid)

    println("Testing S1.4 line: $line")
    return S1_4_valid, retro_data_exists, transverse_profile_points # return values

end

function test_record_S1_5(line::String)
    # Implementation for testing the S1.5 record of the RCD file
    # This is a placeholder for the actual test logic
    println("Testing S1.5 line: $line")
    p1 = line[1:2] # Example: characters 1-11 should contain a float11.3 value
    p2 = line[4:8] # Example: characters 12-22 should contain a float11.3 value
    p3 = line[9:13] # Example: characters 23-31 should contain a float9.3 value

    p1_valid = is_valid_int_0_to_999(p1::String) # Example check for 3 digit integer value
    p2_valid = is_valid_f5_3(p2::String) # Example check for float11.3 value
    p3_valid = is_valid_f5_3(p3::String) # Example check for float9.3 value

    S1_5_valid = all_valid(p1_valid, p2_valid, p3_valid)
    println("Validation result for S1.5: $S1_5_valid")
    return S1_5_valid # return value
end
main() 
 