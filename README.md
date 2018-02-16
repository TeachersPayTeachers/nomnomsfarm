# NomNomsFarms

A simple Elixir toy app built to demonstrate how we can set up a GraphQL endpoint for registering users, and storing user and other relevant information to a database.
Our goal is to persist only data that is valid, or return a helpful error otherwise.
We’ll leverage [Ecto.Multi](https://hexdocs.pm/ecto/Ecto.Multi.html)  and [Ecto.Repo.transaction](https://hexdocs.pm/ecto/Ecto.Repo.html#c:transaction/2) to write a clean user registration flow and handle errors elegantly.

## Problem

<img src="/images/nomnomslogo.png" />

*NomNomsFarm* is a new food cart serving the neighborhood with local, organic, fair trade, free-range, farm-fresh, artisinal delicacies. We're in charge of running logistics for *NomNomsFarm* and we need to build an online registration flow for local farms to become part of the food cart's supply chain.


## Instructions

1. Clone the repo.
2. Run `mix deps.get` to download the dependencies.
2. In the repo run `mix setup`. (This will create the database, migrate the schema, and [seed](https://github.com/TeachersPayTeachers/nomnomsfarm/blob/master/priv/ecto/seed.exs) the USDA farms table.)

### To run the app

1. run `iex -S mix phx.server`
2. Go to `http://localhost:4000/graphiql`
3. Run mutations. Try:
```
  mutation {
    registerFarmAdmin(
      username: "bart",
      password: "password",
      name: "Bartleby",
      email: "bart@bartlebysons.com",
      usdaUid: "00920",
    )
  }
```

### To run the tests

1. Run `MIX_ENV=test mix setup`
2. run `mix test`

Please reach out with questions, comments or suggestions for how we can improve.

Thanks!
