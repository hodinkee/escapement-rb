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
end
