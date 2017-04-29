class CheckboxInput < SimpleForm::Inputs::BooleanInput

  def input(wrapper_options)
    # template.content_tag(:input,'', :type => 'hidden', :name => "#{@builder.object_name}[#{attribute_name}]") +
    template.content_tag(:div, :class => 'checkbox i-checks') do
      template.content_tag(:label) do
        template.content_tag(:input, '', :type => 'checkbox', :checked => options[:checked], :value => options[:value] || 1, :name => options[:name] || "#{@builder.object_name}[#{attribute_name}]") + template.content_tag(:i) + options[:inline_label]
      end
    end
  end

end
