# Finances Dimensions Benchmark

> Defines what life dimensions should exist in `smind_life_dimensions` to comprehensively cover **Finances** — financial stability, income, budgeting, taxes, and wealth management.
>
> **Version:** 1.0 (2026-02-20) — Initial benchmark.
>
> **Consumer:** Evaluator job. Criteria are written to be specific and actionable for LLM grading.

---

## How to Use This Benchmark

The Evaluator should check that `smind_life_dimensions` contains dimensions (or clear sub-dimensions under a parent) that **cover every area below**. A dimension doesn't need to match the exact name — it needs to **substantively address the described scope**. If a single dimension covers multiple areas adequately, that counts. If an area has no coverage at all, that's a gap.

---

## Required Coverage Areas

### 1. Income & Earnings

**Scope:** All sources of money flowing in.

Must cover:
- Primary employment income (salary, wages, freelance revenue)
- Secondary / side income streams
- Passive income (dividends, royalties, rental income, interest)
- Irregular income (bonuses, commissions, windfalls, gifts, inheritance)

**Why it matters:** Without income tracking dimensions, the financial picture has no inflow side.

---

### 2. Budgeting & Spending

**Scope:** How money is allocated and spent across categories.

Must cover:
- Overall budget framework (income vs. expenses balance)
- Fixed expenses (rent/mortgage, insurance premiums, subscriptions, loan payments)
- Variable expenses (food, transport, entertainment, clothing, personal care)
- Discretionary vs. non-discretionary spending distinction
- Spending tracking and review habits

**Why it matters:** Budgeting is the operational core of personal finance. Without it, income and goals are disconnected.

---

### 3. Debt Management

**Scope:** All forms of borrowed money and repayment strategy.

Must cover:
- Consumer debt (credit cards, personal loans, buy-now-pay-later)
- Student loans / education debt
- Mortgage / housing debt
- Debt repayment strategy (snowball, avalanche, consolidation)
- Credit score and creditworthiness awareness

**Why it matters:** Debt is a distinct financial dimension — it interacts with but is not the same as budgeting or investing. Ignoring it leaves a major blind spot for many people.

---

### 4. Emergency Fund & Liquidity

**Scope:** Short-term financial resilience and cash reserves.

Must cover:
- Emergency fund existence and adequacy (typically 3–6 months of expenses)
- Liquid savings accessibility
- Buffer against income disruption (job loss, illness, unexpected expenses)

**Why it matters:** Emergency preparedness is a prerequisite for all other financial planning. Without it, any shock cascades into debt or goal abandonment.

---

### 5. Saving & Wealth Accumulation

**Scope:** Intentional setting aside of money beyond emergency reserves.

Must cover:
- Savings rate (percentage of income saved)
- Short-term savings goals (travel, purchases, events)
- Medium-term savings goals (down payment, education, major life events)
- Net worth tracking and growth over time

**Why it matters:** Savings bridges current income to future goals. It's distinct from investing (which involves risk) and from emergency funds (which are defensive).

---

### 6. Investing & Portfolio Management

**Scope:** Deploying capital for growth, including all asset classes a person might use.

Must cover:
- Investment strategy and asset allocation philosophy
- Equities (stocks, ETFs, index funds, mutual funds)
- Fixed income (bonds, CDs, treasury securities)
- Real estate investing (rental properties, REITs)
- Alternative investments (crypto, commodities, private equity, collectibles)
- Portfolio rebalancing and review cadence
- Risk tolerance and investment horizon awareness

**Why it matters:** Investing is the primary engine of long-term wealth building. Omitting it or treating it as a single monolithic dimension misses the diversity of approaches.

---

### 7. Retirement Planning

**Scope:** Long-term financial preparation for post-employment life.

Must cover:
- Retirement accounts (401k, IRA, Roth IRA, pension, or country-equivalent)
- Employer matching and benefit optimization
- Retirement savings targets (based on age, income, desired lifestyle)
- Withdrawal strategy planning (for those approaching retirement)
- Social security / government pension awareness

**Why it matters:** Retirement planning has unique tax treatment, time horizons, and regulatory structures that justify separate coverage from general investing.

---

### 8. Tax Planning & Optimization

**Scope:** Understanding and minimizing tax burden legally.

Must cover:
- Income tax awareness (brackets, effective rate, withholding)
- Tax-advantaged accounts and strategies (retirement accounts, HSA, 529)
- Deductions and credits awareness
- Tax filing and compliance (deadlines, documentation, professional help)
- Capital gains tax implications for investments
- Self-employment tax considerations (if applicable)

**Why it matters:** Taxes are the single largest expense for most earners. Even basic optimization significantly impacts net wealth.

---

### 9. Insurance & Risk Protection

**Scope:** Financial protection against catastrophic events.

Must cover:
- Health insurance adequacy
- Life insurance (term, whole — relevant if dependents exist)
- Disability insurance (short-term and long-term)
- Property insurance (renters, homeowners, auto)
- Liability insurance / umbrella coverage
- Insurance review cadence (are coverages still appropriate?)

**Why it matters:** Insurance is the financial backstop that prevents catastrophic loss. Under-insurance is a silent risk that only becomes visible during crises.

---

### 10. Estate Planning & Legacy

**Scope:** What happens to assets and responsibilities after death or incapacitation.

Must cover:
- Will and testament existence
- Beneficiary designations on accounts (retirement, insurance, bank)
- Power of attorney (financial and healthcare)
- Trust structures (if applicable)
- Digital asset and account succession planning

**Why it matters:** Estate planning is frequently neglected, especially by younger adults. Its absence creates legal and financial chaos for survivors.

---

### 11. Financial Literacy & Education

**Scope:** Ongoing knowledge development about personal finance.

Must cover:
- Self-assessed financial knowledge level
- Active learning habits (books, courses, advisors, communities)
- Awareness of behavioral finance pitfalls (emotional spending, anchoring, loss aversion)
- Financial decision-making confidence

**Why it matters:** Financial literacy is the meta-dimension — it determines how well all other areas are managed. A person with high income but low literacy will underperform someone with moderate income and high literacy.

---

### 12. Financial Goals & Planning Horizon

**Scope:** Explicit financial targets and the planning framework connecting them.

Must cover:
- Short-term financial goals (< 1 year)
- Medium-term financial goals (1–5 years)
- Long-term financial goals (5+ years)
- Goal prioritization and trade-off awareness
- Financial plan existence (formal or informal)

**Why it matters:** Without explicit goals, financial activity is reactive rather than strategic. This dimension ensures the system captures intentionality.

---

## Edge Cases & Commonly Overlooked Areas

The Evaluator should also verify that the following are addressed (they may live within the areas above or as separate dimensions):

| Often-missed area | Where it should appear |
|---|---|
| **Charitable giving / tithing** | Budgeting & Spending or Financial Goals |
| **Financial impact of relationships** (joint accounts, prenups, divorce costs) | Estate Planning or as a cross-cutting note |
| **Inflation awareness** | Investing or Saving (purchasing power erosion) |
| **Currency risk** (for expats, remote workers paid in foreign currency) | Income or Investing |
| **Subscription creep** | Budgeting & Spending |
| **Financial automation** (auto-pay, auto-invest, auto-save) | Budgeting or Saving |
| **Cost of children / dependents** | Budgeting or Financial Goals |
| **Career earnings trajectory** | Income (forward-looking income potential) |

---

## Grading Guidance for Evaluator

- **Full coverage:** Every one of the 12 areas above has at least one dimension that substantively addresses its scope.
- **Partial coverage:** 8–11 areas covered. Gaps should be filed as issues.
- **Weak coverage:** Fewer than 8 areas covered. Multiple issues should be filed.
- **Depth check:** Areas that are covered should address the "Must cover" bullets at a reasonable level. A dimension called "Finances" with no sub-structure is not adequate coverage even if it technically exists.

---

*Benchmark produced by 💰 Finances Scientist. Next run should review for blind spots, sharpen criteria, and incorporate any feedback from Evaluator issues.*
