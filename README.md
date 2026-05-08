# 📊 Digital Marketing Campaign Performance Analysis

**Tool:** MySQL  |  **Dataset:** Kaggle (SINDERPREET)  |  **Period:** February 2021

## 🎯 Business Question
Are we allocating our $30.6M marketing budget efficiently across channels? Which campaigns should get more budget — and which should be cut?

## 📁 Files
| File | Description |
|------|-------------|
| `marketing-campaign-analysis.sql` | Full SQL analysis (import → validation → EDA → analysis) |
| `marketing-campaign-writeup.docx` | Project write-up with findings and recommendations |

## 🔑 Key Findings
- **Influencer** channel delivers 2.54x ROAS but receives only 27.2% of budget — heavily underinvested
- **Social** receives 45.1% of spend but generates a 0.86x ROAS — losing money on every dollar
- **youtube_blogger** has the highest campaign ROMI at +277.3%; **facebook_lal** destroys -88.6%
- **Friday** is the highest-revenue day; **Tier 1** cities outperform Tier 2 with 2x the ROAS

## 💡 Recommendations
1. Reallocate 20% of social budget ($2.76M) to influencer — projected +$7.6M additional revenue
2. Pause facebook_lal and facebOOK_tier2 (combined -$2.4M net loss) and redirect to top performers
3. Concentrate campaign boosts on Fridays; prioritise Tier 1 geo targeting

## 🛠️ SQL Skills Demonstrated
CTEs · Window Functions · NULLIF · CASE WHEN · DATEDIFF · Funnel Analysis · ROAS/ROMI · Data Validation
