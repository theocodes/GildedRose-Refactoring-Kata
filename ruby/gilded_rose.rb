QUALITY_CAP = 50.freeze
NORMAL_RATE = 1.freeze

class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      # until all item types implement :age,
      # we call on those that do and skip to the next
      if item.respond_to?(:age)
        item.age
        next
      end

      if item.name != "Aged Brie" and item.name != "Backstage passes to a TAFKAL80ETC concert"
        if item.quality > 0
          if item.name != "Sulfuras, Hand of Ragnaros"
            item.quality = item.quality - 1
          end
        end
      else
        if item.quality < 50
          item.quality = item.quality + 1
          if item.name == "Backstage passes to a TAFKAL80ETC concert"
            if item.sell_in < 11
              if item.quality < 50
                item.quality = item.quality + 1
              end
            end
            if item.sell_in < 6
              if item.quality < 50
                item.quality = item.quality + 1
              end
            end
          end
        end
      end
      if item.name != "Sulfuras, Hand of Ragnaros"
        item.sell_in = item.sell_in - 1
      end
      if item.sell_in < 0
        if item.name != "Aged Brie"
          if item.name != "Backstage passes to a TAFKAL80ETC concert"
            if item.quality > 0
              if item.name != "Sulfuras, Hand of Ragnaros"
                item.quality = item.quality - 1
              end
            end
          else
            item.quality = item.quality - item.quality
          end
        else
          if item.quality < 50
            item.quality = item.quality + 1
          end
        end
      end
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end

# AgedItem increases in Quality the older it gets
class AgedItem < Item
  def age
    if @quality >= QUALITY_CAP
      @quality = QUALITY_CAP
    elsif @sell_in <= 0
      @quality += NORMAL_RATE * 2
    else
      @quality += NORMAL_RATE
    end

    @sell_in -= 1
  end
end

# BackstagePassItem increases in Quality as its SellIn value approaches;
#  -  Quality increases by 2 when there are 10 days or less
#  -  Quality increases by 3 when there are 5 days or less
#  -  Quality drops to 0 after the concert
class BackstagePassItem < Item
  def age
    if @sell_in <= 0
      @quality = 0
    elsif @sell_in <= 5
      @quality += NORMAL_RATE + 2
    elsif @sell_in <= 10
      @quality += NORMAL_RATE + 1
    else
      @quality += NORMAL_RATE
    end

    @quality = QUALITY_CAP if @quality > QUALITY_CAP
    @sell_in -= 1
  end
end

# LegendaryItem items have fixed quality and never degrades
# nor needs to be sold in any time frame
class LegendaryItem < Item
  def age
    # NoOp
  end
end

# ConjuredItem degrades twice as fast as normal items
class ConjuredItem < Item
  def age
    @quality -= (@sell_in >= 0 ? 2 : 4)
    @quality = 0 if @quality < 0

    @sell_in -= 1
  end
end
