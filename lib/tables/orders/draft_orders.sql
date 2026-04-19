-- lib/tables/orders/draft_orders.sql
CREATE TABLE IF NOT EXISTS public.draft_orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users_table(id) ON DELETE CASCADE,
    
    -- entries_json stores the list of ProductOrderEntry objects
    -- Includes productId, quantity, color/size selections, and pricing
    entries_json JSONB NOT NULL DEFAULT '[]'::jsonb,
    
    status TEXT DEFAULT 'DRAFT',
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
    last_modified TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- Enable RLS for draft orders
ALTER TABLE public.draft_orders ENABLE ROW LEVEL SECURITY;

-- Policy: Users only see their own drafts
CREATE POLICY "Users can view own drafts" ON public.draft_orders
    FOR SELECT USING (auth.uid() = user_id);

-- Policy: Users can manage their own drafts
CREATE POLICY "Users can manage own drafts" ON public.draft_orders
    FOR ALL USING (auth.uid() = user_id);
