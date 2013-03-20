class CollectionRefHandler < YARD::Handlers::Ruby::AttributeHandler

  handles method_call(:collection_ref)
  namespace_only

  def process
    # push_state(:scope => :class) { super }
    name = statement.parameters.first.jump(:tstring_content, :ident).source
    get_object = YARD::CodeObjects::MethodObject.new(namespace, name)
    register(get_object)
    current_object_type = nil
    get_object.dynamic = true
    if get_object.docstring.to_s.strip =~ /type\s+(.*)/
      current_object_type = $1
      get_object.docstring = "Gets the #{name} object via the #{name}_id reference."
      get_object.docstring.add_tag(YARD::Tags::Tag.new("return","The referenced #{name} object", current_object_type))

      set_object = YARD::CodeObjects::MethodObject.new(namespace, "#{name}=")
      register(set_object)
      set_object.dynamic = true
      set_object.parameters= [ ['new_value', nil] ]
      set_object.docstring = "Sets the the #{name} object and updates the #{name}_id reference."
      set_object.docstring.add_tag(YARD::Tags::Tag.new("return", "", "void"))
      set_object.docstring.add_tag(YARD::Tags::Tag.new(:param, "The new value to be set", current_object_type, 'new_value'))
    end

  end

end