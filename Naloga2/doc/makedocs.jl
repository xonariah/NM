using Weave

Weave.weave(
    "doc/porocilo.jl",          
    doctype = "md2pdf",
    out_path = "pdf",
    args = Dict("latex_code_style" => "minted")
)
