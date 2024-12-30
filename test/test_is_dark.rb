# frozen_string_literal: true

require 'minitest/autorun'
require 'is_dark'

class HolaTest < Minitest::Test
  # dark colors

  def test_is_dark_hex_code_000000
    assert_equal true,
                 IsDark.color('#000000')
  end

  def test_is_dark_hex_code_111111
    assert_equal true,
                 IsDark.color('#111111')
  end

  def test_is_dark_hex_code_102694
    assert_equal true,
                 IsDark.color('#102694')
  end

  def test_is_dark_hex_code_ff2e17
    assert_equal true,
                 IsDark.color('#800f03')
  end

  # not dark colors

  def test_is_dark_hex_code_444444
    assert_equal false,
                 IsDark.color('#444444')
  end

  def test_is_dark_hex_code_888888
    assert_equal false,
                 IsDark.color('#888888')
  end

  def test_is_dark_hex_code_ffffff
    assert_equal false,
                 IsDark.color('#ffffff')
  end

  def test_is_dark_hex_code_fff6b2
    assert_equal false,
                 IsDark.color('#fff6b2')
  end
end
