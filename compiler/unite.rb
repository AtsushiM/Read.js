initvalue = {}

ARGV.each { |argstr|
    arg = argstr.split '='
    initvalue[arg[0]] = arg[1]
}

$root = initvalue['-root']
$main = initvalue['-main']

def raiseNoOption (name)
    raise 'input ' + name + ' option.  sample: ruby unite.rb -root=path/to/dir -main=path/to/dir/file.js'
end
unless $root
    raiseNoOption '-root'
end
unless $main
    raiseNoOption '-main'
end

$output = initvalue['-output']
$remove_read_path = initvalue['-remove_read_path']
$depths = []

$root += '/' unless $root[$root.length - 1] == '/'

def depthLoop (path)
    f = open(path)

    value = "\n" + f.read

    f.close

    reg = '(\n|=|,|;|:|\(|&|\|)\s*read\(.+?,\s*[\'"](.+?)[\'"]\)'

    while index = /#{reg}/ =~ (value)
        # p $2
        jspath = $root + $2 + '.js'

        depthLoop jspath

        value = value[index+$&.length..value.length]
    end

    $depths << path unless $depths.index path
end

def uniteJSFiles (array)
    value = ''

    array.each { |jspath|
        f = open(jspath)

        value += "\n" + f.read

        f.close
    }

    if $remove_read_path
        value = value.gsub(/(\n|=|,|;|:|\(|&|\|)([ \t]*)read\((.+?),\s*['"].+?['"]\)/, '\1\2read(\3)')
    end

    unless $output
        printf value
    else
        output_file = File.open($output, 'w')
        output_file.write value
    end
end

depthLoop $main

uniteJSFiles $depths
