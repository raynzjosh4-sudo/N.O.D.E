create table public.products_table (
  id uuid not null default extensions.uuid_generate_v4 (),
  sku text not null,
  name text not null,
  brand text null,
  slug text not null,
  srp numeric(12, 2) not null default 0,
  price_tiers jsonb not null default '[]'::jsonb,
  supplier_id uuid not null,
  category_id text not null,
  hs_code text null,
  weight_kg numeric(10, 3) null,
  volume_cbm numeric(10, 5) null,
  origin_country text null,
  unbs_number text null,
  denier text null,
  material text null,
  current_stock integer null default 0,
  lead_time_days integer null default 0,
  warehouse_loc text null,
  image_url text not null,
  media_urls jsonb null default '[]'::jsonb,
  aspect_ratio numeric(4, 2) null default 1.0,
  seo_title text null,
  seo_description text null,
  search_keywords text[] null,
  available_colors jsonb null default '[]'::jsonb,
  available_sizes jsonb null default '[]'::jsonb,
  available_materials jsonb null default '[]'::jsonb,
  variant_label text null default 'Size'::text,
  support_info jsonb null default '{}'::jsonb,
  trading_terms jsonb null default '{}'::jsonb,
  created_at timestamp with time zone null default timezone ('utc'::text, now()),
  updated_at timestamp with time zone null default timezone ('utc'::text, now()),
  constraint products_table_pkey primary key (id),
  constraint products_table_sku_key unique (sku),
  constraint products_table_slug_key unique (slug),
  constraint products_table_category_id_fkey foreign KEY (category_id) references categories_table (id),
  constraint products_table_supplier_id_fkey foreign KEY (supplier_id) references users_table (id) on delete CASCADE
) TABLESPACE pg_default;

create trigger trigger_update_category_count
after INSERT
or DELETE
or
update on products_table for EACH row
execute FUNCTION sync_category_item_count ();