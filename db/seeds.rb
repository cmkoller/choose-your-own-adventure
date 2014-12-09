users = [
  { provider: 'github', uid: '8760086', username: 'cmkoller',
    name: 'Christina Koller', email: 'cmkoller01@gmail.com',
    avatar_url: 'https://avatars.githubusercontent.com/u/8670086?v=3' }
]

stories = [
  { title: "A Launch Academy Adventure", user_id: '1' }
]

pages = [
  { story_id: 1, page_num: 1,
    page_header: "Welcome to Launch Academy!",
    page_body: "It's your first day, and you've finally found your way to the
      building after parking troubles galore (you're NEVER bringing your car
      again that's for sure). You walk in and reach the elevator. Uh oh, it's
      on the 8th floor.",
    dest1: 2, action1: "Wait for the elevator.",
    dest2: 3, action2: "Take the stairs.",
    dest3: nil, action3: nil,
    dest4: nil, action4: nil,
  },
  { story_id: 1, page_num: 2,
    page_header: "The elevator finally arrives!",
    page_body: "You get on, along with an old man.",
    dest1: 4, action1: "Make pleasant conversation.",
    dest2: 5, action2: "Ignore him and check your phone.",
    dest3: nil, action3: nil,
    dest4: nil, action4: nil,
  },
  { story_id: 1, page_num: 3,
    page_header: "You start walking up the stairs...",
    page_body: "but halfway up the flight, they're locked with a big black gate!
      Boo, how inconvenient.  Who would lock people out of the stairs,
      what a silly idea.",
    dest1: 2, action1: "Go back and wait for the elevator.",
    dest2: nil, action2: nil,
    dest3: nil, action3: nil,
    dest4: nil, action4: nil,
  },
  { story_id: 1, page_num: 4,
    page_header: "You have a brief but heartwarming interaction...",
    page_body: "...and it turns out the old man is actually a benevolent alien
      with superpowers. Due to your friendly demeanor, he grants you a
      superpower of your choice, along with a supersuit to go with it.
      (He's a pretty cool alien.)",
    dest1: 7, action1: "Choose the power of flight.",
    dest2: 8, action2: "Choose the power of super-human strength.",
    dest3: 9, action3: "Choose the power of really spot-on interior decorating skills.",
    dest4: nil, action4: nil,
  },
  { story_id: 1, page_num: 5,
    page_header: "You ignore the old man...",
    page_body: "...and get the mysterious feeling that you may have passed by
      a chance at greatness.",
    dest1: 6, action1: "Get off at Floor 5.",
    dest2: nil, action2: nil,
    dest3: nil, action3: nil,
    dest4: nil, action4: nil,
  },
  { story_id: 1, page_num: 6,
    page_header: "You go about your day at Launch Academy...",
    page_body: "...and have a pretty awesome time despite the amazing
      opportunities you missed on your way here.",
    dest1: nil, action1: nil,
    dest2: nil, action2: nil,
    dest3: nil, action3: nil,
    dest4: nil, action4: nil,
  },
  { story_id: 1, page_num: 7,
    page_header: " The old man bequeaths you with the power of flight...",
    page_body: "...and you begin a secret life of badass coder by day,
      whizzing-through-the-air superhero by night. You save many lives, inspire
      many hopeless youths, code cool projects, and have an all-around
      very good time.",
    dest1: nil, action1: nil,
    dest2: nil, action2: nil,
    dest3: nil, action3: nil,
    dest4: nil, action4: nil,
  },
  { story_id: 1, page_num: 8,
    page_header: " The old man bequeaths you with the power of super-human strength...",
    page_body: "...and you begin a secret life of badass coder by day,
      boulder-smashing-car-hefting superhero by night. You save many lives,
      inspire many hopeless youths, code cool projects, and have an all-around
      very good time.",
    dest1: nil, action1: nil,
    dest2: nil, action2: nil,
    dest3: nil, action3: nil,
    dest4: nil, action4: nil,
  },
  { story_id: 1, page_num: 9,
    page_header: "The old man bequeaths you with the power of spot-on interior decorating skills...",
    page_body: "...and you begin a secret life of badass coder by day,
      color-scheming-furniture-arranging vigilante interior decorator by night.
      You rescue many ugly living rooms, inspire many hopeless youths,
      code cool projects, and have an all-around very good time.",
    dest1: nil, action1: nil,
    dest2: nil, action2: nil,
    dest3: nil, action3: nil,
    dest4: nil, action4: nil,
  },
]

users.each do |user|
  User.create(user)
end

stories.each do |story|
  Story.create(story)
end

pages.each do |page|
  Page.create(page)
end
