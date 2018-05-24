require 'spec_helper'
require_relative '../bin/stats'

RSpec.describe Stats do

  it 'can instantiate a Stats class' do
    expect(Stats.new).not_to be nil
  end
end