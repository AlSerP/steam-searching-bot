# frozen_string_literal: true

class ItemPriceHistory < ActiveRecord::Base
  belongs_to :item
end
