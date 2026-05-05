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

function count_nonzero(s::String)
    chunks = [s[(i-1)*6+1 : i*6] for i in 1:10]
    first_zero = findfirst(c -> parse(Float64, c) == 0.0, chunks)
    first_zero === nothing ? 10 : first_zero - 1
end
