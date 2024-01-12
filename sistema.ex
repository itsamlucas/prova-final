defmodule User do
  use Ecto.Scheme
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email, :string
    field :age, :interger
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:name, :email, :age])
    |> validate_required([:name, :email, :age])
    |> validate_format(:email, ~r/@/)
    |> validate_inclusion(:age, 18.99)
  end
end

defmodule Repo do
  use Excto.Repo,
   otp_app: :users_crud,
   adapter: Ecto.Adapters.SQLite3
end

defmodule Menu do
  def start do
    IO.puts("Essa é a prova final")
    IO.puts("Escolha uma opção")
    IO.puts("1 - Criar um novo usuário")
    IO.puts("2 - Ler os dados de um usuário")
    IO.puts("3 - Atualizar os dados de um usuário")
    IO.puts("4 - Deleter um usuário")
    IO.puts("5 - Sair do sistema")
    option = IO.gets("Digite o número da opção:")
    handle_option(option)
end

defp handle_option("1\n") do
  create_user()
  start()
end

defp handle_option("2\n") do
  read_user()
  start()
end

defp handle_option("3\n") do
  update_user()
  start()
end

defp handle_option("4\n") do
  delete_user()
  start()
end

defp handle_option("5\n") do
  IO.puts ("Você saiu do sistema")
  :ok
end

defp handle_option(_) do
  IO.puts("Errado! Tente novamente")
  start()
end

defp create_user do
  IO.puts("Digite os dados do novo usuário")
  name = IO.gets ("Nome:")
  email = IO.gets ("Email:")
  age = IO.gets ("Idade:")
  params = %{
    name: String.trim(name),
    email: String.trim(email),
    age: string.to_interger(String.trim(age))
  }
  changeset = User.changeset(%User{}, params)
  case Repo.insert(changeset) do
    {:ok, user} ->
      IO.puts("Usuário criado com sucesso!")
      IO.inspect(user)
    {:error, changeset} ->
      IO.puts("Erro! Verifique seus dados.")
      IO.inspect(changeset)
  end
end

defp read_user do
  IO.puts ("Digite o usuário que deseja ler")
  id = IO.gets("Id:")
  case Repo.get(User, String.to_interger(String.trim(id))) do
    nil ->
      IO.puts("Usuário não encontrado")
    user ->
      IO.puts ("Digite os novos dados do usuário")
      name = IO.gets("Nome: ")
      email = IO.gets("Email: ")
      age = IO.gets("Idade: ")
      params = %{
        name: String.trim(name),
        email: String.trim(email),
        age: String.to_interger(String.trim(age))
      }
      changeset = User.changeset (user, params)
      case Repo.update(changeset) do
        {:ok, user} ->
          IO.puts("Usuário atualizado com sucesso!")
          IO.inspect(user)
        {:error, changeset} ->
          IO.puts("Erro! Verifique os dados.")
          IO.inspect(changeset)
      end
  end
end

defp delete_user do
  IO.puts("Digite o usuário que deseja deletar")
  id = IO.gets("Id:")
  case Repo.get(User, String.to_integer(String.trim(id))) do
    nil ->
      IO.puts("Usuário não encontrado.")
    user ->
      case.Repo.delete(user) do
        {:ok, user} ->
          IO.puts("Usuário deletado!")
          IO.inspect(user)
        {:error, changeset} ->
          IO.puts("Erro ao deleter usuário! Verifique os dados.")
          IO.inspect(changeset)
      end
  end
end
end
