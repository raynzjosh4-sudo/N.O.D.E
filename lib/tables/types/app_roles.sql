-- lib/tables/types/app_roles.sql
-- Enumerating all 4 project roles
CREATE TYPE app_role AS ENUM ('admin', 'supplier', 'agent', 'customer');
