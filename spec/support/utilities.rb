# builds the title for each page (title must be provided in each page)
def full_title(page_title)
	base_title = "Prestissimo"
	if page_title.empty?
		base_title
	else
		"#{base_title} | #{page_title}"
	end
end

