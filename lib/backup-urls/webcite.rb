#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-
# Copyright muflax <mail@muflax.com>, 2012
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

require "awesome_print"

module BackupUrls
  def self.archive urls
    puts "filtering urls..."
    urls = filter_urls urls

    # save citation urls
    cites = {}
    
    # go to webcite
    agent = Mechanize.new
    agent.follow_meta_refresh = true
    agent.user_agent_alias    = 'Windows Mozilla'
    page = agent.get "http://www.webcitation.org/archive.php"
    form = page.forms.first

    urls.each do |url|
      puts "archiving '#{url}' on webcite..."

      # enter data
      form["url"]   = url
      form["email"] = "mail@muflax.com"

      # send, grab short form
      result = agent.submit form

      link = result.link_with :text => /Archived by WebCite® at/
      unless link.nil?
        puts "  -> #{link.href}"
        cites[url] = link.href
      end

      # avoid overloading the site
      sleep 1
    end
    
  cites
  end
end
