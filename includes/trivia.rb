module Trivia
  def self.Question(number)
    [
      {
        question: "Which local organization has vowed to match donations up to 1 million dollars this year?",
         answers: [
          "San Joaquin Community Hospital",
          "Kern County Public Health",
          "Advanced Industrial Services",
          "C.B.C.C" # Correct answer
         ],
         correct_answer: 3
      },
      {
        question: "Which two awards did Little Big Town win at the 2012 C.M.A's?",
         answers: [
          "Vocal Group of the Year and Music Video of the Year",
          "Best Performance and Single of the Year",
          "Vocal Group of the Year and Single of the Year", # Correct answer
          "Best Performance and Music Video of the Year"
         ],
         correct_answer: 2
      },
      {
        question: "Which championship title is being defended at this Saturday's event?",
         answers: [
          "I.F.B.A Heavyweight World Title",
          "W.B.C Super Welter Weight Championship", # Correct answer
          "I.F.B.A Lightweight World Title",
          "W.B.C Women's World Championship"
         ],
         correct_answer: 1
      },
      {
        question: "Mia St. John, the defending champion this Saturday, founded which children's organization?",
         answers: [
          "El Saber Es Poder", # Correct answer
          "League of United Latin American Citizens ",
          "El Pueblo Inc.",
          "Amigos For Kids"
         ],
         correct_answer: 0
      },
      {
        question: "Which men's magazine did champion Mia St. John appear in?",
         answers: [
          "G.Q.",
          "F.H.M",
          "Maxim",
          "Playboy" # Correct answer
         ],
         correct_answer: 3
      },
      {
        question: "Little Big Town members Kimberly Roads and Karen Fairchild met at which university?",
         answers: [
          "Samford University", # Correct answer
          "University of Alabama",
          "University of Atlanta, Georgia",
          "American Baptist College"
         ],
         correct_answer: 0
      },
      {
        question: "According to the California Cancer Registry, in 2011 which type of cancer occured most frequently in Kern County?",
         answers: [
          "Lung Cancer",
          "Colon Cancer",
          "Breast Cancer", # Correct answer
          "Prostate Cancer"
         ],
         correct_answer: 2
      }
    ][number]
  end
end
