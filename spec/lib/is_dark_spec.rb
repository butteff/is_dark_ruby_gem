# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/is_dark'

RSpec.describe IsDark do
  it 'should calculate Hex color' do
    expect(IsDark.color('#ffffff')).to eq(false)
    expect(IsDark.color('#000000')).to eq(true)
  end
end
