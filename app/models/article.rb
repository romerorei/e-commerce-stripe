# == Schema Information
#
# Table name: articles
#
#  id                :bigint           not null, primary key
#  title             :string
#  body              :text
#  body_preview      :text
#  private           :boolean          default(FALSE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  price             :integer
#  stripe_pricing_id :string
#  stripe_product_id :string
#

class Article < ApplicationRecord
  before_save :add_body_preview, if: :body?
  after_create :create_stripe_product, if: :private?

  scope :free, -> { where(private: false) }
  scope :paid, -> { where(private: true) }

  def add_body_preview
    self.body_preview = body[0..150]
  end

  def create_stripe_product
    product = Stripe::Product.create({ name: "Article ##{id}"})
    pricing = Stripe::Price.create({
      product: product.id,
      unit_amount: price,
      currency: 'eur'
    })
    update(stripe_product_id: product.id, stripe_pricing_id: pricing.id)
  end

  def tag
    { class: tag_class, name: tag_name }
  end

  private

  def tag_name
    private ? 'Locked' : 'Free'
  end

  def tag_class
    return 'bg-red-200 text-red-600' unless private

    'bg-blue-200 text-blue-600'
  end
end
