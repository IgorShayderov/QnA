ThinkingSphinx::Index.define :comment, with: :active_record do
  indexes author.email, as: :author, sortable: true
  indexes body

  has user_id, created_at, updated_at
end
