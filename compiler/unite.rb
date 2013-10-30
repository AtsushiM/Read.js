require 'optparse'
require "open-uri"

lambda {
    opt = OptionParser.new

    attr = {}

    opt.on('-r VAL', '--root=VAL') {|v| attr[:root] = v }
    opt.on('-m VAL','--main=VAL') {|v| attr[:main] = v }
    opt.on('-o VAL','--output=VAL') {|v| attr[:output] = v }
    opt.on('-p VAL','--remove_read_path') {|v| attr[:remove_read_path] = v }
    opt.on('-a VAL','--remove_read_all') {|v| attr[:remove_read_all] = v }

    opt.permute!(ARGV)
    attr[:remove_read_path] = attr[:remove_read_path] == '1' ? true : false
    attr[:remove_read_all] = attr[:remove_read_all] == '1' ? true : false
    attr[:readed_path] = []
    attr[:advance_ns] = []

    def readCapture(path, attr)
        stack = []
        buffer = ""

        re = /([^\._a-zA-Z0-9\$]*)read\(['"]([^,]+?)['"],\s*['"](.+?)['"]\)/
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

            if attr[:remove_read_path] || attr[:remove_read_all]
                line =  line.gsub(re, '\1read(\'\2\')')
            end

            buffer += line
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

    if attr[:remove_read_all]
        content = content.gsub(/([^\._a-zA-Z0-9\$]*)read\.ns\(['"](.+?)['"](\,)?/) do |val|
            v1 = $1
            v2 = $2
            v3 = $3

            attr[:advance_ns] << v2

            val = v1 + '(__read_ns[' + attr[:advance_ns].index(v2).to_s + ']='

            if v3.nil?
                val += '{}'
            end

            val
        end

        content = content.gsub(/([^\._a-zA-Z0-9\$]*)read\(['"](.+?)['"]\)/) do |val|
            v1 = $1
            v2 = $2

            index = attr[:advance_ns].index(v2)

            if index.nil?
                index = v2.to_s
            else
                index = '__read_ns[' + index.to_s + ']'
            end

            val = v1 + index

            val
        end

        content = "var __read_ns = [];\n\n" + content
    end

    if attr.has_key? :output
        File.open(attr[:output].to_s, 'w') { |f| f.write content}
    else
        printf content
    end
}.call
