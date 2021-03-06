defmodule AccentTest.GraphQL.Resolvers.Viewer do
  use Accent.RepoCase

  alias Accent.GraphQL.Resolvers.Viewer, as: Resolver

  alias Accent.{
    Repo,
    ProjectCreator,
    User,
    Language
  }

  defmodule PlugConn do
    defstruct [:assigns]
  end

  @user %User{email: "test@test.com"}

  setup do
    user = Repo.insert!(@user)
    language = Repo.insert!(%Language{name: "English", slug: Ecto.UUID.generate()})
    {:ok, project} = ProjectCreator.create(params: %{name: "My project", language_id: language.id}, user: user)
    user = %{user | permissions: %{project.id => "owner"}}

    {:ok, [user: user]}
  end

  test "show", %{user: user} do
    context = %{context: %{conn: %PlugConn{assigns: %{current_user: user}}}}
    {:ok, result} = Resolver.show(nil, %{}, context)

    assert result == user
  end
end
