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

ActiveRecord::Schema.define(version: 20160428160822) do

  create_table "attributes_translation_histories", force: :cascade do |t|
    t.text     "attribute_name",       limit: 65535
    t.text     "china",                limit: 65535
    t.text     "america",              limit: 65535
    t.text     "canada",               limit: 65535
    t.text     "british",              limit: 65535
    t.text     "germany",              limit: 65535
    t.text     "spain",                limit: 65535
    t.text     "italy",                limit: 65535
    t.text     "france",               limit: 65535
    t.integer  "attribute_id",         limit: 4
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "product_attribute_id", limit: 4
  end

  add_index "attributes_translation_histories", ["id"], name: "index_attributes_translation_histories_on_id", using: :btree

  create_table "cash_rates", force: :cascade do |t|
    t.float    "british",    limit: 24
    t.float    "germany",    limit: 24
    t.float    "france",     limit: 24
    t.float    "spain",      limit: 24
    t.float    "italy",      limit: 24
    t.float    "america",    limit: 24
    t.float    "canada",     limit: 24
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.datetime "deleted_at"
  end

  create_table "description_translation_histories", force: :cascade do |t|
    t.text     "description",  limit: 65535
    t.text     "china",        limit: 65535
    t.text     "america",      limit: 65535
    t.text     "canada",       limit: 65535
    t.text     "british",      limit: 65535
    t.text     "germany",      limit: 65535
    t.text     "spain",        limit: 65535
    t.text     "italy",        limit: 65535
    t.text     "france",       limit: 65535
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "is_whole",     limit: 1
    t.boolean  "is_auto_save", limit: 1
    t.integer  "usage_count",  limit: 4
  end

  create_table "merchant_sku_relations", force: :cascade do |t|
    t.integer  "merchant_id", limit: 4
    t.integer  "product_id",  limit: 4
    t.string   "sku",         limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "merchants", force: :cascade do |t|
    t.string   "shop_name",                  limit: 255
    t.string   "merchant_plantform_name",    limit: 255
    t.string   "merchant_account",           limit: 255
    t.integer  "admin_id",                   limit: 4
    t.integer  "user_id",                    limit: 4
    t.string   "merchant_country_name",      limit: 255
    t.string   "merchant_type",              limit: 255
    t.string   "merchant_aws_access_key_id", limit: 255
    t.string   "merchant_secret_key",        limit: 255
    t.string   "merchant_seller_id",         limit: 255
    t.string   "merchant_marketplace_id",    limit: 255
    t.string   "merchant_api_address",       limit: 255
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.boolean  "status",                     limit: 1,   default: true
  end

  create_table "mws_upload_histories", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.text     "xml_body",   limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "product_attributes", force: :cascade do |t|
    t.text     "attribute_name",  limit: 65535
    t.integer  "product_type_id", limit: 4
    t.text     "table_name",      limit: 65535
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "is_locked",       limit: 1
  end

  create_table "product_basic_infos", force: :cascade do |t|
    t.string   "sku",                  limit: 255
    t.float    "price",                limit: 24
    t.integer  "inventory",            limit: 4
    t.integer  "product_id",           limit: 4
    t.integer  "variable_id",          limit: 4
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.float    "america",              limit: 24
    t.float    "canada",               limit: 24
    t.float    "british",              limit: 24
    t.float    "germany",              limit: 24
    t.float    "france",               limit: 24
    t.float    "spain",                limit: 24
    t.float    "italy",                limit: 24
    t.boolean  "america_price_change", limit: 1
    t.boolean  "canada_price_change",  limit: 1
    t.boolean  "british_price_change", limit: 1
    t.boolean  "germany_price_change", limit: 1
    t.boolean  "france_price_change",  limit: 1
    t.boolean  "spain_price_change",   limit: 1
    t.boolean  "italy_price_change",   limit: 1
  end

  add_index "product_basic_infos", ["product_id"], name: "index_product_basic_infos_on_product_id", using: :btree
  add_index "product_basic_infos", ["variable_id"], name: "index_product_basic_infos_on_variable_id", using: :btree

  create_table "product_customize_attributes_relations", force: :cascade do |t|
    t.integer  "product_type_id",                   limit: 4
    t.integer  "product_id",                        limit: 4
    t.string   "attribute_name",                    limit: 255
    t.integer  "attributes_translation_history_id", limit: 4
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  add_index "product_customize_attributes_relations", ["attribute_name"], name: "index_product_customize_attributes_relations_on_attribute_name", using: :btree

  create_table "product_detail_forbidden_lists", force: :cascade do |t|
    t.string   "word",            limit: 255
    t.string   "product_type_id", limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "product_info_translations", force: :cascade do |t|
    t.text     "e_t",        limit: 65535
    t.text     "e_detail",   limit: 65535
    t.text     "e_des1",     limit: 65535
    t.text     "e_des2",     limit: 65535
    t.text     "e_des3",     limit: 65535
    t.text     "g_t",        limit: 65535
    t.text     "g_detail",   limit: 65535
    t.text     "g_des1",     limit: 65535
    t.text     "g_des2",     limit: 65535
    t.text     "g_des3",     limit: 65535
    t.text     "f_t",        limit: 65535
    t.text     "f_detail",   limit: 65535
    t.text     "f_des1",     limit: 65535
    t.text     "f_des2",     limit: 65535
    t.text     "f_des3",     limit: 65535
    t.text     "s_t",        limit: 65535
    t.text     "s_detail",   limit: 65535
    t.text     "s_des1",     limit: 65535
    t.text     "s_des2",     limit: 65535
    t.text     "s_des3",     limit: 65535
    t.text     "i_t",        limit: 65535
    t.text     "i_detail",   limit: 65535
    t.text     "i_des1",     limit: 65535
    t.text     "i_des2",     limit: 65535
    t.text     "i_des3",     limit: 65535
    t.integer  "product_id", limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.datetime "deleted_at"
  end

  add_index "product_info_translations", ["product_id"], name: "index_product_info_translations_on_product_id", using: :btree

  create_table "product_types", force: :cascade do |t|
    t.string   "name",                          limit: 255
    t.string   "father_node",                   limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.integer  "product_type_name_translation", limit: 4
    t.integer  "shipment_translation",          limit: 4
    t.integer  "price_translation",             limit: 4
    t.integer  "product_type_description",      limit: 4
    t.integer  "product_type_feed",             limit: 4
    t.integer  "product_type_1",                limit: 4
    t.integer  "product_type_2",                limit: 4
    t.integer  "product_type_introduction_1",   limit: 4
    t.integer  "product_type_introduction_2",   limit: 4
    t.boolean  "is_final_type",                 limit: 1,   default: false
    t.integer  "key_word1_translation",         limit: 4
    t.integer  "key_word2_translation",         limit: 4
    t.integer  "key_word3_translation",         limit: 4
    t.integer  "key_word4_translation",         limit: 4
    t.integer  "key_word5_translation",         limit: 4
  end

  create_table "products", force: :cascade do |t|
    t.integer  "product_type_id",    limit: 4
    t.text     "title",              limit: 65535
    t.string   "sku",                limit: 255
    t.integer  "sku_number",         limit: 4
    t.string   "product_number",     limit: 255
    t.integer  "user_id",            limit: 4
    t.text     "origin_address",     limit: 65535
    t.text     "desc1",              limit: 65535
    t.text     "desc2",              limit: 65535
    t.text     "desc3",              limit: 65535
    t.string   "brand",              limit: 255
    t.string   "price",              limit: 255
    t.boolean  "on_sale",            limit: 1
    t.boolean  "translate_status",   limit: 1
    t.string   "product_from",       limit: 255
    t.text     "details",            limit: 65535
    t.datetime "deleted_at"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.string   "images1",            limit: 255
    t.string   "images2",            limit: 255
    t.string   "images3",            limit: 255
    t.string   "images4",            limit: 255
    t.string   "images5",            limit: 255
    t.string   "images6",            limit: 255
    t.string   "images7",            limit: 255
    t.string   "images8",            limit: 255
    t.string   "images9",            limit: 255
    t.string   "images10",           limit: 255
    t.string   "seasons",            limit: 255
    t.string   "heel_height",        limit: 255
    t.string   "producer",           limit: 255
    t.text     "england_detail",     limit: 65535
    t.text     "germany_detail",     limit: 65535
    t.text     "france_detail",      limit: 65535
    t.text     "spain_detail",       limit: 65535
    t.text     "italy_detail",       limit: 65535
    t.boolean  "update_status",      limit: 1
    t.string   "shop_id",            limit: 255
    t.string   "shield_type",        limit: 255,   default: "0"
    t.datetime "shield_untill"
    t.datetime "presale_date"
    t.text     "images11",           limit: 65535
    t.text     "images12",           limit: 65535
    t.text     "images13",           limit: 65535
    t.text     "images14",           limit: 65535
    t.text     "images15",           limit: 65535
    t.text     "images16",           limit: 65535
    t.text     "images17",           limit: 65535
    t.text     "images18",           limit: 65535
    t.text     "images19",           limit: 65535
    t.text     "images20",           limit: 65535
    t.text     "images21",           limit: 65535
    t.text     "images22",           limit: 65535
    t.text     "images23",           limit: 65535
    t.text     "images24",           limit: 65535
    t.text     "images25",           limit: 65535
    t.text     "images26",           limit: 65535
    t.text     "images27",           limit: 65535
    t.text     "images28",           limit: 65535
    t.text     "images29",           limit: 65535
    t.text     "images30",           limit: 65535
    t.datetime "first_updated_time"
    t.string   "image_cut_position", limit: 255
    t.string   "image_cut_x",        limit: 255
    t.string   "image_cut_y",        limit: 255
    t.string   "product_link_id",    limit: 255
    t.string   "department_name",    limit: 255
    t.string   "style_name",         limit: 255
    t.string   "leather_type",       limit: 255
    t.string   "shaft_height",       limit: 255
    t.string   "shaft_diameter",     limit: 255
    t.string   "platform_height",    limit: 255
    t.string   "shoe_width",         limit: 255
    t.string   "lining_description", limit: 255
    t.string   "strap_type",         limit: 255
    t.text     "purchase_link",      limit: 65535
    t.string   "product_weight",     limit: 255
    t.text     "editing_backup",     limit: 65535
    t.text     "back_up",            limit: 65535
    t.text     "avatar",             limit: 65535
    t.text     "avatar1",            limit: 65535
    t.text     "avatar2",            limit: 65535
    t.text     "avatar_img_url",     limit: 65535
    t.text     "avatar_img_url1",    limit: 65535
    t.text     "avatar_img_url2",    limit: 65535
    t.integer  "stock",              limit: 4
    t.string   "auto_flag",          limit: 255
    t.boolean  "product_check_flag", limit: 1,     default: false
  end

  add_index "products", ["product_type_id"], name: "index_products_on_product_type_id", using: :btree
  add_index "products", ["user_id"], name: "index_products_on_user_id", using: :btree

  create_table "references", force: :cascade do |t|
    t.string   "key1",       limit: 255
    t.string   "key2",       limit: 255
    t.string   "key3",       limit: 255
    t.text     "value",      limit: 65535
    t.boolean  "is_using",   limit: 1,     default: true
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

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

  create_table "shipment_weight_relations", force: :cascade do |t|
    t.float    "min_weight",                        limit: 24
    t.float    "max_weight",                        limit: 24
    t.integer  "attributes_translation_history_id", limit: 4
    t.integer  "product_type_id",                   limit: 4
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
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
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.boolean  "status",         limit: 1
    t.string   "shop_id",        limit: 255
    t.boolean  "check_status",   limit: 1,     default: true
    t.string   "link_from",      limit: 255
    t.boolean  "link_retry",     limit: 1,     default: false
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
    t.string   "search_word",  limit: 255
    t.string   "filter_word",  limit: 255
    t.string   "manufacture",  limit: 255
  end

  add_index "shops", ["user_id"], name: "index_shops_on_user_id", using: :btree

  create_table "tmall_links", force: :cascade do |t|
    t.text     "address",         limit: 65535
    t.boolean  "status",          limit: 1
    t.integer  "user_id",         limit: 4
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "shop_id",         limit: 255
    t.string   "product_link_id", limit: 255
    t.datetime "deleted_at"
    t.boolean  "auto_update",     limit: 1
    t.boolean  "link_check_flag", limit: 1,     default: false
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
    t.integer  "manager",                limit: 4,   default: 1
    t.integer  "role",                   limit: 4
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
    t.string   "word",          limit: 255
    t.string   "en",            limit: 255
    t.string   "de",            limit: 255
    t.string   "fr",            limit: 255
    t.string   "es",            limit: 255
    t.string   "it",            limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.datetime "deleted_at"
    t.string   "variable_from", limit: 255
    t.integer  "user_id",       limit: 4
  end

  add_index "variable_translate_histories", ["variable_from"], name: "index_variable_translate_histories_on_variable_from", using: :btree

  create_table "variables", force: :cascade do |t|
    t.string   "color",                         limit: 255
    t.string   "size",                          limit: 255
    t.string   "price",                         limit: 255
    t.float    "weight",                        limit: 24
    t.integer  "product_id",                    limit: 4
    t.datetime "deleted_at"
    t.text     "image_url1",                    limit: 65535
    t.text     "image_url2",                    limit: 65535
    t.text     "image_url3",                    limit: 65535
    t.text     "image_url4",                    limit: 65535
    t.text     "image_url5",                    limit: 65535
    t.text     "image_url6",                    limit: 65535
    t.text     "image_url7",                    limit: 65535
    t.text     "image_url8",                    limit: 65535
    t.text     "image_url9",                    limit: 65535
    t.text     "image_url10",                   limit: 65535
    t.string   "stock",                         limit: 255
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.string   "england_color",                 limit: 255
    t.string   "england_size",                  limit: 255
    t.string   "germany_color",                 limit: 255
    t.string   "germany_size",                  limit: 255
    t.string   "france_color",                  limit: 255
    t.string   "france_size",                   limit: 255
    t.string   "spain_color",                   limit: 255
    t.string   "spain_size",                    limit: 255
    t.string   "italy_color",                   limit: 255
    t.string   "italy_size",                    limit: 255
    t.text     "image_url11",                   limit: 65535
    t.text     "image_url12",                   limit: 65535
    t.text     "image_url13",                   limit: 65535
    t.text     "image_url14",                   limit: 65535
    t.text     "image_url15",                   limit: 65535
    t.text     "image_url16",                   limit: 65535
    t.text     "image_url17",                   limit: 65535
    t.text     "image_url18",                   limit: 65535
    t.text     "image_url19",                   limit: 65535
    t.text     "image_url20",                   limit: 65535
    t.text     "image_url21",                   limit: 65535
    t.text     "image_url22",                   limit: 65535
    t.text     "image_url23",                   limit: 65535
    t.text     "image_url24",                   limit: 65535
    t.text     "image_url25",                   limit: 65535
    t.text     "image_url26",                   limit: 65535
    t.text     "image_url27",                   limit: 65535
    t.text     "image_url28",                   limit: 65535
    t.text     "image_url29",                   limit: 65535
    t.text     "image_url30",                   limit: 65535
    t.boolean  "update_status",                 limit: 1,     default: true
    t.boolean  "translate_status",              limit: 1,     default: false
    t.string   "color_dup",                     limit: 255
    t.string   "size_dup",                      limit: 255
    t.string   "variable_id",                   limit: 255
    t.string   "variable_translate_history_id", limit: 255
    t.text     "desc",                          limit: 65535
  end

  add_index "variables", ["product_id"], name: "index_variables_on_product_id", using: :btree

  add_foreign_key "product_basic_infos", "products"
  add_foreign_key "product_basic_infos", "variables"
  add_foreign_key "product_info_translations", "products"
  add_foreign_key "products", "product_types"
  add_foreign_key "products", "users"
  add_foreign_key "shop_links", "users"
  add_foreign_key "shops", "users"
  add_foreign_key "tmall_links", "users"
  add_foreign_key "variables", "products"
end
