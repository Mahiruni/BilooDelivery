# Supabase backend

The initial migrations define the marketplace identity, vendor, menu, driver, order, payment, promotion, review, realtime-location, audit and storage models.

## Apply locally

```bash
supabase start
supabase db reset
```

## Apply to a linked project

```bash
supabase link --project-ref YOUR_PROJECT_REF
supabase db push
```

Do not place a Supabase service-role key in any mobile or web client. Order creation, privileged status transitions, payment callbacks, refunds and notification fan-out must run through server-side RPCs or Edge Functions.
