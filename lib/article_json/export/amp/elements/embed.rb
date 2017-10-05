module ArticleJSON
  module Export
    module AMP
      module Elements
        class Embed < Base
          include Shared::Caption
          attr_reader :amp_library

          def export
            @amp_library = nil
            create_element(:figure).tap do |figure|
              figure.add_child(embed_node)
              figure.add_child(caption_node(:figcaption))
            end
          end

          def type_specific_node
            case @element.embed_type.to_sym
            when :youtube_video
              youtube_node
            when :vimeo_video
              vimeo_node
            when :facebook_video
              facebook_node
            when :tweet
              tweet_node
            when :slideshare
              slideshare_node
            end
          end

          private

          def embed_node
            create_element(:div, class: 'embed').tap do |div|
              div.add_child(type_specific_node)
            end
          end

          def youtube_library
            '<script async custom-element="amp-youtube" ' \
            'src="https://cdn.ampproject.org/v0/amp-youtube-0.1.js"></script>'
          end

          def youtube_node
            @amp_library = youtube_library
            create_element('amp-youtube',
                           'data-videoid' => @element.embed_id,
                           width: default_width,
                           height: default_height)
          end

          def vimeo_library
            '<script async custom-element="amp-vimeo"' \
            'src="https://cdn.ampproject.org/v0/amp-vimeo-0.1.js"></script>'
          end

          def vimeo_node
            @amp_library = vimeo_library
            create_element('amp-vimeo',
                           'data-videoid' => @element.embed_id,
                           width: default_width,
                           height: default_height)
          end

          def tweet_library
            '<script async custom-element="amp-twitter" ' \
            'src="https://cdn.ampproject.org/v0/amp-twitter-0.1.js"></script>'
          end

          def tweet_node
            @amp_library = tweet_library
            create_element('amp-twitter',
                           'data-tweetid' => @element.embed_id,
                           width: default_width,
                           height: default_height)
          end

          def facebook_library
            '<script async custom-element="amp-facebook" ' \
            'src="https://cdn.ampproject.org/v0/amp-facebook-0.1.js"></script>'
          end

          def facebook_node
            @amp_library = facebook_library
            url = "#{@element.oembed_data[:author_url]}videos/#{@element.embed_id}"
            create_element('amp-facebook',
                           'data-embedded-as' => 'video',
                           'data-href' => url,
                           width: default_width,
                           height: default_height)
          end

          def iframe_library
            '<script async custom-element="amp-iframe"' \
            'src="https://cdn.ampproject.org/v0/amp-iframe-0.1.js"></script>'
          end

          def slideshare_node
            @amp_library = iframe_library
            node = Nokogiri::HTML(@element.oembed_data[:html]).xpath('//iframe')
            create_element('amp-iframe',
                           src: node.attribute('src').value,
                           width: node.attribute('width').value,
                           height: node.attribute('height').value,
                           frameborder: '0',)
          end

          def default_width
            '560'
          end

          def default_height
            '315'
          end
        end
      end
    end
  end
end
