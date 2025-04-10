-- Insert sample todo items for users

-- Declare a variable to hold the user ID
DO $$
DECLARE
    user_id_1 UUID;
    user_id_2 UUID;
    user_id_3 UUID;
BEGIN
    -- Query user IDs based on name
    SELECT id INTO user_id_1 FROM auth.users WHERE name = 'user'; -- Replace 'user' with the actual name
    SELECT id INTO user_id_2 FROM auth.users WHERE name = 'admin'; -- Replace 'admin' with the actual name

    -- Insert todo items using the queried user IDs
    INSERT INTO public.user_todos (user_id, title, description, completed)
    VALUES
        (user_id_1, 'Complete project documentation', 'Write detailed documentation for the current project', false),
        (user_id_1, 'Review pull requests', 'Review and merge pending pull requests', false),
        (user_id_1, 'Update dependencies', 'Check and update project dependencies', true),
        (user_id_2, 'Schedule team meeting', 'Set up weekly team sync meeting', false),
        (user_id_2, 'Prepare presentation', 'Create slides for upcoming client meeting', false),
        (user_id_1, 'Test new features', 'Run comprehensive tests on new features', false),
        (user_id_2, 'Fix critical bugs', 'Address high-priority issues in the backlog', true);
END $$;

-- Add comment to the seed file
COMMENT ON TABLE public.user_todos IS 'Sample todo items for demonstration purposes'; 