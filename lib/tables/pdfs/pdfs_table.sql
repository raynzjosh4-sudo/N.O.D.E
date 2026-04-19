-- lib/tables/pdfs/pdfs_table.sql
CREATE TABLE IF NOT EXISTS public.pdfs_table (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users_table(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    file_url TEXT NOT NULL,
    file_size TEXT, -- For display (e.g., '1.2 MB')
    
    -- Metadata captures any extra info needed for reconstruction or context
    metadata JSONB DEFAULT '{}'::jsonb, 
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- Enable RLS for PDF table
ALTER TABLE public.pdfs_table ENABLE ROW LEVEL SECURITY;

-- Policy: Users can only see their own PDFs
CREATE POLICY "Users can view own PDFs" ON public.pdfs_table
    FOR SELECT USING (auth.uid() = user_id);

-- Policy: Users can insert their own PDFs
CREATE POLICY "Users can upload own PDFs" ON public.pdfs_table
    FOR INSERT WITH CHECK (auth.uid() = user_id);
