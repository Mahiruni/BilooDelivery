alter table public.profiles enable row level security;
alter table public.addresses enable row level security;
alter table public.vendors enable row level security;
alter table public.vendor_staff enable row level security;
alter table public.categories enable row level security;
alter table public.menu_items enable row level security;
alter table public.drivers enable row level security;
alter table public.orders enable row level security;
alter table public.order_items enable row level security;
alter table public.order_status_history enable row level security;
alter table public.payments enable row level security;
alter table public.driver_locations enable row level security;
alter table public.device_tokens enable row level security;
alter table public.reviews enable row level security;
alter table public.promotions enable row level security;
alter table public.promotion_redemptions enable row level security;
alter table public.admin_audit_logs enable row level security;

create policy "profiles_select_self_or_admin"
on public.profiles for select
to authenticated
using (id = auth.uid() or public.is_admin());

create policy "profiles_update_self_without_role_escalation"
on public.profiles for update
to authenticated
using (id = auth.uid() or public.is_admin())
with check (
  public.is_admin()
  or (id = auth.uid() and role = public.current_user_role())
);

create policy "addresses_owner_all"
on public.addresses for all
to authenticated
using (customer_id = auth.uid() or public.is_admin())
with check (customer_id = auth.uid() or public.is_admin());

create policy "vendors_public_read_approved"
on public.vendors for select
to anon, authenticated
using (status = 'approved' or public.is_vendor_member(id) or public.is_admin());

create policy "vendors_staff_update"
on public.vendors for update
to authenticated
using (public.is_vendor_member(id) or public.is_admin())
with check (public.is_vendor_member(id) or public.is_admin());

create policy "vendor_staff_read_membership"
on public.vendor_staff for select
to authenticated
using (user_id = auth.uid() or public.is_vendor_member(vendor_id) or public.is_admin());

create policy "vendor_staff_admin_manage"
on public.vendor_staff for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

create policy "categories_public_read"
on public.categories for select
to anon, authenticated
using (is_active or public.is_admin());

create policy "categories_admin_manage"
on public.categories for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

create policy "menu_items_public_read"
on public.menu_items for select
to anon, authenticated
using (
  exists (
    select 1 from public.vendors v
    where v.id = menu_items.vendor_id and v.status = 'approved'
  )
  or public.is_vendor_member(vendor_id)
  or public.is_admin()
);

create policy "menu_items_vendor_manage"
on public.menu_items for all
to authenticated
using (public.is_vendor_member(vendor_id) or public.is_admin())
with check (public.is_vendor_member(vendor_id) or public.is_admin());

create policy "drivers_select_self_associated_or_admin"
on public.drivers for select
to authenticated
using (
  id = auth.uid()
  or public.is_admin()
  or exists (
    select 1 from public.orders o
    where o.driver_id = drivers.id and public.can_access_order(o.id)
  )
);

create policy "drivers_update_self_or_admin"
on public.drivers for update
to authenticated
using (id = auth.uid() or public.is_admin())
with check (id = auth.uid() or public.is_admin());

create policy "orders_read_authorized"
on public.orders for select
to authenticated
using (public.can_access_order(id));

create policy "order_items_read_authorized"
on public.order_items for select
to authenticated
using (public.can_access_order(order_id));

create policy "order_history_read_authorized"
on public.order_status_history for select
to authenticated
using (public.can_access_order(order_id));

create policy "payments_read_authorized"
on public.payments for select
to authenticated
using (public.can_access_order(order_id));

create policy "driver_locations_driver_write"
on public.driver_locations for insert
to authenticated
with check (
  driver_id = auth.uid()
  and exists (
    select 1 from public.orders o
    where o.id = driver_locations.order_id
      and o.driver_id = auth.uid()
      and o.status in ('assigned', 'picked_up', 'on_the_way')
  )
);

create policy "driver_locations_driver_update"
on public.driver_locations for update
to authenticated
using (driver_id = auth.uid() or public.is_admin())
with check (driver_id = auth.uid() or public.is_admin());

create policy "driver_locations_order_participants_read"
on public.driver_locations for select
to authenticated
using (
  driver_id = auth.uid()
  or public.is_admin()
  or exists (
    select 1 from public.orders o
    where o.id = driver_locations.order_id and public.can_access_order(o.id)
  )
);

create policy "device_tokens_owner_all"
on public.device_tokens for all
to authenticated
using (user_id = auth.uid() or public.is_admin())
with check (user_id = auth.uid() or public.is_admin());

create policy "reviews_public_read"
on public.reviews for select
to anon, authenticated
using (true);

create policy "reviews_customer_create_after_delivery"
on public.reviews for insert
to authenticated
with check (
  customer_id = auth.uid()
  and exists (
    select 1 from public.orders o
    where o.id = reviews.order_id
      and o.customer_id = auth.uid()
      and o.vendor_id = reviews.vendor_id
      and o.status = 'delivered'
  )
);

create policy "promotions_public_read_active"
on public.promotions for select
to anon, authenticated
using (
  (is_active and now() between starts_at and ends_at)
  or (vendor_id is not null and public.is_vendor_member(vendor_id))
  or public.is_admin()
);

create policy "promotions_vendor_manage"
on public.promotions for all
to authenticated
using ((vendor_id is not null and public.is_vendor_member(vendor_id)) or public.is_admin())
with check ((vendor_id is not null and public.is_vendor_member(vendor_id)) or public.is_admin());

create policy "promotion_redemptions_customer_read"
on public.promotion_redemptions for select
to authenticated
using (customer_id = auth.uid() or public.is_admin());

create policy "audit_logs_admin_read"
on public.admin_audit_logs for select
to authenticated
using (public.is_admin());

insert into storage.buckets (id, name, public)
values
  ('vendor-media', 'vendor-media', true),
  ('avatars', 'avatars', true),
  ('delivery-evidence', 'delivery-evidence', false)
on conflict (id) do nothing;

create policy "public_read_vendor_media"
on storage.objects for select
to anon, authenticated
using (bucket_id in ('vendor-media', 'avatars'));

create policy "authenticated_upload_own_avatar"
on storage.objects for insert
to authenticated
with check (
  bucket_id = 'avatars'
  and (storage.foldername(name))[1] = auth.uid()::text
);

create policy "authenticated_manage_own_avatar"
on storage.objects for update
to authenticated
using (
  bucket_id = 'avatars'
  and (storage.foldername(name))[1] = auth.uid()::text
)
with check (
  bucket_id = 'avatars'
  and (storage.foldername(name))[1] = auth.uid()::text
);

comment on table public.orders is 'Transactional source of truth for customer delivery orders. Client applications should create and transition orders through validated RPCs or Edge Functions.';
comment on table public.driver_locations is 'Latest driver location only. Historical location retention should be implemented separately with a configured privacy TTL.';
