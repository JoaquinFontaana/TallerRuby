module Backstore
  class ReportsController < ApplicationController
    before_action :require_login

    def index
      @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.current.beginning_of_month
      @end_date = params[:end_date].present? ? Date.parse(params[:end_date]) : Date.current.end_of_month

      range = @start_date.beginning_of_day..@end_date.end_of_day

      @sales_base = Sale.joins(sale_products: :product)
                        .where(created_at: range)
                        .where(cancelled_at: nil)

      # 1. Filtros
      @sales_base = @sales_base.where(products: { type: params[:type] }) if params[:type].present?
      @sales_base = @sales_base.where(products: { category: params[:category] }) if params[:category].present?
      @sales_base = @sales_base.where(user_id: params[:user_id]) if params[:user_id].present?

      # 2. Métricas
      # Sumamos a nivel de line_item para que coincida exactamente con los filtros en productos
      @total_revenue = @sales_base.sum('sale_products.price * sale_products.quantity')
      @sales_count = @sales_base.select('sales.id').distinct.count
      @avg_revenue = @sales_count > 0 ? (@total_revenue / @sales_count.to_f).round(2) : 0
      @products_sold = @sales_base.sum('sale_products.quantity')

      # 3. Datos para Gráficos
      @sales_by_type = @sales_base.group('products.type').sum('sale_products.price * sale_products.quantity')
      @sales_by_genre = @sales_base.group('products.category').sum('sale_products.price * sale_products.quantity')
      @top_5_products = @sales_base.group('products.name').sum('sale_products.quantity').sort_by { |k, v| -v }.first(5)

      # 4. Opciones para los filtros en la vista
      @employees = User.joins(:role).where(roles: { name: 'EMPLEADO' })
      @product_types = Product.distinct.pluck(:type).compact
      @categories = Product.distinct.pluck(:category).compact

      # La agrupación anterior por días, adaptada a la nueva base 
      sales_data = @sales_base.group('DATE(sales.created_at)').sum('sale_products.price * sale_products.quantity')
      
      @sales_by_day = Kaminari.paginate_array(sales_data.to_a).page(params[:page]).per(10)
    end
  end
end
