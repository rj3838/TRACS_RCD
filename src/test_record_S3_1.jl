function test_record_S3_1(rcd_contents::Vector{String}, next_test_record::Int, number_of_s3_1_records::Int)

    for i in 1:number_of_s3_1_records
        println(rcd_contents[next_test_record], " s3.1 record count: $i")
        #s3_1_test_result = test_record_S3_1(rcd_contents[next_test_record])
        s3_1_x_coordinate = rcd_contents[next_test_record][1:11] # extract the x coordinate from the S3.1 record, which is in 1-11
        if is_valid_f11_3(s3_1_x_coordinate) === false
            println("Invalid S3.1 x coordinate format: $s3_1_x_coordinate")
        end

        s3_1_y_coordinate = rcd_contents[next_test_record][12:22] # extract the y coordinate from the S3.1 record, which is in 12-22
        if is_valid_f11_3(s3_1_y_coordinate) === false
            println("Invalid S3.1 y coordinate format: $s3_1_y_coordinate")
        end

        s3_1_z_coordinate = rcd_contents[next_test_record][23:31] # extract the z coordinate from the S3.1 record, which is in 23-31
        if is_valid_f9_3(s3_1_z_coordinate) === false
            println("Invalid S3.1 z coordinate format: $s3_1_z_coordinate")
        end
      
        s3_1_gradient = rcd_contents[next_test_record][32:36] # extract the gradient from the S3.1 record, which is in 32-36
        if is_valid_f5_1(s3_1_gradient) === false
            println("Invalid S3.1 gradient format: $s3_1_gradient")
        end

        s3_1_crossfall = rcd_contents[next_test_record][37:41] # extract the crossfall from the S3.1 record, which is in 37-41
        if is_valid_f5_1(s3_1_crossfall) === false
            println("Invalid S3.1 crossfall format: $s3_1_crossfall")
        end

        s3_1_curvature = rcd_contents[next_test_record][42:49] # extract the curvature from the S3.1 record, which is in 42-46
        if is_valid_f8_2(s3_1_curvature) === false
            println("Invalid S3.1 curvature format: $s3_1_curvature")
        end

        s3_1_deviation = rcd_contents[next_test_record][50:50] # extract the deviation from the S3.1 record, which is in 50
        if !(s3_1_deviation == "D" || s3_1_deviation == " ")
            println("Invalid S3.1 deviation format: $s3_1_deviation")
        end

        s3_1_luminance = rcd_contents[next_test_record][51:53] # extract the luminance from the S3.1 record
        if is_valid_int_0_to_999(s3_1_luminance::String) === false
            println("Invalid S3.1 luminance format: $s3_1_luminance")
        end
        #println("S3.1 test result for record $i: $s3_1_test_result")
        #next_test_record += 1

        return true

    end
end