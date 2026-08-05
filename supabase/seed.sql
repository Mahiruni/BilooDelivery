insert into public.categories (name, slug, emoji, sort_order)
values
  ('All', 'all', '✨', 0),
  ('Burgers', 'burgers', '🍔', 10),
  ('Pizza', 'pizza', '🍕', 20),
  ('Habesha', 'habesha', '🍲', 30),
  ('Healthy', 'healthy', '🥗', 40),
  ('Coffee', 'coffee', '☕', 50)
on conflict (slug) do update
set name = excluded.name,
    emoji = excluded.emoji,
    sort_order = excluded.sort_order,
    is_active = true;
