require 'optparse'
opt = OptionParser.new

attr = {}

opt.on('-r VAL', '--root=VAL') {|v| attr[:root] = v }
opt.on('-m VAL','--main=VAL') {|v| attr[:main] = v }
opt.on('-o VAL','--output=VAL') {|v| attr[:output] = v }
opt.on('-p VAL','--remove_read_path') {|v| attr[:remove_read_path] = true }

opt.permute!(ARGV)
attr[:remove_read_path] ||= false
attr[:readed_path] = []

def readCapture(path, attr)
    stack = []
    buffer = ""

    re = /([^\._a-zA-Z0-9\$]*)read\((.+?),\s*['"](.+?)['"]\)/

    attr[:readed_path] << path
    File.open(path, 'r').each_line do |line|
        if line =~ re
            stack += readCapture("#{attr[:root]}/#{$3}.js", attr) unless attr[:readed_path].index "#{attr[:root]}/#{$3}.js"
        end
        buffer += attr[:remove_read_path] ? line.gsub(re, '\1read(\2)') : line
    end

    stack << buffer
end

content = readCapture(attr[:main], attr).join("\n")

if attr.has_key? :output
    File.open(attr[:output].to_s, 'w') { |f| f.write content}
else
    printf content
end
