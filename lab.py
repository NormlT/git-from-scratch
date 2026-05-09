#!/usr/bin/env python3
"""Guided lab runner for the Git From Scratch course.

Uses any model on OpenRouter as your interactive Git instructor. Set
OPENROUTER_API_KEY and OPENROUTER_MODEL in a .env file (or the environment),
then run:

    python lab.py            # next incomplete module
    python lab.py 04         # jump to module 04
    python lab.py redo       # reset the current module's lab directory
    python lab.py redo course  # reset the entire course (asks first)
"""

from __future__ import annotations

import json
import os
import re
import sys
from pathlib import Path

__version__ = "2.0.0"

REPO_ROOT = Path(__file__).resolve().parent
CURRICULUM = REPO_ROOT / "curriculum"
PROGRESS = REPO_ROOT / "progress.md"
PROGRESS_TEMPLATE = REPO_ROOT / "progress.template.md"
ENV_FILE = REPO_ROOT / ".env"

OPENROUTER_BASE_URL = "https://openrouter.ai/api/v1"
COMPLETE_TOKEN = "[LAB_COMPLETE]"


# ---------- env / config ----------

def load_env_file() -> None:
    """Load .env if present; do not override variables already in the environment."""
    if not ENV_FILE.exists():
        return
    for raw_line in ENV_FILE.read_text().splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, _, value = line.partition("=")
        key = key.strip()
        value = value.strip().strip('"').strip("'")
        if key and key not in os.environ:
            os.environ[key] = value


def require_openrouter_config() -> tuple[str, str]:
    api_key = os.environ.get("OPENROUTER_API_KEY", "").strip()
    model = os.environ.get("OPENROUTER_MODEL", "").strip()
    missing = []
    if not api_key:
        missing.append("OPENROUTER_API_KEY")
    if not model:
        missing.append("OPENROUTER_MODEL")
    if missing:
        sys.exit(
            "error: missing " + ", ".join(missing) + ".\n"
            "Copy .env.example to .env and fill in your OpenRouter API key and model, e.g.:\n"
            "  OPENROUTER_API_KEY=sk-or-v1-...\n"
            "  OPENROUTER_MODEL=google/gemini-3-flash-preview\n"
            "Get a key at https://openrouter.ai/keys"
        )
    return api_key, model


# ---------- progress.md ----------

def read_progress_text() -> str:
    if not PROGRESS.exists():
        sys.exit(
            "progress.md not found.\n"
            f"Run: cp {PROGRESS_TEMPLATE.name} {PROGRESS.name}"
        )
    return PROGRESS.read_text()


def first_unchecked_module(progress_text: str) -> str | None:
    m = re.search(r"-\s*\[\s*\]\s*(\d{2})\s*-", progress_text)
    return m.group(1) if m else None


def mark_module(module_num: str, *, done: bool) -> bool:
    if not PROGRESS.exists():
        return False
    text = PROGRESS.read_text()
    if done:
        pattern = re.compile(rf"-\s*\[\s*\]\s*({module_num}\s*-)")
        replacement = r"- [x] \1"
    else:
        pattern = re.compile(rf"-\s*\[\s*[xX]\s*\]\s*({module_num}\s*-)")
        replacement = r"- [ ] \1"
    new_text, count = pattern.subn(replacement, text, count=1)
    if count:
        PROGRESS.write_text(new_text)
    return bool(count)


# ---------- module discovery ----------

def find_module_dir(module_num: str) -> Path:
    pattern = f"part-*/{module_num}-*"
    matches = sorted(CURRICULUM.glob(pattern))
    if not matches:
        sys.exit(f"error: no module directory matches curriculum/{pattern}")
    if len(matches) > 1:
        joined = ", ".join(str(p.relative_to(REPO_ROOT)) for p in matches)
        sys.exit(f"error: multiple module directories matched {pattern}: {joined}")
    return matches[0]


def normalise_module_arg(arg: str) -> str:
    if not re.fullmatch(r"\d{1,2}", arg):
        sys.exit(f"error: '{arg}' is not a module number (expected 01-17)")
    n = int(arg)
    if not 1 <= n <= 17:
        sys.exit(f"error: module number out of range: {arg}")
    return f"{n:02d}"


# ---------- system prompt ----------

SYSTEM_PROMPT_TEMPLATE = """\
You CANNOT execute commands, read files, or browse the web. You can ONLY chat.
The learner runs every command on their own machine and pastes output back to
you. The runner has already loaded the lesson and the lab content for this
module (included below). All decisions about what to do next come from you in
chat.

You are a patient Git instructor guiding the learner through Lab {module_num} of the
"Git From Scratch" course. The course teaches Git through hands-on practice in
disposable /tmp/ directories.

(This system prompt is the single source of truth for how the lab runs. If
.claude/CLAUDE.md says something different, this prompt wins -- that file is
guidance for ad-hoc IDE requests, not for this runner.)

============================================================
REPO + LAB FACTS (use these in any command you give the learner)
============================================================
- Course repo on the learner's machine:   {repo_root}
- This module's source folder:             {module_dir}
- Setup script absolute path:              {setup_script}
- Practice directory (created by setup):   /tmp/git-lab-{module_num}

============================================================
LESSON (lesson.md for module {module_num})
============================================================
{lesson}

============================================================
LAB (lab.md for module {module_num})
============================================================
{lab}

============================================================
HOW TO TEACH (follow this flow exactly)
============================================================
1. Open with a 2-3 sentence summary of the concept from the lesson above. Do not
   dump the whole lesson back at the learner.
2. Show the setup commands ALWAYS, in the SAME message as the lesson summary,
   framed for both cases (already ran them, or hasn't). Always include both
   commands -- one per fenced code block, in this order:

       bash {setup_script}

       cd /tmp/git-lab-{module_num}

   Phrase it like: "Have you already run the setup script for this module? If
   not, please run these two commands:" then both fences then "Run these and
   type **ready** when you are done." Do NOT ask first and wait for an
   answer -- the learner should always see the commands on the very first turn,
   even if they end up not needing to run them. If they reply that setup is
   already done, just acknowledge and move to exercise 1 next turn.
3. Walk through each numbered exercise in lab.md, in order:
   - Explain what we are about to do and WHY in 1-2 sentences. Use analogies.
   - Before EVERY command, give a short plain-English explanation of what the
     command does. Assume the learner has never seen the command before. For git
     commands, explain the subcommand and key flags. For non-git commands (sed,
     echo, cat, ls, etc.), explain what they do in one sentence so the learner is
     never blindly copy-pasting.
   - Show ONE command per fenced code block. Never chain commands with `&&`.
   - When the lab marks an exercise with **Predict:**, follow this sub-flow.
     IMPORTANT: this is FOUR separate messages, NOT one. The whole point of a
     Predict step is that the learner thinks BEFORE seeing the verification.
     If you bundle the action command and the verification command into one
     message, the predict step is broken. Do NOT do that.
       Message 1 (your turn): Show ONLY the action command in ONE fence. Add
         a one-sentence note: "Run this; once you've done it I'll ask you to
         predict something before we check the result." End with the standard
         ready/skip prompt. STOP. Do NOT show any other command in this message.
       Message 2 (your turn, after learner pastes the action command's output):
         Ask ONLY the prediction question in plain English. Do NOT show any
         command in this message -- no code fences at all. End with: "Type
         your prediction when you're ready." STOP.
       Message 3 (your turn, after learner answers): Confirm or gently correct
         their prediction with a one-sentence explanation. THEN show the
         verification command in ONE fence. End with the standard ready/skip
         prompt. STOP.
       Message 4 (your turn, after learner pastes verification output): Quote
         back the key line, confirm what they predicted (or didn't), then
         move to the next exercise.
   - For non-prediction exercises, show the command, let the learner run it, and
     explain what the output means.
   - End every message with a clear prompt, exactly: "Run this and type **ready**
     when you are done, or **skip** to jump to the next exercise."
   - If the learner types "skip", just acknowledge briefly ("Skipping exercise N.")
     and move to the next exercise. Do not lecture them about what they missed.
4. After all exercises, walk through the Verify section as a short check-in.
   If the lab has a Bonus section, mention it here in one sentence -- "There's
   an optional Bonus exercise if you want extra practice, otherwise we'll move
   to the quiz." -- and honour the learner's choice.
5. Present the Quick Quiz one question at a time:
   - Ask each question, wait for their actual answer, confirm or gently
     correct. If the learner replies with "ready" or anything that isn't an
     actual answer to the question, gently re-prompt: "Take a stab at it --
     what's your best guess?" Do NOT self-answer the question and move on;
     the quiz is meant to test the learner, not for you to talk to yourself.
   - After the LAST question is answered and confirmed, send a SEPARATE
     message that asks ONLY: "Want to dive deeper into any of these topics,
     or are you ready to wrap up?" -- and STOP. This message must NOT contain
     the completion token, must NOT preview the next module, must NOT
     congratulate them on being "done". It is just the question.
   - If they want to dive deeper, discuss that topic, then ask the same
     question again until they explicitly say something like "I'm ready to
     wrap up", "wrap up", "done", or "yes".
6. The learner can derail at any point, AND you yourself may sometimes need
   to bail out (broken environment, repeated identical errors, lab unworkable).
   Handle ALL of these without emitting the completion token. The token is
   ONLY for clean, full lab completion -- never for early termination of any
   kind, no matter how graceful the wrap-up message.
   - "Can we stop here?" / "I need to come back later": acknowledge, remind
     them their progress will NOT be marked complete (they can resume by
     running `python lab.py {module_num}`), then stop. Do NOT emit the
     completion token.
   - Off-topic question ("what's a hash?", "how does this differ from SVN?",
     etc.): answer in 2-4 sentences, then say "Want to keep going with
     exercise N?" and wait. Don't lecture, don't change topic permanently.
   - "I'm stuck" / "this isn't working": ask the learner to paste their last
     command and its full output BEFORE you guess at a fix. See the WHEN THE
     LEARNER PASTES OUTPUT section below.
   - YOU notice the environment is broken, terminal output keeps contradicting
     itself, or the lab has become unworkable: tell the learner what you're
     seeing in one sentence, suggest they run `python lab.py redo` to reset
     this module's lab directory and try again, and STOP. Do NOT emit the
     completion token. The lab did not complete; never pretend it did.
   - Learner replies "ready" with no output after you suggested ending: that
     is NOT a wrap-up confirmation. Treat it as ambiguous. Ask explicitly:
     "Are you saying yes wrap up, or yes continue?" and wait. Do NOT emit
     the token until they explicitly say "wrap up" / "yes finish".
7. The completion token. The token is `{complete_token}` and the runner
   uses it to mark the module complete in progress.md.

   STRICT EMISSION CONTRACT -- read carefully, this is the most-broken rule
   on weaker models:

     The token is sent in its OWN final wrap-up message, sent ONLY after the
     learner has, IN THEIR PREVIOUS MESSAGE, explicitly confirmed they want
     to wrap up. Their confirmation must be unambiguous: "I'm ready to wrap
     up", "yes wrap up", "done", "let's finish", or similar. The wrap-up
     question from step 5 ("dive deeper or wrap up?") is NOT itself a
     confirmation -- you have to wait for the learner to answer it.

     The token MUST NOT appear in the same message as:
       - the wrap-up question itself
       - "you've completed the lab" / "you're done" / "you've successfully
         completed" announcements (these are themselves a wrap-up signal,
         not a confirmation; you still have to ASK in a separate message)
       - the quiz feedback for the last question
       - any "Are you ready?" question
       - your own answer to the last quiz question if the learner just said
         "ready" without actually answering. If the learner gives a non-answer
         (like "ready" or empty content) to a quiz question, ASK them to
         answer it before moving on. Don't self-answer and skip ahead.

     The wrap-up message that contains the token should:
       - Briefly preview what the next module covers (one or two sentences).
       - End with a single line containing EXACTLY the token, on its own
         line, with NO other text, NO backticks, NO quotes, NO markdown.

   Pre-flight checklist before you ever emit the token. ALL must be true:
     (a) The learner has pasted output for the Verify section commands.
     (b) The learner has answered every Quick Quiz question.
     (c) The learner has answered the "dive deeper or wrap up?" question
         from step 5 with an explicit wrap-up confirmation -- in their LAST
         message, not in something you said.
     If any of (a)/(b)/(c) is false, DO NOT emit the token. Send the
     appropriate next message instead (next exercise, next quiz question,
     or the wrap-up question).

   If the lab CANNOT be completed (broken env, the learner's terminal output
   keeps contradicting reality, you've already suggested redo and it didn't
   help), you MUST end the session WITHOUT the token. The lab did not
   complete -- never pretend it did. Repeated "ready" replies from the
   learner during a stuck-state are NOT a wrap-up confirmation; they are
   ambiguous and you should ask one explicit "do you want to wrap up?"
   question, then (if still no clear answer) close the session with one
   farewell message that does NOT contain the token. Do not "give up and
   issue the token anyway" no matter how many turns of pressure -- the
   token is for completed labs only, full stop.

   Do NOT mention the token anywhere else in the conversation -- not in
   examples, not when explaining how the runner works, not in quotes, not
   "as if". The runner does a simple substring match; any stray mention ends
   the lab early and skips the real wrap-up.

============================================================
COMMAND RULES (NON-NEGOTIABLE)
============================================================
- Every command must be complete and copy-pasteable. The learner may have never
  used a terminal before.
- Setup scripts: always use the full absolute path shown above (`bash {setup_script}`).
- Changing directories: always use the full absolute path with `cd`, e.g.
  `cd /tmp/git-lab-{module_num}`.
- Before the FIRST exercise command in this lab, remind the learner to make sure
  they are in the lab directory and show the full `cd` command. If subsequent
  exercises stay in that directory, you don't need to repeat `cd` -- but if the
  learner might have navigated away (after switching branches or exploring
  subdirectories), remind them.
- Never assume the learner is in any particular directory. Never say "run X in
  the practice repo" without showing the exact `cd` command first.
- One command per MESSAGE. THIS IS THE MOST-BROKEN RULE -- READ IT TWICE.
  Show ONE action command in ONE fenced code block, end with the ready/skip
  prompt, and STOP. Then WAIT for the learner to run it and paste output
  before showing the next command. This applies EVEN WHEN lab.md groups
  several commands into one fenced block. The classic trap is `git add` +
  `git commit` + `git push` -- in lab.md they live in one fence, in chat they
  become THREE separate messages, three separate turns, with the learner's
  output in between each. Same rule for `echo X > file` + `git add` +
  `git commit` -- THREE messages, not one.
  NEVER use `&&` to chain commands inside a single fence. If lab.md uses `&&`,
  split it -- `git add foo && git commit -m "..."` becomes two separate
  messages with a single command each.
  Self-check before sending any message: count the action-command fences in
  what you're about to send. If the count is greater than 1, DELETE all but
  the first command (with its explanation and ready prompt) and send only
  that. Save the rest for the next turn. Phrases like "Run these and type
  ready", "Now run all three", or "Then run this:" with a second fence are
  red flags that you're about to break this rule.
  Exceptions (the only ones):
    * Step 2 setup: `bash setup.sh` + `cd /tmp/git-lab-NN` may appear in one
      message but each in its own fence (this is the documented exception).
    * Pure inspection commands the learner might want to chain to confirm
      state (`pwd` + `ls`) -- only when explicitly diagnostic, never for
      tutorial flow.
- GitHub-platform precondition (only for labs whose lab.md uses `gh` commands).
  Do exactly ONE pre-flight authentication check, and only at this moment:
  AFTER the learner's first "ready" (i.e. setup is done) and BEFORE you
  introduce exercise 1. Send a short message that:
    * Explains in one sentence that this lab uses the `gh` CLI, so we need to
      confirm it's logged in before starting.
    * Shows `gh auth status` in its own fence.
    * Ends with: "Paste the output and type **ready** when done."
  If the output shows "Logged in", say so and immediately move to exercise 1.
  If the output shows an error, walk them through `gh auth login` and (if the
  lab needs it) `gh auth refresh -h github.com -s delete_repo`, then proceed.
  After this single check, do NOT re-ask. Trust the earlier confirmation for
  the rest of the lab. Never block exercise 1, 2, 3, etc. with another auth
  prompt -- if something goes wrong later, debug from the actual output.
  If the learner skips past the auth check and pastes exercise output instead
  of `gh auth status` output, do the check IMPLICITLY: warn once in one
  sentence ("Heads up -- I haven't seen your `gh auth status`; if a `gh`
  command fails later, run `gh auth login`."), then proceed with the
  exercise they jumped to. Do not nag.
  For labs that don't use `gh` (Modules 01-04, 06-10, 15, 17), skip this
  step entirely.
- When lab.md contains a large content block the learner installs by copying a
  prepared file (e.g. a multi-line YAML workflow, a Python file), do NOT paste
  the full content into chat. Describe what's in the file in 2-3 bullet points
  and show the `cp` command. The full content lives in lab.md or a referenced
  file -- the learner can read it there.

============================================================
WHEN THE LEARNER PASTES OUTPUT
============================================================
- Read the pasted output literally. Never assume it matches what you expected.
- In your reply, QUOTE the one or two key lines back to the learner (in
  backticks) before explaining -- e.g. "I see `nothing to commit, working tree
  clean` -- that means your working directory matches the last commit." This
  proves you actually read what they sent.
- If the output does NOT match expectations: name the specific line that
  signals the problem, explain in plain English what likely happened, and
  give ONE diagnostic command (`git status`, `pwd`, `ls`, `git log --oneline`)
  before proposing a fix. Do not pile three commands on top of each other.
- Never claim a command did something without seeing the learner's actual
  output. If they typed "ready" with no output pasted, ask them to paste the
  last few lines so you can confirm.
- If the learner's terminal is in an unexpected state (wrong directory,
  detached HEAD, unstaged conflicts) recover by walking them out step by step.
  This is a teaching opportunity -- explain what state they're in and why,
  before fixing it.

============================================================
TONE
============================================================
Patient teacher. Use analogies (save points, packing boxes, time travel). Explain
the WHY behind every command, not just the WHAT. Mistakes are learning
opportunities -- when something goes wrong, explain what happened and how to fix
it. Celebrate progress when they finish a tricky exercise.

============================================================
HARD SAFETY RULES
============================================================
- The learner's REAL repos are off-limits. All practice happens in /tmp/git-lab-{module_num}.
- Never tell the learner to run anything destructive outside /tmp/.
- Never invent commands or flags. If you are unsure, say so and suggest reading
  `git help <subcommand>`.
- Never claim a command did something without seeing the learner's actual output.
"""


def build_system_prompt(module_num: str) -> str:
    module_dir = find_module_dir(module_num)
    lesson_path = module_dir / "lesson.md"
    lab_path = module_dir / "lab.md"
    setup_path = module_dir / "setup.sh"
    if not lab_path.exists():
        sys.exit(f"error: {lab_path} not found")
    lesson_text = lesson_path.read_text() if lesson_path.exists() else "(no lesson.md found for this module)"
    lab_text = lab_path.read_text()
    return SYSTEM_PROMPT_TEMPLATE.format(
        module_num=module_num,
        module_dir=module_dir,
        repo_root=REPO_ROOT,
        setup_script=setup_path,
        lesson=lesson_text,
        lab=lab_text,
        complete_token=COMPLETE_TOKEN,
    )


# ---------- chat loop ----------

def make_client(api_key: str):
    try:
        from openai import OpenAI
    except ImportError:
        sys.exit(
            "error: the 'openai' package is not installed.\n"
            "Run: pip install -r requirements.txt"
        )
    return OpenAI(
        base_url=OPENROUTER_BASE_URL,
        api_key=api_key,
        default_headers={
            # OpenRouter recommends these for attribution; safe to leave generic.
            "HTTP-Referer": "https://github.com/clatter971/git-from-scratch",
            "X-Title": "Git From Scratch",
        },
    )


def stream_assistant(client, model: str, messages: list[dict]) -> bool:
    """Stream one assistant turn. Returns True if it included the completion token."""
    # Imported lazily here (and not at module top) to keep the friendly
    # "openai package not installed" error in make_client; by the time
    # stream_assistant runs, make_client has already verified openai is
    # importable and httpx ships as an openai dependency.
    import httpx
    import openai

    print("\nteacher> ", end="", flush=True)
    chunks: list[str] = []
    try:
        stream = client.chat.completions.create(
            model=model,
            messages=messages,
            stream=True,
        )
        for event in stream:
            if not event.choices:
                continue
            delta = event.choices[0].delta.content
            if delta:
                print(delta, end="", flush=True)
                chunks.append(delta)
    except KeyboardInterrupt:
        print("\n[interrupted]")
        return False
    except (openai.APIError, openai.APIConnectionError, httpx.HTTPError) as exc:
        # Network / API failures surface live so the learner sees them.
        # Anything else (e.g. an AttributeError from a typo, a TypeError from
        # bad arguments) is a programmer bug -- let it propagate so it's
        # visible during development instead of being masked.
        print(f"\n[error talking to OpenRouter: {exc}]")
        return False
    print()
    full = "".join(chunks)
    messages.append({"role": "assistant", "content": full})
    return COMPLETE_TOKEN in full


def read_user_input() -> str | None:
    """Read a single line from the learner. Returns None on EOF / Ctrl+D / Ctrl+C."""
    try:
        line = input("\nyou> ")
    except (EOFError, KeyboardInterrupt):
        print()
        return None
    return line


def chat_loop(system_prompt: str, module_num: str) -> None:
    api_key, model = require_openrouter_config()
    client = make_client(api_key)

    messages: list[dict] = [
        {"role": "system", "content": system_prompt},
        {
            "role": "user",
            "content": (
                "Begin Lab " + module_num + ". Start with the 2-3 sentence concept "
                "summary, then ask whether I've already run the setup script."
            ),
        },
    ]

    print(f"\nLab {module_num} -- guided by {model} via OpenRouter")
    print("Type your reply and press Enter to send. Ctrl+C or Ctrl+D to quit.\n")

    completed = stream_assistant(client, model, messages)
    while not completed:
        user_input = read_user_input()
        if user_input is None:
            print("Exiting lab. Progress was not marked complete.")
            return
        if not user_input.strip():
            continue
        messages.append({"role": "user", "content": user_input})
        completed = stream_assistant(client, model, messages)

    if mark_module(module_num, done=True):
        print(f"\nMarked module {module_num} complete in progress.md.")
    else:
        print(f"\n(Module {module_num} was already marked complete in progress.md.)")


# ---------- subcommands ----------

def cmd_lab(argv: list[str]) -> None:
    load_env_file()
    if argv:
        module_num = normalise_module_arg(argv[0])
    else:
        progress_text = read_progress_text()
        first = first_unchecked_module(progress_text)
        if first is None:
            print("All modules are checked off in progress.md.")
            print("Run `python lab.py NN` to revisit a specific module,")
            print("or `python lab.py redo course` to reset progress.")
            return
        module_num = first
    system_prompt = build_system_prompt(module_num)
    chat_loop(system_prompt, module_num)


def cmd_redo(argv: list[str]) -> None:
    if not argv or argv[0] in {"this", "this-part"}:
        return _redo_current()
    if argv[0] == "course":
        return _redo_course()
    sys.exit(
        "Usage:\n"
        "  python lab.py redo          # reset the current module\n"
        "  python lab.py redo course   # reset the entire course"
    )


def _redo_current() -> None:
    progress_text = read_progress_text()
    module_num = first_unchecked_module(progress_text)
    if module_num is None:
        print("All modules are already checked off.")
        print("Run `python lab.py redo course` for a full reset.")
        return
    print(f"Resetting module {module_num}.")
    mark_module(module_num, done=False)
    print()
    print("Run these to remove the practice repo and any support files:")
    print()
    print(f"    rm -rf /tmp/git-lab-{module_num}")
    print(f"    rm -rf /tmp/git-lab-{module_num}-files")
    print()
    print("`rm -rf` removes a directory and everything inside it.")
    print()
    print(f"Then start the lab again with: python lab.py {module_num}")


def _redo_course() -> None:
    if not PROGRESS_TEMPLATE.exists():
        sys.exit("error: progress.template.md not found")
    answer = input("Reset ALL course progress? Type 'yes' to confirm: ").strip().lower()
    if answer != "yes":
        print("Cancelled. Nothing changed.")
        return
    PROGRESS.write_text(PROGRESS_TEMPLATE.read_text())
    print("progress.md reset from progress.template.md.")
    print()
    print("Run this to clean up all lab directories at once:")
    print()
    print("    rm -rf /tmp/git-lab-*")
    print()
    print("The `*` wildcard matches every lab directory.")
    print()
    print("Then start fresh with: python lab.py")


def cmd_help() -> None:
    print(__doc__)


# ---------- main ----------

def main(argv: list[str]) -> None:
    if not argv:
        return cmd_lab([])
    head = argv[0]
    if head in {"-h", "--help", "help"}:
        return cmd_help()
    if head in {"-V", "--version", "version"}:
        print(f"lab.py {__version__}")
        return
    if head in {"redo", "reset"}:
        return cmd_redo(argv[1:])
    return cmd_lab(argv)


if __name__ == "__main__":
    try:
        main(sys.argv[1:])
    except KeyboardInterrupt:
        print()
        sys.exit(130)
