# Rummage.Phoenix

`Rummage.Phoenix` is a support framework for Phoenix that can be used to manipulate Phoenix collections and Ecto
models with Search, Sort and Paginate operations.

It accomplishes the above operations by using `Rummage.Ecto`, to paginate `Ecto` queries and adds Phoenix and HTML
support to views and controllers. For information on how to configure `Rummage.Ecto` visit
[this](/Users/adiiyengar/Excipients/rummage_ecto) page.

**NOTE: Rummage is not like Ransack, and doesn't intend to be either. It doesn't add functions based on search params.
If you'd like to have that for a model, you can always configure Rummage to use your Search module for that model. This
is why Rummage has been made configurable.**


## Installation

If [available in Hex](https://hexdocs.pm/rummage_phoenix/api-reference.html), the package can be installed as:

  - Add `rummage_phoenix` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [
        {:rummage_phoenix, "~> 0.5.0"}
      ]
    end
    ```


## Usage

### Pagination

  - Use Rummage.Ecto in the models/ecto structs:

  ```elixir
  defmodule MyApp.Product do
    use MyApp.Web, :model
    use Rummage.Ecto, repo: MyApp.Repo, per_page: 5

    # More code below....
  end
  ```

  - Use Rummage.Controller in to controller module:

  ```elixir
  defmodule MyApp.ProductController do
    use MyApp.Web, :controller
    use Rummage.Phoenix.Controller, struct: :product, helper: MyApp.Router.Helpers

    # More code below....
  end
  ```

  - Change the index action in the controller:

  ```elixir
  def index(conn, params) do
    {query, rummage} = Product
      |> Product.rummage(params["rummage"])

    products = Repo.all(query)

    render conn, "index.html",
      products: products,
      rummage: rummage
  end
  ```

  - Test with params:

  [![after pagination](https://github.com/Excipients/rummage_phoenix/tree/master/src/images/rummage_ecto_paginate.png "Pagination")]
  ![custom paginated params](https://github.com/Excipients/rummage_phoenix/tree/master/src/images/custom_paginated_params.png "Custom Paginated Params")
  ![custom paginated page](https://github.com/Excipients/rummage_phoenix/tree/master/src/images/custom_paginated_page.png "Custom Paginated Page")


