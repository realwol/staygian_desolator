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

ActiveRecord::Schema.define(version: 20160628144051) do

  create_table "accounts", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "user_id",    limit: 4
    t.integer  "responser",  limit: 4
    t.string   "platform",   limit: 255
    t.boolean  "status",     limit: 1,   default: true
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "accounts", ["user_id"], name: "index_accounts_on_user_id", using: :btree

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

  create_table "auth_lists", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "auth_url",   limit: 255
    t.boolean  "status",     limit: 1,   default: true
    t.integer  "parent_id",  limit: 4
    t.string   "backup",     limit: 255
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "backup_histories", force: :cascade do |t|
    t.integer  "order_id",      limit: 4
    t.integer  "order_item_id", limit: 4
    t.string   "content",       limit: 255
    t.integer  "user_id",       limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "brand_shop_relations", force: :cascade do |t|
    t.integer  "brand_id",           limit: 4
    t.integer  "shop_id",            limit: 4
    t.string   "status",             limit: 255
    t.string   "latest_update_user", limit: 255
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "brand_shop_relations", ["brand_id"], name: "index_brand_shop_relations_on_brand_id", using: :btree
  add_index "brand_shop_relations", ["shop_id"], name: "index_brand_shop_relations_on_shop_id", using: :btree

  create_table "brands", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "english_name", limit: 255
    t.string   "status",       limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "buyers", force: :cascade do |t|
    t.string   "email",                 limit: 255
    t.string   "buyer_name",            limit: 255
    t.string   "state_or_region",       limit: 255
    t.string   "city",                  limit: 255
    t.string   "country_code",          limit: 255
    t.string   "postal_code",           limit: 255
    t.string   "address_line1",         limit: 255
    t.string   "name",                  limit: 255
    t.string   "phone",                 limit: 255
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "platform_order_number", limit: 255
  end

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

  create_table "departments", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "parent_id",  limit: 4
    t.string   "backup",     limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
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

  create_table "financial_turnovers", force: :cascade do |t|
    t.integer  "turnover_type", limit: 4
    t.datetime "date"
    t.float    "amount",        limit: 24
    t.string   "income_type",   limit: 255
    t.string   "income_method", limit: 255
    t.string   "expand_type",   limit: 255
    t.string   "creater_id",    limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "expand_method", limit: 255
    t.string   "income_one",    limit: 255
    t.string   "expand_one",    limit: 255
  end

  create_table "logistic_channels", force: :cascade do |t|
    t.string   "name",                            limit: 255
    t.integer  "logistic_company_id",             limit: 4
    t.boolean  "is_using",                        limit: 1
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "platform_shipping_method",        limit: 255
    t.string   "platform_shipping_method_server", limit: 255
    t.string   "code",                            limit: 255
  end

  create_table "logistic_companies", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.boolean  "is_auth",    limit: 1
    t.boolean  "is_using",   limit: 1
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "api_server", limit: 255
    t.string   "username",   limit: 255
    t.string   "password",   limit: 255
    t.text     "auth_token", limit: 65535
  end

  create_table "merchant_sku_relations", force: :cascade do |t|
    t.integer  "merchant_id", limit: 4
    t.integer  "product_id",  limit: 4
    t.text     "sku",         limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "merchant_sku_relations", ["merchant_id"], name: "index_merchant_sku_relations_on_merchant_id", using: :btree
  add_index "merchant_sku_relations", ["product_id"], name: "index_merchant_sku_relations_on_product_id", using: :btree
  add_index "merchant_sku_relations", ["sku"], name: "index_merchant_sku_relations_on_sku", length: {"sku"=>255}, using: :btree

  create_table "merchants", force: :cascade do |t|
    t.string   "shop_name",                  limit: 255
    t.string   "merchant_plantform_name",    limit: 255
    t.string   "merchant_account",           limit: 255
    t.integer  "admin_id",                   limit: 4
    t.integer  "user_id",                    limit: 4
    t.integer  "account_id",                 limit: 4
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
    t.float    "shipment_cost",              limit: 24
    t.boolean  "update_flag",                limit: 1
  end

  create_table "mws_upload_histories", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.text     "xml_body",    limit: 65535
    t.string   "upload_type", limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "order_items", force: :cascade do |t|
    t.string   "order_item_id",                          limit: 255
    t.string   "platform_order_number",                  limit: 255
    t.string   "order_id",                               limit: 255
    t.datetime "paid_date"
    t.string   "principal_currency",                     limit: 255
    t.float    "principal_amount",                       limit: 24
    t.string   "tax_currency",                           limit: 255
    t.float    "tax_amount",                             limit: 24
    t.string   "gift_wrap_currency",                     limit: 255
    t.float    "gift_wrap_amount",                       limit: 24
    t.string   "gift_wrap_tax_currency",                 limit: 255
    t.float    "gift_wrap_tax_amount",                   limit: 24
    t.string   "shipping_charge_currency",               limit: 255
    t.float    "shipping_charge_amount",                 limit: 24
    t.string   "shipping_tax_currency",                  limit: 255
    t.float    "shipping_tax_amount",                    limit: 24
    t.string   "commission_currency",                    limit: 255
    t.float    "commission_amount",                      limit: 24
    t.string   "fixed_closing_fee_currency",             limit: 255
    t.float    "fixed_closing_fee_amount",               limit: 24
    t.string   "gift_wrap_commission_currency",          limit: 255
    t.float    "gift_wrap_commission_amount",            limit: 24
    t.string   "sales_tax_collection_fee_currency",      limit: 255
    t.float    "sales_tax_collection_fee_amount",        limit: 24
    t.string   "shipping_hb_currency",                   limit: 255
    t.float    "shipping_hb_amount",                     limit: 24
    t.string   "variable_closing_fee_currency",          limit: 255
    t.float    "variable_closing_fee_amount",            limit: 24
    t.integer  "quantity_shipped",                       limit: 4
    t.string   "seller_sku",                             limit: 255
    t.string   "product_id",                             limit: 255
    t.string   "user_id",                                limit: 255
    t.string   "merchant_id",                            limit: 255
    t.string   "vendor_id",                              limit: 255
    t.integer  "buyer_id",                               limit: 4
    t.datetime "posted_date"
    t.string   "marketplace_name",                       limit: 255
    t.datetime "created_at",                                                               null: false
    t.datetime "updated_at",                                                               null: false
    t.string   "title",                                  limit: 255
    t.string   "asin",                                   limit: 255
    t.string   "condition_note",                         limit: 255
    t.string   "quantity_ordered",                       limit: 255
    t.string   "shipping_discount_currency",             limit: 255
    t.float    "shipping_discount_amount",               limit: 24
    t.string   "image",                                  limit: 255
    t.string   "purchase_price",                         limit: 255
    t.datetime "purchase_date"
    t.datetime "shipped_date"
    t.integer  "logistic_channel_id",                    limit: 4
    t.integer  "purchase_method_id",                     limit: 4
    t.string   "purchase_order_number",                  limit: 255
    t.string   "purchase_tracking_number",               limit: 255
    t.string   "shipping_order_number",                  limit: 255
    t.string   "shipping_tracking_number",               limit: 255
    t.integer  "shipping_tracking_number_update_status", limit: 4,   default: 1
    t.string   "order_item_ship_status",                 limit: 255, default: "Unupdated"
    t.string   "backup",                                 limit: 255
    t.string   "refund_currency",                        limit: 255
    t.float    "refund_amount",                          limit: 24
    t.datetime "first_finish_time"
    t.datetime "to_problem_date"
    t.integer  "reship_order_item_id",                   limit: 4
    t.string   "buyer_country_code",                     limit: 255
    t.string   "flag_shipping_status",                   limit: 255
  end

  create_table "orders", force: :cascade do |t|
    t.string   "platform_order_number",           limit: 255
    t.string   "local_order_number",              limit: 255
    t.string   "order_type",                      limit: 255
    t.datetime "purchase_date"
    t.datetime "earliest_ship_date"
    t.datetime "latest_ship_date"
    t.datetime "last_update_date"
    t.datetime "earliest_delivery_date"
    t.datetime "latest_delivery_date"
    t.string   "ship_service_level",              limit: 255
    t.integer  "number_of_item_shipped",          limit: 4
    t.integer  "number_of_item_unshipped",        limit: 4
    t.string   "order_status",                    limit: 255
    t.string   "sales_channel",                   limit: 255
    t.boolean  "shipped_by_amazon_TFM",           limit: 1
    t.boolean  "is_business_order",               limit: 1
    t.string   "currency",                        limit: 255
    t.float    "amount",                          limit: 24
    t.boolean  "is_premium_order",                limit: 1
    t.string   "marketplace_id",                  limit: 255
    t.string   "fulfillment_channel",             limit: 255
    t.string   "payment_method",                  limit: 255
    t.boolean  "is_prime",                        limit: 1
    t.boolean  "shipment_service_level_category", limit: 1
    t.string   "seller_id",                       limit: 255
    t.string   "buyer_id",                        limit: 255
    t.string   "merchant_id",                     limit: 255
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.string   "contact_email",                   limit: 255
    t.boolean  "is_item_created",                 limit: 1,   default: false
    t.datetime "last_request_time"
    t.string   "country_code",                    limit: 255
    t.string   "backup",                          limit: 255
    t.string   "image",                           limit: 255
    t.string   "order_ship_status",               limit: 255
    t.integer  "reship_order_id",                 limit: 4
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
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.float    "america",              limit: 24
    t.float    "canada",               limit: 24
    t.float    "british",              limit: 24
    t.float    "germany",              limit: 24
    t.float    "france",               limit: 24
    t.float    "spain",                limit: 24
    t.float    "italy",                limit: 24
    t.boolean  "america_price_change", limit: 1,   default: true
    t.boolean  "canada_price_change",  limit: 1,   default: true
    t.boolean  "british_price_change", limit: 1,   default: true
    t.boolean  "germany_price_change", limit: 1,   default: true
    t.boolean  "france_price_change",  limit: 1,   default: true
    t.boolean  "spain_price_change",   limit: 1,   default: true
    t.boolean  "italy_price_change",   limit: 1,   default: true
  end

  add_index "product_basic_infos", ["product_id"], name: "index_product_basic_infos_on_product_id", using: :btree
  add_index "product_basic_infos", ["sku"], name: "index_product_basic_infos_on_sku", using: :btree
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
    t.string   "brand_id",           limit: 255
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
    t.string   "auto_flag",          limit: 255,   default: "0"
    t.boolean  "product_check_flag", limit: 1,     default: false
    t.boolean  "is_separate",        limit: 1,     default: false
    t.string   "search_link_id",     limit: 255
  end

  add_index "products", ["product_type_id"], name: "index_products_on_product_type_id", using: :btree
  add_index "products", ["sku"], name: "index_products_on_sku", using: :btree
  add_index "products", ["user_id"], name: "index_products_on_user_id", using: :btree

  create_table "references", force: :cascade do |t|
    t.string   "key1",       limit: 255
    t.string   "key2",       limit: 255
    t.string   "key3",       limit: 255
    t.integer  "key4",       limit: 4,     default: 0
    t.text     "value",      limit: 65535
    t.boolean  "is_using",   limit: 1,     default: true
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "key5",       limit: 255
  end

  create_table "refund_lists", force: :cascade do |t|
    t.datetime "refund_date"
    t.string   "refund_type",              limit: 255
    t.string   "order_id",                 limit: 255
    t.string   "order_item_id",            limit: 255
    t.float    "refund_amount",            limit: 24
    t.text     "backup",                   limit: 65535
    t.string   "buyer_memo",               limit: 255
    t.string   "refund_reason",            limit: 255
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "currency",                 limit: 255
    t.float    "shipping_refund_amount",   limit: 24
    t.string   "shipping_refund_currency", limit: 255
  end

  create_table "role_auth_relations", force: :cascade do |t|
    t.integer  "role_id",      limit: 4
    t.integer  "auth_list_id", limit: 4
    t.boolean  "status",       limit: 1, default: true
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "role_auth_relations", ["auth_list_id"], name: "index_role_auth_relations_on_auth_list_id", using: :btree
  add_index "role_auth_relations", ["role_id"], name: "index_role_auth_relations_on_role_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.boolean  "status",     limit: 1,   default: true
    t.integer  "parent_id",  limit: 4
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "search_links", force: :cascade do |t|
    t.text     "link",              limit: 65535
    t.text     "grasp_shop_id",     limit: 65535
    t.text     "forbidden_words",   limit: 65535
    t.text     "link_desc",         limit: 65535
    t.text     "backup",            limit: 65535
    t.integer  "user_id",           limit: 4
    t.boolean  "status",            limit: 1
    t.boolean  "check_status",      limit: 1
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.boolean  "first_link_status", limit: 1,     default: true
  end

  add_index "search_links", ["user_id"], name: "index_search_links_on_user_id", using: :btree

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
    t.string   "product_status",  limit: 255
    t.integer  "user_id",         limit: 4
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "shop_id",         limit: 255
    t.string   "product_link_id", limit: 255
    t.datetime "deleted_at"
    t.boolean  "auto_update",     limit: 1
    t.boolean  "link_check_flag", limit: 1,     default: false
    t.string   "search_link_id",  limit: 255
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
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.string   "email",                  limit: 255, default: "",  null: false
    t.string   "username",               limit: 255
    t.integer  "manager",                limit: 4,   default: 1
    t.integer  "role",                   limit: 4
    t.string   "leader_id",              limit: 255
    t.string   "user_product_version",   limit: 255, default: "1"
    t.string   "department_id",          limit: 255
    t.string   "user_role_id",           limit: 255
    t.string   "encrypted_password",     limit: 255, default: "",  null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,   null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "deleted_at"
    t.integer  "order_role",             limit: 4,   default: 1
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
    t.text     "title",                         limit: 65535
    t.text     "title_it",                      limit: 65535
    t.text     "title_es",                      limit: 65535
    t.text     "title_fr",                      limit: 65535
    t.text     "title_de",                      limit: 65535
    t.text     "title_en",                      limit: 65535
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
    t.text     "en",                            limit: 65535
    t.text     "de",                            limit: 65535
    t.text     "fr",                            limit: 65535
    t.text     "es",                            limit: 65535
    t.text     "it",                            limit: 65535
  end

  add_index "variables", ["product_id"], name: "index_variables_on_product_id", using: :btree

  create_table "vendors", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.boolean  "status",           limit: 1,     default: true
    t.integer  "brand_id",         limit: 4
    t.string   "shop_id",          limit: 255
    t.string   "purchase_address", limit: 255
    t.string   "contact",          limit: 255
    t.text     "backup",           limit: 65535
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  add_index "vendors", ["brand_id"], name: "index_vendors_on_brand_id", using: :btree

  add_foreign_key "accounts", "users"
  add_foreign_key "brand_shop_relations", "brands"
  add_foreign_key "brand_shop_relations", "shops"
  add_foreign_key "product_basic_infos", "products"
  add_foreign_key "product_basic_infos", "variables"
  add_foreign_key "product_info_translations", "products"
  add_foreign_key "products", "product_types"
  add_foreign_key "products", "users"
  add_foreign_key "role_auth_relations", "auth_lists"
  add_foreign_key "role_auth_relations", "roles"
  add_foreign_key "search_links", "users"
  add_foreign_key "shop_links", "users"
  add_foreign_key "shops", "users"
  add_foreign_key "tmall_links", "users"
  add_foreign_key "variables", "products"
  add_foreign_key "vendors", "brands"
end
