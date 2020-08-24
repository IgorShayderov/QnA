ThinkingSphinx::Index.define :user, with: :active_record do
  has id, email, created_at, updated_at
end
