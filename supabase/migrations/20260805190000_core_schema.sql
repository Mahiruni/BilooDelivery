-- Biloo Delivery initial marketplace schema
-- Apply with the Supabase CLI after linking a local, staging, or production project.

create extension if not exists pgcrypto;
create extension if not exists citext;

create type public.user_role as enum ('customer', 'driver', 'vendor_staff', 'admin');
create type public.vendor_status as enum ('pending', 'approved', 'suspended', 'rejected');
create type public.driver_status as enum ('offline', 'available', 'busy', 'suspended');
create type public.order_status as enum (
  'pending_payment',
  'confirmed',
  'preparing',
  'ready_for_pickup',
  'assigned',
  'picked_up',
  'on_the_way',
  'delivered',
  'cancelled',
  'payment_failed',
  'refunded'
);
create type public.payment_method as enum ('cash', 'chapa', 'telebirr', 'card');
create type public.payment_status as enum ('pending', 'authorized', 'paid', 'failed', 'refunded', 'partially_refunded');

create sequence public.order_number_seq start 100001;

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null default '',
  phone text,
  email citext,
  avatar_url text,
  role public.user_role not null default 'customer',
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.addresses (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null references public.profiles(id) on delete cascade,
  label text not null,
  address_line text not null,
  latitude numeric(10, 7) not null,
  longitude numeric(10, 7) not null,
  delivery_notes text,
  is_default boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.vendors (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references public.profiles(id),
  name text not null,
  slug citext not null unique,
  description text,
  phone text,
  email citext,
  address_line text,
  latitude numeric(10, 7),
  longitude numeric(10, 7),
  logo_url text,
  cover_url text,
  status public.vendor_status not null default 'pending',
  rating numeric(3, 2) not null default 0 check (rating between 0 and 5),
  rating_count integer not null default 0 check (rating_count >= 0),
  delivery_fee numeric(12, 2) not null default 0 check (delivery_fee >= 0),
  service_fee numeric(12, 2) not null default 0 check (service_fee >= 0),
  minimum_order numeric(12, 2) not null default 0 check (minimum_order >= 0),
  preparation_minutes integer not null default 20 check (preparation_minutes between 1 and 240),
  commission_rate numeric(5, 2) not null default 15 check (commission_rate between 0 and 100),
  is_open boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.vendor_staff (
  vendor_id uuid not null references public.vendors(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  staff_role text not null default 'operator' check (staff_role in ('owner', 'manager', 'operator', 'analyst')),
  created_at timestamptz not null default now(),
  primary key (vendor_id, user_id)
);

create table public.categories (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug citext not null unique,
  emoji text,
  sort_order integer not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table public.menu_items (
  id uuid primary key default gen_random_uuid(),
  vendor_id uuid not null references public.vendors(id) on delete cascade,
  category_id uuid references public.categories(id) on delete set null,
  name text not null,
  description text,
  price numeric(12, 2) not null check (price >= 0),
  image_url text,
  is_available boolean not null default true,
  is_popular boolean not null default false,
  sort_order integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.drivers (
  id uuid primary key references public.profiles(id) on delete cascade,
  status public.driver_status not null default 'offline',
  vehicle_type text not null default 'motorcycle' check (vehicle_type in ('bicycle', 'motorcycle', 'car', 'van')),
  vehicle_make text,
  vehicle_model text,
  plate_number text,
  license_number text,
  document_status public.vendor_status not null default 'pending',
  rating numeric(3, 2) not null default 0 check (rating between 0 and 5),
  rating_count integer not null default 0 check (rating_count >= 0),
  is_online boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.orders (
  id uuid primary key default gen_random_uuid(),
  order_number text not null unique,
  customer_id uuid not null references public.profiles(id),
  vendor_id uuid not null references public.vendors(id),
  driver_id uuid references public.drivers(id),
  delivery_address_id uuid references public.addresses(id) on delete set null,
  delivery_address_snapshot jsonb not null default '{}'::jsonb,
  status public.order_status not null default 'pending_payment',
  payment_method public.payment_method not null default 'cash',
  subtotal numeric(12, 2) not null default 0 check (subtotal >= 0),
  delivery_fee numeric(12, 2) not null default 0 check (delivery_fee >= 0),
  service_fee numeric(12, 2) not null default 0 check (service_fee >= 0),
  discount numeric(12, 2) not null default 0 check (discount >= 0),
  total numeric(12, 2) not null default 0 check (total >= 0),
  customer_notes text,
  cancellation_reason text,
  estimated_arrival timestamptz,
  accepted_at timestamptz,
  picked_up_at timestamptz,
  delivered_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.order_items (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders(id) on delete cascade,
  menu_item_id uuid references public.menu_items(id) on delete set null,
  item_name text not null,
  unit_price numeric(12, 2) not null check (unit_price >= 0),
  quantity integer not null check (quantity > 0),
  line_total numeric(12, 2) generated always as (unit_price * quantity) stored,
  notes text,
  created_at timestamptz not null default now()
);

create table public.order_status_history (
  id bigint generated always as identity primary key,
  order_id uuid not null references public.orders(id) on delete cascade,
  from_status public.order_status,
  to_status public.order_status not null,
  changed_by uuid references public.profiles(id) on delete set null,
  reason text,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create table public.payments (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders(id) on delete cascade,
  provider text not null,
  provider_reference text,
  method public.payment_method not null,
  status public.payment_status not null default 'pending',
  amount numeric(12, 2) not null check (amount >= 0),
  currency text not null default 'ETB',
  raw_response jsonb not null default '{}'::jsonb,
  failure_reason text,
  paid_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (provider, provider_reference)
);

create table public.driver_locations (
  driver_id uuid primary key references public.drivers(id) on delete cascade,
  order_id uuid references public.orders(id) on delete set null,
  latitude numeric(10, 7) not null,
  longitude numeric(10, 7) not null,
  heading numeric(6, 2),
  speed_mps numeric(8, 2),
  accuracy_meters numeric(8, 2),
  recorded_at timestamptz not null default now()
);

create table public.device_tokens (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  token text not null unique,
  platform text not null check (platform in ('android', 'ios', 'web')),
  app_scope text not null check (app_scope in ('customer', 'driver', 'vendor', 'admin')),
  last_seen_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);

create table public.reviews (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null unique references public.orders(id) on delete cascade,
  customer_id uuid not null references public.profiles(id) on delete cascade,
  vendor_id uuid not null references public.vendors(id) on delete cascade,
  driver_id uuid references public.drivers(id) on delete set null,
  vendor_rating integer not null check (vendor_rating between 1 and 5),
  driver_rating integer check (driver_rating between 1 and 5),
  comment text,
  created_at timestamptz not null default now()
);

create table public.promotions (
  id uuid primary key default gen_random_uuid(),
  vendor_id uuid references public.vendors(id) on delete cascade,
  code citext not null unique,
  title text not null,
  description text,
  discount_type text not null check (discount_type in ('percentage', 'fixed', 'free_delivery')),
  discount_value numeric(12, 2) not null default 0 check (discount_value >= 0),
  minimum_order numeric(12, 2) not null default 0 check (minimum_order >= 0),
  maximum_discount numeric(12, 2),
  usage_limit integer,
  per_user_limit integer not null default 1 check (per_user_limit > 0),
  starts_at timestamptz not null,
  ends_at timestamptz not null,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  check (ends_at > starts_at)
);

create table public.promotion_redemptions (
  promotion_id uuid not null references public.promotions(id) on delete cascade,
  order_id uuid not null unique references public.orders(id) on delete cascade,
  customer_id uuid not null references public.profiles(id) on delete cascade,
  discount_amount numeric(12, 2) not null check (discount_amount >= 0),
  created_at timestamptz not null default now(),
  primary key (promotion_id, order_id)
);

create table public.admin_audit_logs (
  id bigint generated always as identity primary key,
  actor_id uuid references public.profiles(id) on delete set null,
  action text not null,
  entity_type text not null,
  entity_id text,
  before_data jsonb,
  after_data jsonb,
  ip_address inet,
  created_at timestamptz not null default now()
);

create index addresses_customer_idx on public.addresses(customer_id);
create index vendors_status_open_idx on public.vendors(status, is_open);
create index vendor_staff_user_idx on public.vendor_staff(user_id);
create index menu_items_vendor_available_idx on public.menu_items(vendor_id, is_available);
create index orders_customer_created_idx on public.orders(customer_id, created_at desc);
create index orders_vendor_status_idx on public.orders(vendor_id, status, created_at desc);
create index orders_driver_status_idx on public.orders(driver_id, status, created_at desc);
create index orders_created_idx on public.orders(created_at desc);
create index order_items_order_idx on public.order_items(order_id);
create index order_history_order_idx on public.order_status_history(order_id, created_at);
create index payments_order_idx on public.payments(order_id, created_at desc);
create index reviews_vendor_idx on public.reviews(vendor_id, created_at desc);
create index promotions_active_idx on public.promotions(is_active, starts_at, ends_at);
