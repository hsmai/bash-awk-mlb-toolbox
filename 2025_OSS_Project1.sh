#!/bin/bash


CSV_file="$1"

if [ ! -f "$CSV_file" ] 
then
    echo "usage: ./2025_OSS_Project1.sh file"
    exit 1
fi


#----------------------------------------functions------------------------------------


function whoami() {
    echo "**********2025_OSS_Project1***********"
    echo "*        StudentID : 12214206        *"
    echo "*        Name : Sangmin Han          *"
    echo "**************************************"
}



function Search_Player() {
    
   
    read -p "Enter a player name to search: " First_name Last_name
    
    Full_name="$First_name $Last_name"
    
    echo ''
    echo "Player stats for \"$Full_name\":"
    awk  -F',' -v full="$Full_name" '$2==full {printf "Player: %s, Team: %s, Age: %s, WAR: %s, HR: %s, BA: %s\n", $2, $4, $3, $6, $14, $20}' "$CSV_file"
}



function SLG_ranked() {

    read -p "Do you want to see the top 5 players by SLG? (y/n) : " answer
    
    case "$answer" in
        [yY])
          echo ''
          echo "***Top 5 Players by SLG***"
          awk -F',' '$8 >= 502' "$CSV_file" | sort -t, -k22 -nr | head -n 5 | awk -F',' '{printf "%d. %s (Team:%s) - SLG: %s, HR: %s, RBI: %s\n", NR, $2, $4, $22, $14, $15}' ;;
        [nN])
            echo ''
            echo "enter \'y\' if you want to list the top 5 players ranked by SLG" ;;
        
        *)
            echo ''
            echo "enter y or n" ;;
     esac
}


function Analyze_teamstat() {

    read -p "Enter team abbreviation (e.g., NYY, LAD, BOS): " team_name
    
    valid_team=$(awk -F',' -v team="$team_name" '$4 == team {found=1; exit} END {print found+0}' "$CSV_file")
    
    if [ "$valid_team" -eq 0 ]; then
        echo "No team name '$team_name'. Please try again"
        return
    fi
    
    
    echo ''
    echo "Team stats for $team_name:"
    awk -F',' -v team="$team_name" '
        $4 == team {
            age_sum += $3; 
            homerun_sum += $14; 
            RBI_sum += $15; 
            count++;
            } END { 
                if (count>0) {
                    printf "Average age: %.1f\n", age_sum / count; 
                    printf "Total home runs: %d\n", homerun_sum; 
                    printf "Total RBI: %d\n", RBI_sum
                }
        }' "$CSV_file"
            
}



function Compare_players() {
    
    echo ''
    echo "Compare players by age groups:"
    echo "1. Group A (Age < 25)"
    echo "2. Group B (Age 25-30)"
    echo "3. Group C (Age > 30)"
    read -p "Select age group (1-3):" group_selection
    
    case "$group_selection" in
        1)
        echo ''
        echo "Top 5 by SLG in Group A (Age < 25):"
        awk -F',' '$3 < 25 && $8 >= 502' "$CSV_file" | sort -t, -k22 -nr | head -n 5 | awk -F',' '{
            printf "%s (%s) - Age: %s, SLG: %s, BA: %s, HR: %s\n", $2, $4, $3, $22, $20, $14
            }'
        ;;
        
        
        2)
        echo ''
        echo "Top 5 by SLG in Group B (Age 25-30):"
        awk -F',' '$3 >= 25 && $3 <= 30 && $8 >= 502' "$CSV_file" | sort -t, -k22 -nr | head -n 5 | awk -F',' '{
            printf "%s (%s) - Age: %s, SLG: %s, BA: %s, HR: %s\n", $2, $4, $3, $22, $20, $14
            }'
        ;;
        
        
        3)
        echo ''
        echo "Top 5 by SLG in Group C (Age > 30):"
        awk -F',' '$3 > 30 && $8 >= 502' "$CSV_file" | sort -t, -k22 -nr | head -n 5 | awk -F',' '{
            printf "%s (%s) - Age: %s, SLG: %s, BA: %s, HR: %s\n", $2, $4, $3, $22, $20, $14
            }'
        ;;
        
        
        *)
            echo ''
            echo "no age group '$group_selection'. Please choose age group between (1-3)"
            ;;
     esac
}



function User_specified_filter() {
    
    echo ''
    echo "Find players with specific criteria"
    read -p "Minimum home runs:" min_hr
    read -p "Minimum batting average (e.g., 0.280):" min_batting
    
    
    if ! [[ "$min_hr" =~ ^[0-9]+$ ]] || ! [[ "$min_batting" =~ ^0\.[0-9]+$ ]]; then
        echo "Invalid input. Please enter \'number\' in home runs, and \'decimal\' in batting average"
        return
    fi
    
    
    echo ''
    echo "Players with HR >= $min_hr and BA >= $min_batting:"
    
    awk -F',' -v min_hr="$min_hr" -v min_ba="$min_batting" '
        $8 >= 502 && $14 >= min_hr && $20 >= min_ba {
            print $2 "," $14 "," $20 "," $15 "," $4 "," $22 
        }
    ' "$CSV_file" | sort -t, -k2 -nr | head -n 6 | awk -F',' '{
        printf "%s (%s) - HR: %s, BA: %s, RBI: %s, SLG: %s\n", $1, $5, $2, $3, $4, $6
        }'
    
}



function Team_reports() {
    
    echo "Generate a formatted player report for which team?"
    read -p "Enter team abbreviation (e.g., NYY, LAD, BOS): " team_name
    echo ''
    
    
    valid_team=$(awk -F',' '{print $4}' "$CSV_file" | grep -w "$team_name" | wc -l)
    
    if [ "$valid_team" -eq 0 ]; then
        echo "No team name '$team_name'. Please try again"
        return
    fi
    
    
    echo "================== $team_name PLAYER REPORT =================="
    echo "Date: $(date +%Y/%m/%d)"
    echo "---------------------------------------------------------"
    echo "PLAYER                HR   RBI   AVG   OBP   OPS"
    echo "---------------------------------------------------------"
    awk -F',' -v team="$team_name" '$4 == team {
        print $2 "," $14 "," $15 "," $20 "," $21 "," $23}' "$CSV_file" | sort -t, -k2 -nr | awk -F',' '{
            printf "%-20s %3s %4s %4s %4s %4s\n", $1, $2, $3, $4, $5, $6;
            count++
        }
        END {
            print "------------------------------------------------";
            printf "TEAM TOTALS: %d players\n", count;
        }'
    
}



function exit_func() {
    echo "Have a good day!"
    exit 0
}


#-----------------------------------menu---------------------------------------


function menu() {
    while true 
    do
        echo ""
        echo "[MENU]"
        echo "1.Search player stats by name in MLB data"
        echo "2.List top 5 players by SLG value"
        echo "3.Analyze the team stats - average age and total home runs"
        echo "4.Compare players in different age groups"
        echo "5.Search the players who meet specific statistical conditions"
        echo "6.Generate a performance report (formatted data)"
        echo "7.Quit"
        read -p "Enter your COMMAND (1~7): " selection
        
        case "$selection" in
            1) Search_Player ;;
            2) SLG_ranked ;;
            3) Analyze_teamstat ;;
            4) Compare_players ;;
            5) User_specified_filter ;;
            6) Team_reports ;;
            7) exit_func ;;
            *) echo "Wrong Selection. Enter number between 1~7" ;;
        esac
    done
}


#------------------------------------------execution------------------------------

whoami
menu
