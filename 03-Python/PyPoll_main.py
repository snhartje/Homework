# Stephanie Hartje - March 16, 2019 - Homework: 03-Python

# Import modules and list file path
import os
import csv

PyPoll_csv = os.path.join("../PyPoll", "election_data.csv")

# Open and read PyBank_csv
with open(PyPoll_csv, newline = '') as csvfile:
    csvreader = csv.reader(csvfile, delimiter = ",")

    #Read the header row first
    csv_header = next(csvfile)

    #create a three lists from csv data - Voter ID, County, and Candidate
    VoterID = []
    County = []
    Candidate = []
    
    for row in csvreader:
        VoterID.append(str(row[0]))
        County.append(str(row[1]))
        Candidate.append(str(row[2]))

    #Count number of votes and create a variable to hold it
    TotalVotes = len(VoterID)

    #Find unique names in Candidate list
    templist = set(Candidate)
    UniqueCandidates = list(templist)

    #The total number of votes each candidate won
    VotesPerCandidate = []
    for x in UniqueCandidates:
        CandidateVotes = Candidate.count(x)
        VotesPerCandidate.append(int(CandidateVotes))

    #The percentage of votes per candidate
    PercentPerCandidate = []
    for x in VotesPerCandidate:
        PercentVotes = x/TotalVotes
        PercentPerCandidate.append(PercentVotes)  

    #Create one list of the candidates, percent, and votes
    Results = list(zip(UniqueCandidates, PercentPerCandidate, VotesPerCandidate))

    #Sort Results in descending order based on votes
    Results.sort(key=lambda x: x[2], reverse = True)

    #print results
    print(f"Election Results")   
    # spacer row of "---------------------------"
    print(f"---------------------------------------------------")    
    # "Total Votes: "
    print(f"Total Votes: {TotalVotes}")
    # spacer row of "---------------------------"
    print(f"---------------------------------------------------") 
    # Each candidate: % of votes, (total # of votes)
    print(f"{Results[0][0]}: {Results[0][1]:.3%} ({Results[0][2]})")
    print(f"{Results[1][0]}: {Results[1][1]:.3%} ({Results[1][2]})")
    print(f"{Results[2][0]}: {Results[2][1]:.3%} ({Results[2][2]})")
    print(f"{Results[3][0]}: {Results[3][1]:.3%} ({Results[3][2]})")
    # spacer row of "---------------------------"
    print(f"---------------------------------------------------") 
    # Winner's name
    print(f"Winner: {Results[0][0]}")
    # spacer row of "---------------------------"
    print(f"---------------------------------------------------")

    #export a text file with results (how do we do that?)
    
    file = open("PyPoll_Results.txt", "w")

    file.write("Stephanie Hartje - March 16, 2019 - Homework: 03-Python\n")
    
    file.write(f"Election Results\n")   
    # spacer row of "---------------------------"
    file.write(f"---------------------------------------------------\n")    
    # "Total Votes: "
    file.write(f"Total Votes: {TotalVotes}\n")
    # spacer row of "---------------------------"
    file.write(f"---------------------------------------------------\n") 
    # Each candidate: % of votes, (total # of votes)
    file.write(f"{Results[0][0]}: {Results[0][1]:.3%} ({Results[0][2]})\n")
    file.write(f"{Results[1][0]}: {Results[1][1]:.3%} ({Results[1][2]})\n")
    file.write(f"{Results[2][0]}: {Results[2][1]:.3%} ({Results[2][2]})\n")
    file.write(f"{Results[3][0]}: {Results[3][1]:.3%} ({Results[3][2]})\n")
    # spacer row of "---------------------------"
    file.write(f"---------------------------------------------------\n") 
    # Winner's name
    file.write(f"Winner: {Results[0][0]}\n")
    # spacer row of "---------------------------"
    file.write(f"---------------------------------------------------\n")

    file.close()