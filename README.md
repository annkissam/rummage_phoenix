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

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `rummage_phoenix` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:rummage_phoenix, "~> 0.1.0"}]
    end
    ```

  2. Ensure `rummage_phoenix` is started before your application:

    ```elixir
    def application do
      [applications: [:rummage_phoenix]]
    end
    ```

