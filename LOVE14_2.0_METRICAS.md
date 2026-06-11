# 📊 LOVE14 2.0 - MÉTRICAS, FÓRMULAS Y DASHBOARDS

---

## FÓRMULAS CRÍTICAS DE NEGOCIO

### 1. CUSTOMER ACQUISITION COST (CAC)

```
CAC = Total Marketing Spend / New Customers Acquired

EJEMPLO MES 1:
├─ Marketing spend: $100
├─ New customers: 10
├─ CAC = $100 / 10 = $10

OBJETIVO:
├─ Viral channels: $0-1
├─ Referral: $1-2
├─ Paid ads: $2-5
└─ PROMEDIO: $2-3

FÓRMULA COMPLETA:
CAC = (Ad Spend + Salaries + Tools) / (Customers This Month)
```

### 2. LIFETIME VALUE (LTV)

```
LTV = (ARPU × Gross Margin%) × (1 / Churn Rate)

DONDE:
├─ ARPU = Average Revenue Per User
├─ Gross Margin = 80-90% (costo directo / revenue)
├─ Churn Rate = % usuarios que se van por mes

EJEMPLO:
├─ ARPU: $8/mes
├─ Gross Margin: 85%
├─ Monthly churn: 5% (retention = 95%)
│
├─ LTV = (8 × 0.85) / 0.05 = $136

OTRO CÁLCULO (Más simple):
├─ Average order value: $7.50
├─ Repeat purchase rate: 20% (vuelven a comprar)
├─ Repeat orders per year: 4 (aniversarios, etc)
│
└─ LTV = $7.50 × 4 = $30 conservador

REALISTA (6 meses):
└─ LTV = $50-100
```

### 3. LTV:CAC RATIO (HEALTHINESS)

```
LTV:CAC Ratio = LTV / CAC

HEALTHY RATIOS:
├─ Ratio > 3:1 = Sustainable ✅
├─ Ratio > 5:1 = Strong growth
├─ Ratio 10:1 = Exceptional
└─ Ratio < 3:1 = Check model

LOVE14 OBJETIVO:
├─ LTV: $75 (conservador)
├─ CAC: $3 (promedio)
├─ Ratio: 25:1 = EXCEPTIONAL ✅
└─ Significa: Gastar $1 → recuperar $25
```

### 4. CONVERSION RATE

```
Conversion Rate = (Customers / Visitors) × 100%

LOVE14 TARGETS:
├─ Downloads → Signup: 30%
├─ Signup → Create Gift: 50%
├─ Create Gift → Add to Cart: 70%
├─ Add to Cart → Purchase: 85%
│
├─ FUNNEL CONVERSION: 30% × 50% × 70% × 85% = 8.9%
└─ O SEA: 1000 descargas → 89 pagos (conservador: 2-5%)

BENCHMARK:
├─ SaaS típico: 2-5%
├─ E-commerce típico: 1-3%
└─ LOVE14 objetivo: 2-5% ✅ (realista)
```

### 5. VIRAL COEFFICIENT (k-factor)

```
k = (% shares per user) × (share acceptance rate) × (conversion rate)

LOVE14 VIRAL LOOP:
├─ Compra usuario A → envía regalo usuario B
├─ Usuario B recibe email + regalo
├─ Usuario B es motivado a comprar de vuelta
│
├─ % shares: 40% de compradores comparten
├─ Acceptance: 70% de receptores ven regalo
├─ Conversion: 15% de receptores compran de vuelta
│
├─ k = 40% × 70% × 15% = 0.042 (por compra directa)
│
└─ MÁS REALISTA CON REFERRAL:
   ├─ 40% comparten en WhatsApp
   ├─ De esos, 70% aceptan + ven
   ├─ De esos, 30% hacen referral activo
   ├─ De referrals, 15% compran
   │
   └─ k ≈ 0.3-0.5 (VIRAL! 🔥)

CRECIMIENTO VIRAL:
├─ If k > 1: Crece exponencialmente
├─ If k = 0.5: Crece geométricamente (bueno)
├─ If k < 0.3: Crece linealmente (requiere ads)

LOVE14: k ≈ 0.3-0.5 → Crecimiento exponencial posible
```

### 6. PAYBACK PERIOD

```
Payback Period = CAC / (ARPU × Gross Margin%)

LOVE14 EJEMPLO:
├─ CAC: $3
├─ ARPU: $7.50
├─ Gross Margin: 85%
│
├─ Payback = $3 / ($7.50 × 0.85) = $3 / $6.38 = 0.47 meses
└─ = ~2 SEMANAS (excelente!)

BENCHMARK:
├─ SaaS promedio: 9-12 meses
├─ E-commerce: 6-9 meses
└─ LOVE14: 0.5 meses ✅ (muy superior)

IMPLICACIÓN:
└─ Dinero invertido en ads = recuperado en 2 semanas
└─ Permite reinversión acelerada
```

### 7. MONTHLY RECURRING REVENUE (MRR)

```
MRR = Suma de todas las suscripciones activas × precio

LOVE14 STRUCTURE:
├─ One-time gifts: No recurrente
├─ Subscriptions: $4.99/mes (future)
├─ Referral rewards: Occasional
│
MRR PROYECTADO:
├─ Month 3: 20 subscriptions = $99.80 MRR
├─ Month 4: 50 subscriptions = $249.50 MRR
├─ Month 5: 100 subscriptions = $499 MRR
├─ Month 6: 200 subscriptions = $998 MRR
└─ Month 12: 800 subscriptions = $3,992 MRR

PLUS One-time purchases:
├─ Month 6: 900 one-time × $7.5 = $6,750
└─ Total revenue month 6: ~$7,750
```

### 8. CHURN RATE

```
Churn Rate = (Customers Lost This Month / Customers Start of Month) × 100%

LOVE14:
├─ No es modelo subscription (inicialmente)
├─ Churn = % que NO vuelven a comprar en 12 meses
│
├─ Target:
│  ├─ 1st purchase to 2nd: 30% repurchase
│  ├─ 2nd to 3rd: 50% repurchase
│  └─ LT retention: 20-30% buy 4+ times
│
└─ Implicación: 70% one-time buyers, 30% repeat

REDUCTION STRATEGIES:
├─ Push notifications en aniversarios
├─ Email sequences en fechas especiales
├─ Referral incentives para volver
└─ Premium features que incentiven repeat
```

---

## DASHBOARD DIARIO (Googlesheet template)

```
FECHA | INSTALLS | SIGNUPS | CREAR_REGALO | PAGOS | REVENUE | CHURN | NOTAS
──────────────────────────────────────────────────────────────────────────
Jun 10|    50    |   20    |      10      |   2   |  $14.98 |  0%   | Soft launch
Jun 11|    80    |   35    |      18      |   4   |  $29.96 |  0%   | Product Hunt top 50
Jun 12|   120    |   50    |      25      |   5   |  $37.45 |  5%   | TikTok post viral
Jun 13|   150    |   60    |      30      |   6   |  $44.94 |  5%   | Ads test started
Jun 14|   180    |   75    |      35      |   7   |  $52.43 |  8%   | Better onboarding
─────────────────────────────────────────────────────────────────────────
TOTAL|   580    |  240    |     118      |  24   | $179.76 | 3.6%  | 4.1% overall conversion

CALCULOS AUTOMÁTICOS:
├─ DAU = Usuarios activos hoy
├─ Conversion: Pagos / Signups
├─ ARPU: Revenue / Usuarios
├─ CAC: Ad spend / New signups
├─ Running totals: Revenue cumulative
└─ Trends: Week-over-week growth %
```

---

## WEEKLY METRICS REPORT

```
SEMANA 1 (Días 1-7)

ADQUISICIÓN:
├─ Total installs: 580
├─ Installs/día promedio: 83
├─ Top channel: Product Hunt (45%)
├─ Growth rate: N/A (primera semana)
└─ Target: >50 installs/día ✅

ACTIVACIÓN:
├─ Total signups: 240
├─ Signup rate: 41% (installs → signup)
├─ Onboarding completion: 50% (120/240)
├─ First gift creation: 118 (49%)
└─ Target: >40% signup ✅

MONETIZACIÓN:
├─ Total payments: 24
├─ Conversion: 2.5% (pagos/signups)
├─ Conversion: 4.1% (pagos/creaciones)
├─ Total revenue: $179.76
├─ Avg order value: $7.49
└─ Target: >1.5% ✅

RETENCIÓN:
├─ Day 1 retention: 65%
├─ Day 7 retention: 20%
├─ Churned: 12 usuarios
└─ Target: >60% D1, >25% D7

REFERRAL:
├─ Shares tracked: 35
├─ Referral completions: 3
├─ k-factor (estimated): 0.15
└─ Target: >0.1 ✅

FINANCIERO:
├─ Total spend: $150 (ads testing)
├─ Revenue: $179.76
├─ Profit: $29.76 (week 1!)
├─ CAC: $6.25
├─ LTV estimate: $75 (proyectado)
└─ LTV:CAC = 12:1 (HEALTHY!)
```

---

## MONTHLY METRICS REPORT (Template)

```
MONTH: JUNIO (Month 0 - Soft Launch)

USERS & GROWTH:
├─ Total installs: 2,500
├─ New installs: 2,500 (MoM: N/A)
├─ Active users (7-day): 850
├─ DAU: 250-300
├─ Growth rate: N/A (launch month)
└─ Target: >100 installs/día by end ✅

ENGAGEMENT:
├─ % creating gift: 45%
├─ % completing checkout: 85%
├─ Avg time to purchase: 18 minutes
├─ Repeat purchase rate: 8%
└─ Target: >40% create ✅

MONETIZATION:
├─ Total transactions: 100
├─ Total revenue: $750
├─ ARPU: $3 (all users)
├─ ARPPU: $7.50 (paying users)
├─ Avg order value: $7.50
├─ Conversion rate: 4%
└─ Target: >2% ✅

RETENTION & CHURN:
├─ Day 1 retention: 62%
├─ Day 7 retention: 24%
├─ Day 30 retention: 12%
├─ Monthly churn: 88%
├─ Repeat purchase rate: 8%
└─ Note: Normal for paid one-time products

REFERRAL:
├─ Referral shares: 120
├─ Completed referrals: 25
├─ Referral revenue: $185 (25 × $7.50)
├─ Referral CAC: $1.00 (paid $25)
├─ k-factor: 0.21
└─ Target: >0.15 ✅

MARKETING:
├─ Channels breakdown:
│  ├─ Product Hunt: 45% (1,125 users)
│  ├─ Viral/referral: 25% (625 users)
│  ├─ Organic: 20% (500 users)
│  └─ Ads (test): 10% (250 users)
│
├─ Ad spend: $400
├─ CAC from ads: $1.60 (250 installs)
├─ ROAS: 2.3x (revenue vs spend)
└─ Conclusion: Ads viable, viral is primary

COHORTS:
├─ Week 1 cohort:
│  ├─ Size: 400 users
│  ├─ Week 1 retention: 70%
│  ├─ Week 4 retention: 15%
│  ├─ Spend: $35
│  └─ Revenue: $110
│
└─ Week 4 cohort:
   ├─ Size: 900 users
   ├─ Week 1 retention: 60%
   ├─ Week 2 retention: 30%
   └─ (Still tracking)

FINANCIAL:
├─ Revenue: $750
├─ Ad spend: $400
├─ Infrastructure: $120
├─ Gross profit: $230
├─ Net margin: 31%
├─ Breakeven analysis:
│  └─ With 4% conversion, need 117 customers/month to break even
│  └─ Current: 100 customers
│  └─ Status: VERY CLOSE ✅
│
└─ Outlook: Profitable by Month 3-4
```

---

## COHORT ANALYSIS (Critical for Understanding Behavior)

```
COHORT RETENTION ANALYSIS:

                Week 1  Week 2  Week 3  Week 4  Week 5  Week 6
────────────────────────────────────────────────────────────
Week 1    →     100%    62%     24%     12%     8%      5%
Week 2    →     100%    64%     28%     14%     9%      -
Week 3    →     100%    60%     30%     16%     -       -
Week 4    →     100%    58%     28%     -       -       -
Week 5    →     100%    65%     -       -       -       -
Week 6    →     100%    -       -       -       -       -

INSIGHTS:
├─ Week 2 retention: ~60-65% (GOOD)
├─ Week 4 retention: 12-16% (NORMAL for one-time)
├─ Trend: Stable (not getting worse) ✅
├─ Implication: Product-market fit exists
└─ Action: Increase retention features (month 2)

REPEAT PURCHASE ANALYSIS:

Time to Repeat Purchase:
├─ Same week: 2%
├─ Week 2-4: 5%
├─ Month 2-3: 15%
├─ Month 3-6: 25%
└─ Year 1: 35% repeat rate

Triggers for repeat:
├─ Aniversario: 30-40% repurchase rate
├─ Reciprocal gifting: 20-25% repurchase
├─ Email reminder: 10-15% repurchase
└─ No trigger: 5% spontaneous

IMPLICATION:
└─ Seasonal campaigns = LTV multiplier
```

---

## UNIT ECONOMICS CALCULATOR

```
USE THIS SPREADSHEET TO CALCULATE YOUR UNIT ECONOMICS:

INPUT VARIABLES:
├─ Average Order Value: $_____
├─ Payment Processor Fee: ___% (Stripe: 2.9% + $0.30)
├─ Infrastructure Cost per order: $_____
├─ Email delivery cost per order: $_____
├─ Refund rate: ___% (assume 5%)
│
├─ Monthly fixed costs:
│  ├─ Firebase: $_____
│  ├─ SendGrid: $_____
│  ├─ Domain: $_____
│  ├─ Your salary: $_____
│  └─ Other: $_____
│
└─ Customer acquisition:
   ├─ Paid CAC: $_____
   ├─ Viral CAC: $_____
   ├─ Organic CAC: $_____
   └─ Referral CAC: $_____

CALCULATIONS:
├─ Revenue per order: (AOV × 97.5%) - 2.9% - $0.30 = ?
├─ COGS per order: Infrastructure + Email = ?
├─ Gross profit per order: Revenue - COGS = ?
├─ Gross margin %: (Gross profit / AOV) × 100 = ?%
│
├─ Break-even customers/month: Fixed costs / Gross profit per order = ?
├─ Current customers/month: ? (from analytics)
├─ Profitability: (Current × Gross profit) - Fixed = $?
│
└─ LTV calculation:
   ├─ Repeat purchase rate: ___%
   ├─ Average repeat orders: ?
   ├─ LTV = (AOV × repeat rate × avg orders) = $?
   ├─ CAC blended: (Paid + Viral + Organic + Referral) / 4 = $?
   └─ LTV:CAC ratio = ? (target: >3:1)

EXAMPLE (Love14 Month 3):
├─ AOV: $7.50
├─ Stripe fee: -$0.51
├─ Infrastructure: -$0.10
├─ Email: -$0.01
├─ Net per order: $6.88
│
├─ Gross margin: 92%
├─ Fixed costs: $1,000
├─ Break-even: 145 customers
├─ Actual: 150 customers
├─ Profit: $30
│
├─ LTV: $30 (first 6 months)
├─ CAC: $2.50
└─ LTV:CAC = 12:1 ✅ HEALTHY
```

---

## RED FLAGS TO WATCH

```
METRICA             GOOD        WARNING    RED FLAG
─────────────────────────────────────────────────────
DAU/Downloads       >30%        <30%       <10%
Signup rate         >40%        <40%       <20%
Checkout complete   >80%        <80%       <60%
Conversion          >2%         1-2%       <1%
7-day retention     >40%        20-40%     <20%
Repeat purchase     >15%        5-15%      <5%
CAC                 <$5         $5-10      >$10
LTV:CAC             >5:1        3-5:1      <3:1

IF SEEING RED FLAGS:
├─ CAC > $5: Reduce ad spend, boost viral
├─ Conversion < 1%: Debug checkout flow
├─ Retention < 20%: Add push notifications
├─ Repeat < 5%: Implement referral system
└─ LTV:CAC < 3:1: Model is broken, pivot
```

---

## PROJECTION SCENARIOS

### Escenario 1: Pessimistic (30% de probabilidad)

```
ASSUMPTIONS:
├─ Viral loop no funciona: k = 0
├─ Conversion: 1% (baja)
├─ CAC: $5 (ads necesarios)
├─ Repeat rate: 10%
├─ Monthly growth: 50%

PROYECCIÓN:
Mes 1: $56 revenue | -$644 profit
Mes 2: $200 revenue | -$700 profit
Mes 3: $400 revenue | -$600 profit
Mes 4: $800 revenue | -$200 profit
Mes 5: $1,600 revenue | +$600 profit
Mes 6: $3,200 revenue | +$2,200 profit
─────────────────────────────────────
Year 1: $15,000 revenue | -$1,000 net

CONCLUSION:
├─ Slower growth
├─ Requires sustained ad spend
├─ Breakeven delayed to Month 4-5
└─ Still viable but tighter
```

### Escenario 2: Realistic (50% de probabilidad) ✅

```
ASSUMPTIONS:
├─ Viral loop funciona: k = 0.3
├─ Conversion: 2.5% (target)
├─ CAC blended: $3
├─ Repeat rate: 20%
├─ Monthly growth: 100%

PROYECCIÓN:
Mes 1: $56 revenue | -$644 profit
Mes 2: $299 revenue | -$750 profit
Mes 3: $1,125 revenue | -$250 profit
Mes 4: $2,247 revenue | +$900 profit
Mes 5: $4,597 revenue | +$3,450 profit
Mes 6: $7,192 revenue | +$6,200 profit
─────────────────────────────────────
Year 1: $50,000+ revenue | $30,000+ net

CONCLUSION:
├─ Strong growth trajectory
├─ Breakeven Month 3-4
├─ Profitable from Month 4
└─ MOST LIKELY PATH ✅
```

### Escenario 3: Optimistic (20% de probabilidad)

```
ASSUMPTIONS:
├─ Viral loop + referral strong: k = 0.5
├─ Conversion: 5% (superior)
├─ CAC: $1.50 (mostly viral)
├─ Repeat rate: 30%
├─ Monthly growth: 150%

PROYECCIÓN:
Mes 1: $100 revenue | -$600 profit
Mes 2: $600 revenue | -$400 profit
Mes 3: $2,500 revenue | $1,500 profit
Mes 4: $7,500 revenue | $6,500 profit
Mes 5: $18,000 revenue | $17,000 profit
Mes 6: $45,000 revenue | $44,000 profit
─────────────────────────────────────
Year 1: $120,000+ revenue | $80,000+ net

CONCLUSION:
├─ Explosive growth
├─ Early profitability
├─ Viral flywheel working
└─ Best case scenario
```

---

**Usa estos dashboards y fórmulas diariamente para tomar decisiones data-driven.**

**Recuerda: Lo que se mide, se mejora. 📊**
