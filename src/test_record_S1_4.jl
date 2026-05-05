function test_record_S1_4(line::String)
    # Implementation for testing the S1.4 record of the RCD file
    p1 = line[1:5] # number of location markers
    p2 = line[6:17] # geometric chainage interval
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
    p26 = line[165:166] # number of interior noise points
    p27 = line[167:178] # Example: characters 167-178
    p28 = line[179:180] # number of exterior noise points
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
    rmst_points = parse(Int, p20) # number of RMST points is used to determine how many S1.7 records there are
    println("RMST points: $rmst_points")

    interior_noise_points = p26
    exterior_noise_points = p28
    number_of_location_markers = p1
    geometric_chainage_interval = parse(Float64, p2)
    S1_4_valid = all_valid(p8_valid, p9_valid, p10_valid, p11_valid, p12_valid, p13_valid, p14_valid, p15_valid, p16_valid, p17_valid, p18_valid, p19_valid, p20_valid, p21_valid, p22_valid, p23_valid, p24_valid, p25_valid, p26_valid, p27_valid, p28_valid, p29_valid, p30_valid, p31_valid, p32_valid, p33_valid, p34_valid)

    println("Testing S1.4 line: $line")
    return S1_4_valid, retro_data_exists, 
                        transverse_profile_points, 
                        rmst_points, 
                        interior_noise_points, 
                        exterior_noise_points, 
                        number_of_location_markers,
                        geometric_chainage_interval # return values

end