# run this to seed the database

usda_farms_seed = [
  %{name: "Bob's Sunflower Farm", address: "123 Plainfield", usda_uid: "00345"},
  %{name: "Bartleby & Son's", address: "400 Plainfield", usda_uid: "00920"},
]

NomNomsFarm.Repo.insert_all(NomNomsFarm.UsdaFarm, usda_farms_seed)
