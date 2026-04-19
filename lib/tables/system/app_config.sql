-- lib/tables/system/app_config.sql

-- 1. Create the App Config Table
-- This stores global system-wide settings
CREATE TABLE IF NOT EXISTS public.app_config (
    -- The key identifies the setting (e.g., 'min_order_amount')
    key TEXT PRIMARY KEY,
    
    -- Using JSONB for the value to support numbers, strings, or complex objects
    value JSONB NOT NULL,
    
    -- Optional description for the admin panel
    description TEXT,
    
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- 2. Trigger for updated_at
CREATE TRIGGER trigger_update_config_timestamp
BEFORE UPDATE ON public.app_config
FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- 3. Initial Configuration Data
INSERT INTO public.app_config (key, value, description)
VALUES 
    ('min_order_amount', '50000', 'Minimum order amount for checkout'),
    ('app_version_ios', '"1.0.0"', 'Current required iOS version'),
    ('app_version_android', '"1.0.0"', 'Current required Android version'),
    ('maintenance_mode', 'false', 'Enable/Disable maintenance mode')
ON CONFLICT (key) DO NOTHING;

-- 4. Enable RLS
ALTER TABLE public.app_config ENABLE ROW LEVEL SECURITY;

-- Policy: Everyone can read app config
CREATE POLICY "Public can view app config" ON public.app_config
    FOR SELECT USING (true);

-- Policy: Only admins can manage app config
-- (Assuming the role 'admin' exists in users_table)
CREATE POLICY "Admins can manage config" ON public.app_config
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.users_table 
            WHERE id = auth.uid() AND role = 'admin'
        )
    );
