function test_octave_frequencies(record_to_test::String, rcd_contents::Vector{String}, next_test_record::Int)
    s = rcd_contents[next_test_record]
        #println("Testing S1.8 record at index: $next_test_record")
    println("$record_to_test record content at index $next_test_record : ", s)
    # S1.8 (and s1.9) record contains the octave frequencies
    n = length(s) ÷ 5  # number of values in the string
    
    # Extract chunks
    chunks = [s[(i-1)*5+1 : i*5] for i in 1:n]
    
    # Try to parse each chunk as an integer
    values = Vector{Int}(undef, n)
    for (i, chunk) in enumerate(chunks)
        stripped = strip(chunk)
        val = tryparse(Int, stripped)
        if val === nothing
            error("Invalid integer at position $i: '$chunk'")
        end
        values[i] = val
    end
    
    # Check ascending order
    for i in 2:n
        if values[i] <= values[i-1]
            error("Values not in ascending order at position $i: $(values[i-1]) >= $(values[i])")
        end
    end
    
    return #values
end