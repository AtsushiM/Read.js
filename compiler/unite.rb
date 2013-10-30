require 'optparse'
require "open-uri"

lambda {
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
        is_external = /^(\/\/|http)/

        attr[:readed_path] << path

        readed = lambda do |line|
            if line =~ re
                nextpath = $3

                if nextpath !~ /^(\/\/|http)/
                    nextpath = "#{attr[:root]}/#{nextpath}"
                end
                if nextpath !~ /\.[a-z0-9]+$/
                    nextpath += '.js'
                end

                stack += readCapture(nextpath, attr) unless attr[:readed_path].index nextpath
            end
            buffer += attr[:remove_read_path] ? line.gsub(re, '\1read(\2)') : line
        end

        if path =~ is_external
            open(path, 'r').each_line do |line|
                readed.call line
            end
        else
            File.open(path, 'r').each_line do |line|
                readed.call line
            end
        end

        stack << buffer
    end

    content = readCapture(attr[:main], attr).join("\n")

    if attr.has_key? :output
        File.open(attr[:output].to_s, 'w') { |f| f.write content}
    else
        printf content
    end
}.call
