# MLB 2024 Player Stats CLI (Bash + Awk)

MLB 2024 시즌 **선수 성적 CSV(455×33, comma-separated)** 를 입력으로 받아,  

**Bash + Awk 기반의 메뉴형 CLI 프로그램**으로 

선수 검색, SLG Top5, 팀 통계 분석, 연령대 비교, 조건 필터링, 팀 리포트 생성을 수행합니다.

---

## Project Requirements

- 입력: `2024_MLB_Player_Stats.csv` (CSV, comma-separated)
- Bash script + awk 중심으로 처리 (Python/pandas 등 금지)
- 팀/선수명 하드코딩 금지
- 실행 시 인자 파일 존재 여부 확인 (잘못된 파일이면 사용법 출력 후 종료)
- 학번/이름 출력(whoami)
- 메뉴 기반으로 1~7 기능 수행, 7(Quit) 선택 전까지 반복

---

## Dataset Format

CSV Header (33 columns)

Rk, Player, Age, Team, Lg, WAR, G, PA, AB, R, H, 2B, 3B, HR, RBI, SB, CS, BB, SO, BA, OBP, SLG, OPS, OPS+, rOBA, Rbat+, TB, GIDP, HBP, SH, SF, IBB, Pos

<br>

본 스크립트에서 주요 사용 컬럼(awk 기준)

- Player: `$2`  
- Age: `$3`  
- Team: `$4`  
- WAR: `$6`  
- PA: `$8`  
- HR: `$14`  
- RBI: `$15`  
- BA: `$20`  
- OBP: `$21`  
- SLG: `$22`  
- OPS: `$23`  

---

## How to Run

1) 실행 권한 부여  
```bash
chmod +x 2025_OSS_Project1.sh
```

2) 실행 (CSV 인자 필수)

```bash
./2025_OSS_Project1.sh 2024_MLB_Player_Stats.csv
```

인자가 없거나 파일이 유효하지 않으면 아래 사용법을 출력하고 종료합니다.

```text
usage: ./2025_OSS_Project1.sh file
```

---

## Program Flow

- whoami 출력 (프로젝트명 / 학번 / 이름)
- 메뉴 출력
- 사용자 입력에 따라 기능 실행
- 7(Quit) 선택 전까지 반복

---

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

## Features
<br>

## 1) Search player statistics by name

- 사용자에게 firstname, lastname 입력 받기
- full name = firstname + " " + lastname 로 구성
- awk로 해당 선수 정보 출력
  - 출력 필드: Name, Team, Age, WAR, HR, BA
  - 방식: -F',' 로 CSV 구분자 지정, -v full 로 awk 변수 전달
  - 조건: $2 == full 일 때 printf로 출력

<br>

## 2) List the top 5 players ranked by SLG

- 사용자에게 기능 사용 여부(y/n) 입력 받기
- case로 y/n/기타 입력 처리

- y인 경우:
  - PA < 502 제외
  - SLG(22번째 필드) 기준 내림차순 정렬
  - 상위 5명 출력
  - sort 옵션: sort -t, -k22 -nr
  - head -n 5 적용
  - awk -F',' 로 필요한 필드 출력

- n인 경우:
  - 원하면 y를 입력하라는 메시지 출력

- 잘못된 입력:
  - y 또는 n을 입력하라는 메시지 출력

<br>

## 3) Analyze the team statistics (Average Age / Total HR / Total RBI)

- 사용자에게 팀명(약어) 입력 받기

- 팀 유효성 검사:
  - 명령어 치환으로 valid_team=0 또는 1 저장
  - $4(Team) 가 입력 팀과 일치하는 행이 있다면 1, 없으면 0

- valid_team 이 0이면:
  - 에러 메시지 출력 후 종료/복귀

- awk로 팀 단위 통계 계산:
  - $4 == team 인 행에서 age/hr/rbi 누적
  - count 로 선수 수 계산
  - END 에서 평균 나이(age_sum/count), 총 HR, 총 RBI 출력

<br>

## 4) Compare players in different age groups (Top 5 by SLG)

- 공통 조건: PA < 502 제외
- 사용자에게 나이 그룹 입력 받기

- case로 그룹 분기 후 각 그룹별로:
  - awk로 나이 조건($3) 필터 + PA 조건($8) 필터
  - SLG(22) 기준 sort -t, -k22 -nr
  - head -n 5
  - awk로 필요한 필드 출력

- 잘못된 그룹 입력 시:
  - 에러 메시지 출력

<br>

## 5) Find players meeting custom conditions (min HR & min BA)

- 사용자 입력:
  - 최소 홈런수(min HR)
  - 최소 타율(min BA)

- 입력 검증:
  - min HR이 정수인지 if로 검사
  - min BA가 소수 형태인지 if로 검사
  - 부적절하면 에러 메시지 출력

- 공통 조건: PA < 502 제외
- 홈런수 기준 내림차순 정렬

- 파이프라인 형태(awk 2개 연결):
  - 1번째 awk: 조건(PA, HR, BA) 만족 행만 추출
  - sort로 HR 기준 정렬
  - head -n 6
  - 2번째 awk: 최종 출력 포맷으로 필드 출력

<br>

## 6) Generate performance reports for specific teams

- 사용자에게 팀명 입력 받기

- 리포트 출력:
  - date 명령어로 실행 시점 날짜 출력

- 팀 선수 출력(홈런 기준 정렬):
  - awk 2개 파이프라인 구성
  - 정렬 후 선수별 주요 필드 출력
  - count 로 선수 수 누적
  - END 에서 팀 총 선수 수 출력

<br>

## 7) Quit

- Have a good day! 출력 후 프로그램 종료









