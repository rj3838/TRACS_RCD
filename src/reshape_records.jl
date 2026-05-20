# Reshapes a DataFrame into 214 columns by flattening all values row-by-row
# and repacking them into rows of 214.  The last row is zero-padded if needed.

"""
    reshape_16_to_214(source_df::DataFrame;
                      col_prefix::String = "col") -> DataFrame

Flattens all values in `source_df` row-by-row into a single integer sequence,
then repacks that sequence into a new DataFrame where every row contains
214 consecutive values.

# Arguments
- `source_df`  : input DataFrame of integer values (any number of rows/columns)
- `col_prefix` : prefix for the 214 output column names (default `"col"`)

# Returns
A DataFrame with 214 columns named `<col_prefix>_1` … `<col_prefix>_214`.
The last row is zero-padded if the total number of values is not a multiple of 214.
"""

using DataFrames, CSV

function reshape_16_to_214(source_df::DataFrame;
                            col_prefix::String = "col")::DataFrame

    OUT_WIDTH = 214

    # ── 1. Convert to Int matrix and flatten row-by-row ───────────────────────
    # permutedims converts N×C → C×N so that vec() (column-major) reads
    # the original rows in order: row1col1, row1col2, …, row2col1, …
    src_mat = Matrix{Int}(source_df)
    flat    = vec(permutedims(src_mat))
    total   = length(flat)

    println("Values to reshape: $total  ($(nrow(source_df)) rows × $(ncol(source_df)) cols)")
    println("Head: ", first(flat, 5))

    # ── 2. Pad to a multiple of OUT_WIDTH ─────────────────────────────────────
    n_out = cld(total, OUT_WIDTH)
    pad   = n_out * OUT_WIDTH - total
    if pad > 0
        append!(flat, fill(0, pad))
    end

    # ── 3. Reshape into n_out rows × 214 cols ─────────────────────────────────
    # reshape fills column-by-column, so reshape(flat, OUT_WIDTH, n_out) puts
    # consecutive values into column j.  permutedims then gives n_out × OUT_WIDTH.
    mat = permutedims(reshape(flat, OUT_WIDTH, n_out))

    # ── 4. Build output DataFrame ──────────────────────────────────────────────
    col_names = [Symbol("$(col_prefix)_$i") for i in 1:OUT_WIDTH]
    return_df = DataFrame(mat, col_names)
    CSV.write("temp_trans.csv", return_df)
    return return_df
end
