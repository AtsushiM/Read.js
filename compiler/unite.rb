require 'optparse'
opt = OptionParser.new

OPTS = {}

opt.on('-r VAL', '--root=VAL') {|v| OPTS[:root] = v }
opt.on('-m VAL','--main=VAL') {|v| OPTS[:main] = v }
opt.on('-o VAL','--output=VAL') {|v| OPTS[:output] = v }
opt.on('-p VAL','--remove_read_path=VAL') {|v| OPTS[:remove_read_path] = v }

opt.parse!(ARGV)

@root = OPTS[:root]
@main = OPTS[:main]

def raiseNoOption (name)
    raise 'input ' + name + ' option.  sample: ruby unite.rb -root=path/to/dir -main=path/to/dir/file.js'
end

raiseNoOption '-root' unless @root
raiseNoOption '-main' unless @main

@output = OPTS[:output]
@remove_read_path = OPTS[:remove_read_path]
@depths = []
@reg = /(\n|=|,|;|:|\(|&|\|)([ \t]*)read\((.+?),\s*['"](.+?)['"]\)/

@root += '/' unless @root[-1] == '/'

def depthLoop (path)
    f = open(path)

    value = "\n" + f.read

    f.close

    while index = @reg =~ (value)
        jspath = @root + $4 + '.js'

        depthLoop jspath

        value = value[index+$&.length..value.length]
    end

    @depths << path unless @depths.index path

    @depths
end

def uniteJSFiles (array)
    value = ''

    array.each do |jspath|
        f = open(jspath)

        value += "\n" + f.read

        f.close
    end

    if @remove_read_path == '1'
        value = value.gsub(@reg, '\1\2read(\3)')
    end

    unless @output
        printf value
    else
        output_file = File.open(@output, 'w')
        output_file.write value
    end

    value
end

uniteJSFiles depthLoop @main
