---
title: Reinforcement Learning (RL)
type: concept
sources: [https://www.mathworks.com/help/reinforcement-learning/ug/what-is-reinforcement-learning.html, https://en.wikipedia.org/wiki/Reinforcement_learning, https://spinningup.openai.com/en/latest/spinningup/rl_intro.html]
related: [Deep Learning, Machine Learning vs Deep Learning, Loss Functions]
created: 12-06-2026
last-updated: 12-06-2026
---

# Reinforcement Learning (RL)

## The Core Idea

Reinforcement learning is a goal-directed approach in which an **agent** learns to perform a task by repeatedly interacting with an environment, rather than by learning from a fixed labelled dataset. At each step, the agent receives an **observation** of the environment's state and a numeric **reward**, and chooses an **action** to send back to the environment. The agent's goal is to learn a **policy** — a mapping from observations to actions — that maximises the *cumulative* reward over time, through repeated trial and error, without explicit human-provided "correct answers" (MathWorks, *What Is Reinforcement Learning?*).

## Intuition: Learning by Trial and Error, Not by Example

[[Machine Learning vs Deep Learning|Supervised learning]] trains on (input, correct-output) pairs — the model is told the right answer for every example. RL has no such labels: the agent only knows whether the *outcome* of a sequence of actions was good or bad, expressed as a reward signal, often delayed (a reward might only arrive several steps after the action that caused it). This is the classic "credit assignment" challenge — the agent has to figure out *which* of its past actions deserve credit for a reward received later.

A useful mental model: think of training a dog. You can't tell the dog "rotate your paw 15 degrees" (no labelled instructions), but you *can* give it a treat when it does something close to what you want (a reward signal). Over many repetitions, the dog (the agent) learns a "policy" — a behaviour pattern — that tends to produce treats.

## The Agent-Environment Loop

The RL agent consists of two components:

- **Policy** — a mapping that selects actions based on observations. Often implemented as a function approximator with tunable parameters, such as a deep neural network (hence "deep reinforcement learning").
- **Learning algorithm** — continuously updates the policy's parameters based on the actions taken, the observations received, and the rewards obtained, with the goal of finding an **optimal policy** that maximises cumulative reward.

This loop — agent observes state, takes action, environment returns new state + reward, repeat — runs for many episodes until the policy converges.

## The Standard RL Workflow

The lecture (via MATLAB's Reinforcement Learning Toolbox documentation) frames the development workflow as a sequence of steps:

1. **Formulate Problem** — define the task the agent should learn.
2. **Create Environment** — define the environment the agent operates within (states, dynamics, available actions).
3. **Define Reward** — specify the reward signal that measures how well the agent is performing the task.
4. **Create Agent** — instantiate the agent (policy representation + learning algorithm).
5. **Train Agent** — run the agent-environment loop repeatedly, updating the policy.
6. **Validate Agent** — evaluate the trained policy's performance.
7. **Deploy Policy** — deploy the trained policy for actual use.

The lecture references two classic worked examples that follow this workflow: a **grid-world** Q-learning agent (a small discrete environment — good for learning the basics) and a **pendulum balancing** task using a deep deterministic policy gradient (DDPG) agent with image observations (a continuous-control task — much closer to robotics applications).

## In Practice: A Minimal Agent-Environment Loop (Python)

```python
import random

# A trivial 1D "grid world": agent at position 0-4, goal at position 4
state = 0
goal = 4

def step(state, action):
    # action: -1 (left), +1 (right)
    next_state = max(0, min(goal, state + action))
    reward = 1.0 if next_state == goal else -0.01  # small step penalty
    done = next_state == goal
    return next_state, reward, done

# Random policy (a learned policy would replace this with, e.g., a neural network)
for episode in range(3):
    state, done = 0, False
    total_reward = 0
    while not done:
        action = random.choice([-1, 1])
        state, reward, done = step(state, action)
        total_reward += reward
    print(f"Episode reward: {total_reward:.2f}")
```

A real RL algorithm (e.g. Q-learning, DDPG) replaces the random `action = random.choice(...)` with a policy that's updated after each step/episode based on the rewards observed — the "learning algorithm" component described above.

## Common Pitfalls & Practical Tips

- **Reward design is everything.** A poorly shaped reward function can lead the agent to find unintended shortcuts that maximise reward without solving the intended task ("reward hacking").
- **Exploration vs. exploitation.** The agent must balance trying new actions (exploration, to discover better strategies) against repeating known-good actions (exploitation) — purely greedy policies often get stuck in local optima.
- **Sample inefficiency.** RL typically requires far more interaction steps than supervised learning requires labelled examples, which is why simulated environments (like MATLAB's grid world and pendulum) are common training grounds before deploying to real hardware.

## Related Concepts

- [[Machine Learning vs Deep Learning]] — contrasts RL's trial-and-error, reward-driven learning with the labelled-example paradigm of supervised learning.
- [[Deep Learning]] — "deep reinforcement learning" uses a deep neural network as the policy's function approximator.
- [[Loss Functions]] — RL doesn't use a fixed loss in the supervised sense, but learning algorithms (e.g. policy gradient methods) derive update rules from the reward signal that play an analogous role.

**Source:** [What Is Reinforcement Learning? - MathWorks](https://www.mathworks.com/help/reinforcement-learning/ug/what-is-reinforcement-learning.html); [Reinforcement Learning (Wikipedia)](https://en.wikipedia.org/wiki/Reinforcement_learning)
