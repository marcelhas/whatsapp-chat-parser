require 'date'

class Parser
    DATE_LENGTH = 10
    LENGTH_UNTIL_CONTENT = 20

    def initialize(iterable, process_fn)
        @iterable = iterable
        @process_fn = process_fn
    end

    private def init()
        @line_no = 1
        @buf = { author: nil, date: nil, content: nil }
    end

    private def flush()
        # Ignore media files alltogether.
        if @buf[:content] != "<Media omitted>"
            @process_fn.call(@buf)
        end
        @buf[:author] = nil
        @buf[:date] = nil
        @buf[:content] = nil
    end
    
    def parse()
        init()
        @iterable.each do |line|
            # Match example: "31/12/2023, 15:00".
            date_re = /^(\d{2}\/\d{2}\/\d{4})\,\s(\d{2}:\d{2})/
            is_new_msg = date_re.match?(line)  

            if !is_new_msg and @buf[:date] == nil
                raise "Line #{@line_no} is missing associated date!"
            end

            if !is_new_msg and @buf[:author] == nil
                raise "Line #{@line_no} is missing associated author!"
            end

            if is_new_msg 
                flush()
                dateStr = line.slice(0, DATE_LENGTH)
                @buf[:date] = Date.parse(dateStr)

                # Match example: "Marcel: Long content".
                author_and_content_re = /([^:]*):\s(.*)$/
                if author_and_content_re.match(line, LENGTH_UNTIL_CONTENT)
                    @buf[:author] = $1
                    @buf[:content] = $2
                else
                    @buf[:author] = "system"
                    @buf[:content] = line[LENGTH_UNTIL_CONTENT..-1]
                end
            else
                @buf[:content] += "\n" + line
            end

            @line_no += 1
        end
        # Always flush last message.
        flush()
    end
end

