# Biloo Delivery architecture

## Principles

Biloo Delivery is designed as a modular marketplace rather than a single monolithic app. Customer, driver, and vendor experiences share domain models and a design system while retaining independent release cycles.

The system prioritizes:

- mobile-first performance on unstable and low-bandwidth networks;
- strict tenant and role isolation through PostgreSQL Row Level Security;
- idempotent order and payment workflows;
- realtime order state changes without making realtime transport the source of truth;
- auditable administrative actions;
- graceful degradation when maps, notifications, or payment providers are unavailable.

## Client architecture

Each Flutter app follows a feature-oriented presentation layer backed by repository interfaces from `biloo_domain`.

```text
screen/widget -> application state -> repository interface -> Supabase/provider adapter
```

The first foundation commit uses deterministic in-memory repositories so the complete ordering flow can be reviewed without credentials. Supabase adapters are introduced after environment configuration is supplied.

## Backend architecture

Supabase provides:

- Auth for customer, driver, vendor staff, and administrator identities;
- PostgreSQL as the transactional source of truth;
- Row Level Security for authorization;
- Realtime subscriptions for order and driver-location updates;
- Storage for restaurant imagery, menu media, avatars, and proof-of-delivery evidence;
- Edge Functions for payment webhooks, notification fan-out, and privileged workflows.

## Order lifecycle

```text
cart -> pending_payment -> confirmed -> preparing -> ready_for_pickup
     -> assigned -> picked_up -> on_the_way -> delivered
```

Terminal exception states are `cancelled`, `payment_failed`, and `refunded`. Every transition is validated server-side and appended to an order-status history table.

## Payments

The payment abstraction supports cash on delivery, Chapa, Telebirr-compatible integrations, and Stripe where available. Provider callbacks are verified by Edge Functions and mapped to a provider-neutral payment record. Client success screens never independently mark an order paid.

## Location and tracking

Drivers publish throttled location updates while an active delivery is in progress. The latest position is kept in `driver_locations`; historical samples may be retained with a configured TTL for incident review. Customers only receive tracking data for their own active orders.

## Environments

- local: mock repositories or local Supabase CLI
- staging: isolated Supabase project and non-production payment credentials
- production: protected database migrations, signed releases, monitoring, and backup policies
