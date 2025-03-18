extends Control  # The script is attached to the StorybookIntro (Control) node

var pages = []  # Stores all the pages
var current_index = 0  # Keeps track of which page is currently displayed

func _ready():
	pages = $PageContainer.get_children()  # Get all the child nodes inside PageContainer
	print("Pages found:", pages.size())  # Debugging: Check if pages are detected

	if pages.size() == 0:
		print("ERROR: No pages found inside PageContainer!")
		return  # Stop execution if no pages found

	# Hide all pages except the first one
	for i in range(1, pages.size()):
		pages[i].modulate.a = 0  # Make pages invisible

	print("Starting page transitions...")  
	show_next_page()  # Start transitioning pages

func show_next_page():
	if current_index >= pages.size():
		print("End of pages reached. Exiting storybook.")
		return  # Stop if all pages have been shown

	# Hide previous page (if not the first page)
	if current_index > 0:
		pages[current_index - 1].modulate.a = 0  # Make previous page invisible

	print("Showing Page:", current_index + 1)  # Debugging output

	# Fade in the next page
	var tween = create_tween()
	pages[current_index].modulate.a = 0  # Start fully transparent
	tween.tween_property(pages[current_index], "modulate:a", 1, 1.5)  # Fade-in over 1.5 sec

	current_index += 1  # Move to the next page

	# Wait 3 seconds before transitioning to the next page
	await get_tree().create_timer(3.0).timeout  
	show_next_page()  # Call itself to show the next page
