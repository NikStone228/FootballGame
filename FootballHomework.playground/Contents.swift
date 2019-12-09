import UIKit


struct Tournament {

  var schedule = [[Int]]()
  
  struct Team {
    let name: String
    let number: Int
    var wins: Int = 0
    var draws: Int = 0
    var losses: Int = 0
    
    init(number: Int, name: String) {
      self.name = name
      self.number = number
    }

    var points: Int {
      return wins * 3 + draws
    }
    var matchesPlayed: Int {
      return wins + draws + losses
    }
  }
  
  var teamList = [Team]()
  struct MatchDay {
    let day: Int
    let teamplaying: (Int, Int)
    let teamscore: (Int, Int)
    let teams: Array<Team>
    var tournamentTable = Array(repeating: 0, count: 12)
    
    init(day: Int, teamplaying: (Int, Int), teamscore: (Int, Int), teams: Array<Team>){
      self.day = day
      self.teamplaying = teamplaying
      self.teamscore = teamscore
      self.teams = teams
    }
  }
  
  var matchDayResult = Array<MatchDay>()
  
  func randomNameGenerate(_ length: Int) -> String {
    let letters = "AB"
    return String((0..<length).map{ _ in letters.randomElement()! })
  }
  
  mutating func teamNameGeneration() {
    for number in 1...12 {
      teamList.append(Team(number: number, name: randomNameGenerate(7)))
    }
  }
  

  mutating func scheduleGenerationFor12Teams() {
    let n = 12
    var tournamentTable = Array(repeating: Array(repeating: Array(repeating: 0, count: 2), count: n / 2), count: n - 1)
    var teamPairs = [Int]()
    var tournamentSchedule = [[Int]]()

    for r in 1..<n {
      teamPairs.append(1)
      teamPairs.append(r + 1)
      tournamentTable[r - 1][0] = teamPairs
      teamPairs = []
      
      for i in 2...(n/2) {
        teamPairs.append((r+i-2) % (n-1) + 2)
        teamPairs.append((n-1+r-i) % (n-1) + 2)
        tournamentTable[r-1][i-1] = teamPairs
        teamPairs = []
      }
    }
    for y in 0..<tournamentTable.count {
      for x in 0..<tournamentTable[y].count {
        tournamentSchedule.append(tournamentTable[y][x])
      }
    }
    schedule = tournamentSchedule + tournamentSchedule
  }

  mutating func start(){
    for day in 0..<schedule.count {
      let team1score = Int.random(in: 0...7)
      let team2score = Int.random(in: 0...7)
      
      if team1score == team2score {
        teamList[schedule[day][0] - 1].draws += 1
        teamList[schedule[day][1] - 1].draws += 1
      }
      if team1score > team2score {
        teamList[schedule[day][0] - 1].wins += 1
        teamList[schedule[day][1] - 1].losses += 1
      }
      if team1score < team2score {
        teamList[schedule[day][0] - 1].losses += 1
        teamList[schedule[day][1] - 1].wins += 1
      }
      
      var matchDaytmp = MatchDay(day: day + 1, teamplaying: (schedule[day][0], schedule[day][1]), teamscore: (team1score, team2score), teams: teamList)
            
      for team in 1...teamList.count {
        matchDaytmp.tournamentTable[team - 1] = teamList[team - 1].points
      }
      matchDayResult.append(matchDaytmp)
    }
  }
 
  func sortTeams(_ teams: [Team]) -> [Team] {
    let sorted = teams.sorted { team1, team2 -> Bool in
      if team1.points == team2.points {
        if team1.wins == team2.wins {
          return team1.name < team2.name
        } else {
          return team1.wins > team2.wins
        }
      } else {
        return team1.points > team2.points
      }
    }
    return sorted
  }
  
  func printTournamentTableResultsOfDay(_ day: Int) {
    guard day > 0 && day <= schedule.count else {return print("Day is not found")}
    var teams = matchDayResult[day - 1].teams
    teams = sortTeams(teams)
    
    print("Rating table in \(day)th day")
    var result = "Team--------MP----W-----D-----L-----P"
    for team in teams {
      let name = team.name
      result += "\n\(name)"
      let numberOfSpaces = 10 - name.count
      for _ in 1...numberOfSpaces {
        result += " "
      }
        
      var shuffleMP = "", shuffleW = "", shuffleD = "", shuffleL = ""
      if team.matchesPlayed < 10 {shuffleMP = " "}
      if team.wins < 10 {shuffleW = " "}
      if team.draws < 10 {shuffleD = " "}
      if team.losses < 10 {shuffleL = " "}
      result += "| \(team.matchesPlayed)\(shuffleMP) |  \(team.wins)\(shuffleW) |  \(team.draws)\(shuffleD) |  \(team.losses)\(shuffleL) |  \(team.points)"
    }
    print(result)
  }
    
  func printSchedule(_ day: Int) {
    guard day > 0 && day <= schedule.count else {return print("Day out of range")}
    for days in 0..<day {
      let currentDayResults = matchDayResult[days]
      print("\(teamList[currentDayResults.teamplaying.0 - 1].name) vs \(teamList[currentDayResults.teamplaying.1 - 1].name): \(currentDayResults.teamscore.0) - \(currentDayResults.teamscore.0). Day: \(days + 1)th")
    }
  }
  
  func printWinners(){
    var teams = matchDayResult.last!.teams
    teams = sortTeams(teams)
    print("Winners of tournament")
    var result = "Team--------MP-----W-----D----L----P"
    for i in 0...2 {
      let name = teams[i].name
      result += "\n\(name)"
      let numberOfSpaces = 10 - name.count
      for _ in 1...numberOfSpaces {
        result += " "
      }
      result += "|  \(teams[i].matchesPlayed) |  \(teams[i].wins) |  \(teams[i].draws) |  \(teams[i].losses) |  \(teams[i].points)"
    }
    print(result)
  }
}

var tournament = Tournament()
tournament.teamNameGeneration()
tournament.scheduleGenerationFor12Teams()


tournament.start()
print("Start Tournament")
print("*************************************")
tournament.printSchedule(31)
print("*************************************")
tournament.printTournamentTableResultsOfDay(7)
print("*************************************")
tournament.printWinners()

