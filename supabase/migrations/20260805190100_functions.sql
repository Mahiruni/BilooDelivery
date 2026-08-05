create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create or replace function public.set_order_number()
returns trigger
language plpgsql
as $$
begin
  if new.order_number is null or btrim(new.order_number) = '' then
    new.order_number := 'BL-' || to_char(current_date, 'YYYYMMDD') || '-' || lpad(nextval('public.order_number_seq')::text, 6, '0');
  end if;
  return new;
end;
$$;

create or replace function public.record_order_status_change()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if tg_op = 'INSERT' then
    insert into public.order_status_history (
      order_id,
      from_status,
      to_status,
      changed_by
    ) values (
      new.id,
      null,
      new.status,
      auth.uid()
    );
  elsif old.status is distinct from new.status then
    insert into public.order_status_history (
      order_id,
      from_status,
      to_status,
      changed_by
    ) values (
      new.id,
      old.status,
      new.status,
      auth.uid()
    );
  end if;
  return new;
end;
$$;

create or replace function public.recalculate_order_totals()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  target_order_id uuid;
  computed_subtotal numeric(12, 2);
begin
  target_order_id := case
    when tg_op = 'DELETE' then old.order_id
    else new.order_id
  end;
  select coalesce(sum(line_total), 0)
  into computed_subtotal
  from public.order_items
  where order_id = target_order_id;

  update public.orders
  set
    subtotal = computed_subtotal,
    total = greatest(computed_subtotal + delivery_fee + service_fee - discount, 0),
    updated_at = now()
  where id = target_order_id;

  return null;
end;
$$;

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, full_name, phone, email)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'full_name', ''),
    new.phone,
    new.email
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

create trigger profiles_set_updated_at before update on public.profiles for each row execute function public.set_updated_at();
create trigger addresses_set_updated_at before update on public.addresses for each row execute function public.set_updated_at();
create trigger vendors_set_updated_at before update on public.vendors for each row execute function public.set_updated_at();
create trigger menu_items_set_updated_at before update on public.menu_items for each row execute function public.set_updated_at();
create trigger drivers_set_updated_at before update on public.drivers for each row execute function public.set_updated_at();
create trigger orders_set_updated_at before update on public.orders for each row execute function public.set_updated_at();
create trigger payments_set_updated_at before update on public.payments for each row execute function public.set_updated_at();
create trigger orders_set_number before insert on public.orders for each row execute function public.set_order_number();
create trigger orders_record_status after insert or update of status on public.orders for each row execute function public.record_order_status_change();
create trigger order_items_recalculate after insert or update or delete on public.order_items for each row execute function public.recalculate_order_totals();
create trigger on_auth_user_created after insert on auth.users for each row execute function public.handle_new_user();

create or replace function public.current_user_role()
returns public.user_role
language sql
stable
security definer
set search_path = public
as $$
  select role from public.profiles where id = auth.uid();
$$;

create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select coalesce((select role = 'admin' from public.profiles where id = auth.uid()), false);
$$;

create or replace function public.is_vendor_member(target_vendor_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(
    exists (
      select 1
      from public.vendors v
      where v.id = target_vendor_id and v.owner_id = auth.uid()
    ) or exists (
      select 1
      from public.vendor_staff vs
      where vs.vendor_id = target_vendor_id and vs.user_id = auth.uid()
    ),
    false
  );
$$;

create or replace function public.can_access_order(target_order_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(
    exists (
      select 1
      from public.orders o
      where o.id = target_order_id
        and (
          o.customer_id = auth.uid()
          or o.driver_id = auth.uid()
          or public.is_vendor_member(o.vendor_id)
          or public.is_admin()
        )
    ),
    false
  );
$$;
