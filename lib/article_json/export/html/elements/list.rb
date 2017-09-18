module ArticleJSON
  module Export
    module HTML
      module Elements
        class List < Base
          def build
            create_element(tag_name).tap do |list|
              @element.content.each do |child_element|
                item = create_element(:li)
                item.add_child(Paragraph.new(child_element).build)
                list.add_child(item)
              end
            end
          end

          private

          def tag_name
            @element.list_type == :ordered ? :ol : :ul
          end
        end
      end
    end
  end
end