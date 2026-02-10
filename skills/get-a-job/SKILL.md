---
name: getajob
description: AI-powered job search assistant. Scan job listings, track applications, maintain dream company lists, and generate tailored resumes and cover letters. Use when the user wants to find jobs, run a job scan, set up job search, track applications, or prepare application materials.
license: MIT
metadata:
  openclaw:
    emoji: "💼"
    author: "bitpixi"
    version: "1.0.0"
    homepage: "https://getajob.bitpixi.com"
    requires:
      bins: []
    tags:
      - productivity
      - career
      - job-search
---

# GetAJob — AI Job Search Assistant

An intelligent job search skill that helps you find opportunities, track applications, and generate tailored application materials through natural conversation.

## When to Use This Skill

Activate this skill when the user:
- Wants to search for jobs or run a job scan
- Says "set up my job search" or "find me jobs"
- Asks to track job applications or dream companies
- Needs help with resumes, cover letters, or follow-up emails
- Wants a daily or weekly job search summary
- Mentions job hunting, career search, or employment

## Trigger Phrases

- "get a job", "job search", "find me jobs"
- "run a scan", "scan for jobs"
- "let's apply to [company]"
- "update my dream companies"
- "daily summary", "weekly recap"
- "set up my job search"
- "prepare application for [company]"

## Capabilities

### 1. Job Search Setup
Collect and store user preferences:
- Target roles (e.g., Senior UX Designer, Product Manager)
- Industries (e.g., Tech, AI/ML, Gaming, Healthcare)
- Location preferences (city, remote/hybrid/in-person)
- Salary expectations
- Target companies (dream list)
- Job board sources to monitor

### 2. Job Scanning
Search the web for job listings matching user criteria:
- Use web search to find current openings
- Filter by role, location, company, and recency
- Score matches (1-5) based on fit with user profile
- Extract key details: title, company, location, salary, URL
- Avoid duplicate listings

### 3. Tracking System
Maintain organized records:
- **Job Listings**: All discovered opportunities with status tracking
- **Dream Companies**: Target employers to monitor for openings
- **Application Status**: Applied, Interviewing, Offered, Rejected, Ghosted

### 4. Application Materials
Generate tailored documents:
- Customized resumes highlighting relevant experience
- Cover letters matched to job requirements
- Follow-up emails (post-application, post-interview)
- LinkedIn connection request messages

### 5. Progress Summaries
Provide regular updates:
- Daily: New listings found, applications submitted
- Weekly: Full recap with statistics and highlights
- Format for LinkedIn/X posting if requested

## Workflow Instructions

### Setting Up a Job Search

When user says "set up my job search":

1. Ask for their target roles (can be multiple)
2. Ask for preferred industries
3. Ask for location preferences and remote work flexibility
4. Ask for salary range (optional but helpful)
5. Ask for dream companies they'd love to work for
6. Ask for any specific job boards to monitor

Store this information for future scans.

### Running a Job Scan

When user says "run a scan" or "find me jobs":

1. Use web search with queries like:
   - "[role] jobs [location] 2026"
   - "[company] careers [role]"
   - "[role] remote jobs [industry]"

2. For each result, extract:
   - Job Title
   - Company Name
   - Location (city or remote)
   - Job Type (full-time, contract, etc.)
   - Salary if listed
   - URL to apply
   - Key requirements

3. Score each listing 1-5 based on:
   - Role match
   - Location fit
   - Company alignment with user interests
   - Salary match (if known)

4. Present findings organized by match score (highest first)

5. Offer to add listings to tracking spreadsheet

### Preparing Application Materials

When user says "let's apply to [company]" or asks for application help:

1. Retrieve the job listing details
2. Ask for or retrieve user's resume/background
3. Generate:
   - Tailored resume bullet points emphasizing relevant skills
   - Cover letter addressing specific job requirements
   - Notes on company culture and values for interview prep

4. Format professionally and offer to save as files

### Generating Summaries

When user asks for "daily summary" or "weekly recap":

1. Compile statistics:
   - New listings found this period
   - Applications submitted
   - Responses received
   - Interviews scheduled

2. Highlight top opportunities

3. Suggest next actions

4. If requested, format as a LinkedIn or X post celebrating progress

## Data Storage

Store job search data in the user's workspace:

```
~/getajob/
├── config.json          # Search preferences
├── listings.csv         # All job listings found
├── dream_companies.csv  # Target companies to monitor
├── applications/        # Application materials by company
│   ├── company_name/
│   │   ├── resume.md
│   │   ├── cover_letter.md
│   │   └── notes.md
└── summaries/           # Daily/weekly summaries
```

## CSV Schemas

### listings.csv
```
date_found,job_title,company,location,job_type,salary,match_score,url,status,notes
```

### dream_companies.csv
```
company,industry,why_interested,careers_url,last_checked,recent_news
```

## Example Interactions

**User**: Set up my job search
**Agent**: I'll help you set up your job search. Let's start with the basics:

1. What roles are you targeting? (e.g., "Senior UX Designer, Product Manager")
2. What industries interest you? (e.g., "Tech, AI/ML, Gaming")
3. Where are you looking? (city + remote preference)
4. Any dream companies you'd love to work for?

---

**User**: Run a scan
**Agent**: Running job scan for your saved preferences...

[Searches web for matching roles]

Found 8 new listings matching your criteria:

**Top Matches (5/5)**:
1. Senior UX Designer at Canva (Melbourne, Hybrid) - $150-180k
2. Product Designer at Atlassian (Remote) - $140-165k

**Strong Matches (4/5)**:
3. UX Lead at MYOB (Melbourne) - $130-150k
...

Want me to add these to your tracking spreadsheet?

---

**User**: Let's apply to Canva
**Agent**: Great choice! I'll prepare your application materials for Canva's Senior UX Designer role.

Based on the job requirements, I'll emphasize:
- Your 10+ years in UX design
- Experience with design systems
- Work with major brands

[Generates tailored cover letter and resume suggestions]

## Important Notes

- Always verify job listings are current before applying
- Flag urgent deadlines (closing dates within 7 days)
- Respect user's stated salary minimums
- Never share user's personal data externally
- Update listing status as user progresses through applications
- Celebrate wins (interviews, offers) in summaries
