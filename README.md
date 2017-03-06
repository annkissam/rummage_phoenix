# Rummage.Phoenix

[![Build Status](https://travis-ci.org/Excipients/rummage_phoenix.svg?branch=master)](https://travis-ci.org/Excipients/rummage_phoenix)
[![Coverage Status](https://coveralls.io/repos/github/Excipients/rummage_phoenix/badge.svg?branch=master)](https://coveralls.io/github/Excipients/rummage_phoenix?branch=master)
[![Hex Version](http://img.shields.io/hexpm/v/rummage_phoenix.svg?style=flat)](https://hex.pm/packages/rummage_phoenix)
[![hex.pm downloads](https://img.shields.io/hexpm/dt/rummage_phoenix.svg)](https://hex.pm/packages/rummage_phoenix)
[![Hex docs](http://img.shields.io/badge/hex.pm-docs-green.svg?style=flat)](https://hexdocs.pm/rummage_phoenix)
[![docs](https://inch-ci.org/github/Excipients/rummage_phoenix.svg)](http://inch-ci.org/github/Excipients/rummage_phoenix)
[![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/Excipients/rummage_phoenix/master/LICENSE)

`Rummage.Phoenix` is a support framework for `Phoenix` that can be used to manipulate `Phoenix` collections and `Ecto`
models with Search, Sort and Paginate operations.

It accomplishes the above operations by using `Rummage.Ecto`, to paginate `Ecto` queries and adds Phoenix and HTML
support to views and controllers. For information on how to configure `Rummage.Ecto` visit
[this](https://github.com/Excipients/rummage_ecto) page.

The best part about rummage is that all the three operations: `Search`, `Sort` and `Paginate` integrate seamlessly and
can be configured separately. To check out their seamless integration, please check the information below.

**NOTE: `Rummage` is not like `Ransack`, and doesn't intend to be either. It doesn't add functions based on search params.
If you'd like to have that for a model, you can always configure `Rummage` to use your `Search` module for that model. This
is why Rummage has been made configurable.**

________________________________________________________________________________________________

**Search, Sort and Paginate seamlessly in Phoenix!**

![phoenix all together](src/images/rummage_all_together.gif)

________________________________________________________________________________________________

## Installation

This is [available in Hex](https://hexdocs.pm/rummage_phoenix/), the package can be installed as:

  - Add `rummage_phoenix` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [
        {:rummage_phoenix, "~> 1.0.0"}
      ]
    end
    ```

## Configuration (Optional, Not the preferred way to set `default_per_page`)

`Rumamge.Phoenix` can be configured globally with a `default_per_page` value (which can be overriden for a model).
This is **NOT** the preferred way to set `default_per_page` as it might lead to conflicts. It is recommended to
do it per model as show below in the [Initial Setup](#initial-setup) section. If you want to set `default_per_page`
for all the models, add it to `model` function in `web.ex`

  - Add `rummage_phoenix` config to your list of configs in `dev.exs`:

    ```elixir
    config :rummage_phoenix,
      Rummage.Phoenix,
      default_per_page: 5
    ```

## Usage (The screenshots correspond to version 0.6.0, soon there will be screenshots for version 1.0.0)

### Initial Setup

  - Use `Rummage.Ecto` in the models/ecto structs:

  ```elixir
  defmodule MyApp.Product do
    use MyApp.Web, :model
    use Rummage.Ecto

    # More code below....
  end
  ```

  - Use `Rummage.Controller` in to controller module:

  ```elixir
  defmodule MyApp.ProductController do
    use MyApp.Web, :controller
    use Rummage.Phoenix.Controller

    # More code below....
  end
  ```

  - Change the `index` action in the controller:

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

  - if using Search feature, define a `search` path in the `router.ex` (no need to define the action):

  ```elixir
  scope "/", MyApp do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/products", ProductController
  end
  ```

Doing this itself will allow you to search, sort and paginate by updating `params` on the request.
Please check the [screenshots](#more-screenshots) below for details


### Using Rummage.ViewHelpers

  - Use `Rummage.View` in to a view module:

  ```elixir
  defmodule MyApp.ProductView do
    use MyApp.Web, :view
    use Rummage.Phoenix.View

    # More code below...
  end
  ```

  - #### Pagination:
  Add this at the bottom of `index.html.eex` to render `Rummage` pagination links (Make sure that you
  pass `rummage` to the views from the `index` action in the controller) :

  ```elixir
  <%= pagination_link(@conn, @rummage) %>
  ```

  Reload and this is how your page should look:

  ![phoenix pagination](src/images/rummage_phoenix_pagination.png)


  - #### Sorting:
  Replace table headers on the `index.html.eex` with sort links (Make sure that the headers are actual columns in the
  table in the database.)

  Replace this:
  ```elixir
    <th>Name</th>
    <th>Price</th>
    <th>Category</th>
  ```

  With:
  ```elixir
    <th><%= sort_link @conn, @rummage, [field: :name, ci: true] %></th>
    <th><%= sort_link @conn, @rummage, [field: :price] %></th>
  ```

  OR for Sort by associations:
  ```elixir
    <th><%= sort_link @conn, @rummage, [field: :category_name, name: "Category Name", assoc: ["category"]] %></th>
  ```

  Reload and this is how your page should look with sortable links instead of just table headers:

  ![phoenix sorting](src/images/rummage_phoenix_sorting.png)

  **NOTE: Currently working on adding better elements to the views, soon the text
  arrow in the sort links will be replaced by an icon**

  - ### Searching:
  Add a search form in the `index.html.eex` with searchable fields:

  ```elixir
  <%= search_form(@conn, @rummage, [fields:
  [
    name: %{label: "Search by Product Name", search_type: "ilike"},
    price: %{label: "Search by Price", search_type: "eq"},
  ], button_class: "btn",
  ]) %>
  ```
  OR for Search by associations:

  ```elixir
  <%= search_form(@conn, @rummage, [fields:
  [
    category_name: %{label: "Search by Category Name", search_type: "ilike", assoc: ["category"]}
  ], button_class: "btn",
  ]) %>
  ```

  Reload and your page should look somewhat like this:
  ![phoenix searching](src/images/rummage_phoenix_searching.png)

  - #### ALL TOGETHER:
  The best part about `Rummage` is that all the three hooks/operations integrate seamlessly without affecting each other's functionality
  and therefore, you have a page looking somewhat like this:

  ![phoenix all together](src/images/all_together.png)

## More Screenshots

### Before rummage
![before pagination](src/images/before_rummage.png)

### After Pagination:

- Default pagination:

![after pagination](src/images/rummage_ecto_paginate.png)

- Custom pagination params:

![custom pagination params](src/images/custom_pagination_params.png)
![custom pagination page](src/images/custom_paginated_page.png)

### After Pagination View:

- Default
![after pagination](src/images/rummage_ecto_paginate.png)

- Custom pagination params
![phoenix pagination](src/images/rummage_phoenix_pagination.png)

### After Sort:

![custom sort params asc](src/images/custom_sort_params_asc.png)
![custom sort page asc](src/images/rummage_ecto_sort_asc.png)


![custom sort params desc](src/images/custom_sort_params_desc.png)
![custom sort page desc](src/images/rummage_ecto_sort_desc.png)

### After Sort View:

![phoenix sorting](src/images/rummage_phoenix_sorting.png)

### After Search:

![custom search params](src/images/custom_search_params.png)
![custom search page](src/images/rummage_ecto_search.png)

### After Search View:

![phoenix searching](src/images/rummage_phoenix_searching.png)

## Coming up Next:

- Better sort links using icons instead of arrows.
- Not having to pass repo, helpers and model while using view, if default.
- Not having to pass repo, helpers and model while using controller, if default.
- A Video with the demo.



