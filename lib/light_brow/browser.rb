module LightBrow
  class Browser

    attr_accessor :history_index

    def initialize
      @history_index = 0
    end

    def run
      welcome
      loop do
        input
        break if quit?
        handle
      end
    end

    private

    def welcome
      menu = <<-menutext
Welcome to Lighthouse Browser - Aka LightBrow
      menutext
      puts menu.colorize(:yellow)
      help
    end

    def help
      help = <<-helptext
COMMANDS:
\\? - help text
\\q - quit
\\h - history
\\b - back
      helptext
      puts help.colorize(:blue)
    end

    def handle
      if command?
        handle_command
      else
        visit(@input)
      end
    end

    def command?
      @input.start_with? '\\'
    end

    def handle_command
      case @input
      when '\\?' # \?
        help
      when '\\h' # \h
        history
      when '\\b' 
        back
      when '\\f' # \f
        forward
      end
    end

    def history
      Page.all.each {|page| puts page.address}
    end

    def back
      page = Page.where("created_at < ?", @current_page.created_at).order('created_at DESC').first
      
      if page
        fetch_and_render_page(page.address)
        @current_page = page
      else
        puts 'There is no page backawrd!!!'
      end 
    end

    def forward
      page = Page.where("created_at > ?", @current_page.created_at).order('created_at ASC').first

      if page
        fetch_and_render_page(page.address)
        @current_page = page
      else
        puts 'There is no page foward!!!'
      end
    end

    def fetch_and_render_page(url)
      if response = fetch(url)
        @page = HTMLPage.new(response.body)
        display rescue puts " ! Invalid URL ! ".black.on_red
      else
        puts " ! Invalid URL ! ".black.on_red
      end
    end

    def visit(url)
      if fetch_and_render_page(url)
        Page.delete_all(["created_at > ?", @current_page.created_at]) if @current_page
        @current_page = Page.create(address: @input)
        # User.first.pages << @current_page
      end
    end

    def fetch(uri_str, limit = 5)
      # You should choose a better exception.
      raise ArgumentError, 'too many HTTP redirects' if limit == 0

      response = Net::HTTP.get_response(URI(uri_str))

      case response
      when Net::HTTPSuccess then
        
        response

      when Net::HTTPRedirection then
        location = response['location']
        warn "redirected to #{location}"
        fetch(location, limit - 1)
      else
        response.value
      end
    end

    def display
      print_info "Title", @page.title
      print_info "Description", @page.description
      print_info "Links"
      @page.links.each_with_index do |link, i|
        puts "#{i}. #{link}"
      end
    end

    def menu
      puts "--".colorize(:blue)
      puts "Where to next?"
      print "url> ".colorize(:blue)
    end

    def input
      menu
      @input = gets.chomp
    end

    def quit?
      @input == '\q'
    end

    def print_info(label, value=nil)
      print "#{label}: ".colorize(:red)
      puts value
    end

  end

end
