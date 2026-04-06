# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# Predefined roles
[ "ADMIN", "GERENTE", "EMPLEADO", "CLIENTE" ].each do |role_name|
  Role.find_or_create_by!(name: role_name)
end

# Crear un usuario admin
admin_role = Role.find_by(name: "ADMIN")

User.find_or_create_by!(email: "admin@gmail.com") do |u|
  u.name = "Admin"
  u.surname = "Admin"
  u.password = "Admin123"
  u.role_id = admin_role.id
end



# Crear permisos
[ "modify_role", "create_user" ].each do |perm_name|
  Permission.find_or_create_by!(name: perm_name)
end

# Asignar permisos a roles
admin_role = Role.find_by(name: "ADMIN")
modify_role_permission = Permission.find_by(name: "modify_role")
create_user_permission = Permission.find_by(name: "create_user")

HasPermission.find_or_create_by!(role_id: admin_role.id, permission_id: modify_role_permission.id)
HasPermission.find_or_create_by!(role_id: admin_role.id, permission_id: create_user_permission.id)

puts "Creando productos de prueba..."

# Imágenes de prueba genéricas (URLs de internet)
image_urls = [
  "https://upload.wikimedia.org/wikipedia/en/4/42/Beatles_-_Abbey_Road.jpg",
  "https://upload.wikimedia.org/wikipedia/en/5/55/Michael_Jackson_-_Thriller.png",
  "https://upload.wikimedia.org/wikipedia/en/3/3b/Dark_Side_of_the_Moon.png",
  "https://upload.wikimedia.org/wikipedia/en/2/2a/Queen_A_Night_At_The_Opera.png"
]

types = [ "Vinilo", "CD" ]
categories = [ "Rock", "Pop", "Jazz", "Metal" ]

12.times do |i|
  # 1. Crear el Producto base
  product = Product.create!(
    name: "Disco Ejemplo Vol. #{i + 1}",
    author: "Artista Genérico #{i + 1}",
    category: categories.sample, # Elige uno al azar
    type: types.sample,          # Elige uno al azar
    price: rand(15000..50000),   # Precio al azar entre 15k y 50k
    description: "Esta es una descripción de prueba para el disco número #{i + 1}. Es una edición limitada muy buscada.",
    upload_date: Time.now
  )

  # 2. Asignarle Stock (Creamos la entrada en new_products)
  # (Asumimos que todos son nuevos para este ejemplo rápido)
  NewProduct.create!(
    product: product,
    stock: rand(1..20)
  )

  # 3. Asignarle una Imagen
  Image.create!(
    product: product,
    url: image_urls.sample # Elige una foto al azar
  )
end

puts "Creando ventas de prueba para el reporte..."
# Asegurar rol EMPLEADO
empleado_role = Role.find_or_create_by!(name: "EMPLEADO", description: "Rol de Vendedor")
vendedor = User.find_or_create_by!(email: "vendedor@gmail.com") do |u|
  u.name = "Vendedor"
  u.surname = "Reportes"
  u.password = "12345678"
  u.password_confirmation = "12345678"
  u.role_id = empleado_role.id
end

cliente = Client.find_or_create_by!(dni: "12345678") do |c|
  c.name = "Cliente"
  c.surname = "Prueba"
  c.email = "cliente@prueba.com"
  c.phone = "123456789"
end

sales_count = 25
sales_count.times do |i|
  # Fechas aleatorias de los últimos 60 días
  random_date = rand(0..60).days.ago

  sale = Sale.create!(
    user: [User.find_by(email: "admin@gmail.com"), vendedor].sample,
    client: cliente,
    total: 0,
    created_at: random_date,
    updated_at: random_date
  )

  # 1 a 3 productos por venta
  total_sale = 0
  rand(1..3).times do
    product = Product.all.sample
    # Saltear si no tiene stock simulado
    next unless product.new_product && product.new_product.stock > 0

    qty = rand(1..3)
    # Evitar problemas de sobreventa en test si superamos stock
    qty = product.new_product.stock if qty > product.new_product.stock
    
    # Restar stock real (simular compra)
    product.decrement_stock!(qty)

    sp = SaleProduct.create!(
      sale: sale,
      product: product,
      quantity: qty,
      price: product.price
    )
    total_sale += (sp.price * sp.quantity)
  end

  # Actualizar total
  sale.update!(total: total_sale)
end

puts "¡Datos de prueba creados con éxito!"
