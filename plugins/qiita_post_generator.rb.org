# -*- encoding: utf-8 -*--
require 'qiita'

module Jekyll
  class QiitaPost < Page
    def initialize(site, title, content, name, url, options)
      @dir = '_qiita_post'
      @site = site
      @title = title
      @name = name
      @url = url
      @tags = options["tags"]
      @private = options["private"]

      self.output = content.dup
      self.adjust_content!
      self.process @name
    end

    def posted_item?
      File.exists? self.file_path
    end

    def post_item(qiita)
      qiita.post_item title: @title, body: self.output, tags: @tags, private: @private
      self.write site.source
      puts "posted to Qiita (#{@title})."
    end

    def adjust_content!
      self.output.gsub! /\n? *<!-- *more *--> *\n/, "\n"
      self.output.gsub! /\n? *\[!.+\](.+) *\n/, "\n"
      self.output << <<-ORIGIN


[元記事](#{site.config['url'] + @url})
      ORIGIN
    end

    def destination(dest)
      File.join(dest, @dir, self.name)
    end

    def file_path
      self.destination site.source
    end
  end

  class QiitaPostGenerator < Generator
    safe true

    def generate(site)
      qiita_token = site.config['qiita_token']
      return unless qiita_token
      site.posts.each do |post|
        if post.data["qiita"] && post.data["published"]
          qiita = Qiita.new token: qiita_token
          q_post = QiitaPost.new site, post.data["title"], post.content, post.name, post.url, post.data["qiita"]
          q_post.post_item qiita unless q_post.posted_item?
        end
      end
    end
  end
end
