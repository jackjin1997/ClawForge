# 10-Day Sprint Plan: RingCentral Node.js Senior Backend Engineer

## 🎯 Target: RingCentral (铃盛)
- **Role**: Senior Node.js Backend Engineer (AI/Agent Focus)
- **Interview Style**: All English, technical deep dive, system design, behavioral (STAR).
- **Core Requirements**: Node.js/TypeScript mastery, Microservices, AI/Agent (LangChain/LangGraph), System Design, Scalability.

---

## 📅 10-Day Schedule

### Phase 1: Foundation & Storytelling (Day 1-2)
- **Day 1: Resume Deep Dive (EN)**
  - Practice explaining your 4 key projects in English.
  - Focus on: "What was the challenge?", "Why this architecture?", "What was the result?".
  - **Task**: Write down "Introduction" and "Project 1 (Travel Agent)" scripts.
- **Day 2: Behavioral & STAR (EN)**
  - Prepare STAR stories for: Conflict, Failure, Leadership (Tech Lead exp), Tight Deadlines.
  - **Tool**: Use `gpt-4o` or `claude-3-5-sonnet` to simulate a behavioral interview.

### Phase 2: Node.js & Architecture Deep Dive (Day 3-5)
- **Day 3: Node.js Internals & Performance**
  - Event Loop, Libuv, Streams, Buffer, Memory Leaks, Worker Threads.
  - **Topic**: Why Hono over NestJS? (Relevant to your Project 2).
- **Day 4: Microservices & Infrastructure**
  - Redis (Caching strategies), RabbitMQ/Kafka (Messaging), Etcd (Service discovery/Config).
  - RingCentral specific: High availability, WebSockets/Socket.io.
- **Day 5: Database & Concurrency**
  - PostgreSQL optimization, MongoDB vs MySQL, Prisma/TypeORM trade-offs.
  - Distributed locks, Idempotency.

### Phase 3: AI Agent & LangChain Mastery (Day 6-7)
- **Day 6: LangChain/LangGraph Deep Dive**
  - Explain the "Supervisor Pattern" in English.
  - State management, Checkpoints, Tool calling (MCP).
- **Day 7: AI System Design**
  - How to build a scalable RAG system?
  - Handling LLM latency, Cost optimization, Evaluation (LangSmith).

### Phase 4: Mock & Polish (Day 8-10)
- **Day 8: Full English Mock Interview**
  - Use a voice tool or AI to simulate the whole flow.
- **Day 9: System Design Practice**
  - Design a global communication system (like RingCentral) or a large-scale Agent platform.
- **Day 10: Final Review & Mental Prep**
  - Review all scripts, check company news (RingCentral's AI initiatives).

---

## 🛠 Tools & Resources

### 1. English Practice (The "Immersion" Method)
- **AI Voice Chat**: Use ChatGPT App (Voice Mode) or Claude to practice speaking.
- **Shadowing**: Watch YouTube videos of "Senior Node.js Interview" and repeat.
- **Scripting**: Don't memorize, but have "bullet points" in your head.

### 2. Technical Materials
- **Node.js**: [Node.js Design Patterns](https://www.nodejsdesignpatterns.com/) (Focus on Streams/ESM/Plugins).
- **System Design**: [ByteByteGo](https://bytebytego.com/) or "Grokking the System Design Interview".
- **AI**: LangChain/LangGraph official docs (you're already a contributor, use that!).

### 3. RingCentral Specifics
- **Product**: Understand RC MVP (Message, Video, Phone).
- **Tech Blog**: Search for "RingCentral Engineering Blog" to see their tech stack (they use a lot of Java, but Node.js is core for their integration and newer AI services).

---

## 📝 Practice Script Template (Example)
**Question**: "Tell me about your most challenging project."
**Answer (STAR)**:
- **Situation**: In Project 1, we needed a multi-agent system to handle complex travel planning.
- **Task**: The challenge was managing state and coordination between 6 different agents.
- **Action**: I designed a Supervisor pattern using LangGraph and implemented a POI pool for state persistence.
- **Result**: Reduced response latency to second-level and enabled conversation rollback.

---

*Good luck, Jack! You have the background (5 years + LangChain contributor), you just need to "unlock" your English mode.*
