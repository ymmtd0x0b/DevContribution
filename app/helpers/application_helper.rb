# frozen_string_literal: true

module ApplicationHelper
  def tailwind_classes_for(flash_type)
    {
      success: 'bg-green-500 text-white',
      info: 'bg-sky-500 text-white',
      warning: 'bg-yellow-400 text-white',
      error: 'bg-red-500 text-white'
    }.stringify_keys[flash_type.to_s] || flash_type.to_s
  end

  def flash_icon_classes_for(flash_type)
    {
      success: 'text-green-500 bg-white',
      info: 'text-sky-500 bg-white',
      warning: 'text-yellow-400 bg-white',
      error: 'text-red-500 bg-white'
    }.stringify_keys[flash_type.to_s] || flash_type.to_s
  end

  # def tailwind_classes_for(flash_type)
  #   {
  #     success: 'bg-green-400 text-white',
  #     info: 'bg-sky-400 text-white',
  #     warning: 'bg-yellow-400 text-white',
  #     error: 'bg-red-400 border-l-4 border-red-700 text-black'
  #   }.stringify_keys[flash_type.to_s] || flash_type.to_s
  # end

  def tab_to(tab_name, path)
    link_to tab_name, path, data: { turbo_frame: :items_list, optimized_tabs_target: 'tab', action: 'click->optimized-tabs#change' },
                            class: 'me-2 inline-block p-4 border-b-2'
  end
end
