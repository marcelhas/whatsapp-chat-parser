require 'date'

OUT="./out"

def mkdir(path)
    dir = OUT+"/"+path
    if Dir.exist?(dir)
        return
    end
    Dir.mkdir(dir)
end

def write_file(path, url, created)
    p = OUT + "/" +  path
    puts(p)
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

def mk_filename(url)
    re = /\/([^\/]+)\/?$/
    if url =~ re
        return $1
    else
        return url
    end
end

last_date = nil
mkdir("")
File.readlines('input.txt', chomp: true).each do |line|
    re = /^\d{2}\/\d{2}\/\d{4}/
    dateStr = line.slice(0, 10)
    startsWithDate = re.match?(dateStr)  
    if !startsWithDate and last_date == nil
        raise "Line is missing associated date!"
    end

    date = last_date
    if startsWithDate 
        date = Date.parse(dateStr)
        last_date = date
    end

    contentRe = /masl\: (.*)/
    match = contentRe.match(line)
    if match
        puts(date.to_s + ": " + match[1])
        path = date.strftime("%Y-%m")
        mkdir(path)
        url = match[1]
        filename = mk_filename(url)
        created = date.strftime("%Y-%m-%d")
        write_file("#{path}/#{filename}", url, created)
    else
        # Ignore.
    end
end

