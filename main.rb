require 'date'
require_relative 'lib'

OUT="./out"
def mkdir(path)
    dir = OUT + "/" + path
    if !Dir.exist?(dir)
        Dir.mkdir(dir)
    end
end

def write_read_this_file(path, url, created)
    p = OUT + "/" +  path
    if File.exist?(p) 
        raise "File #{path} already exists!"
    end
    File.open(p, "w") do |file|
        # Properties.
        file.puts("---")
        file.puts("tags:")
        file.puts("  - read/open")
        file.puts("created: #{created}")
        file.puts("finished: ")
        file.puts("url: #{url}")
        file.puts("rating: ")
        file.puts("---")
        # Summary.
        file.puts("> TODO: Add summary.")
        file.puts("")
        # Related.
        file.puts("# Related")
        file.puts("")
        file.puts("- -")
    end
end

def write_use_this_file(path, url, created)
    p = OUT + "/" +  path
    if File.exist?(p) 
        raise "File #{path} already exists!"
    end
    File.open(p, "w") do |file|
        # Properties.
        file.puts("---")
        file.puts("tags:")
        file.puts("  - meta/todo")
        file.puts("created: #{created}")
        file.puts("url: #{url}")
        file.puts("keywords: ")
        file.puts("---")
        # Summary.
        file.puts("> TODO: Add summary.")
        file.puts("")
    end
end

def mk_filename(url)
    re = /\/([^\/]+)\/?$/
    if url =~ re
        return $1
    else
        return url
    end
end

process_read_fn = lambda do |msg|
    puts msg
    if msg[:author] == "masl"
        path = "read/#{msg[:date].strftime("%Y-%m")}"
        mkdir(path)
        
        filename = mk_filename(msg[:content])
        url = msg[:content]
        created = msg[:date].strftime("%Y-%m-%d")
        write_read_this_file("#{path}/#{filename}", url, created)
    else
        # Ignore.
    end
end

process_use_fn = lambda do |msg|
    puts msg
    if msg[:author] == "masl"
        path = "use"
        mkdir(path)
        
        filename = mk_filename(msg[:content])
        if msg[:content] == ""
            return # Ignore.
        end
        url = msg[:content]
        created = msg[:date].strftime("%Y-%m-%d")
        write_use_this_file("#{path}/#{filename}", url, created)
    else
        # Ignore.
    end
end

mkdir("")
mkdir("read")
parser1 = Parser.new(File.readlines('input.txt', chomp: true), process_read_fn)
parser1.parse()
mkdir("use")
parser2 = Parser.new(File.readlines('input2.txt', chomp: true), process_use_fn)
parser2.parse()
