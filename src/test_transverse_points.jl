function test_transverse_points(record_test_type::String, number_of_transverse_profile_points::Int, rcd_contents::Vector{String}, next_test_record::Int)
    # There are $number_of_transverse_profile_points transverse profile points, so there will be $number_of_transverse_profile_points $record_test_type records to test
    # the records contain 10 of F6.3 per line
    record_count, remaining_values_in_last_record = divrem(number_of_transverse_profile_points, 10) # each record can contain 60 characters, which is 10 F6.3 values 
                                                                                                        # each F6.3 value is 8 characters including the decimal point and 3 decimal places)
                                                                                                        # the divrem function will give us the number of full S1.6 records and the
                                                                                                        #number of remaining values that will be in the last S1.6 record if there are any

        # if there are remaining values in the last record then we need to add one more record to the count
        if remaining_values_in_last_record > 0
            record_count += 1
        end
        
        println("There are $number_of_transverse_profile_points transverse profile points, so there will be $(record_count) $record_test_type records to test")

        value_count = 0

        for i in 1:(record_count)
            
            #println("Testing $record_test_type record at index: $next_test_record")
            # $record_test_type_test_result = test_record_$record_test_type(rcd_contents[next_test_record])
            println("$record_test_type record content at index $next_test_record : ", rcd_contents[next_test_record])
            #println("$record_test_type test result for record $i: $$record_test_type_test_result")
            value_count += count_nonzero(rcd_contents[next_test_record])
            next_test_record += 1
        end

        #if remaining_values_in_last_record > 0
        #    println("The last $record_test_type record contains $remaining_values_in_last_record transverse profile points")
        #end

        if value_count != number_of_transverse_profile_points
            println("Warning: The total number of transverse profile points counted in the $record_test_type records ($value_count) does not match the number specified in the S1.4 record ($number_of_transverse_profile_points)")
        else
            println("The total number of transverse profile points counted in the $record_test_type records matches the number specified in the S1.4 record")
        end

        return next_test_record
    end