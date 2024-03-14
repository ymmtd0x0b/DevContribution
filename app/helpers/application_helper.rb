module ApplicationHelper
  def tab_to(tab_name, path)
    if current_page?(path)
      link_to tab_name, path, class: "inline-block p-4 text-blue-600 border-b-2 border-blue-600 rounded-t-lg active dark:text-blue-500 dark:border-blue-500", aria: { current: "page" }
    else
      link_to tab_name, path, class: "inline-block p-4 border-b-2 border-transparent rounded-t-lg hover:text-gray-600 hover:border-gray-300 dark:hover:text-gray-300"
    end
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
