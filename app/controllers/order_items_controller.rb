class OrderItemsController < ApplicationController
  before_action :authenticate_user!

  def create
    order_item = current_order.order_items.new(article_id: params[:article_id])
    if order_item.save
      redirect_to current_order, notice: 'Agregando al carrito con exito.'
    else
      redirect_to article_path(id: params[:article_id]), alert: 'Error al agregar al carrito'
    end
  end

  private

  def current_order
    order = Order.where(user_id: current_user.id, status: 'created').order(updated_at: :desc).first
    order || Order.create(user_id: current_user.id)
  end

end
