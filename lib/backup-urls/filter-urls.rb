#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-
# Copyright muflax <mail@muflax.com>, 2012
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

# filtered hosts
module BackupUrls
  Hosts = [
           # chans
           /\d+chan\.\w+/,

           # video sites
           /beeq\.com/,
           /motherless\.com/,
           /mypinktube\.com/,
           /ted\.com/,
           /thedailyshow\.com/,
           /videos\.arte\.tv/,
           /vimeo\.com/,
           /xhamster\.com/,
           /youtube\.com/,
           
           # search sites
           /\/search\//,
           /\/search\.php/,
           /findtubes\.com/,
           /google\.com\/search/,
           /isohunt\.com/,
           /jpopsuki\.eu/,
           /lesswrong\.com\/search/,
           /library\.nu\/search/,
           /piratebay\.org/,
           /search(\?q)?=/,
           /search\?/,
           /wikipedia.*search=\w+/,
           
           # hosting sites
           /megaupload\.com/,
           /rapidshare\.com/,
           /warez-bb\.org/,

           # random sites without useful content
           /amazon\.\w+/,
           /github\.com/,
           /google\.\w+/,
           /imdb\.\w+/,
           /librarything\.com/,

           # archives
           /archive\.org/,
           /webcache\.googleusercontent\.com/,
           
           # session ids
           /\/session\//,
           /session(_?)(id)?=\w+/,
           /sid=\w+/,
           
           # local IPs
           /127\.0\.0\.1/,
           /192\.\d+\.\d+\.\d+/,
           /localhost/,

           # my own stuff
           /muflax\.com/,

           # wikipedia
           /wiki(p|m)edia\.\w+/,

           # short URL sites
           /bit\.ly/,
           /t\.co/,
           /tinyurl\.com/,

           # reddit-y sites (way too slow and huge)
           /(lesswrong|reddit)\.com/,

           # beeminder (I also save my data locally)
           /beeminder\.com/,

           # twitter (also locally)
           /twitter\.com/,

           # predictionbook newsfeeds
           /predictionbook\.com\/predictions\/(future|judged|new|unjudged)/,
           /predictionbook\.com\/happenstance/,
          ]

  # skip this stuff
  Extensions = [
                # execs
                "bin",
                "exe",
                "iso",
                "jar",

                # archives
                "7z",
                "bz2",
                "gz",
                "rar",
                "tar",
                "xz",
                "zip",

                # video / audio
                "avi",
                "flv",
                "mkv",
                "mov",
                "mp3",
                "mp4",
                "ogg",
                "swf",
                "webm",
                "wmv",

                # docs
                "djvu",
                "epub",
                "mobi",
                "pdf",

                # misc
                "torrent",
               ]

  # delete files over that size
  FileLimit = "4M"

  def self.filter_urls urls
    # remove trailing slashes
    urls.map!{|u| u.chomp.sub(%r{/$}, "")}

    # remove duplicates
    urls.uniq!

    # remove local files
    urls.delete_if{|u| u.match /^file:/}

    # remove useless hosts
    Hosts.each{|host| urls.delete_if{|u| u.match host}}

    # remove all file extensions (wget doesn't catch them
    Extensions.each{|ext| urls.delete_if{|u| u.match /\.#{ext}\b/}}

    if Debug
      # make debug mode deterministic
      urls.sort! 
    else
      # shuffle them to avoid polling the same server
      urls.shuffle!
    end

    urls
  end
end
