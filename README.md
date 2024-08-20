
<a href="https://club-project-one.vercel.app/" target="_blank">
<img width="700" alt="스크린샷 2024-08-14 오전 7 48 26" src="https://github.com/user-attachments/assets/af31b6d0-0e76-4977-b7a3-07c30567b97d">
</a>

<br/>
<br/>

# 1. 프로젝트 개요
- 서비스 이름: 무장애 맞춤화 관광지 추천 "챗봇 서비스" - 아띠
- 프로젝트 설명: AI챗봇을 통해 용인에 있는 모든 관광지에 대한 사용자 맞춤화 정보 제공 

<br/>
<br/>

# 2. 팀 소개
| 도성현 | 이바체슬라브(이윤빈) | 박준서 | 오에린 |
|:------:|:------:|:------:|:------:|
| <img src="https://avatars.githubusercontent.com/u/52828205?v=4" alt="이동규" width="150"> | <img src="https://avatars.githubusercontent.com/u/81556800?v=4" alt="이바체슬라브" width="150"> | <img src="https://avatars.githubusercontent.com/u/81576126?v=4" alt="박준서" width="150"> | <img src="https://avatars.githubusercontent.com/u/62730155?v=4" alt="오에린" width="150"> |
| 백/프론트 개발 | 백/프론트 개발 | 기획/디자인 | AI모델 학습/데이터 수집 및 전처리 |
| [GitHub](https://github.com/glaxyt) | [GitHub](https://github.com/kanado5385-k) | [GitHub](https://github.com/Debuging-JunSeoPark) | [GitHub](https://github.com/eoh9) |


<br/>
<br/>

# 3. 주요 기능
<img width="700" alt="스크린샷 2024-08-14 오전 8 18 23" src="https://github.com/user-attachments/assets/bc95b1e1-4af9-4d28-9411-92c5128a75a3">

- **설문조사**:
  - 맞춤화를 위한 서비스 선택.

- **AI챗봇**:
  - 사용자에게 AI챗봇을 통해 궁금해하거나 찾는 관광지에 대한 정도 제공.
 
- **지도**:
  - 채팅에서 언급된 관광지를 사용자 중심으로 지도에서 표시.

- **상세페이지**:
  - 특정 관광지에 대한 세부 정보 제공.
 
# 4. AI챗봇(GPT-4o mini)
<img width="500" alt="스크린샷 2024-08-14 오전 8 42 07" src="https://github.com/user-attachments/assets/4cda3b68-43c8-4d00-8a6d-6d8c8756c3d1">
<br/>
<br/>

# 4-1. 데이터 수집 및 전처리
1. 모델 로딩 및 데이터 준비
* 용인시 열린관광과 용인관광 웹페이지를 selenium을 통해 크롤링하여 관광명소와 관련 정보 수집
* 수집한 데이터프레임에서 관광지명, 주소, 특징 등의 컬럼을 문자열로 변환하고, 이들 컬럼을 결합하여 feature라는 새로운 컬럼을 제작
* 이 feature 컬럼을 기반으로, 각 관광지에 대한 임베딩을 생성하여 hf_embeddings 컬럼에 저장
![KakaoTalk_Photo_2024-08-14-09-39-35](https://github.com/user-attachments/assets/1d32ecbd-aee5-432a-87d3-b4477df83dbb)

2. 임베딩 기반 검색 기능
* 사용자가 입력한 쿼리(예: "휠체어 대여가 되는 관광지를 알고싶어")에 대해 임베딩을 생성
* 이 쿼리 임베딩과 hf_embeddings에 저장된 관광지 임베딩 간의 코사인 유사도를 계산하여, 가장 유사한 관광지들을 top_k 개수만큼 찾음(임의로 top_k=3으로 지정)
![KakaoTalk_Photo_2024-08-14-09-40-45](https://github.com/user-attachments/assets/e3a6d3f3-a503-437a-a7b0-e755082b8fe7)


3. ChatGPT 기반 대화 모델 설정
* msg_prompt라는 사전(dictionary)에 다양한 사용자 의도(intent)에 따른 시스템 메시지와 사용자 메시지의 템플릿을 정의함. 
* 예를 들어, '추천', '설명', '검색'이라는 의도에 따라 각각 다른 메시지 템플릿을 사용할 수 있도록 설정
![KakaoTalk_Photo_2024-08-14-09-43-36](https://github.com/user-attachments/assets/895c3a65-2503-429e-8086-0ba38fa5a3c5)


4. 사용자 상호작용 처리 함수 (user_interact)
* 사용자의 쿼리를 분석하여 의도를 파악
* 이를 위해 ChatGPT API를 사용하여, 사용자의 입력을 분석하고 intent를 식별함
* 식별된 intent에 따라 적절한 msg_prompt를 선택하고, 최종적으로 사용자에게 반환할 메시지를 생성함
* 만약 사용자의 쿼리가 관광지 추천이나 검색에 해당하면, 유사도가 높은 관광지 정보를 제공하고, 그 정보에 대해 상세 설명을 하거나 적절한 추천 메시지를 생성하여 사용자에게 반환함
* 생성된 메시지들은 jsonl로 제작하여 추후, 관광 맞춤 챗봇을 개발하기 위한 파인튜닝 데이터셋으로 활용함

5. 사용자의 의도에 따른 작업 수행
* 추천 또는 검색: 사용자의 질문에 대해 가장 유사한 관광지 정보를 추출하고, 해당 정보를 사용자에게 제공하는 메시지를 생성
* 설명: 특정 관광지에 대한 설명이 요청된 경우, 이미 계산된 유사도를 기반으로 해당 관광지의 상세 정보를 제공

6. ChatGPT 메시지 생성
![KakaoTalk_Photo_2024-08-14-09-41-35](https://github.com/user-attachments/assets/3cce61e2-7af9-4ce5-afb2-f3f09435c304)

# 4-2. GPT-4o-mini Fine-tuning
![KakaoTalk_Photo_2024-08-14-10-10-49](https://github.com/user-attachments/assets/d3822b84-5dee-4f70-ae17-8e2014028b3d)
- 4-1에서 수집한 데이터를 토대로 jsonl형식으로 변환 후, fine-tuning 진행
- Trained tokens: 16,449
- Epochs: 3
- Batch size: 1
- LR multiplier: 1.8
- Seed: 1024073020
<img width="500" alt="스크린샷 2024-08-15 오후 12 40 33" src="https://github.com/user-attachments/assets/f83c6f44-509b-4842-831a-143f419e88fd">

<br/>

# 5. 카카오맵 API 연동
  - 사용자 위치 기반 시스템
  - 커스터마이징한 지도

