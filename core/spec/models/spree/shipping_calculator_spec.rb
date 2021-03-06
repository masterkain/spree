require 'spec_helper'

module Spree
  describe ShippingCalculator do
    let(:variant1) { build(:variant, :price => 10) }
    let(:variant2) { build(:variant, :price => 20) }

    let(:package) do
      build(:stock_package, variants_contents: { variant1 => 2, variant2 => 1 })
    end

    subject { ShippingCalculator.new }

    it 'computes with a shipment' do
      shipment = mock_model(Spree::Shipment)
      subject.should_receive(:compute_shipment).with(shipment)
      subject.compute(shipment)
    end

    it 'computes with a package' do
      subject.should_receive(:compute_package).with(package)
      subject.compute(package)
    end

    it 'compute_shipment must be overridden' do
      expect {
        subject.compute_shipment(shipment)
      }.to raise_error
    end

    it 'compute_package must be overridden' do
      expect {
        subject.compute_package(package)
      }.to raise_error
    end

    it 'checks availability for a package' do
      subject.available?(package).should be_true
    end

    it 'calculates totals for content_items' do
      subject.send(:total, package.contents).should eq 40.00
    end
  end
end
