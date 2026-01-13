# bash-awk-mlb-toolbox


# MLB 2024 CLI Analytics (Bash + Awk)

MLB 2024 시즌 선수 성적 CSV(455 rows × 33 columns)를 대상으로,  
**Bash + Awk**만으로 검색/리더보드/팀 분석/조건 필터/리포트를 제공하는 **인터랙티브 CLI 프로그램**입니다.

> 한 번 실행하면 메뉴 기반으로 1~7번 기능을 계속 수행할 수 있습니다.

---

## Features

### 1) Search player stats by name
- 사용자 입력 `firstname lastname`로 **full name**을 구성
- 해당 선수의 주요 스탯 출력:
  - **Name, Team, Age, WAR, HR, BA**

### 2) Top 5 players ranked by SLG (PA 조건 포함)
- 사용자 의사(y/n)를 `case`로 처리
- **PA >= 502** 인 선수만 대상으로
- **SLG(22번째 필드) 내림차순** 상위 5명 출력

### 3) Team stats (Average Age / Total HR / Total RBI)
- 팀 약어(예: NYY, LAD, BOS) 입력
- 팀 존재 여부를 먼저 검증한 뒤
- **평균 나이, 총 HR, 총 RBI** 출력

### 4) Compare players by age groups (Top 5 by SLG)
- 나이 그룹 선택(1~3)
  - Group A: Age < 25
  - Group B: 25 <= Age <= 30
  - Group C: Age > 30
- **PA >= 502** 조건 적용
- 각 그룹에서 **SLG 상위 5명** 출력

### 5) Custom filter (HR & BA 조건) + Top 6
- 최소 HR(정수), 최소 BA(소수) 입력
- 입력값 형식 검증 후
- **PA >= 502** + 조건 만족 선수만 필터링
- **HR 내림차순 정렬 후 상위 6명** 출력

### 6) Team performance report (Formatted)
- 팀 약어 입력 후 리포트 출력
- 실행 날짜(date) 포함
- 팀 선수들을 **HR 기준 정렬**하여 표 형태로 출력
- 마지막에 **팀 총 선수 수(count)** 출력

### 7) Quit
- `Have a good day!` 출력 후 종료

---

## Dataset Assumptions (CSV Column Index)

이 스크립트는 입력 CSV에서 아래 “필드 위치”를 사용합니다.  
데이터셋 컬럼 순서가 다르면 결과가 달라질 수 있습니다.

| Metric | Field Index (awk) |
|---|---:|
| Player Name | $2 |
| Age | $3 |
| Team | $4 |
| WAR | $6 |
| PA | $8 |
| HR | $14 |
| RBI | $15 |
| BA | $20 |
| OBP | $21 |
| SLG | $22 |
| OPS | $23 |

---

## Requirements
- bash
- awk
- coreutils: `sort`, `head`, `grep`, `wc`, `date`

(macOS / Linux 터미널에서 동작)

---

## Quick Start

### 1) 권한 부여
```bash
chmod +x 2025_OSS_Project1.sh
```

### 2) 실행 (CSV 파일 인자 필수)
```bash
./2025_OSS_Project1.sh path/to/mlb_2024.csv
```

---

## Program Flow

실행 시:

- whoami 출력(프로젝트명/학번/이름)
<br>

- 메뉴 출력 후 사용자 입력에 따라 기능 수행
<br>

- Quit(7) 선택 전까지 반복 실행

## MENU

```text
1.Search player stats by name in MLB data
2.List top 5 players by SLG value
3.Analyze the team stats - average age and total home runs
4.Compare players in different age groups
5.Search the players who meet specific statistical conditions
6.Generate a performance report (formatted data)
7.Quit
```

---

## Example Usage

### (1) 선수 검색

```text
Enter a player name to search: Juan Soto
Player stats for "Juan Soto":
Player: Juan Soto, Team: NYY, Age: 25, WAR: 7.1, HR: 41, BA: 0.288
```

### (2) SLG Top 5

```text
Do you want to see the top 5 players by SLG? (y/n) : y
***Top 5 Players by SLG***
1. Player A (Team:LAD) - SLG: 0.650, HR: 45, RBI: 110
...
```

### (3) 팀 리포트

```text
================== LAD PLAYER REPORT ==================
Date: 2026/01/13
---------------------------------------------------------
PLAYER                HR   RBI   AVG   OBP   OPS
---------------------------------------------------------
Mookie Betts          27   80   0.295 0.380 0.900
...
TEAM TOTALS: 14 players
```

---

## Notes

- 리더보드(Top N) 관련 기능은 PA >= 502 조건을 사용합니다.

- 팀 약어는 데이터셋의 Team 필드($4)에 존재하는 값과 동일해야 합니다.

- `whoami` 정보(학번/이름)는 스크립트 상단의 출력부를 수정하면 됩니다.

---

## Project Files

- `2025_OSS_Project1.sh` : Main CLI program (Bash + Awk)







