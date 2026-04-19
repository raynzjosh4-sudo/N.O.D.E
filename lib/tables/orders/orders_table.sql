-- lib/tables/orders/orders_table.sql

-- 1. Create the Orders Table
CREATE TABLE IF NOT EXISTS public.orders_table (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users_table(id) ON DELETE CASCADE,
    
    -- Financials
    total_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
    
    -- Logistics link
    pdf_id UUID REFERENCES public.pdfs_table(id) ON DELETE SET NULL,
    
    -- Status with standard Flutter OrderStatus alignment
    status TEXT NOT NULL DEFAULT 'pending',
    CONSTRAINT valid_order_status CHECK (status IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled')),
    
    -- Order Content (Full snapshot of products, variants, and quantities)
    entries_json JSONB NOT NULL DEFAULT '[]'::jsonb,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- 2. Trigger to automatically update 'updated_at' on every change
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = timezone('utc'::text, now());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_orders_timestamp
BEFORE UPDATE ON public.orders_table
FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- 3. Enable RLS
ALTER TABLE public.orders_table ENABLE ROW LEVEL SECURITY;

-- Policy: Users can only view their own orders
CREATE POLICY "Users can view own orders" ON public.orders_table
    FOR SELECT USING (auth.uid() = user_id);

-- Policy: Users can create their own orders
CREATE POLICY "Users can create own orders" ON public.orders_table
    FOR INSERT WITH CHECK (auth.uid() = user_id);
