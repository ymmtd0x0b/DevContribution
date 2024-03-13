module ApplicationHelper
  def tab_to(tab_name, path, classes = '')
    classes = classes.split(' ') + %w[h-10 w-32 text-center leading-10 border-t border-x border-gray-400]
    classes << 'tab-active' if current_page?(path)

    link_to tab_name, path, class: classes
  end

  def icon(icon, options = {})
    file = File.read("app/assets/images/#{icon}.svg")
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css 'svg'
    if options[:class].present?
      svg['class'] += " " + options[:class]
    end
      doc.to_html.html_safe
  end
end
