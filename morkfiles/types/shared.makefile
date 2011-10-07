
define module_type_shared

$$(eval $$(call module_type_native,$(1),$(2)))

$(2)_main = $(1)/$(static_output_dir)/$(shared_output_prefix)$(2)$(shared_output_suffix)
$(2)_output_dirs = $(1)/$(cpp_output_dir) $(1)/$(shared_output_dir) $(1)/gen $(1)/depends

$$($(2)_main): $$($(2)_cpp_outputs)
	$($(2)_prebuild)
	mkdir -p $(1)/$(shared_output_dir)
	$(shared_tool) $(shared_flags) $(shared_output)$$($(2)_main) $$($(2)_cpp_outputs)
	$($(2)_postbuild)

# Share libraries that need to be on the path (or copied) for an executable
$(2)_sharedlibs = $$($(2)_main) $$(foreach r,$$($(2)_requires),$$($$(r)_sharedlibs))

# The linker flags needed to link to this module (order is important on Linux!)
$(2)_link = $(exe_libpath_prefix)$(1)/$(shared_output_dir) $(exe_libname_prefix)$$($(2)_main) \
		$$(foreach r,$$($(2)_requires), $$($$(r)_link))

endef
