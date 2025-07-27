# 🔐 FSM Password Lock System – Verilog HDL Project

This project implements a **Finite State Machine (FSM)-based Password Lock System** using Verilog HDL. The design simulates a secure digital lock that accepts hexadecimal inputs, supports password verification, locking, reset functionality, password setting, and password viewing features.

---

## 🚀 Features

- ✅ 4-digit hexadecimal password input (default: `1 2 3 4`)
- 🔄 Ability to **set a custom password** (when unlocked)
- 🟢 **Unlock state** triggers green LED on successful match
- 🔴 **Wrong password** triggers red LED and decrements attempt counter
- 🚨 Lockout after **3 failed attempts**, activates alarm
- 🔁 **Reset system** to clear alarm and restore attempts
- 👁️ **View current password** only when system is unlocked

---

## 🧠 FSM Architecture

The FSM consists of the following key states:

- `IDLE`
- `READ_1` to `READ_4`
- `CHECK`
- `UNLOCKED`
- `ERROR`
- `LOCKED`
- `RESET_STATE`
- `VIEW_PASS`
- `SET_PASS_1` to `SET_PASS_4`

State transitions are driven by user inputs (`digit`, `enter`, `reset`, `view_pass`, `set_pass`) and internal conditions like password match and attempt counter.

---

## 🧪 Testbenches Included

Each testbench verifies one key aspect of the FSM:

| Testbench File               | Description                              |
|-----------------------------|------------------------------------------|
| `fsm_password_lock_tb.v`          | Tests correct password unlocking         |
| `fsm_wrong_password.v`   | Tests wrong attempts without lockout     |
| `fsm_lockout.v`          | Verifies alarm triggers after 3 fails    |
| `fsm_set_new_password.v` | Verifies password change functionality   |
| `fsm_view_password.v`    | Confirms viewing password in unlocked    |
| `fsm_full_flow.v`        | 🚀 Full system test (stress test case)    |

---

## 🛠️ Tools & Technologies

- **HDL**: Verilog (IEEE 1364)
- **Simulation**: Xilinx Vivado Simulator
- **Testbench**: Manual stimulus with `initial` blocks
- **Target Use Case**: FPGA (synthesizable FSM core)

---

## 📁 Project Structure
fsm-password-lock/
│
├── designs/
│   └── fsm_password_lock.v          # Main FSM module
│
├── testbench/
│   ├── fsm_password_lock_tb.v             # Basic correct password test
│   ├── fsm_wrong_password.v
│   ├── fsm_lockout.v             # Lockout test after 3 wrong tries
│   ├── fsm_view_password.v       # View password when unlocked
│   ├── fsm_set_new_password.v    # Change password functionality
│   └── fsm_full_flow.v           # End-to-end functional flow test
│
└── README.md                        # This file


