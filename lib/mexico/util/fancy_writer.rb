# encoding: utf-8

class Mexico::Util::FancyWriter

  attr_reader :stream
  attr_reader :prefix_stack

  def initialize(p_stream, &block)
    @stream = p_stream
    @prefix_stack = []
    if block_given?
      instance_eval &block
    end
  end

  def prepend(prepend_string=' ', &block)
    @prefix_stack << prepend_string
    instance_eval &block
    @prefix_stack.pop
  end

  def comment(comment_string='# ', &block)
    if block_given?
      prepend(comment_string, &block)
    end
  end

  def indent(number=2, &block)
    prepend(' '*number, &block)
  end

  def tab_indent(number=2, &block)
    prepend("\t"*number, &block)
  end

  def write(line)
    stream << "%s%s%s" %[@prefix_stack.join(''),line,"\n"]
  end

  alias :w    :write
  alias :<<   :write
  alias :line :write
end