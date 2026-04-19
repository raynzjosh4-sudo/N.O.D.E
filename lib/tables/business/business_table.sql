create table public.business_table (
  user_id uuid not null,
  legal_name text not null,
  phone_number text null,
  physical_address text null,
  city text null,
  region text null,
  latitude double precision null,
  longitude double precision null,
  updated_at timestamp with time zone null default timezone ('utc'::text, now()),
  industry_group text null,
  logo_url text null,
  constraint business_table_pkey primary key (user_id),
  constraint business_table_user_id_fkey foreign KEY (user_id) references users_table (id) on delete CASCADE
) TABLESPACE pg_default;