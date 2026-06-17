---
title: COMP838 Lecture 8.2 - Reinforcement Learning
type: source-summary
sources: [raw/lecture-notes/COMP838/Lecture8.pdf]
related: [COMP838, Reinforcement Learning (RL), Machine Learning vs Deep Learning]
created: 12-06-2026
last-updated: 12-06-2026
---

# COMP838 Lecture 8.2 - Reinforcement Learning

> [!tip] Going Deeper
> [[Reinforcement Learning (RL)]] has a full concept page with intuition, the agent-environment loop, the standard RL workflow, a minimal Python example, and pitfalls (reward design, exploration vs. exploitation). This note summarises the lecture's framing.

## Cues & Questions

> Use this column for self-testing. Cover the Notes section and try to answer each cue from memory.

- **How does RL differ from supervised learning, in terms of what the model is "told"?**
- **What three things pass between agent and environment at each step?**
- **What are the two components of an "agent"?**
- **List the 7 steps of the RL workflow, in order.**
- **What kind of task is the grid-world example? The pendulum example?**

---

## Notes

### What Is Reinforcement Learning

[[Reinforcement Learning (RL)|Reinforcement learning]] is described as a goal-directed computational approach where a computer (the **agent**) learns to perform a task by interacting with an unknown, dynamic environment — making a series of decisions to maximise cumulative reward, without human intervention and without being explicitly programmed for the task.

> [!check] Verified
> This matches MathWorks' framing closely — see [What Is Reinforcement Learning? - MathWorks](https://www.mathworks.com/help/reinforcement-learning/ug/what-is-reinforcement-learning.html), and the broader field's standard agent/environment/reward formulation, e.g. [Reinforcement Learning (Wikipedia)](https://en.wikipedia.org/wiki/Reinforcement_learning).

### The Agent-Environment Loop

At each step: the agent receives **observations** and a **reward** from the environment, and sends **actions** back to the environment. The reward measures how successful an action was with respect to the task goal.

The agent itself has two components:

- A **policy** — a mapping that selects actions based on observations. Typically a function approximator with tunable parameters, such as a deep neural network.
- A **learning algorithm** — continuously updates the policy's parameters based on the actions taken, observations received, and rewards obtained.

The overall goal of the learning algorithm is to find an **optimal policy** that maximises the cumulative reward received during the task — achieved through repeated trial-and-error interaction with the environment, without human involvement.

### The RL Workflow

The lecture gives a 7-step general workflow for training an RL agent:

1. **Formulate Problem** — define the task for the agent to learn.
2. **Create Environment** — define the environment the agent operates within.
3. **Define Reward** — specify the reward signal used to measure performance.
4. **Create Agent** — create the agent (policy + learning algorithm).
5. **Train Agent** — train the agent's policy representation.
6. **Validate Agent** — evaluate the trained agent's performance.
7. **Deploy Policy** — deploy the trained policy representation.

Two worked examples are referenced as illustrations of this workflow:

- A **basic grid world** task trained with a Q-learning agent — a small, discrete environment well suited to a first RL implementation.
- A **pendulum balancing** task trained with a DDPG (deep deterministic policy gradient) agent using image observations — a continuous-control task closer to robotics applications.

---

## Summary

Reinforcement learning trains an agent to complete a task within an environment through repeated trial-and-error, guided only by a reward signal rather than labelled examples. The agent consists of a policy (often a deep neural network) and a learning algorithm that updates the policy based on observed actions, observations, and rewards, with the goal of maximising cumulative reward. The lecture frames RL development as a 7-step workflow — formulate problem, create environment, define reward, create agent, train, validate, deploy — illustrated with MATLAB's grid-world (Q-learning) and pendulum-balancing (DDPG) examples.

---

## Sources & Verification

| Claim / Topic | Source | Status |
|---|---|---|
| RL as goal-directed learning via agent-environment interaction and reward | [What Is Reinforcement Learning? - MathWorks](https://www.mathworks.com/help/reinforcement-learning/ug/what-is-reinforcement-learning.html) | ✓ Verified |
| Agent = policy + learning algorithm, optimal policy maximises cumulative reward | [Reinforcement Learning (Wikipedia)](https://en.wikipedia.org/wiki/Reinforcement_learning) | ✓ Verified |
