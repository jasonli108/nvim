local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("python", {
	-- Your existing main snippet
	s({ trig = "main", name = "main header", desc = "check if __name__ is equal to __main__" }, {
		t('if __name__ == "__main__":'),
	}),

	s({ trig = "__i", name = "constructor", desc = "constructor header" }, {
		t({ "", "  " }),
		i(0, "def __init__(self): "),
	}),

	s({
		trig = "mainss",
		name = "LeetCode Solution Template",
		desc = "Template for a LeetCode solution",
	}, {
		t('if __name__ == "__main__":'),
		t({ "", "    ss = Solution()" }),
		t({ "", '    setattr(ss, "func", ss.isHappy)' }),
		t({ "", "    input_data = 0" }),
		t({ "", "    expect_result = 0" }), -- Placeholder for expect_result
		t({ "", "    actual_result = ss.func(input_data) # type: ignore" }),
		t({ "", "" }),
		t("    try:"),
		t({
			"",
			'        assert actual_result == expect_result, f"Test failed. Expected {expect_result}, got {actual_result}."',
		}),
		t({ "", "" }),
		t("    except AssertionError as e:"),
		t({ "", "        print(e)" }), -- Print exception message
	}),

	s("doc", {
		t({ '"""' }),
		t({ "", "Summary: " }),
		i(1, "Brief description of the function."),
		t({ "", "", "Args:" }),
		t({ "", "    " }),
		i(2, "arg_name: Description of the argument."),
		t({ "", "", "Returns:" }),
		t({ "", "    " }),
		i(3, "Description of the return value."),
		t({ "", '"""' }),
	}),

	-- Updated Triple Quote snippet in the same format
	s({ trig = '"""', name = "Triple Quote", desc = "Python multi-line docstring" }, {
		t({ '"""', "    " }), -- The second string in the table starts a new line with indentation
		i(1, ""), -- Placeholder for your text
		t({ "", '"""' }), -- New line followed by closing quotes
	}),
})
