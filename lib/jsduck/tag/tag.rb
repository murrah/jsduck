module JsDuck::Tag
  # Base class for all builtin tags.
  class Tag
    # Defines the name of the @tag.
    # The name itself must not contain the "@" sign.
    # For example: "cfg"
    attr_reader :pattern

    # True to include all lines up to next @tag as part of this tag's
    # :doc property.
    attr_reader :multiline

    # Called by DocParser when the @tag is reached to do the parsing
    # from that point forward.  Gets passed an instance of DocScanner.
    #
    # Can return a hash or array of hashes representing the detected
    # @tag data.  Each returned hash must contain the :tagname key,
    # e.g.:
    #
    #     {:tagname => :protected, :foo => "blah"}
    #
    # All hashes with the same :tagname will later be combined
    # together and passed on to #process_doc method of this Tag class
    # that has @key field set to that tagname.
    def parse(p)
    end

    # Defines the symbol under which the tag data is stored in final
    # member/class hash.
    attr_reader :key

    # Gets called with array of @tag data that was generated by
    # #parse.  The return value is stored under :key in the resulting
    # member/class hash.
    def process_doc(docs)
    end

    # Defines that the tag defines a class member and specifies a name
    # for the member type.  For example :event.
    attr_reader :member_type

    # The text to display in member signature.  Must be a hash
    # defining the short and long versions of the signature text:
    #
    #     {:long => "something", :short => "SOM"}
    #
    # Additionally the hash can contain a :tooltip which is the text
    # to be shown when the signature bubble is hovered over in docs.
    attr_reader :signature

    # Defines the name of object property in Ext.define()
    # configuration which, when encountered, will cause the
    # #parse_ext_define method to be invoked.
    attr_reader :ext_define_pattern

    # The default value to use when Ext.define is encountered, but the
    # key in the config object itself is not found.
    # This must be a Hash defining the key and value.
    attr_reader :ext_define_default

    # Called by Ast class to parse a config in Ext.define().
    # @param {Hash} cls A simple Hash representing a class on which
    # various properties can be set.
    # @param {AstNode} ast Value of the config in Ext.define().
    def parse_ext_define(cls, ast)
    end

    # Whether to render the tag before other content (:top) or after
    # it (:bottom).  Must be defined together with #to_html method.
    attr_accessor :html_position

    # Implement #to_html to transform tag data to HTML to be included
    # into documentation.
    #
    # It gets passed the full class/member hash. It should return an
    # HTML string to inject into document.  For help in that it can
    # use the #format method to easily support Markdown and
    # {@link/img} tags inside the contents.
    def to_html(context)
    end

    # Helper method for use if #to_html for rendering markdown.
    def format(markdown)
      @formatter.format(markdown)
    end

    attr_accessor :formatter

    # Returns all descendants of JsDuck::Tag::Tag class.
    def self.descendants
      result = []
      ObjectSpace.each_object(::Class) do |cls|
        result << cls if cls < self
      end
      result
    end
  end
end
