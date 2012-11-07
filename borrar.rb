person1 = {first: "Antonio", last: "Gil"}
person2 = {first: "Pilar", last: "Marquez"}
person3 = {first: "Mauricio", last: "Gil"}

params = {}
params[:father] = person1
params[:mother] = person2
params[:child]  = person3


p person2.merge(person1)

