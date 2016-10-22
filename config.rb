###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

set :markdown_engine, :kramdown
set :markdown, parse_block_html: true

#Setup Config vars


# With alternative layout
# page "/path/to/file.html", layout: :otherlayout

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

# General configuration

# Reload the browser automatically whenever files change
configure :development do
  config[:host] = "localhost:4567"
  activate :livereload
end

###
# Helpers
###

# Methods defined in the helpers block are available in templates
 helpers do

    def txt_links(array)
       return array.map{ |e|
         app.link_to e.txt, e.url, :target => "_blank"
       }.join(' ')
     end

    def img_links(array)
      links =  array.map{ |e|
        img = app.image_tag(e.img_url, :class => e.img_class, :alt => e.img_alt)
        app.link_to img, e.url, :class => e.img_class,:target => "_blank"
      }.join(' ')

      return links
    end

    def img_links_from_hash(hash)
      links = ""

      hash.each do |k, v|
        if v.url
          img = app.image_tag(v.img_url, :class => v.img_class, :alt => v.img_alt)
          link = app.link_to img, v.url, :class => v.img_class,:target => "_blank"
          links = "#{links} #{link}"
        end
      end

      links
    end

    def share_link(img_props,share_url)
      img = app.image_tag img_props.img_url, :alt => img_props.img_alt
      link = app.link_to img, share_url, :title => "Share on <%= img_props.img_alt%>",:target => "_blank", :rel => "nofollow", :class => "share-btn"
    end
 end

 activate :blog do |blog|
   # Matcher for blog source files
   # blog.taglink = "tags/{tag}.html"
   blog.layout = "layouts/blog_layout"
   # blog.summary_separator = /(READMORE)/
   blog.summary_length = 250
   # blog.year_link = "{year}.html"
   # blog.month_link = "{year}/{month}.html"
   # blog.day_link = "{year}/{month}/{day}.html"

   blog.tag_template = "tag.html"
   blog.calendar_template = "calendar.html"

   #set up blog urls
   blog.prefix = "posts"# This will add a prefix to all links, template references and source paths
   blog.permalink = "{title}" #"{year}/{month}/{day}/{title}.html"
   blog.sources = "{year}-{month}-{day}-{title}.html" # define year-month-day in filename to make an organized dir
   blog.default_extension = ".markdown"

   # Enable pagination
   blog.paginate = true
   blog.per_page = 1
   blog.page_link = "#{blog.prefix}/page/{num}"
 end

 activate :syntax, :line_numbers => true

 activate :deploy do |deploy|
   deploy.user = 'JTronLabs'
   deploy.deploy_method = :git
   deploy.remote   = 'deploy' #added a custom remote to the .git repo in the build/ folder
   deploy.branch = 'master'
   deploy.build_before = true
 end

# Build-specific configuration
configure :build do
  config[:host] = "jtronlabs.com"

  # Minify CSS and JS on build
  activate :minify_css
  activate :minify_javascript

  activate :relative_assets
  set :relative_links, true
end
