# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_12_01_205233) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "audios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url"
    t.integer "used_product_id", null: false
    t.index ["used_product_id"], name: "index_audios_on_used_product_id"
  end

  create_table "clients", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "dni"
    t.string "name"
    t.string "surname"
    t.datetime "updated_at", null: false
    t.index ["dni"], name: "index_clients_on_dni", unique: true
  end

  create_table "has_permissions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "permission_id", null: false
    t.integer "role_id", null: false
    t.datetime "updated_at", null: false
    t.index ["permission_id"], name: "index_has_permissions_on_permission_id"
    t.index ["role_id"], name: "index_has_permissions_on_role_id"
  end

  create_table "images", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "product_id", null: false
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["product_id"], name: "index_images_on_product_id"
  end

  create_table "new_products", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "product_id", null: false
    t.integer "stock"
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_new_products_on_product_id"
  end

  create_table "permissions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "author"
    t.string "category"
    t.integer "cover_image_id"
    t.datetime "created_at", null: false
    t.datetime "date_removed"
    t.string "description"
    t.datetime "last_modification"
    t.string "name"
    t.decimal "price"
    t.string "type"
    t.datetime "updated_at", null: false
    t.datetime "upload_date"
    t.integer "year"
    t.index ["cover_image_id"], name: "index_products_on_cover_image_id"
  end

  create_table "roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "sale_products", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.decimal "price"
    t.integer "product_id", null: false
    t.integer "quantity"
    t.integer "sale_id", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_sale_products_on_product_id"
    t.index ["sale_id"], name: "index_sale_products_on_sale_id"
  end

  create_table "sales", force: :cascade do |t|
    t.datetime "cancelled_at"
    t.integer "client_id", null: false
    t.boolean "completed", default: true
    t.datetime "created_at", null: false
    t.datetime "date"
    t.decimal "total"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["client_id"], name: "index_sales_on_client_id"
    t.index ["user_id"], name: "index_sales_on_user_id"
  end

  create_table "used_products", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "product_id", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_used_products_on_product_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.boolean "must_change_password", default: true, null: false
    t.string "name"
    t.string "password_digest"
    t.integer "role_id", null: false
    t.string "surname"
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "audios", "used_products"
  add_foreign_key "has_permissions", "permissions"
  add_foreign_key "has_permissions", "roles"
  add_foreign_key "images", "products"
  add_foreign_key "new_products", "products"
  add_foreign_key "products", "images", column: "cover_image_id"
  add_foreign_key "sale_products", "products"
  add_foreign_key "sale_products", "sales"
  add_foreign_key "sales", "clients"
  add_foreign_key "sales", "users"
  add_foreign_key "used_products", "products"
  add_foreign_key "users", "roles"
end
