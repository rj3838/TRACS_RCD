# Displays a popup window listing S2.1 location markers with checkboxes.
# Returns a DataFrame of the selected markers.
#
# Requires: Gtk.jl  (add with: import Pkg; Pkg.add("Gtk"))

using Gtk
using DataFrames

"""
    select_location_markers(rcd_contents, start_index, number_of_markers) -> DataFrame

Parses `number_of_markers` S2.1 records from `rcd_contents` beginning at
`start_index`, shows a popup window so the user can tick which markers to
keep, then returns those rows as a DataFrame with columns:
  - marker_id  :: Int
  - chainage   :: Float64  (metres)
"""
function select_location_markers(rcd_contents::Vector{String},
                                  start_index::Int,
                                  number_of_markers::Int)::DataFrame

    # ── 1. Parse S2.1 records ────────────────────────────────────────────────
    markers = DataFrame(marker_id = Int[], chainage = Float64[])

    for i in 1:number_of_markers
        line = rcd_contents[start_index + i - 1]
        marker_id = parse(Int,     strip(line[1:10]))
        chainage  = parse(Float64, strip(line[23:31]))
        push!(markers, (marker_id, chainage))
    end

    # ── 2. Build GTK window ──────────────────────────────────────────────────
    selected_indices = Int[]

    win  = GtkWindow("Select Location Markers", 440, 380)
    vbox = GtkBox(:v)
    Gtk.GAccessor.spacing(vbox, 8)
    Gtk.GAccessor.margin_top(vbox,    10)
    Gtk.GAccessor.margin_bottom(vbox, 10)
    Gtk.GAccessor.margin_start(vbox,  10)
    Gtk.GAccessor.margin_end(vbox,    10)

    # Instruction label
    lbl = GtkLabel("Tick the location markers to include, then click\n\"Accept Selection\" when done.")
    Gtk.GAccessor.xalign(lbl, 0.0f0)
    push!(vbox, lbl)

    # Framed box of checkboxes
    frame      = GtkFrame("Location Markers")
    marker_box = GtkBox(:v)
    Gtk.GAccessor.spacing(marker_box, 4)
    Gtk.GAccessor.margin_top(marker_box,    6)
    Gtk.GAccessor.margin_bottom(marker_box, 6)
    Gtk.GAccessor.margin_start(marker_box,  6)
    Gtk.GAccessor.margin_end(marker_box,    6)

    checkboxes = GtkCheckButton[]
    for row in eachrow(markers)
        label = "$(lpad(row.marker_id, 10, '0'))   –   $(row.chainage) m"
        cb = GtkCheckButton(label)
        push!(marker_box, cb)
        push!(checkboxes, cb)
    end

    push!(frame, marker_box)
    push!(vbox, frame)

    # Accept Selection / Cancel buttons
    hbox       = GtkBox(:h)
    Gtk.GAccessor.spacing(hbox, 10)
    accept_btn = GtkButton("Accept Selection")
    cancel_btn = GtkButton("Cancel")
    push!(hbox, accept_btn)
    push!(hbox, cancel_btn)
    push!(vbox, hbox)
    Gtk.GAccessor.vexpand(hbox, false)   # keep buttons at natural height

    push!(win, vbox)

    # ── 3. Wire signals ──────────────────────────────────────────────────────
    signal_connect(accept_btn, "clicked") do _
        for (i, cb) in enumerate(checkboxes)
            if get_gtk_property(cb, :active, Bool)
                push!(selected_indices, i)
            end
        end
        destroy(win)
    end

    signal_connect(cancel_btn, "clicked") do _
        destroy(win)
    end

    # Destroying the window stops the gtk_main() loop below
    signal_connect(win, "destroy") do _
        Gtk.gtk_quit()
    end

    # ── 4. Show and block until window is closed ─────────────────────────────
    # Show the window first so GTK can complete the initial render pass.
    showall(win)

    # GTK on macOS then writes repeated "drawing failure" warnings directly to
    # file descriptor 2 (bypassing Julia's stderr).  Redirect fd 2 to /dev/null
    # only during the blocking gtk_main() call to suppress that noise.
    saved_fd2 = ccall(:dup,   Cint, (Cint,),        2)
    null_fd   = ccall(:open,  Cint, (Cstring, Cint), "/dev/null", 1)  # O_WRONLY = 1
    ccall(:dup2,  Cint, (Cint, Cint), null_fd, 2)
    ccall(:close, Cint, (Cint,),      null_fd)

    Gtk.gtk_main()   # blocks here; Gtk.gtk_quit() is called on window destroy

    # Restore stderr so subsequent program output is unaffected.
    ccall(:dup2,  Cint, (Cint, Cint), saved_fd2, 2)
    ccall(:close, Cint, (Cint,),      saved_fd2)

    # ── 5. Build and return result DataFrame ─────────────────────────────────
    # For each selected marker at original index i, the section before it ends
    # at the previous marker's chainage (= the start of the selected section).
    # For the very first marker there is no preceding marker, so use 0.0.
    result = markers[selected_indices, :]
    result.start_chainage = [idx == 1 ? 0.0 : markers.chainage[idx - 1]
                             for idx in selected_indices]
    return result
end
