source mygeminikey

curl=`cat <<EOS
curl -s \
  -X POST 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key='${API_KEY} \
  -H 'Content-Type: application/json' \
  -d '{
  "contents": [
    {
      "parts": [
        {
          "text": "$*"
        }
      ]
    }
  ],
  "generationConfig": {
    "temperature": 0.9,
    "topK": 1,
    "topP": 1,
    "maxOutputTokens": 2048,
    "stopSequences": []
  },
  "safetySettings": [
    {
      "category": "HARM_CATEGORY_HARASSMENT",
      "threshold": "BLOCK_MEDIUM_AND_ABOVE"
    },
    {
      "category": "HARM_CATEGORY_HATE_SPEECH",
      "threshold": "BLOCK_MEDIUM_AND_ABOVE"
    },
    {
      "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
      "threshold": "BLOCK_MEDIUM_AND_ABOVE"
    },
    {
      "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
      "threshold": "BLOCK_MEDIUM_AND_ABOVE"
    }
  ]
}'

EOS`


echo $curl >ttcmdcurlg
eval ${curl} |tee ttgeminiout|jq .candidates[].content.parts[].text |sed 's/\\n/\n/g' |sed 's/"//g' |tee ttgout
if [ ! -s ttgout ]; then
cat  ttgeminiout
fi
