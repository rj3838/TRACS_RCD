function test_record_S5_1(rcd_contents::Vector{String}, next_test_record::Int, number_of_s5_1_records::Int)

    number_of_records_to_test = next_test_record + number_of_s5_1_records # get the S5.1 records to test based on the next_test_record index and the number of S5.1 records to test, which is determined by the total survey length and the chainage interval from the S1.4 record
    for record_to_test in next_test_record:(next_test_record + number_of_s5_1_records)
        #println(rcd_contents[next_test_record], " s5.1 record count: $i")
        #field_position = 1
        for test_values_block in 1:56:18
            nearside_profile_point_value = rcd_contents[record_to_test][test_values_block : test_values_block + 6]
            is_valid_int_0_to_9999999(nearside_profile_point_value)

            offside_profile_point_value = rcd_contents[record_to_test][test_values_block + 7 : test_values_block + 13]
            is_valid_int_0_to_9999999(offside_profile_point_value)

            speed_value = rcd_contents[record_to_test][test_values_block + 14 : test_values_block + 17] 
            is_valid_int_0_to_999(speed_value)
            # extract the speed value from the S5.1 record, which is in 14-20 for each block of test values
            #println(rcd_contents[next_test_record], " s5.1 record count: $record_to_test, test block: $test_values_block")
            #s5_1_test_result = test_record_S5_1(rcd_contents[next_test_record])
            #field_position += 18 # move to the next block of test values in the S5.1 record, which are in blocks of 18 characters (7 for nearside profile point value, 7 for offside profile point value, and 4 for speed value)
        end

        #next_test_record += 1
    end

    return (next_test_record + number_of_s5_1_records) # return the index of the next test record after processing the S5.1 records, which is the current next_test_record index plus the number of S5.1 records processed

end