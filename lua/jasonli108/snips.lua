local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("python", {
	s({ trig = "main", name = "main header", desc = "check if __name__ is equal to the __main__" }, {
		t('if __name__ == "__main__":'),
	}),
})

ls.add_snippets("python", {
	s({ trig = "__i", name = "constructor", desc = "constructor header" }, {
		t({ "", "  " }),
		i(0, "def __init__(self): "),
	}),
})

ls.add_snippets("python", {
	s({
		trig = "mainss",
		name = "LeetCode Solution Template",
		desc = "Template for a LeetCode solution",
	}, {
		t('if __name__ == "__main__":'),
		t({ "", "    ss = Solution()" }),
		t({ "", "    input_data = 0" }),
		t({ "", "    expect_result = 0" }), -- Placeholder for expect_result
		t({ "", "    actual_result = ss.func(input_data)" }),
		t({ "", "" }),
		t("    try:"),
		t({
			"",
			'        assert actual_result == expect_result, "Test failed. Expected {expect_result}, got {actual_result}. Please check your code and try again."',
		}),
		t({ "", "" }),
		t("    except AssertionError as e:"),
		t({ "", "        print(e)" }), -- Print exception message
	}),
})

ls.add_snippets("python", {
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
})
