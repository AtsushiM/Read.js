require 'optparse'

attr = {}

opt = OptionParser.new
opt.on('-r VAL', '--root=VAL') {|v| attr[:root] = v }
opt.on('-m VAL', '--main=VAL') {|v| attr[:main] = v }
opt.on('-o VAL', '--output=VAL') {|v| attr[:output] = v }
opt.on('-p', '--remove_read_path') {|v| attr[:remove_read_path] = true }
opt.permute! ARGV
attr[:remove_read_path] ||= false

def readCapture(path, attr)
    stack = []
    buffer = ""
    re = /([^.a-zA-Z0-9$]*)read\((.+?),\s*['"](.+?)['"]\)/
        File.open(path, 'r').each_line do |line|
        stack  += readCapture("#{attr[:root]}/#{$3}.js", attr) if line =~ re
        buffer += attr[:remove_read_path] ? line.gsub(re, '\1read(\2)') : line
        end
    stack << buffer
end

content = readCapture(attr[:main], attr).join("\n")
if attr.has_key? :output
    File.open(attr[:output].to_s, 'w') { |f| f.write content }
else
    print content
end
