DECLARE Sentiment_analysis_prompt STRING;

SET Sentiment_analysis_prompt = 'Analyze this social media comment and label the sentiment that is being conveyed as either Positive, Neutral, or Negative \n Example:Collaborating on a school project with peers. Teamwork makes the dream work. Answer:Positive';


WITH PromptTable AS (
  SELECT
    CONCAT(Sentiment_analysis_prompt, '\n Comment:', Text) AS prompt,
    Year,
    Likes,
    Country,
    Month,
    Text,
    Unnamed__0,
    Platform
  FROM `PROJECT_ID.Clean_data.Social Media Comments`)


SELECT
  Unnamed__0 AS row_index,
  Text AS Social_Media_Comment,
  ml_generate_text_llm_result AS Sentiment_Analysis_By_AI_Model,
  Platform,
  Likes,
  Country,
  Year,
  Month,
FROM
  ml.generate_text(MODEL `PROJECT_ID.ai_model.company_llm`,
  (SELECT * FROM PromptTable),
  STRUCT(
    0.2 AS temperature,
    10 AS max_output_tokens,
    0.6 AS top_p,
    1 AS top_k,
    TRUE AS flatten_json_output
  )
  );
