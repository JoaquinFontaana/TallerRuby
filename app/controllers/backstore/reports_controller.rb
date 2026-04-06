module Backstore
  class ReportsController < ApplicationController
    before_action :require_login

    def index
      @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : nil
      @end_date = params[:end_date].present? ? Date.parse(params[:end_date]) : nil

      # Base: todas las ventas no canceladas
      @sales_base = Sale.joins(sale_products: :product)
                        .where(cancelled_at: nil)

      # Filtro de fechas solo si se proporcionan
      if @start_date && @end_date
        range = @start_date.beginning_of_day..@end_date.end_of_day
        @sales_base = @sales_base.where(sales: { created_at: range })
      elsif @start_date
        @sales_base = @sales_base.where('sales.created_at >= ?', @start_date.beginning_of_day)
      elsif @end_date
        @sales_base = @sales_base.where('sales.created_at <= ?', @end_date.end_of_day)
      end

      # 1. Filtros de producto y empleado
      @sales_base = @sales_base.where(products: { type: params[:type] }) if params[:type].present?
      @sales_base = @sales_base.where(products: { category: params[:category] }) if params[:category].present?
      @sales_base = @sales_base.where(sales: { user_id: params[:user_id] }) if params[:user_id].present?

      # 2. Métricas
      @total_revenue = @sales_base.sum('sale_products.price * sale_products.quantity')
      @sales_count = @sales_base.select('sales.id').distinct.count
      @avg_revenue = @sales_count > 0 ? (@total_revenue / @sales_count.to_f).round(2) : 0
      @products_sold = @sales_base.sum('sale_products.quantity')

      # 3. Datos para Gráficos
      @sales_by_type = @sales_base.group('products.type').sum('sale_products.price * sale_products.quantity')
      @sales_by_genre = @sales_base.group('products.category').sum('sale_products.price * sale_products.quantity')
      @top_5_products = @sales_base.group('products.name').sum('sale_products.quantity').sort_by { |_k, v| -v }.first(5)

      # 4. Opciones para los filtros en la vista
      @employees = User.joins(:role).where(roles: { name: 'EMPLEADO' })
      @product_types = Product.distinct.pluck(:type).compact
      @categories = Product.distinct.pluck(:category).compact

      # 5. Desglose por día
      sales_data = @sales_base.group('DATE(sales.created_at)').sum('sale_products.price * sale_products.quantity')

      @sales_by_day = Kaminari.paginate_array(sales_data.to_a).page(params[:page]).per(10)
    end
  end
end
