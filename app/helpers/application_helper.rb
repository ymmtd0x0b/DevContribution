# frozen_string_literal: true

module ApplicationHelper
  def tab_to(tab_name, path)
    if current_page?(path, check_parameters: true)
      link_to tab_name, path, class: 'inline-block p-4 text-blue-600 border-b-2 border-blue-600 rounded-t-lg active', aria: { current: 'page' }
    else
      link_to tab_name, path, class: 'inline-block p-4 border-b-2 border-transparent rounded-t-lg hover:text-gray-600 hover:border-gray-300'
    end
  end

  def tailwind_classes_for(flash_type)
    {
      success: 'bg-green-400 text-white',
      info: 'bg-sky-400 text-white',
      warning: 'bg-yellow-400 text-white',
      error: 'bg-red-400 border-l-4 border-red-700 text-black'
    }.stringify_keys[flash_type.to_s] || flash_type.to_s
  end
end
