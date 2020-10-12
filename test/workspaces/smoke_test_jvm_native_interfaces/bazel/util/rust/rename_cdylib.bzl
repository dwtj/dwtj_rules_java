def rename_cdylib(name, src, out):
    native.genrule(
        name = name,
        srcs = [src],
        outs = [out],
        cmd = "cp $< $(@)",
    )
