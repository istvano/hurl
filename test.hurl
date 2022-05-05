GET https://www.google.com/

HTTP/* 200
[Asserts]
duration < 1000
xpath "string(/html/head/title)" == "Google"