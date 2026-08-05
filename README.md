# Biloo Delivery

Biloo Delivery is a multi-sided delivery platform for customers, drivers, vendors, and administrators. The product is being built as a Flutter-first mobile system with a Supabase backend and a web-based operations dashboard.

## Product surfaces

- Customer app — discovery, cart, checkout, live tracking, wallet, ratings, and support
- Driver app — availability, delivery offers, navigation, proof of delivery, and earnings
- Vendor app — order management, menu/catalog, opening hours, promotions, and analytics
- Admin dashboard — marketplace operations, users, vendors, drivers, orders, payments, and reports
- Backend — authentication, PostgreSQL data model, Row Level Security, realtime events, storage, and notifications

## Repository structure

```text
apps/
  customer_app/
  driver_app/
  vendor_app/
  admin_dashboard/
packages/
  biloo_ui/
  biloo_domain/
supabase/
  migrations/
docs/
```

## Delivery plan

1. Platform foundation and design system
2. Customer ordering MVP
3. Vendor operations
4. Driver fulfilment and live tracking
5. Payments, notifications, and production hardening
6. Store release, observability, and post-launch maintenance

Detailed architecture and execution plans live in `docs/`.

## Status

Phase 1 foundation is in progress.
