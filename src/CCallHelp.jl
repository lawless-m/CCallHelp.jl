module CCallHelp

export free_ptr, string_from_ptr, vec_string_from_ptr

"""
    free_ptr(ptr; free=true)  
Free the given ptr if not C_NULL.
# Arguments
- `ptr` the C pointer to be freed
- `free` a conditional flag to prevent an `if` at the call site
"""
free_ptr(ptr; free=true) = if free && ptr != C_NULL ccall(:free, Cvoid, (Ptr{Cvoid},), Ptr{Cvoid}(ptr)) end

"""
    string_from_ptr(ptr::Ptr{Cuchar}; free=true)
Create a Julia String from a memory location a byte at a time.
# Arguments
- `ptr` pointer to use
- `free` flag to determine if the memory should be freed once copied
"""
function string_from_ptr(ptr::Ptr{Cuchar}; free=true)
    if ptr == C_NULL
        return ""
    end
    uchars = Vector{UInt8}()
    i = 1
    while (c = unsafe_load(ptr, i)) != 0
        push!(uchars, c)
        i += 1
    end
    free_ptr(ptr; free)
    String(uchars)
end

"""
    vec_string_from_ptr(ptr_ptr_uchar; free=true)
Create a Vector{String} from the supplied list of uchar*
# Arguments
- `ptr` the pointer to the list
- `free` flag to determine if the memory of both the strings and the list should be freed once copied
"""
function vec_string_from_ptr(ptr::Ptr{Ptr{Cuchar}}; free=true)
    if ptr == C_NULL
        return String[]
    end
    strings = Vector{String}()
    i = 1
    while (stringp = unsafe_load(ptr,i)) != C_NULL
        push!(strings, string_from_ptr(stringp; free))
        i += 1
    end
    free_ptr(ptr; free)
    strings
end


###
end
