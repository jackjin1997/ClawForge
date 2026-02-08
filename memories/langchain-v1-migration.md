---
title: LangChain v1.0 Migration Cheat Sheet
source: "LangChain Official Documentation (https://python.langchain.com/docs/versions/v1_0/)"
description: "A quick reference for the most common breaking changes and migration paths for LangChain 1.0."
---

# LangChain v1.0 Migration Guide

## 1. Package Structure
- **Core**: `langchain-core` (Stable base)
- **Community**: `langchain-community` (Integrations)
- **Main**: `langchain` (High-level chains & agents)
- **Integration Specific**: `langchain-openai`, `langchain-anthropic`, etc.

## 2. Model Instantiation
- **DEPRECATED**: `from langchain.chat_models import ChatOpenAI`
- **NEW**: `from langchain_openai import ChatOpenAI`

## 3. LCEL (LangChain Expression Language)
- **OLD**: `LLMChain(llm=llm, prompt=prompt)`
- **NEW**: `chain = prompt | llm`

## 4. Agents
- **OLD**: `initialize_agent(...)`
- **NEW**: `create_tool_calling_agent` or `create_react_agent` + `AgentExecutor`
- **RECOMMENDED**: **LangGraph** for any complex agent logic.

## 5. Output Parsers
- All output parsers now live in `langchain-core`.
- **OLD**: `from langchain.output_parsers import PydanticOutputParser`
- **NEW**: `from langchain_core.output_parsers import PydanticOutputParser`

## 6. Prompt Caching (Anthropic)
- Use `ChatAnthropic(..., betas=["prompt-caching-2024-07-31"])`.
- Add `"cache_control": {"type": "ephemeral"}` to message content blocks.
