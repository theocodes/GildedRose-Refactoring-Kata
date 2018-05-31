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

  def test_legendary_items
    items = [
      LegendaryItem.new(name="Sulfuras, Hand of Ragnaros", sell_in=0, quality=80),
    ]

    GildedRose.new(items).update_quality()
    assert_equal 0, items[0].sell_in
    assert_equal 80, items[0].quality
  end

  def test_backstage_pass_items
    items = [
      BackstagePassItem.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=15, quality=20),
      BackstagePassItem.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=10, quality=49),
      BackstagePassItem.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=5, quality=49),
    ]

    20.times do
      items.each_with_index do |item, i|
        prev_s = items[i].sell_in
        prev_q = items[i].quality
        GildedRose.new(items).update_quality()
        after_s = items[i].sell_in
        after_q = items[i].quality

        if after_q >= 50
          assert_operator after_q, :<=, 50
        else
          if prev_s <= 0
            assert_equal 0, after_q, "Expected 0 but got #{after_q} when sell_in was #{prev_s}"
          elsif prev_s <= 5
            assert_equal prev_q + 3, after_q, "Expected #{prev_q + 3} but got #{after_q} when sell_in was #{prev_s}"
          elsif prev_s <= 10
            assert_equal prev_q + 2, after_q, "Expected #{prev_q + 2} but got #{after_q} when sell_in was #{prev_s}"
          else
            assert_equal prev_q + 1, after_q, "Expected #{prev_q + 1} but got #{after_q} when sell_in was #{prev_s}"
          end
        end

      end
    end
  end

  def test_aged_items
    items = [
      AgedItem.new(name="Aged Brie", sell_in=10, quality=0),
      AgedItem.new(name="Aged Brie", sell_in=10, quality=49),
    ]

    20.times do
      items.each_with_index do |item, i|
        prev_s = items[i].sell_in
        prev_q = items[i].quality
        GildedRose.new(items).update_quality()
        after_s = items[i].sell_in
        after_q = items[i].quality

        if after_q >= 50
          assert_operator after_q, :<=, 50
        else
          if prev_s <= 0
            assert_equal prev_q + 2, after_q, "Expected #{prev_q + 1} but got #{after_q} when sell_in was #{prev_s}"
          else
            assert_equal prev_q + 1, after_q, "Expected #{prev_q + 1} but got #{after_q} when sell_in was #{prev_s}"
          end
        end

      end
    end
  end

end
