require 'date'

class Parser
    DATE_LENGTH = 10
    LENGTH_UNTIL_CONTENT = 20

    def initialize(iterable, process_fn)
        @iterable = iterable
        @process_fn = process_fn
    end

    private def init()
        @last_date = nil
        @last_author = nil
        @line_no = 1
        @buf = nil
    end

    private def emit()
        # Ignore media files alltogether.
        if @buf[:content] != "<Media omitted>"
            @process_fn.call(@buf)
        end
        @buf = nil
    end
    
    def parse()
        init()
        @iterable.each do |line|
            date_re = /^(\d{2}\/\d{2}\/\d{4})\,\s(\d{2}:\d{2})/
            starts_with_date = date_re.match(line)  
            if starts_with_date and @buf
                emit()
            end
            if !starts_with_date and @last_date == nil
                raise "Line #{@line_no} is missing associated date!"
            end

            if !starts_with_date and @last_author == nil
                raise "Line #{@line_no} is missing associated author!"
            end

            author = @last_author
            date = @last_date
            content = nil
            if starts_with_date 
                dateStr = line.slice(0, DATE_LENGTH)
                date = Date.parse(dateStr)
                @last_date = date

                author_and_content_re = /([^:]*):\s(.*)$/
                if author_and_content_re.match(line, LENGTH_UNTIL_CONTENT)
                    author = $1
                    content = $2
                else
                    author = "system"
                    content = line[LENGTH_UNTIL_CONTENT..-1]
                end
                @last_author = author
            else
                content = line
            end

            if @buf == nil
                @buf = { author: author, date: date, content: content}
            else
                @buf = { author: author, date: date, content: @buf[:content] + "\n" + content}
            end


            @line_no += 1
        end
        if @buf != nil
            emit()
        end
    end
end

