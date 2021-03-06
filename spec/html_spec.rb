require 'spec_helper'

RSpec.describe Escapement::HTML do
  let (:es) { Escapement::HTML.new(html) }

  context "simple paragraph" do
    let (:html) do
      %{<p>Lorem <strong>ipsum</strong> dolor <i>sit</i> amet.</p>}
    end
    let (:entities) { es.results.first[:entities] }

    it "parses without error" do
      expect {
        es.extract!
      }.to_not raise_error

      expect(es.elements).to be_an_instance_of(Array)
      expect(es.results).to be_an_instance_of(Array)
    end

    it "identifies the correct number of entities" do
      es.extract!

      expect(es.elements.size).to eq 1
      expect(es.results.size).to eq 1

      expect(entities.size).to eq 2
    end

    it "has the correct positions for the entities" do
      es.extract!

      expect(entities[0][:html_tag]).to eq 'strong'
      expect(entities[0][:position]).to eq [6, 11]

      expect(entities[1][:html_tag]).to eq 'i'
      expect(entities[1][:position]).to eq [18, 21]
    end
  end

  context "nested tags" do
    let (:html) do
      %{<p>Lorem <strong>ipsum <i>dolor <u>sit</u></i> amet</strong>.</p>}
    end
    let (:entities) { es.results.first[:entities] }

    it "parses without error" do
      expect {
        es.extract!
      }.to_not raise_error

      expect(es.elements).to be_an_instance_of(Array)
      expect(es.results).to be_an_instance_of(Array)
    end

    it "identifies the correct number of entities" do
      es.extract!

      expect(es.elements.size).to eq 1
      expect(es.results.size).to eq 1

      expect(entities.size).to eq 3
    end

    it "has the correct positions for the entities" do
      es.extract!

      expect(entities[0][:html_tag]).to eq 'strong'
      expect(entities[0][:position]).to eq [6, 26]

      expect(entities[1][:html_tag]).to eq 'i'
      expect(entities[1][:position]).to eq [12, 21]

      expect(entities[2][:html_tag]).to eq 'u'
      expect(entities[2][:position]).to eq [18, 21]
    end
  end

  context "tags with attributes" do
    let (:html) do
      %{<p class="foobar">This is a <a href="http://google.com" target="_blank">link</a>.</p>}
    end
    let (:entities) { es.results.first[:entities] }

    it "parses without error" do
      expect {
        es.extract!
      }.to_not raise_error

      expect(es.elements).to be_an_instance_of(Array)
      expect(es.results).to be_an_instance_of(Array)
    end

    it "identifies the correct number of entities" do
      es.extract!

      expect(es.elements.size).to eq 1
      expect(es.results.size).to eq 1

      expect(entities.size).to eq 1
    end

    it "has the correct positions for the entities" do
      es.extract!

      expect(entities[0][:html_tag]).to eq 'a'
      expect(entities[0][:position]).to eq [10, 14]
    end

    it "has the correct attributes for the entities" do
      es.extract!

      expect(entities[0][:attributes]).to eq({ "href" => "http://google.com" })
    end
  end

  context "complex HTML" do
    context "lists" do
      let (:html) do
        %{<p>Some thoughts:</p><ul><li>Yes</li><li><strong>No</strong></li></ul>}
      end
      let(:list) { es.results[1] }

      before(:each) { es.extract! }

      it "treats lists as a separate paragraph" do
        expect(es.results.size).to eq 2
      end

      it "correctly identifies lists" do
        expect(list[:type]).to eq 'unordered_list'
      end

      it "treats list items as separate entities" do
        expect(list[:children].size).to eq 2
        expect(list[:children].all? { |item| item[:type] == 'list_item' }).to be_truthy
      end

      it "parses entities in list items" do
        entities = list[:children][1][:entities]
        expect(entities.size).to eq 1
        expect(entities[0][:type]).to eq 'bold'
        expect(entities[0][:html_tag]).to eq 'strong'
        expect(entities[0][:position]).to eq [0, 2]
      end

      context "nested" do
        let (:html) do
          %{<ul><li>List item 1</li><ul><li>Nested <b>item</b></li></ul><li>List item 2</li></ul>}
        end
        let (:list) { es.results[0] }
        let (:list2) { es.results[0][:children][1] }

        it "supports list nesting" do
          expect(es.results.size).to eq 1
          expect(list[:children].size).to eq 3
          expect(list2[:type]).to eq 'unordered_list'
          expect(list2[:children].size).to eq 1
          expect(list2[:children][0][:type]).to eq 'list_item'
        end

        it "correctly parses entities on nested list items" do
          expect(list2[:children][0][:entities].size).to eq 1
          expect(list2[:children][0][:entities][0][:type]).to eq 'bold'
          expect(list2[:children][0][:entities][0][:html_tag]).to eq 'b'
          expect(list2[:children][0][:entities][0][:position]).to eq [7, 11]
        end
      end
    end

    context "images" do
      let (:html) do
        %{<p>Lorem ipsum <img src="http://example.com/image.png" width="200" height="300" class="foobar" /> dolor sit amet.</p>}
      end
      let (:entities) { es.results[0][:entities] }

      before(:each) { es.extract! }

      it "correctly parses the entity" do
        expect(entities.size).to eq 1
        expect(entities[0][:type]).to eq 'image'
      end

      it "has the correct position" do
        expect(entities[0][:position]).to eq [12, 12]
      end

      it "has the correct attributes" do
        expect(entities[0][:attributes]).to eq({ 'src' => 'http://example.com/image.png', 'width' => '200', 'height' => '300' })
      end
    end

    context "HTML escaped characters" do
      let (:html) do
        %{<p>This &amp; that <strong>these &mdash; those</strong></p>}
      end
      let (:entities) { es.results[0][:entities] }

      before(:each) { es.extract! }

      it "decodes HTML entities" do
        expect(es.results[0][:text]).to eq "This & that these — those"
      end

      it "gives the correct positions based on the decoded text" do
        expect(entities[0][:position]).to eq [12, 25]
      end
    end

    context "double newlines" do
      let (:html) do
        %{<p>Paragraph 1</p>\r\n\r\n<p>Paragraph 2</p>}
      end

      before(:each) { es.extract! }

      it "results in 2 elements" do
        expect(es.results.size).to eq 2
      end
    end

    context "non-breakable space paragraphs" do
      let (:html) do
        %{<p>&nbsp;</p>}
      end

      before(:each) { es.extract! }

      it "discards paragraphs with only non-breakable space characters" do
        expect(es.results.size).to eq 0
      end
    end

    context "<br> tags" do
      let (:html) do
        %{<p>This is<br>a <i>test<br/>okay</i></p>}
      end
      let (:entities) { es.results[0][:entities] }

      before(:each) { es.extract! }

      it "converts a line break tag to a newline" do
        result = es.results[0]
        expect(result[:text]).to eq "This is\na test\nokay"
        expect(entities.size).to eq 1
        expect(entities[0][:type]).to eq 'italic'
      end
    end
  end
end
