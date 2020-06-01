#from https://m.blog.naver.com/wideeyed/221771836059
def get_kor_amount_string(num_amount, ndigits_round=0, str_suffix=''):
    """숫자를 자릿수 한글단위와 함께 리턴한다 """
    if isinstance(num_amount, str):
      num_amount = int(num_amount)
    assert isinstance(num_amount, int) and isinstance(ndigits_round, int)
    if num_amount == 0: return '영'
    assert num_amount >= 1, '최소 1원 이상 입력되어야 합니다'
    ## 일, 십, 백, 천, 만, 십, 백, 천, 억, ... 단위 리스트를 만든다.
    maj_units = ['만', '억', '조', '경', '해', '자', '양', '구', '간', '정', '재', '극'] # 10000 단위
    units     = [' '] # 시작은 일의자리로 공백으로하고 이후 십, 백, 천, 만...
    for mm in maj_units:
        units.extend(['십', '백', '천']) # 중간 십,백,천 단위
        units.append(mm)
    
    list_amount = list(str(round(num_amount, ndigits_round))) # 라운딩한 숫자를 리스트로 바꾼다
    list_amount.reverse() # 일, 십 순서로 읽기 위해 순서를 뒤집는다
    
    str_result = '' # 결과
    num_len_list_amount = len(list_amount)
    
    for i in range(num_len_list_amount):
        str_num = list_amount[i]
        # 만, 억, 조 단위에 천, 백, 십, 일이 모두 0000 일때는 생략
        if num_len_list_amount >= 9 and i >= 4 and i % 4 == 0 and ''.join(list_amount[i:i+4]) == '0000':
            continue
        if str_num == '0': # 0일 때
            if i % 4 == 0: # 4번째자리일 때(만, 억, 조...)
                str_result = units[i] + str_result # 단위만 붙인다
        elif str_num == '1': # 1일 때
            if i % 4 == 0: # 4번째자리일 때(만, 억, 조...)
                str_result = str_num + units[i] + str_result # 숫자와 단위를 붙인다
            else: # 나머지자리일 때
                str_result = units[i] + str_result # 단위만 붙인다
        else: # 2~9일 때
            str_result = str_num + units[i] + str_result # 숫자와 단위를 붙인다
    str_result = str_result.strip() # 문자열 앞뒤 공백을 제거한다 
    if len(str_result) == 0:
        return None
    if not str_result[0].isnumeric(): # 앞이 숫자가 아닌 문자인 경우
        str_result = '1' + str_result # 1을 붙인다
    return str_result + str_suffix # 접미사를 붙인다

__map = dict(zip("1234567890", "일이삼사오육칠팔구영"))
def num_to_alpha(text):
  __f = lambda t: __map[t] if t.isdigit() else t
  return "".join(__f(t) for t in text)

if __name__ == '__main__':
  __test = [
    (0, '영'),
    (7, '칠'),
    (10, '일십'), # fix to 십?
    (20, '이십'),
    (978, '구백칠십팔'),
    ('0', '영'),
    ('7', '칠'),
    ('10', '일십'), # fix to 십?
    ('20', '이십'),
    ('978', '구백칠십팔')
  ]
  v = get_kor_amount_string(978)
  print(num_to_alpha(v))

  for a, b in __test:
    res = num_to_alpha(get_kor_amount_string(a))
    print(a, res)
    assert res == b
