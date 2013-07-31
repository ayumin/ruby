require 'test/unit'
require 'rexml/document'

class TestNotationDecl < Test::Unit::TestCase
  private
  def xml(internal_subset)
    <<-XML
<!DOCTYPE r SYSTEM "urn:x-henrikmartensson:test" [
#{internal_subset}
]>
<r/>
    XML
  end

  def parse(internal_subset)
    REXML::Document.new(xml(internal_subset)).doctype
  end

  class TestCommon < self
    def test_name
      doctype = parse("<!NOTATION name PUBLIC 'urn:public-id'>")
      assert_equal("name", doctype.notation("name").name)
    end
  end

  class TestExternID < self
    def test_notation
      doctype = parse(<<-INTERNAL_SUBSET)
        <!NOTATION n1 PUBLIC "-//HM//NOTATION TEST1//EN" 'urn:x-henrikmartensson.org:test5'>
        <!NOTATION n2 PUBLIC '-//HM//NOTATION TEST2//EN' "urn:x-henrikmartensson.org:test6">
      INTERNAL_SUBSET
      assert(doctype.notation('n1'), "Testing notation n1")
      assert(doctype.notation('n2'), "Testing notation n2")
    end
  end
end
