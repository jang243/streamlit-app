import streamlit as st
import base64
from PIL import Image
import pandas as pd
import numpy as np

# 페이지 설정
st.set_page_config(page_title="Cooking Assistant", layout="centered")

# CSS 스타일을 사용하여 배경 이미지 추가 및 레이아웃 조정
def add_bg_from_local(image_file):
    with open(image_file, "rb") as image:
        encoded = base64.b64encode(image.read()).decode()
    st.markdown(
        f"""
        <style>
        .stApp {{
            background-image: url(data:image/jpeg;base64,{encoded});
            background-size: cover;
            background-position: center;
        }}
        </style>
        """,
        unsafe_allow_html=True
    )

# 초기 화면에만 배경 이미지 추가
if "page" not in st.session_state:
    st.session_state.page = 0

# 사용자 데이터를 세션 상태에 저장
if "user_data" not in st.session_state:
    st.session_state.user_data = {}

# 업로드된 파일을 세션 상태에 저장
if "uploaded_files" not in st.session_state:
    st.session_state.uploaded_files = []

# 페이지 이동 함수
def next_page():
    st.session_state.page += 1

def prev_page():
    st.session_state.page -= 1

# 업로드된 파일 경로
uploaded_file_path = r'C:\Users\Administrator\Desktop\dummy_user_data_with_ratings.csv'
user_info_df = pd.read_csv(uploaded_file_path, encoding='utf-8')

# 기존 사용자 ID 로드
existing_user_ids = np.unique(user_info_df['user_id'])

# 페이지 0: 초기 화면
if st.session_state.page == 0:
    add_bg_from_local('C:/Users/Administrator/Desktop/1.jpg')
    st.markdown("<div class='main'>", unsafe_allow_html=True)
    st.title("안녕하세요")

    if st.button("신규 회원 가입"):
        st.session_state.new_user = True
        next_page()
        st.experimental_rerun()

    user_id = st.text_input("기존 사용자 ID를 입력하세요")
    if user_id:
        st.session_state.user_id = user_id
        st.session_state.new_user = False
        next_page()
        st.experimental_rerun()
    st.markdown("</div>", unsafe_allow_html=True)

# 페이지 1: 사용자 기본 정보 입력 화면
elif st.session_state.page == 1:
    st.markdown("<div class='main'>", unsafe_allow_html=True)

    if st.session_state.new_user:
        st.title("사용자의 기본 정보를 입력하세요")

        user_id = st.text_input("유저 아이디를 입력하세요", key='user_id')
        print(user_id)
        if "user_id_check" not in st.session_state:
            st.session_state.user_id_check = False

        if st.button("ID 중복확인"):
            if user_id in existing_user_ids:
                st.error("이미 존재하는 ID입니다. 다시 설정해주세요.")
                st.session_state.user_id_check = False
            else:
                st.success("사용 가능한 ID입니다.")
                st.session_state.user_id_check = True

        sex_options = ["남자", "여자"]
        sex = st.radio("성별", sex_options, index=0, key='sex')
        age_options = ["10대", "20대", "30대", "40대", "50대", "60대"]
        age = st.radio("연령대", age_options, index=0, key='age')
        allergy_options = ["견과류", "복숭아", "생선", "없음"]
        allergies = st.multiselect("알레르기 음식", allergy_options, key='allergies')

        if st.button("다음"):
            if not st.session_state.user_id_check:
                st.error("ID 중복확인을 해주세요.")
            else:
                st.session_state.user_data.update({
                    "user_id": user_id,
                    "sex": sex,
                    "age": age,
                    "allergies": allergies
                })
                next_page()
                st.experimental_rerun()
        if st.button("이전"):
            prev_page()
            st.experimental_rerun()

    else:
        st.title("환영합니다!")
        st.write(f"사용자 ID: {st.session_state.user_id}")
        if st.button("다음"):
            next_page()
            st.experimental_rerun()
        if st.button("이전"):
            prev_page()
            st.experimental_rerun()
    st.markdown("</div>", unsafe_allow_html=True)

# 페이지 2: 조미료 선택 화면
elif st.session_state.page == 2:
    st.markdown("<div class='main'>", unsafe_allow_html=True)
    st.title("조미료를 선택하세요")

    seasoning_options = ["소금", "설탕", "후추", "고춧가루","없음"]
    selected_seasonings = st.multiselect("조미료", seasoning_options, key='seasonings')

    st.title("양념장을 선택하세요")
    sauce_options = ["다진마늘", "고추장", "된장", "케챱", "마요네즈","없음"]
    selected_sauces = st.multiselect("양념장", sauce_options, key='sauces')

    if st.button("다음"):
        st.session_state.user_data["seasonings"] = selected_seasonings
        st.session_state.user_data["sauces"] = selected_sauces
        next_page()
        st.experimental_rerun()
    if st.button("이전"):
        prev_page()
        st.experimental_rerun()
    st.markdown("</div>", unsafe_allow_html=True)

# 페이지 3: 앱 화면
elif st.session_state.page == 3:
    st.markdown("<div class='main'>", unsafe_allow_html=True)
    st.title("앱 화면")

    col1, col2 = st.columns([1, 2])
    with col1:
        st.image(r'C:\Users\Administrator\Desktop\APP_LOGO.png', caption='앱 로고', use_column_width=True)
        st.markdown("### 메뉴")
        st.button("홈")
        st.button("종류별 레시피")
        st.button("재료별 레시피")
        st.button("영상 레시피")
        if st.button("나의 추천 레시피"):
            next_page()
            st.experimental_rerun()

    with col2:
        st.markdown("### 오늘의 인기 레시피")
        st.image(r'C:\Users\Administrator\Desktop\APP_first.jpg', caption='맛간장 계란비빔밥', use_column_width=True)
        st.image(r'C:\Users\Administrator\Desktop\APP_first.jpg', caption='공원나들이 도시락', use_column_width=True)
        st.image(r'C:\Users\Administrator\Desktop\2018013002095_0.jpg', caption='깔끔한 과일깍기', use_column_width=True)
        st.image(r'C:\Users\Administrator\Desktop\1.jpg', caption='봄나들이 도시락', use_column_width=True)
        st.image(r'C:\Users\Administrator\Desktop\APP_first.jpg', caption='전자렌지로 콩떡 만드는법', use_column_width=True)
        st.image(r'C:\Users\Administrator\Desktop\2018013002095_0.jpg', caption='NO오븐 계란빵', use_column_width=True)

    if st.button("이전"):
        prev_page()
        st.experimental_rerun()
    st.markdown("</div>", unsafe_allow_html=True)

# 페이지 4: 최종 화면 및 이미지 업로드
elif st.session_state.page == 4:
    st.markdown("<div class='main'>", unsafe_allow_html=True)
    st.title("원하는 식재료를 촬영해주세요.")

    uploaded_files = st.file_uploader("이미지 업로드", type=["jpg", "jpeg", "png"], accept_multiple_files=True)

    if uploaded_files:
        st.session_state.uploaded_files = uploaded_files
        for uploaded_file in uploaded_files:
            image = Image.open(uploaded_file)
            st.image(image, caption=f'업로드한 이미지: {uploaded_file.name}', use_column_width=True)

        if st.button("다음"):
            next_page()
            st.experimental_rerun()

    if st.button("이전"):
        prev_page()
        st.experimental_rerun()
    st.markdown("</div>", unsafe_allow_html=True)

# 페이지 5: 추천 레시피 화면
elif st.session_state.page == 5:
    st.markdown("<div class='main'>", unsafe_allow_html=True)
    st.title("추천 레시피")
    st.write("여기에는 YOLO 모델을 통해 인식된 재료를 바탕으로 추천 레시피가 표시됩니다.")

    if st.button("다음"):
        next_page()
        st.experimental_rerun()
    if st.button("이전"):
        prev_page()
        st.experimental_rerun()
    st.markdown("</div>", unsafe_allow_html=True)
