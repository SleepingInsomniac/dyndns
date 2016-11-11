require "spec_helper"

describe Dyndns do
  it "has a version number" do
    expect(Dyndns::VERSION).not_to be nil
  end
end


describe Dyndns::Checker do
  it "is cool" do
    expect("cool").to eq("cool")
  end
end