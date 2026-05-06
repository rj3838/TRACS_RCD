function analyse_file(rcd_contents::Vector{String}, next_test_record::Int)
    lines = rcd_contents[next_test_record:end]
    
    total_values = 0
    valid_records = 0
    
    for (i, line) in enumerate(lines)
        # Check line is exactly 84 characters
        if length(line) != 84
            println("Format change at line $i: length is $(length(line)), expected 84")
            println("Valid records: $valid_records")
            println("Total values in valid records: $total_values")
            return
        end
        
        # Check each 3-character field is a right-justified integer
        valid = true
        for f in 1:28
            field = line[(f-1)*3+1 : f*3]
            if isnothing(tryparse(Int, field))
                println("Format change at line $i, field $f: \"$field\" is not a valid integer")
                println("Valid records: $valid_records")
                println("Total values in valid records: $total_values")
                return
            end
        end
        
        valid_records += 1
        total_values += 28
    end
    
    # Reached end of file without format change
    println("No format change detected")
    println("Valid records: $valid_records")
    println("Total values: $total_values")
end