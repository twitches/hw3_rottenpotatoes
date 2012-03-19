# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create! movie
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  # Make sure we know how many table columns we're dealing with.
  header = page.find(:xpath, "//table[@id='movies']//tr").text
  cols = header.split("\n").size
  # Grab the titles out of the table.
  table = page.find("table#movies").text
  titles = table.split("\n").
    select.with_index { |_,i| i%cols==0}.
    drop(1)
  assert titles.index(e1) < titles.index(e2)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.gsub(/\s/, '').
    split(',').
    each do |rating|
    step %{I #{uncheck}check "ratings[#{rating}]"}
  end
end

Then /I should see (all|none) of the movies/ do |range|
  expected = (range=="all") ? Movie.all.size : 0
  # We expect one row for the header.
  expected += 1
  assert page.has_css?("table#movies tr", :count => expected)
end
