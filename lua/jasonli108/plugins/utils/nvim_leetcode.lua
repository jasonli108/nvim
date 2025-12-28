return {
	"jasonli108/nvim_leetcode",
	-- dir = "~/CS/nvim_leetcode/",
	opts = {},
	config = function(_, opts)
		require("nvim-leetcode").setup({})
		-- if you encounter an error, refresh leetcode login by log out and log back in, get the new csrf and leetcode cookies web dev -> app -> cookies -> leetcode-session, csrftoken
		-- in fish config or in terminal like so
		--
		-- set -g LEETCODE_SESSION "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfYXV0aF91c2VyX2lkIjoiMTk4NjUzOSIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImFsbGF1dGguYWNjb3VudC5hdXRoX2JhY2tlbmRzLkF1dGhlbnRpY2F0aW9uQmFja2VuZCIsIl9hdXRoX3VzZXJfaGFzaCI6IjE0NjJiZjJlMmIwYmU2MDkzYzAwMDc4YTc3M2NiM2IyMjYzZmNkNjhlYTQ3MDc5NDNkMjNkZGMwY2FjYTdhOGYiLCJzZXNzaW9uX3V1aWQiOiI3ZWY5Mjk1ZSIsImlkIjoxOTg2NTM5LCJlbWFpbCI6Imphc29ubGkxMDhAZ21haWwuY29tIiwidXNlcm5hbWUiOiJqYXNvbmxpMTA4IiwidXNlcl9zbHVnIjoiamFzb25saTEwOCIsImF2YXRhciI6Imh0dHBzOi8vYXNzZXRzLmxlZXRjb2RlLmNvbS91c2Vycy9kZWZhdWx0X2F2YXRhci5qcGciLCJyZWZyZXNoZWRfYXQiOjE3NjY2MzkxODMsImlwIjoiNzIuNjkuMTA5LjEyOCIsImlkZW50aXR5IjoiOGRmMWQxZTFkMmM1ODRlNGEwMTU4NGRiZTkyNTE3NDQiLCJkZXZpY2Vfd2l0aF9pcCI6WyJjNTUxYTNiMDIxMmVmZGNmYzgzZmVjZDJmNzI5YzMzNSIsIjcyLjY5LjEwOS4xMjgiXSwiX3Nlc3Npb25fZXhwaXJ5IjoxMjA5NjAwfQ.aN3jrfg4vPqyfIEL0IgzeflTot5W8kla2M9lSooiCNo"
		-- set -g CSRF_TOKEN "wAWXqUWz6vTZjOnM6XqcMVCVydDZ7j6W"
		--
	end,
}
