require File.join(File.dirname(__FILE__), 'gilded_rose')
require 'test/unit'

class TestUntitled < Test::Unit::TestCase

  def test_conjured_items
    items = [
      ConjuredItem.new(name="Conjured Mana Cake", sell_in=3, quality=6),
      ConjuredItem.new(name="Conjured Mana Cake", sell_in=0, quality=0),
      ConjuredItem.new(name="Conjured Mana Cake", sell_in=0, quality=1),
    ]
    GildedRose.new(items).update_quality()

    assert_equal 2, items[0].sell_in
    assert_equal 4, items[0].quality

    assert_equal -1, items[1].sell_in
    assert_equal 0, items[1].quality

    assert_equal -1, items[2].sell_in
    assert_equal 0, items[2].quality
  end

end
