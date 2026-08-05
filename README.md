# Biloo Delivery

Biloo Delivery is a multi-sided delivery platform for customers, drivers, vendors, and marketplace administrators. The foundation is built as a Flutter monorepo with a Supabase transactional backend and a responsive web operations dashboard.

## Included applications

- **Customer app:** onboarding, phone/social authentication shell, restaurant discovery, menu browsing, cart, payment selection, order history, live tracking simulation, profile, and dark mode.
- **Driver app:** online availability, delivery offers, pickup/drop-off workflow, navigation state, earnings, payout summary, and driver profile.
- **Vendor app:** store availability, live order queue, preparation-state transitions, menu availability, metrics, and store settings.
- **Admin dashboard:** marketplace KPIs, live operations, active-order search, CSV export, vendor approvals, dispatch exceptions, and responsive navigation.
- **Supabase backend:** marketplace schema, order/payment state models, indexes, triggers, Row Level Security, media buckets, and seed data.

## Repository structure

```text
apps/
  customer_app/       Flutter customer experience
  driver_app/         Flutter driver fulfilment app
  vendor_app/         Flutter restaurant/vendor app
  admin_dashboard/    Responsive web operations console
packages/
  biloo_ui/           Shared Material 3 design system
  biloo_domain/       Shared domain models and repository contracts
supabase/
  migrations/         PostgreSQL schema and RLS
  seed.sql             Local development seed data
docs/
  architecture.md
  roadmap.md
scripts/
  bootstrap.sh
```

## Local setup

### Flutter apps

Install the current stable Flutter SDK, then run:

```bash
./scripts/bootstrap.sh
make analyze
make test
```

The bootstrap script generates missing Android and iOS host projects without replacing Biloo's Dart application code.

Run an app from its directory:

```bash
cd apps/customer_app
flutter run
```

Use `driver_app` or `vendor_app` in the path for the other mobile applications.

### Admin dashboard

```bash
make admin
```

Open `http://localhost:4173`.

### Supabase

Install the Supabase CLI, link the target project, and apply migrations only after reviewing the environment:

```bash
supabase link --project-ref YOUR_PROJECT_REF
supabase db push
```

Client applications must use only the public project URL and anonymous key. Store service-role keys, payment credentials, webhook secrets, signing keys, and provider secrets in protected environment or platform secret stores.

## Architecture status

The repository now contains the complete Phase 1 product foundation and interactive mock workflows. The next implementation stage replaces deterministic local state with Supabase repositories, secure server-side order/payment functions, realtime subscriptions, maps, push notifications, and production credentials.

See `docs/architecture.md` and `docs/roadmap.md` for the implementation sequence.
