create table public.categories_table (
  id text not null,
  name text not null,
  image_url text null,
  parent_id text null,
  level integer null default 0,
  item_count integer null default 0,
  created_at timestamp with time zone null default timezone ('utc'::text, now()),
  updated_at timestamp with time zone null default timezone ('utc'::text, now()),
  constraint categories_table_pkey primary key (id),
  constraint categories_table_parent_id_fkey foreign KEY (parent_id) references categories_table (id) on delete set null
) TABLESPACE pg_default;