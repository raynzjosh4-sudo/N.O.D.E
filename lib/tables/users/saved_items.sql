-- lib/tables/users/saved_items.sql
CREATE TABLE IF NOT EXISTS public.saved_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users_table(id) ON DELETE CASCADE,
    
    -- The ID of the product from the products catalog
    product_id UUID NOT NULL, 
    
    quantity INTEGER DEFAULT 1,
    selected_color TEXT,
    selected_size TEXT,
    
    -- Snapshot data can be stored in metadata if products might change frequently
    product_snapshot JSONB DEFAULT '{}'::jsonb, 
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
    
    -- Ensure a user doesn't have duplicate entries for same product/variant
    UNIQUE(user_id, product_id, selected_color, selected_size)
);

-- Enable RLS
ALTER TABLE public.saved_items ENABLE ROW LEVEL SECURITY;

-- Policy: Users only see their own saved items
CREATE POLICY "Users can view own saved items" ON public.saved_items
    FOR SELECT USING (auth.uid() = user_id);

-- Policy: Users can manage their own saved items
CREATE POLICY "Users can manage own saved items" ON public.saved_items
    FOR ALL USING (auth.uid() = user_id);
