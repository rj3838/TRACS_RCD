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

    points_in_retro_profile = p1
    width_of_rerro_profile = p2
    length_of_retro_profile = p3
    println("Validation result for S1.5: $S1_5_valid, 
            points_in_retro_profile=$points_in_retro_profile, 
            width_of_retro_profile=$width_of_rerro_profile, 
            length_of_retro_profile=$length_of_retro_profile")
    return S1_5_valid, points_in_retro_profile, width_of_rerro_profile, length_of_retro_profile # return values
end