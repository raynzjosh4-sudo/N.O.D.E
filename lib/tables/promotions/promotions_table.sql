create table public.promotions_table (
  id uuid not null default extensions.uuid_generate_v4 (),
  title text not null,
  subtitle text null,
  action_text text null,
  image_urls jsonb not null default '[]'::jsonb,
  priority integer null default 0,
  is_active boolean null default true,
  starts_at timestamp with time zone null default timezone ('utc'::text, now()),
  expires_at timestamp with time zone null,
  created_at timestamp with time zone null default timezone ('utc'::text, now()),
  updated_at timestamp with time zone null default timezone ('utc'::text, now()),
  constraint promotions_table_pkey primary key (id)
) TABLESPACE pg_default;