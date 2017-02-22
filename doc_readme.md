# Rummage.Phoenix

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
