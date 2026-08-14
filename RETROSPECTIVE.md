# Retrospective

Written roughly a year after submission, as a first-year university student re-reading code
I wrote at eighteen. The source in this repository is unchanged from what I submitted — the
point of publishing it is to show the work and the judgement, and rewriting it now would
destroy both. This file is where the judgement goes.

---

## 1. Three executables where one application belonged

`Welcome_p`, `Consumer_p` and `Admin_p` are three separate Delphi projects that compile to
three separate programs. Welcome exists only to launch one of the other two.

The instinct was modular design, three different programs for three different purposes; consumer and admin surfaces should be separated. 
It means three compiles for every change, no shared runtime state, an entire process
launched just to switch role, and the same helper logic living in more than one place. Two
executables reading and writing the same Access file also invites contention that nothing in
the code handles.

**What I'd do now:** one application, three forms, role determined at login and enforced by
showing or hiding functionality. The separation stays conceptual instead of being paid for at
the process level.

## 2. The admin password is hardcoded in plaintext

```pascal
if spassword = 'Admin' then
begin
  edtpassword.Hide;
  DbgrdCargo.Show;
end;
```

The credential lives in the source, the comparison happens in an `OnChange` handler on the
client, and there is no hashing, no attempt limiting and no session concept. Anyone with the
executable has the database.

**What I'd do now:** credentials in a users table, salted hash comparison (bcrypt or Argon2),
authentication in a service layer rather than a UI event, and rate limiting on failed
attempts. At minimum, out of source control.

I noted "No Authorization, as only a password is used for access" in my Phase 1 document at
the time, so I knew the shape of the problem. I didn't know how much of a problem it was.

## 3. Business logic lives inside UI event handlers

`BitBtnCalculateClick` runs to several hundred lines. It validates input, resolves combo box
indices to strings, looks up the flight, computes the cost, applies surcharges and tax, and
formats the output — all in one procedure attached to one button.

**Consequence:** the cost model cannot be tested, reused or changed without touching the
interface. Because the consumer and admin surfaces are separate executables (§1), any logic
they both needed had to be duplicated rather than shared.

**What I'd do now:** a `PricingEngine` unit exposing something like
`CalculateCost(Cargo: TCargoDetails): TCostBreakdown`, with the form doing nothing but
gathering input, calling it, and rendering the result. Same behaviour, testable in isolation.

## 4. Combo box indices are mapped to strings by hand

```pascal
case cmbbxcargo.ItemIndex of
  0: begin icargo := 1; scargo := 'Art'; end;
  1: begin icargo := 2; scargo := 'Dangerous Goods'; end;
  ...
```

This mapping is repeated for cargo type, departure city and arrival city — three separate
`case` blocks tying business meaning to the visual order of items in a dropdown. Reordering a
dropdown silently changes the data.

**What I'd do now:** an array of records or an enumerated type as the single source of truth,
with the combo box populated *from* that structure rather than mirroring it.

## 5. Fixed-capacity storage

```pascal
const MAX_FLIGHTS = 20;
var   arrFlights: array[0..MAX_FLIGHTS - 1] of TFlight;
```

Twenty flights, decided at compile time, populated by twenty hand-written constructor calls
in `LoadFlights` — while the same flights already exist in `TblFlights` in the database. The
orders array is `array[1..200, 1..8] of string`: a fixed grid of untyped strings where a
record type belonged. A weight stored as a string is a weight that can silently be `"abc"`.

**What I'd do now:** dynamic arrays or generic collections; flights loaded from the database
rather than hardcoded twice; a `TOrder` record with typed fields instead of a string matrix.

## 6. Two sources of truth for the same booking

A confirmed order is written both to the Access database and to `Orders.txt`. There is no
reconciliation between them. If one write succeeds and the other fails, they diverge, and
nothing detects it.

In fairness, the flat file existed for a reason: two independent executables needed to share
the day's bookings without competing for a database lock. That constraint disappears entirely
once §1 is fixed.

**What I'd do now:** one authoritative store. If a flat-file export is genuinely needed, it
gets generated *from* the database on demand rather than written in parallel.

## 7. Data access is scattered through the UI

The `Dmshipment_u` data module was the right idea — connection components defined once and
shared. But the layer stops there. `tblCargo.Next`, `tblCargo['Cost']` and similar calls
appear directly inside button handlers across the admin form, so the forms still know exactly
how the data is stored.

**What I'd do now:** extend the data module into a proper repository — `GetAllCargo`,
`GetCargoById`, `DeleteCargo`, `GetAverageCost`. The forms ask for data; they don't know where
it comes from.

## 8. Aggregations are computed by iterating in code

Highest cost and average cost are calculated by walking the entire table row by row in Object
Pascal. `SELECT MAX(Cost)` and `SELECT AVG(Cost)` do the same work in the engine that already
has the data indexed. At ten records the difference is invisible; the habit is the problem.

## 9. No automated tests

Zero. Everything was verified by clicking through the interface. The cost model in particular
is pure arithmetic with clearly defined inputs and outputs — it is exactly the kind of thing
that should have had a test suite, and would have, if the logic had been extracted from the
form (see §3).

## 10. Errors in my own documentation

Re-reading the Phase 1 document, I found mistakes I didn't catch at the time:

- The component table names two different buttons `BitBtnConsumer` — a copy-paste error; the
  second is the admin button.
- A `RichEdit` component is listed under the name `BitButtonReset`.
- The `FindFlight` entry describes it as searching `arrFlights` in one column and states it
  doesn't in the next.

The document is preserved as submitted. I'd rather show that I can find these than quietly
fix them.

---

## What I'd keep

Not everything here is a mistake.

- **Modelling flights as objects instead of branching logic.** This was the right instinct and
  it is the reason adding a route is a one-line change.
- **The shared `Dmshipment_u` data module.** Connection configuration defined once and
  referenced by both consuming applications, rather than reconfigured per form. This is the
  one piece of the architecture I'd carry forward unchanged.
- **Validating everything before calculating anything, with an accumulated result flag.** The
  user sees every problem at once instead of being walked through them one at a time. I still
  think this is the right behaviour.
- **Showing the full cost breakdown before confirmation.** The problem I set out to solve was
  cost opacity, and the design actually addresses it.
- **Externalising content into `About_Us.txt`.** Copy changes without a recompile — a small
  decision, but the right kind.

## What the project actually taught me

Designing the data model before writing code, and discovering the cost of getting it slightly
wrong. That an architectural decision made in week two — three executables instead of one —
keeps charging you for the remaining five months. That a six-month project is mostly not
writing code. That documentation you wrote in month one becomes wrong by month four unless you
go back and maintain it. And that being able to explain *why* a structure was chosen matters
more than the structure.
