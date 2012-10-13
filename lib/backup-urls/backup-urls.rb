#!/usr/bin/env ruby
# coding: utf-8
# Copyright muflax <mail@muflax.com>, 2011
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

module BackupUrls
  def self.backup urls, target
    # number of parallel wgets
    parallel_num = 20

    puts "filtering urls..."
    urls = filter_urls urls

    puts "mirroring into #{target}..."
    Dir.chdir target

    exts = Extensions.map{|e| ".#{e}"}.join(",")
    opts = "--quiet --continue --page-requisites -e robots=off --timestamping --reject #{exts} --timeout=15 --ignore-case --convert-links"

    Parallel.each_with_index(urls, :in_threads=>parallel_num) do |url, i|
      puts "backing up (#{i+1}/#{urls.size}): #{url}"
      system "wget #{opts} '#{url}'" unless Debug
    end

    puts "cleaning up..."

    # remove large files
    system "find #{target} -size '+#{FileLimit}' -delete" unless Debug

    # remove empty files
    system "find #{target} -size 0 -delete" unless Debug

    # remove duplicates
    system "ftwin -r #{target} | ftwin-hardlink.rb" unless Debug
  end
end
