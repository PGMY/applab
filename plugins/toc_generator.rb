#
# require 'nokogiri'
#
# module Jekyll
#   module TOCGenerator
#     TOC_CONTAINER_HTML = '<table cellpadding="0" cellspacing="0" id="toc-container"><tbody><td><section class="toc-panel"><div class="toc-heading"><h3 class="toc-title"><span class="glyphicon glyphicon-list-alt"></span> %1</h3></div><ul id="toc-listing">%2</ul></section></td></tbody></table>'
#    def toc_table_init(html)
#      if html.index(/<!–\smore\s–>/i)
#         tmp = html.split(/<!–\smore\s–>/i)
#         return tmp[0] + "<div id='toc-table-content'></div>" + tmp[1]
#      else
#         return html;
#      end
#    end
#
#    def toc_generate(html)
#         # No Toc can be specified on every single page
#         # For example the index page has no table of contents
#         enable_toc = @context.environments.first["page"]["toc"] || true;
#
#         if !enable_toc
#             return html
#         end
#
#
#         config = @context.registers[:site].config
#         # Minimum number of items needed to show TOC, default 0 (0 means no minimum)
#         min_items_to_show_toc = config["minItemsToShowToc"] || 0
#
#         anchor_prefix = config["anchorPrefix"] || 'TOC-'
#
#         # Text labels
#         contents_label = config["contentsLabel"] || 'Contents'
#
#         toc_html = ''
#         toc_level = 1
#         toc_section = 1
#         item_number = 1
#         level_html = ''
#         inner_section = 0
#
#         doc = Nokogiri::HTML(html)
#
#         # Find H2 tag and all its H3 siblings until next H2
#         doc.css('h2').each do |h2|
#             # TODO This XPATH expression can greatly improved
#             ct  = h2.xpath('count(following-sibling::h2)')
#             h3s = h2.xpath("following-sibling::h3[count(following-sibling::h2)=#{ct}]")
#
#             level_html = '';
#             inner_section = 0
#
#             h3s.map.each do |h3|
#                 h4ct = h3.xpath('count(following-sibling::h3)')
#                 h4s = h3.xpath("following-sibling::h4[count(following-sibling::h3)=#{h4ct}]")
#                 inner_section += 1
#                 anchor_id = anchor_prefix + item_number.to_s + '-' + inner_section.to_s + '-' + h3.text.to_url
#                 h3['id'] = "#{anchor_id}"
#                 inner_4_section = 0
#                 level_4_html = '';
#                 h4s.map.each do |h4|
#                   inner_4_section += 1
#                   anchor_4_id = anchor_prefix + item_number.to_s + '-' + inner_section.to_s + '-' + inner_4_section.to_s + '-' + h4.text.to_url
#                   h4['id'] = anchor_4_id
#                   level_4_html += create_level_html(anchor_4_id,
#                                                     toc_level + 1,
#                                                     toc_section + inner_section,
#                                                     item_number.to_s + '.' + inner_section.to_s + '.' + inner_4_section.to_s,
#                                                     h4.text,
#                                                     '')
#                 end
#                 if level_4_html.length > 0
#                   level_4_html = '<ul class="toc-list-item">' + level_4_html + '</ul>'
#                 end
#
#                 level_html += create_level_html(anchor_id,
#                     toc_level + 1,
#                     toc_section + inner_section,
#                     item_number.to_s + '.' + inner_section.to_s,
#                     h3.text,
#                     level_4_html)
#             end
#             if level_html.length > 0
#                 level_html = '<ul class="toc-list-item">' + level_html + '</ul>';
#             end
#             anchor_id = anchor_prefix + item_number.to_s + '-' + h2.text.to_url;
#             h2['id'] = "#{anchor_id}"
#
#             toc_html += create_level_html(anchor_id,
#                 toc_level,
#                 toc_section,
#                 item_number,
#                 h2.text,
#                 level_html);
#
#             toc_section += 1 + inner_section;
#             item_number += 1;
#         end
#
#         # for convenience item_number starts from 1
#         # so we decrement it to obtain the index count
#         toc_index_count = item_number - 1
#
#         if toc_html.length > 0
#             if min_items_to_show_toc <= toc_index_count
#                 toc_table = TOC_CONTAINER_HTML.gsub('%1', contents_label).gsub('%2', toc_html)
#
#                 table_content = doc.xpath("//div[@id='toc-table-content']")
#                 if table_content
#                   table_content.first.inner_html=(toc_table)
#                 end
#             end
#             doc.css('body').children.to_xml(:save_with => 0)
#         else
#             return html
#         end
#    end
#
# private
#
#     def create_level_html(anchor_id, toc_level, toc_section, tocNumber, tocText, tocInner)
#         link = '<a href="#%1"><span class="tocnumber">%2</span> <span class="toctext">%3</span></a>%4'
#             .gsub('%1', anchor_id.to_s)
#             .gsub('%2', tocNumber.to_s)
#             .gsub('%3', tocText)
#             .gsub('%4', tocInner ? tocInner : '');
#         '<li class="toc-item">%3</li>'
#             .gsub('%1', toc_level.to_s)
#             .gsub('%2', toc_section.to_s)
#             .gsub('%3', link)
#     end
#   end
# end
#
# Liquid::Template.register_filter(Jekyll::TOCGenerator)
