function test_record_S6_1(rcd_contents::Vector{String}, next_test_record::Int, number_of_s6_1_records::Int)

    number_of_records_to_test = next_test_record + number_of_s6_1_records # get the S6.1 records to test based on the next_test_record index and the number of S6.1 records to test, which is determined by the total survey length and the chainage interval from the S1.4 record
    last_record_test = next_test_record + number_of_s6_1_records
    # calculate the last record index to test for the S6.1 records, which is the next_test_record index plus the number of S6.1 records to
    # test minus one, as the next_test_record index is the index of the first S6.1 record to test.

     println("Next test record index for S6.1 testing: $next_test_record")
     println("Last expected record index for S6.1 testing: $last_record_test")
    
    for record_to_test in next_test_record:last_record_test
        #println(rcd_contents[next_test_record], " s5.1 record count: $i")
        if length(rcd_contents[record_to_test]) == 96
            for test_values_block in 1:91:6
                profile_point_value = rcd_contents[record_to_test][test_values_block : test_values_block + 4]
                is_valid_int_0_to_99999(profile_point_value)
                road_marking_value = rcd_contents[record_to_test][test_values_block + 5 : test_values_block + 5]
                road_marking_value == "0" || road_marking_value == "1" || road_marking_value == ""

                #speed_value = rcd_contents[record_to_test][test_values_block + 6 : test_values_block + 11] 
                #is_valid_int_0_to_999(speed_value)
                # extract the speed value from the S5.1 record, which is in 14-20 for each block of test values
                #println(rcd_contents[next_test_record], " s5.1 record count: $record_to_test, test block: $test_values_block")
                #s5_1_test_result = test_record_S5_1(rcd_contents[next_test_record])
                #field_position += 18 # move to the next block of test values in the S5.1 record, which are in blocks of 18 characters (7 for nearside profile point value, 7 for offside profile point value, and 4 for speed value)
            end
        else
            println("Warning: S6.1 record at index $record_to_test has length $(length(rcd_contents[record_to_test])) which is less than expected for a complete S6.1 record, skipping this record")
            last_record_test = record_to_test - 1 # set the last record test index to the previous record index, which is the last complete S6.1 record index
            break # we are at the end of the S6.1 records, so break out of the loop to avoid trying to test incomplete S6.1 records 

        end
        #field_position = 1
        # move to the next S6.1 record to test, which is the current record index plus one, and this will be used as the next_test_record index for the next iteration of the loop to test the next S6.1 record
    end
    next_test_record = last_record_test + 1 
    return next_test_record # return the index of the next test record after processing the S6.1 records, which is the current next_test_record index plus the number of S6.1 records processed

end