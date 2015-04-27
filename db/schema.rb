# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150424142831) do

  create_table "product_info_translations", force: :cascade do |t|
    t.string   "e_t",        limit: 255
    t.string   "e_des1",     limit: 255
    t.string   "e_des2",     limit: 255
    t.string   "e_des3",     limit: 255
    t.string   "g_t",        limit: 255
    t.string   "g_des1",     limit: 255
    t.string   "g_des2",     limit: 255
    t.string   "g_des3",     limit: 255
    t.string   "f_t",        limit: 255
    t.string   "f_des1",     limit: 255
    t.string   "f_des2",     limit: 255
    t.string   "f_des3",     limit: 255
    t.string   "s_t",        limit: 255
    t.string   "s_des1",     limit: 255
    t.string   "s_des2",     limit: 255
    t.string   "s_des3",     limit: 255
    t.string   "i_t",        limit: 255
    t.string   "i_des1",     limit: 255
    t.string   "i_des2",     limit: 255
    t.string   "i_des3",     limit: 255
    t.integer  "product_id", limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "product_info_translations", ["product_id"], name: "index_product_info_translations_on_product_id", using: :btree

  create_table "product_types", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "father_node", limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "products", force: :cascade do |t|
    t.integer  "product_type_id",        limit: 4
    t.text     "title",                  limit: 65535
    t.string   "sku",                    limit: 255
    t.integer  "sku_number",             limit: 4
    t.string   "product_number",         limit: 255
    t.integer  "user_id",                limit: 4
    t.text     "origin_address",         limit: 65535
    t.text     "desc1",                  limit: 65535
    t.text     "desc2",                  limit: 65535
    t.text     "desc3",                  limit: 65535
    t.string   "brand",                  limit: 255
    t.string   "price",                  limit: 255
    t.boolean  "on_sale",                limit: 1
    t.boolean  "translate_status",       limit: 1
    t.string   "product_from",           limit: 255
    t.text     "details",                limit: 65535
    t.datetime "deleted_at"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "images1",                limit: 255
    t.string   "images2",                limit: 255
    t.string   "images3",                limit: 255
    t.string   "images4",                limit: 255
    t.string   "images5",                limit: 255
    t.string   "images6",                limit: 255
    t.string   "images7",                limit: 255
    t.string   "images8",                limit: 255
    t.string   "images9",                limit: 255
    t.string   "images10",               limit: 255
    t.string   "outer_material_type",    limit: 255
    t.string   "outer_material_type_uk", limit: 255
    t.string   "outer_material_type_de", limit: 255
    t.string   "outer_material_type_fr", limit: 255
    t.string   "outer_material_type_es", limit: 255
    t.string   "outer_material_type_it", limit: 255
    t.string   "inner_material_type",    limit: 255
    t.string   "inner_material_type_uk", limit: 255
    t.string   "inner_material_type_de", limit: 255
    t.string   "inner_material_type_fr", limit: 255
    t.string   "inner_material_type_es", limit: 255
    t.string   "inner_material_type_it", limit: 255
    t.string   "sole_material",          limit: 255
    t.string   "sole_material_uk",       limit: 255
    t.string   "sole_material_de",       limit: 255
    t.string   "sole_material_fr",       limit: 255
    t.string   "sole_material_es",       limit: 255
    t.string   "sole_material_it",       limit: 255
    t.string   "heel_type",              limit: 255
    t.string   "heel_type_uk",           limit: 255
    t.string   "heel_type_de",           limit: 255
    t.string   "heel_type_fr",           limit: 255
    t.string   "heel_type_es",           limit: 255
    t.string   "heel_type_it",           limit: 255
    t.string   "closure_type",           limit: 255
    t.string   "closure_type_uk",        limit: 255
    t.string   "closure_type_de",        limit: 255
    t.string   "closure_type_fr",        limit: 255
    t.string   "closure_type_es",        limit: 255
    t.string   "closure_type_it",        limit: 255
    t.string   "seasons",                limit: 255
    t.string   "heel_height",            limit: 255
    t.string   "producer",               limit: 255
    t.text     "england_detail",         limit: 65535
    t.text     "germany_detail",         limit: 65535
    t.text     "france_detail",          limit: 65535
    t.text     "spain_detail",           limit: 65535
    t.text     "italy_detail",           limit: 65535
    t.boolean  "update_status",          limit: 1
  end

  add_index "products", ["product_type_id"], name: "index_products_on_product_type_id", using: :btree
  add_index "products", ["user_id"], name: "index_products_on_user_id", using: :btree

  create_table "tmall_links", force: :cascade do |t|
    t.text     "address",    limit: 65535
    t.boolean  "status",     limit: 1
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "tmall_links", ["user_id"], name: "index_tmall_links_on_user_id", using: :btree

  create_table "translate_tokens", force: :cascade do |t|
    t.string   "t_id",       limit: 255
    t.string   "t_type",     limit: 255
    t.string   "t_status",   limit: 255
    t.string   "t_method",   limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "deleted_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "variable_translate_histories", force: :cascade do |t|
    t.string   "word",       limit: 255
    t.string   "en",         limit: 255
    t.string   "de",         limit: 255
    t.string   "fr",         limit: 255
    t.string   "es",         limit: 255
    t.string   "it",         limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "variables", force: :cascade do |t|
    t.string   "color",            limit: 255
    t.string   "size",             limit: 255
    t.string   "price",            limit: 255
    t.integer  "product_id",       limit: 4
    t.datetime "deleted_at"
    t.text     "image_url1",       limit: 65535
    t.text     "image_url2",       limit: 65535
    t.text     "image_url3",       limit: 65535
    t.text     "image_url4",       limit: 65535
    t.text     "image_url5",       limit: 65535
    t.text     "image_url6",       limit: 65535
    t.text     "image_url7",       limit: 65535
    t.text     "image_url8",       limit: 65535
    t.text     "image_url9",       limit: 65535
    t.text     "image_url10",      limit: 65535
    t.string   "stock",            limit: 255
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "england_color",    limit: 255
    t.string   "england_size",     limit: 255
    t.string   "germany_color",    limit: 255
    t.string   "germany_size",     limit: 255
    t.string   "france_color",     limit: 255
    t.string   "france_size",      limit: 255
    t.string   "spain_color",      limit: 255
    t.string   "spain_size",       limit: 255
    t.string   "italy_color",      limit: 255
    t.string   "italy_size",       limit: 255
    t.text     "image_url11",      limit: 65535
    t.text     "image_url12",      limit: 65535
    t.text     "image_url13",      limit: 65535
    t.text     "image_url14",      limit: 65535
    t.text     "image_url15",      limit: 65535
    t.text     "image_url16",      limit: 65535
    t.text     "image_url17",      limit: 65535
    t.text     "image_url18",      limit: 65535
    t.text     "image_url19",      limit: 65535
    t.text     "image_url20",      limit: 65535
    t.text     "image_url21",      limit: 65535
    t.text     "image_url22",      limit: 65535
    t.text     "image_url23",      limit: 65535
    t.text     "image_url24",      limit: 65535
    t.text     "image_url25",      limit: 65535
    t.text     "image_url26",      limit: 65535
    t.text     "image_url27",      limit: 65535
    t.text     "image_url28",      limit: 65535
    t.text     "image_url29",      limit: 65535
    t.text     "image_url30",      limit: 65535
    t.boolean  "update_status",    limit: 1,     default: false
    t.boolean  "translate_status", limit: 1,     default: false
  end

  add_index "variables", ["product_id"], name: "index_variables_on_product_id", using: :btree

  add_foreign_key "product_info_translations", "products"
  add_foreign_key "products", "product_types"
  add_foreign_key "products", "users"
  add_foreign_key "tmall_links", "users"
  add_foreign_key "variables", "products"
end
