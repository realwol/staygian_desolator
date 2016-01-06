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

ActiveRecord::Schema.define(version: 20160104025011) do

  create_table "attributes_translation_histories", force: :cascade do |t|
    t.string   "attribute_name",       limit: 255
    t.string   "china",                limit: 255
    t.string   "america",              limit: 255
    t.string   "canada",               limit: 255
    t.string   "british",              limit: 255
    t.string   "germay",               limit: 255
    t.string   "spain",                limit: 255
    t.string   "italy",                limit: 255
    t.string   "france",               limit: 255
    t.integer  "attribute_id",         limit: 4
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "product_attribute_id", limit: 4
  end

  create_table "cash_rates", force: :cascade do |t|
    t.float    "england",    limit: 24
    t.float    "germany",    limit: 24
    t.float    "france",     limit: 24
    t.float    "spain",      limit: 24
    t.float    "italy",      limit: 24
    t.float    "amercia",    limit: 24
    t.float    "canada",     limit: 24
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.datetime "deleted_at"
  end

  create_table "product_attributes", force: :cascade do |t|
    t.string   "attribute_name",  limit: 255
    t.integer  "product_type_id", limit: 4
    t.string   "table_name",      limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "is_locked",       limit: 1
  end

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
    t.datetime "deleted_at"
  end

  add_index "product_info_translations", ["product_id"], name: "index_product_info_translations_on_product_id", using: :btree

  create_table "product_types", force: :cascade do |t|
    t.string   "name",                        limit: 255
    t.string   "father_node",                 limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "shipment_translation",        limit: 4
    t.integer  "price_translation",           limit: 4
    t.integer  "product_type_description",    limit: 4
    t.integer  "product_type_feed",           limit: 4
    t.integer  "product_type_1",              limit: 4
    t.integer  "product_type_2",              limit: 4
    t.integer  "product_type_introduction_1", limit: 4
    t.integer  "product_type_introduction_2", limit: 4
  end

  create_table "products", force: :cascade do |t|
    t.integer  "product_type_id",             limit: 4
    t.text     "title",                       limit: 65535
    t.string   "sku",                         limit: 255
    t.integer  "sku_number",                  limit: 4
    t.string   "product_number",              limit: 255
    t.integer  "user_id",                     limit: 4
    t.text     "origin_address",              limit: 65535
    t.text     "desc1",                       limit: 65535
    t.text     "desc2",                       limit: 65535
    t.text     "desc3",                       limit: 65535
    t.string   "brand",                       limit: 255
    t.string   "price",                       limit: 255
    t.boolean  "on_sale",                     limit: 1
    t.boolean  "translate_status",            limit: 1
    t.string   "product_from",                limit: 255
    t.text     "details",                     limit: 65535
    t.datetime "deleted_at"
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.string   "images1",                     limit: 255
    t.string   "images2",                     limit: 255
    t.string   "images3",                     limit: 255
    t.string   "images4",                     limit: 255
    t.string   "images5",                     limit: 255
    t.string   "images6",                     limit: 255
    t.string   "images7",                     limit: 255
    t.string   "images8",                     limit: 255
    t.string   "images9",                     limit: 255
    t.string   "images10",                    limit: 255
    t.string   "outer_material_type",         limit: 255
    t.string   "outer_material_type_england", limit: 255
    t.string   "outer_material_type_germany", limit: 255
    t.string   "outer_material_type_france",  limit: 255
    t.string   "outer_material_type_spain",   limit: 255
    t.string   "outer_material_type_italy",   limit: 255
    t.string   "inner_material_type",         limit: 255
    t.string   "inner_material_type_england", limit: 255
    t.string   "inner_material_type_germany", limit: 255
    t.string   "inner_material_type_france",  limit: 255
    t.string   "inner_material_type_spain",   limit: 255
    t.string   "inner_material_type_italy",   limit: 255
    t.string   "sole_material",               limit: 255
    t.string   "sole_material_england",       limit: 255
    t.string   "sole_material_germany",       limit: 255
    t.string   "sole_material_france",        limit: 255
    t.string   "sole_material_spain",         limit: 255
    t.string   "sole_material_italy",         limit: 255
    t.string   "heel_type",                   limit: 255
    t.string   "heel_type_england",           limit: 255
    t.string   "heel_type_germany",           limit: 255
    t.string   "heel_type_france",            limit: 255
    t.string   "heel_type_spain",             limit: 255
    t.string   "heel_type_italy",             limit: 255
    t.string   "closure_type",                limit: 255
    t.string   "closure_type_england",        limit: 255
    t.string   "closure_type_germany",        limit: 255
    t.string   "closure_type_france",         limit: 255
    t.string   "closure_type_spain",          limit: 255
    t.string   "closure_type_italy",          limit: 255
    t.string   "seasons",                     limit: 255
    t.string   "heel_height",                 limit: 255
    t.string   "producer",                    limit: 255
    t.text     "england_detail",              limit: 65535
    t.text     "germany_detail",              limit: 65535
    t.text     "france_detail",               limit: 65535
    t.text     "spain_detail",                limit: 65535
    t.text     "italy_detail",                limit: 65535
    t.boolean  "update_status",               limit: 1
    t.string   "shop_id",                     limit: 255
    t.string   "shield_type",                 limit: 255,   default: "0"
    t.datetime "shield_untill"
    t.datetime "presale_date"
    t.text     "images11",                    limit: 65535
    t.text     "images12",                    limit: 65535
    t.text     "images13",                    limit: 65535
    t.text     "images14",                    limit: 65535
    t.text     "images15",                    limit: 65535
    t.text     "images16",                    limit: 65535
    t.text     "images17",                    limit: 65535
    t.text     "images18",                    limit: 65535
    t.text     "images19",                    limit: 65535
    t.text     "images20",                    limit: 65535
    t.text     "images21",                    limit: 65535
    t.text     "images22",                    limit: 65535
    t.text     "images23",                    limit: 65535
    t.text     "images24",                    limit: 65535
    t.text     "images25",                    limit: 65535
    t.text     "images26",                    limit: 65535
    t.text     "images27",                    limit: 65535
    t.text     "images28",                    limit: 65535
    t.text     "images29",                    limit: 65535
    t.text     "images30",                    limit: 65535
    t.datetime "first_updated_time"
    t.string   "image_cut_position",          limit: 255
    t.string   "image_cut_x",                 limit: 255
    t.string   "image_cut_y",                 limit: 255
    t.string   "product_link_id",             limit: 255
    t.string   "department_name",             limit: 255
    t.string   "style_name",                  limit: 255
    t.string   "leather_type",                limit: 255
    t.string   "shaft_height",                limit: 255
    t.string   "shaft_diameter",              limit: 255
    t.string   "platform_height",             limit: 255
    t.string   "shoe_width",                  limit: 255
    t.string   "lining_description",          limit: 255
    t.string   "strap_type",                  limit: 255
    t.text     "purchase_link",               limit: 65535
    t.string   "product_weight",              limit: 255
    t.text     "editing_backup",              limit: 65535
    t.text     "back_up",                     limit: 65535
  end

  add_index "products", ["product_type_id"], name: "index_products_on_product_type_id", using: :btree
  add_index "products", ["user_id"], name: "index_products_on_user_id", using: :btree

  create_table "shipment_method_values", force: :cascade do |t|
    t.string   "region",             limit: 255
    t.string   "weight",             limit: 255
    t.float    "price",              limit: 24
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "america_price",      limit: 255
    t.string   "canada_price",       limit: 255
    t.string   "british_price",      limit: 255
    t.string   "germany_price",      limit: 255
    t.string   "italy_price",        limit: 255
    t.string   "spain_price",        limit: 255
    t.string   "france_price",       limit: 255
    t.integer  "shipment_method_id", limit: 4
  end

  create_table "shipment_methods", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "shoes_attributes_values", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "england",    limit: 255
    t.string   "germany",    limit: 255
    t.string   "france",     limit: 255
    t.string   "spain",      limit: 255
    t.string   "italy",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.datetime "deleted_at"
  end

  create_table "shop_links", force: :cascade do |t|
    t.string   "shop_id_string", limit: 255
    t.text     "link",           limit: 65535
    t.integer  "user_id",        limit: 4
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.boolean  "status",         limit: 1
    t.string   "shop_id",        limit: 255
    t.boolean  "check_status",   limit: 1,     default: true
  end

  add_index "shop_links", ["user_id"], name: "index_shop_links_on_user_id", using: :btree

  create_table "shops", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.integer  "user_id",      limit: 4
    t.boolean  "status",       limit: 1,     default: true
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "shop_id",      limit: 255
    t.string   "shop_from",    limit: 255
    t.datetime "deleted_at"
    t.boolean  "check_status", limit: 1,     default: true
    t.text     "back_up",      limit: 65535
  end

  add_index "shops", ["user_id"], name: "index_shops_on_user_id", using: :btree

  create_table "tmall_links", force: :cascade do |t|
    t.text     "address",         limit: 65535
    t.boolean  "status",          limit: 1
    t.integer  "user_id",         limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "shop_id",         limit: 255
    t.string   "product_link_id", limit: 255
    t.datetime "deleted_at"
  end

  add_index "tmall_links", ["user_id"], name: "index_tmall_links_on_user_id", using: :btree

  create_table "translate_tokens", force: :cascade do |t|
    t.string   "t_id",       limit: 255
    t.string   "t_type",     limit: 255
    t.string   "t_status",   limit: 255
    t.string   "t_method",   limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.datetime "deleted_at"
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
    t.datetime "deleted_at"
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
    t.boolean  "update_status",    limit: 1,     default: true
    t.boolean  "translate_status", limit: 1,     default: false
    t.string   "color_dup",        limit: 255
    t.string   "size_dup",         limit: 255
    t.string   "variable_id",      limit: 255
  end

  add_index "variables", ["product_id"], name: "index_variables_on_product_id", using: :btree

  add_foreign_key "product_info_translations", "products"
  add_foreign_key "products", "product_types"
  add_foreign_key "products", "users"
  add_foreign_key "shop_links", "users"
  add_foreign_key "shops", "users"
  add_foreign_key "tmall_links", "users"
  add_foreign_key "variables", "products"
end
