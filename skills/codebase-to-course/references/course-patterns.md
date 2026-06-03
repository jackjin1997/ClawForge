# Course Patterns

Use these patterns as implementation guidance. Adapt class names and styling to the generated course, but preserve the learning behaviors.

## Module Section

Each module should be independently readable and scannable:

```html
<section class="module" id="module-1">
  <p class="kicker">Module 1</p>
  <h1>What happens when the user clicks Analyze</h1>
  <p class="lede">Start with the visible action, then trace it into the files that make it work.</p>

  <div class="lesson-grid">
    <article>
      <h2>The user-facing moment</h2>
      <p>Explain the behavior in plain language.</p>
    </article>
    <article>
      <h2>The code path</h2>
      <p>Point to the entry file, handler, state update, or job that receives the action.</p>
    </article>
  </div>
</section>
```

## Code To English

Always use real project code. Keep snippets short enough to inspect.

```html
<div class="code-translation">
  <pre><code>// path/to/file.ts:42
async function loadProject(id) {
  return db.project.findUnique({ where: { id } });
}</code></pre>
  <div class="plain-english">
    <h3>Plain English</h3>
    <p>This asks the database for exactly one project whose id matches the page the user opened.</p>
  </div>
</div>
```

## Applied Quiz

Quizzes should test whether the learner can use the idea.

```html
<div class="quiz" data-answer="b">
  <h3>A user sees stale project data after editing. Where would you inspect first?</h3>
  <button data-choice="a">The icon component</button>
  <button data-choice="b">The data-loading or cache invalidation path</button>
  <button data-choice="c">The README badges</button>
  <p class="quiz-feedback" aria-live="polite"></p>
</div>
```

Minimum quiz behavior:

- Mark selected answer as correct or incorrect.
- Show a short explanation.
- Keep the explanation tied to the target codebase.

## Glossary Tooltip

Use tooltips for technical terms on first use per module.

```html
<span class="term" data-definition="A function that receives a request and returns a response.">handler</span>
```

Minimum tooltip behavior:

- Works by hover and keyboard focus.
- Does not obscure the surrounding text on mobile.

## Data Flow

Use this for request/response, event pipelines, state updates, queues, or database interactions.

```html
<div class="flow" data-steps='[
  "User submits the form",
  "UI validates the input",
  "API handler receives the request",
  "Database stores the change",
  "UI refreshes with the new state"
]'>
  <ol>
    <li>User submits the form</li>
    <li>UI validates the input</li>
    <li>API handler receives the request</li>
    <li>Database stores the change</li>
    <li>UI refreshes with the new state</li>
  </ol>
  <button class="play-flow">Play flow</button>
</div>
```

Minimum flow behavior:

- The static ordered list remains readable without JavaScript.
- The animation highlights one step at a time.

## Component Conversation

Use this when modules hand work to each other.

```html
<div class="conversation">
  <p><strong>Page:</strong> I have a project id from the URL.</p>
  <p><strong>Loader:</strong> I will fetch the project record.</p>
  <p><strong>Database:</strong> Here is the matching row.</p>
  <p><strong>View:</strong> I can render the title and status now.</p>
</div>
```

Keep conversations short. The goal is to reveal ownership and handoffs, not to add decoration.

## Debugging Map

Close the course with practical fault isolation:

```html
<table class="debug-map">
  <thead>
    <tr>
      <th>Symptom</th>
      <th>Likely area</th>
      <th>First file to inspect</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Button does nothing</td>
      <td>Event handler or form validation</td>
      <td><code>src/components/SubmitForm.tsx</code></td>
    </tr>
  </tbody>
</table>
```

Use actual files from the analyzed codebase.
