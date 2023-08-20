module ApplicationHelper
  def tab_to(tab_name, path, classes = '')
    classes = classes.split(' ') + %w[h-10 w-32 text-center leading-10 border-t border-x border-gray-400]
    classes << 'tab-active' if current_page?(path)

    link_to tab_name, path, class: classes
  end
end
