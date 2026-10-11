# ARCHITECTURE (FROZEN)

## Core Model (ARE)
Evaluation Target
  ↓ Evaluation
  ↓ Dimension
  ↓ Perspective
  ↓ Specification
  ↓ Execution
  ↓ Evidence
  ↓ Consensus
  ↓ Decision
  ↓ Report

## BET-ANALYZER Pipeline
Fonbet + Smarkets + Manual
  ↓ Consensus
  ↓ EV
  ↓ Value Bets

## Stack
opera-proxy (127.0.0.1:18080)
  ↓ socat bridge (172.17.0.1:18080)
  ↓ OmniRoute (127.0.0.1:20128)
  ↓ Telegram bot
