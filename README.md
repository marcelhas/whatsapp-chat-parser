# whatsapp-chat-parser

> [!WARNING]
> This script was written for a course to learn Ruby.
> For real usecases, you should look at more elaborate/robust 
> implementations like [this](https://github.com/Pustur/whatsapp-chat-parser)
> or [this](https://github.com/PetengDedet/WhatsApp-Analyzer)!

> [!NOTE]
> Media and attachments are not supported!

Process Whatsapp chat exports programmatically with ruby.

## Usage

1. Export your Whatsapp chat without media
   - See [Whatsapp FAQ](https://faq.whatsapp.com/1180414079177245/?helpref=uf_share)
2. Place the resulting `.txt` file in the same folder as this `README.md`
3. Make sure ruby version >=3 is installed
   - Use the provides nix flake if you can
4. Create your own driver file (see [main.rb](./main.rb) for reference usage)

```ruby
# Define process lambda function.
process = lambda do |msg|
    author  = msg[:author]
    date    = msg[:date]
    content = msg[:content]
    # Do whatever you want with this.
end

# Open file and create parser.
file = File.readlines('input.txt', chomp: true)
parser = Parser.new(file, process_read_fn)

# Start parsing!
parser.parse()
```

```shell
# Execute the script.
ruby your_file.rb
```


## License

[MIT](./LICENSE) License © 2023-Present [marcelhas](https://github.com/marcelhas)

