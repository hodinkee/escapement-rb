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

      expect(es.blocks).to be_an_instance_of(Array)
      expect(es.results).to be_an_instance_of(Array)
    end

    it "identifies the correct number of entities" do
      es.extract!

      expect(es.blocks.size).to eq 1
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

      expect(es.blocks).to be_an_instance_of(Array)
      expect(es.results).to be_an_instance_of(Array)
    end

    it "identifies the correct number of entities" do
      es.extract!

      expect(es.blocks.size).to eq 1
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

      expect(es.blocks).to be_an_instance_of(Array)
      expect(es.results).to be_an_instance_of(Array)
    end

    it "identifies the correct number of entities" do
      es.extract!

      expect(es.blocks.size).to eq 1
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
        %{<p>Some thoughts: <ul><li>Yes</li><li><strong>No</strong></li></ul></p>}
      end
      let(:entities) { es.results[1][:entities] }

      before(:each) { es.extract! }

      it "treats lists as a separate paragraph" do
        expect(es.results.size).to eq 2
      end

      it "gets the correct name for lists" do
        expect(entities[0][:type]).to eq 'list_item'
        expect(entities[1][:type]).to eq 'list_item'
      end

      it "finds the correct positions for the list items" do
        expect(entities[0][:position]).to eq [0, 3]
        expect(entities[1][:position]).to eq [3, 5]
      end

      it "grabs entities inside of list items" do
        expect(entities[2][:html_tag]).to eq 'strong'
        expect(entities[2][:type]).to eq 'bold'
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

      it "results in 2 blocks" do
        expect(es.results.size).to eq 2
      end
    end
  end
end
