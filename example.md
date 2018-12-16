# My French Vocabulary

## Food

Food - La nourriture
Vegetarian - Le Végétarien
Vegan - Le Végétalien
To have a breakfast or lunch - Déjeuner
To have a dinner - Dîner
To drink - Boire
To eat - Manger
Hunger - La faim
Thirst - La soif
To be hungry - Avoir faim
To be thirsty - Avoir soif

### Vegetables

Vegetables - Les légumes
Artichoke - Le artichaut
Asparagus - Les asperges
Eggplant - La aubergine
Carrot - La carotte
Celery - Le céleri
Mushroom - Le champignon
Cauliflower - Le chou-fleur
Cabbage - Le chou
Cucumber - Le concombre
Spinach - Les épinards
Bean - L'haricot
Lentil - Le lentille
Lettuce -  La laitue
Beetroot - La Betterave
Onion - Le oignon
Garlic - L'ail
Broccoli - Le Brocoli
Corn - Le maïs
Peas - Les petits pois
Potato - La pomme de terre
Radish - Le radis
Horseradish - Le raifort
Tomato - La tomate

### Fruit

Forest fruit - Fruit de la forêt
Exotic fruit - Fruit Exotique
Apricot - Le abricot
Peach - La pêche
Pineapple - Le ananas
Banana - La banane
Cherry - La cerise
Lemon - Le citron
Lime - Le citron vert
Strawberry - La fraise
Raspberry - La Framboise
Blackberry - La Mûre
Blueberry - La Myrtille
Orange - La orange
Grapefruit - Le pamplemousse
Watermelon - La pastèque
Pear - La poire
Apple - Le pomme
Plum - La prune
Grape - Le raisin
Walnut, Nut - Le noyer
Peanut - L'arachide, La cacahouète
Juniper - Le genévrier
Ginger - Le gingembre
Mint - La menthe

# Devops Questions

What is Canary Release:
* You start with deployment with no users routed to. After testing you route small portion of users (internal users, random users, geographical partition) to it.
* Slow release of new software version only on a small userbase (for example user ID mod number).
* With Canary Release we need only `N+1` resources. You can repurpose your existing infrastructure using **Phoenix Servers** / **Immutable Servers** (Replacing old instances/version with new).
* Canary release is Parallel Change that lasts until all users are routed to new version.
* Advantage is incrementality, capacity testing with ability to rollback.

Explain building, linking, compiling:
* Compiling is the act of turning source code into object code.
* Linking is the act of combining object code with libraries into a raw executable.
* Building is the sequence composed of compiling and linking, with possibly other tasks such as installer creation.

## Test Driven Development

Is core practice of _Extreme Programming_.
The idea is that, because writing tests can improve the design of what you build, you should write the test before you write the code you test. The classic working rhythm is _red-green-refactor_.

Code coverage for TDD should be at least 80%.

Red-Green-Refactor:
* Red - Write a test for the next change you want to make, run the test, and see that it fails.
* Green - Implement minimal code and test the definitions until the test passes.
* Refactor - Improve the new and old definitions to make it well structured.

TDD workflow:
* Write a "single" unit test describing an aspect of the program
* Run the test, which should fail because the program lacks that feature
* Write "just enough" code, the simplest possible, to make the test pass
* "Refactor" the code until it conforms to the simplicity criteria
* Repeat, "accumulating" unit tests over time

What is **Perfection**? Perfection is Achieved Not When There Is Nothing More to Add, But When There Is Nothing Left to Take Away (Antoine de Saint-Exupery).
