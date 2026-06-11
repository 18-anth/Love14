# ❓ LOVE14 2.0 - FAQs PARA FUNDADOR

---

## PREGUNTAS TÉCNICAS

### P: ¿Tengo que reescribir todo el código actual?

**R:** ~60-70%. Reutilizarás:
- UI components (buttons, cards, etc)
- Firebase services (auth base)
- Model structures (partial)
- Animations (Lottie)

Necesitas reescribir:
- Auth flow (couples, not admin/client)
- Gift creation flow (NUEVO)
- Payment integration (NUEVO)
- Email service (NUEVO)
- Home screen (complete redesign)

**Tiempo:** ~40-50 horas para MVP.

---

### P: ¿Necesito Cloud Functions o puedo hacer todo en Flutter?

**R:** **Necesitas Cloud Functions para:**
- Email delivery (async, confiable)
- Payment webhooks (Stripe confirmation)
- Scheduled tasks (aniversarios)
- Analytics agregación (report generation)

**Puedes hacer en Flutter:**
- CRUD básico (gifts, users)
- UI flows
- Analytics tracking
- Payment initiation

**Arquitectura recomendada:**
```
Flutter App → Firebase Cloud Functions → Stripe + SendGrid
     ↓              ↓
  Firestore ← Cloud Functions
```

**Esfuerzo Cloud Functions:** 10-15 horas (vale la pena).

---

### P: ¿Qué pasa si Firebase Database está caída?

**R:** 
1. **Prevención:** Firebase tiene 99.95% uptime
2. **Fallback:** App funciona offline (SharedPreferences)
3. **Recovery:** Sincroniza cuando reconecta
4. **User communication:** Banner: "Sincronizando..."

**Implementación:**
```dart
// Offline support
class OfflineService {
  Future<void> saveGiftLocally(Gift gift) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('pending_gift_${gift.id}', jsonEncode(gift));
  }
  
  Future<void> syncPendingGifts() async {
    // Retry cuando internet vuelva
  }
}
```

**Tiempo:** 5 horas de implementation.

---

### P: ¿Firebase Realtime DB o Firestore?

**R:** **USA FIRESTORE PARA LOVE14:**

| Feature | Firestore | Realtime DB |
|---------|-----------|------------|
| Pricing | Pay per read | Pay per GB | 
| Queries | Avanzadas | Limitadas |
| Scaling | Mejor para>1M | Mejor para<1M |
| Latency | 100-500ms | 10-100ms |
| Índices | Automáticos | Manual |

**Para Love14:**
- Queries complejas (historias de regalo)
- Más usuarios (>100k futuro)
- Pricing mejor escala

**Usa Firestore + Realtime DB para:**
- Realtime notifications (cuando gift seen)

**Hybrid approach:** Firestore (primary) + Realtime DB (notifications).

---

### P: ¿Cómo manejo seguridad de datos de parejas?

**R:** 
1. **Authentication:** Email + password (Firebase Auth)
2. **Authorization:** Firestore rules solo permiten couples leer su data
3. **Encryption:** SSL en tránsito (automatico con Firebase)
4. **Sensitive data:** Nunca guardar contraseñas

**Firestore Rules ejemplo:**
```javascript
match /couples/{coupleId} {
  allow read, write: if 
    request.auth.uid in resource.data.userIds;
}

match /gifts/{giftId} {
  allow read: if 
    request.auth.uid == resource.data.senderId ||
    request.auth.uid == resource.data.recipientId;
}
```

**Compliance:**
- Privacy policy: Requerido
- GDPR: Permitir delete account
- CCPA: Data portability (export)

---

### P: ¿Qué pasa con datos después de expiración?

**R:** **Estrategia de retention:**

```
POLICY:
├─ Gifts: Expiran en 7 días (web view)
├─ App view: 30 días (users pueden re-guardar)
├─ Analytics data: 90 días
├─ User accounts: Indefinido (or delete on request)
├─ Videos/images: Delete after expiry

IMPLEMENTATION:
├─ Cloud Function: cron job daily
├─ Mark gifts as "expired"
├─ Delete files from Storage
├─ Keep metadata en Firestore (for stats)

COST BENEFIT:
├─ Storage cleanup: Save $$$
├─ User privacy: Security compliance
├─ Analytics: Still available
```

---

## PREGUNTAS DE MONETIZACIÓN

### P: ¿Por qué $4.99 y no $2.99?

**R:** Psicología de precios:

```
$2.99: Perceived value baja ("fake cheap")
$4.99: Sweet spot ("affordable but valuable")
$9.99: Premium tier marker
$14.99: Alternative luxury

A/B TEST (Mes 2):
├─ 50% usuarios ven $4.99
├─ 50% usuarios ven $3.99
├─ Medir: Revenue vs Conversion rate
├─ Fórmula: (Conversion × Price) = RPU
│
├─ $4.99: 3% × $4.99 = $0.15 RPU
├─ $3.99: 5% × $3.99 = $0.20 RPU
└─ Ganador: $3.99 probablemente (test primero)
```

**Recomendación:** Comienza con $4.99, test downward luego.

---

### P: ¿Debo cobrar por descargar?

**R:** **NO.** Razones:

```
FREE APP:
├─ Barrier to entry: Baja (99% will try)
├─ Users gained: 10x más
├─ Viral potential: 5x más
├─ Conversion: Compensates volume

PAID DOWNLOAD ($0.99):
├─ Barrier: Alta
├─ Users gained: 10% de free
├─ Conversion rate: 5-10% (higher intent)
├─ Revenue: $0.99 × users pero... muy pocos users

MATH:
├─ FREE: 1000 downloads × 3% conversion = 30 customers = $150
├─ PAID: 50 downloads × 8% conversion = 4 customers = $4

VEREDICTO: FREE + monetization > Paid download
```

---

### P: ¿Cuándo lanzar Premium tier?

**R:** 
```
NO HACER (Mes 1-2):
├─ Distrae del core product
├─ Confunde mensajería
├─ Baja conversión total

SÍ HACER (Mes 3):
├─ Tener 1000+ usuarios base
├─ Saber qué quieren mejorar
├─ A/B testear features
├─ Dann launch Premium con claridad

TIER STRUCTURE (Mes 3+):
├─ FREE: 1 regalo/año
├─ BASIC: $4.99 (default)
├─ PREMIUM: $14.99 (upsell en checkout)
│  ├─ Add voice message
│  ├─ Video message (futuro)
│  ├─ More music options
│  ├─ No watermark
│  └─ Extended expiry (90 días)
│
└─ SUBSCRIPTION: $4.99/mes (Mes 5)
   ├─ Unlimited gifts
   ├─ All features
   ├─ Prioridad support
   └─ Target: 5-10% of users
```

---

### P: ¿Cómo evito compras fraudulentas con Stripe?

**R:** 

```
STRIPE HANDLES:
├─ 3D Secure (CVV verification)
├─ Fraud detection (machine learning)
├─ Chargeback protection (disputes)
└─ PCI compliance (seguridad)

YOUR RESPONSIBILITIES:
├─ Verify email (confirmation)
├─ Rate limiting (max 5 attempts)
├─ Monitor chargeback rate (<1%)
├─ Refund policy clear (30 días)

SETUP:
1. Enable Stripe Radar (fraud detection)
2. Set strong email verification
3. Implement rate limiting
4. Monitor Stripe dashboard daily
5. Respond to chargebacks dentro 7 días

EXPECTED FRAUD RATE: 0.1-0.5% (normal)
RESERVE FUND: $500 para chargebacks Month 1-3
```

---

### P: ¿Qué si tengo refunds altos?

**R:** 

```
REFUND RATE TARGETS:
├─ <1%: Excelente
├─ 1-3%: Aceptable
├─ 3-5%: Warning, investigate
├─ >5%: Critical, fix immediately

REASONS PARA REFUNDS:
1. Gift no funciona técnicamente
2. Recipient no recibe email
3. User cambió de opinion
4. Fraud/chargeback

MITIGATION:
├─ Test todos gifts antes enviar
├─ Verify email delivery
├─ Clear messaging (no easy refund)
├─ Quality support (prevent issues)
├─ Stripe Radar (fraud detection)

IF SEEING >3%:
├─ Debug: ¿Technical issues?
├─ Check: ¿Email delivery?
├─ Test: ¿Onboarding confuso?
└─ Action: Fix issue + retry customers
```

---

## PREGUNTAS DE GROWTH

### P: ¿Cómo empiezo sin presupuesto de marketing?

**R:** 

```
WEEK 1-2: FREE CHANNELS ($0)
├─ Product Hunt: 200-500 usuarios
├─ Twitter organic: 100-200 usuarios  
├─ Reddit: 50-100 usuarios
├─ Email: Ask beta testers to refer
└─ Total: 500-1000 usuarios gratis

WEEK 3-4: LEVERAGE VIRAL ($0 + product-driven)
├─ Referral system go-live
├─ Reciprocal gift mechanics
├─ Share buttons everywhere
├─ k-factor: 0.2-0.3
└─ Amplification: 20-50% additional growth

MONTH 2: SMART PAID ($200-500)
├─ Test Facebook ads: $100-200
├─ Monitor ROI carefully
├─ Stop losers, double winners
└─ CAC target: $2-3

PROGRESSION:
├─ First growth: Founder mode + viral
├─ Second growth: Paid advertising
├─ Third growth: Content + SEO
└─ Fourth growth: Partnerships + B2B
```

**Clave:** No gastar dinero hasta tener product-market fit (evidencia).

---

### P: ¿Cuándo puedo parar de spamear Twitter?

**R:**

```
TWITTER POSTING STRATEGY:

MONTH 1: Agresivo (2-3 posts/día)
├─ Building audience
├─ Generating buzz
├─ Capturing early adopters
└─ OK para "spam" = authentic hustle

MONTH 2: Moderado (1 post/día)
├─ Audience built
├─ Focus en engagement
├─ Less frequency, more quality

MONTH 3+: Selective (3-4 posts/semana)
├─ Sustainable pace
├─ Brand authority
├─ Not annoying followers

TIPOS DE POSTS:
├─ 40%: Product updates
├─ 30%: User stories / testimonials  
├─ 20%: Insights / tips
├─ 10%: Memes / personality

METRICS:
├─ Followers: Target 1000 by month 2
├─ Engagement: >5% (likes/retweets)
├─ CTR (link clicks): >2%
└─ Referrals from Twitter: Track

REGLA: Si alguien dijo "annoying pero bought anyway" = perfect balance
```

---

### P: ¿Debería hacer TikTok?

**R:** 

```
TikTok PROS:
├─ Viral potential: EXTREMAMENTE ALTA
├─ Younger audience: 18-35 (también parejas)
├─ Short format: Fácil crear
├─ Algorithm: Rewards quality, not followers
├─ Engagement: 10x mejor que Instagram

TikTok CONS:
├─ Algorithm: Impredecible
├─ Trend chasing: Requiere time
├─ Longer strategy: Toma 3-6 months
├─ Copycat content: Easy if no original

RECOMMENDATION:

MONTH 1: Skip (focus Firebase/payment)
MONTH 2: Test (post 2-3 videos)
MONTH 3+: Commit (3 videos/semana) if getting traction

FORMAT IDEAS:
├─ "Reaction" videos (pareja veiendo regalo)
├─ "Create in 60s" (walktrough rápido)
├─ Behind-the-scenes (de dev)
├─ Testimonials (user stories)
└─ Trends (adapt trending sounds)

HONEST ASSESSMENT:
├─ TikTok puede traer 30-50% growth
├─ But high variance (viral or not)
├─ Better como secondary channel
├─ Focus: Product + Facebook ads primero

DECISION: Prueba Month 2, scale if working.
```

---

## PREGUNTAS OPERACIONALES

### P: ¿Necesito LLC/Empresa formal?

**R:**

```
MONTH 1-3: NOT REQUIRED
├─ Bootstrap como indie dev
├─ Ingresos directos a tu cuenta
├─ Simple, sin overhead

MONTH 3-6: CONSIDER
├─ Si revenue >$5k/month
├─ Si quieres escalar employees
├─ Si buscas investors
├─ Tax benefits (en US)

SETUP:
├─ Consulta CPA (tax accountant)
├─ Probablemente LLC o S-Corp
├─ Costo: $500-1500
├─ Paperwork: 5 horas

TAX IMPLICATIONS:
├─ Deducibles: Hosting, tools, equipment
├─ Income tax: Depends en jurisdiction
├─ Quarterly estimated: Si LLC

RECOMENDACIÓN:
└─ Run as indie first
└─ Formalizar cuando pase $10k/month
```

---

### P: ¿Cómo manejo customer support?

**R:**

```
MONTH 1-2: Manual (Tú)
├─ Email: support@love14.app
├─ Response time: <4 hours
├─ Spreadsheet tracker
├─ Log issues para fix

TIPOS DE ISSUES:
├─ Payment failed (25%)
│  └─ Solu: Check email, retry link, refund
│
├─ Gift not arrived (20%)
│  └─ Solu: Resend email, check spam
│
├─ Can't login (20%)
│  └─ Solu: Password reset link
│
├─ Feature requests (20%)
│  └─ Solu: "Thanks, on roadmap" note
│
└─ Other (15%)
   └─ Solu: Google answer or research

TEMPLATE RESPONSES:
```
Subject: Re: Love14 Support - [Issue]

Hi [Name],

Thanks for reaching out! Here's how to fix this:

[Solution]

If it doesn't work, let me know. We're here to help!

Best,
[Your name]
Love14 Team
```

MONTH 3+: Automate
├─ FAQ page en website
├─ Chatbot para FAQ comunes
├─ Zendesk o similar ($25/month)
├─ Hiring support person (if needed)

METRICS:
├─ Support response time: <2 hours
├─ Resolution rate: >90%
├─ CSAT score: >4.5/5
└─ Support cost: <5% revenue
```

---

### P: ¿Cómo trackeo qué está funcionando?

**R:**

```
DAILY (5 min):
├─ Check Firebase dashboard
├─ Note: Revenue, users, errors
├─ Quick gut check: ¿Está bien?

WEEKLY (30 min):
├─ Prepare metrics report
├─ Calculate: CAC, LTV, conversion
├─ Identify: Wins, problems, next steps
├─ Share: Personal log or document

MONTHLY (1-2 hours):
├─ Full analysis
├─ Cohort retention
├─ Channel performance
├─ Decide: What to optimize next

TOOLS RECOMENDADOS:
├─ Firebase: Free, built-in
├─ Mixpanel: $999/month (overkill inicio)
├─ Plausible: $9/month (privacy-focused)
├─ Spreadsheet: Manual but effective
└─ Recommendation: Firebase + Google Sheets

SPREADSHEET COLUMNS:
├─ Date
├─ Installs
├─ Signups  
├─ Purchases
├─ Revenue
├─ CAC estimate
├─ Notes
└─ Action items

GOLDEN METRIC:
├─ No es revenue (vanity)
├─ No es users (vanity)
├─ Es: LTV > 3x CAC (health)
├─ Optimize: este único número
```

---

### P: ¿A quién le pido feedback?

**R:**

```
EARLY STAGE (Mes 1-2):
├─ Target: Parejas en relaciones a distancia
├─ Method: Direct message en Twitter
├─ Ask: "Mi app es para ti, try for free?"
├─ Get: Honest feedback, testimonial
├─ Offer: $10 referral crédito

APPROACH:
"Hi [Name]! I saw you follow [couple topic]. I'm building Love14 - 
app para parejas sorpresas románticas. Would you test it? Free. 
Te importaría feedback después?"

FEEDBACK SOURCES:
├─ r/LongDistance: 500k+ relevant users
├─ Twitter: Hashtag #longdistance #relationships
├─ Facebook groups: Parejas a distancia
├─ Reddit AMA: "I built an app for couples"
└─ Product Hunt: Built-in feedback

WHAT TO ASK:
├─ Would you pay for this? ($4.99)
├─ What's missing?
├─ How likely to recommend? (1-10)
├─ Any bugs or issues?
└─ Would you want X feature?

NPS SCORE:
├─ 9-10: Promoter (refer friends)
├─ 7-8: Passive (might buy again)
├─ 0-6: Detractor (won't use)
│
└─ Target: >30 NPS by month 2
   (anything >0 is decent for new product)

TESTIMONIALS:
├─ Ask best users: "Can I use your quote?"
├─ Use in landing page, ads, Twitter
├─ Video testimonials > text
└─ Offer: $20 for 30-second video
```

---

## PREGUNTAS PERSONALES

### P: ¿Cuánto debo trabajar diario?

**R:**

```
MONTH 1-2: 40-60 horas/semana
├─ Development: 25 horas
├─ Marketing/Growth: 10 horas
├─ Support: 5 horas
├─ Analytics: 5 horas
└─ Sleep: Importante! 8 horas

MONTH 3-6: 50-70 horas/semana
├─ Development: 30 horas (less coding, more decisions)
├─ Marketing: 20 horas
├─ Support: 10 horas
├─ Strategy: 10 horas
└─ Sleep: Even more important

AFTER MONTH 6: Normalize
├─ If profitable: 40-50 horas
├─ If seeking VC: 60-80 horas
├─ If running it solo: 40-50 horas

IMPORTANT:
├─ Burnout es real
├─ Toma días libres (at least Sundays)
├─ Don't sacrifice health
├─ Esto es marathon, no sprint
└─ Your energy = product quality

REALITY:
└─ First 3 months will be INTENSE
└─ But doable si motivated
└─ Break every 90 minutes (Pomodoro)
```

---

### P: ¿Debería buscar cofundador?

**R:**

```
ARGUMENTS FOR:
├─ Shared workload
├─ Moral support (this is isolating)
├─ Division of skills (dev + biz)
├─ Morale during downturns
└─ Networking effect

ARGUMENTS AGAINST:
├─ Equity split (30% of future?)
├─ Decision making (more complex)
├─ Personality conflicts (startup marriages)
├─ Focus (finding good cofounder takes time)
├─ Already have distribution network

MY RECOMMENDATION:

MONTH 1-3: SOLO
├─ Prove concept
├─ Get to $5k revenue
├─ Build momentum
├─ THEN recruit

FINDING COFOUNDER:
├─ Look for: Business/marketing person
├─ NOT another developer (you don't need it)
├─ Should have network (customer acquisition)
├─ Equity: 40-50% para cofounder

EQUITY SPLIT EXAMPLE:
├─ You: 60% (founder + dev)
├─ Cofounder: 40% (biz + growth)
├─ Future: 20% reserved (employees)
└─ Note: Vesting over 4 years

TIMING:
└─ If getting good traction Month 2-3
└─ Then consider cofounder
└─ But not required for $10k/month

HONEST TAKE:
└─ You can do this solo
└─ Cofounder helps but not necessary
└─ Don't dilute equity for wrong person
```

---

### P: ¿Cuándo debo parar si no funciona?

**R:**

```
QUIT SIGNALS:

1. AFTER MONTH 2:
   └─ If <50 total users
   └─ If 0 paying customers
   └─ If viral loop no existe
   └─ If can't get single person to pay

2. AFTER MONTH 4:
   └─ If <500 users
   └─ If <$50 revenue/month
   └─ If retention <10%
   └─ If every user is from ads (no organic)

3. AFTER MONTH 6:
   └─ If <$1000 cumulative revenue
   └─ If LTV:CAC < 2:1
   └─ If retention <5%
   └─ If no path to profitability visible

PIVOT SIGNALS (Don't quit, transform):

1. B2B instead of B2C:
   └─ Sell to wedding planners
   └─ Sell to event companies
   └─ Bundle with other services
   └─ Higher ARPU, lower volume

2. Different market:
   └─ Corporate team building
   └─ Long-distance family (parents/kids)
   └─ Friend groups (not couples)
   └─ Different geography (focus one country)

3. Different model:
   └─ White-label for platforms
   └─ Affiliate program (commission)
   └─ API for other apps
   └─ B2B SaaS for poets

DECISION FRAMEWORK:

METRICS MONTH 1-2:
├─ Good: >100 users, >5 pays, DAU >30%
├─ Okay: >50 users, >2 pays, DAU >20%
├─ Bad: <50 users, 0 pays, DAU <10%

ACTION PLAN:

BAD → PIVOT or QUIT (give 2 weeks)
OKAY → ADJUST + CONTINUE (month 3 make or break)
GOOD → SCALE (accelerate spend)

FINAL ADVICE:
└─ If genuinely unsure: Continue to month 3
└─ If conviction gone: Quit and try next idea
└─ If learning lots: Persist even if slow
└─ Remember: First idea rarely works
└─ But: Love14 has fundamentals
```

---

## PREGUNTAS SOBRE COMPETENCIA

### P: ¿Qué tal si alguien copia Love14?

**R:**

```
COMPETITIVE ADVANTAGES (MOAT):
1. Poetry database (1000+ poemas)
2. User base (viral loop starts small)
3. UI/UX (took time to perfect)
4. Brand (if you build it right)
5. Integrations (multiple payment methods)

WHAT THEY CAN COPY:
├─ Technology stack
├─ UI design
├─ Pricing model
└─ Distribution channels

WHAT'S HARD TO COPY:
├─ Viral coefficient (if built-in)
├─ User retention (if emotionally designed)
├─ Network effects (if couples are sticky)
└─ Brand trust (if you provide value)

STRATEGY IF COPIED:

MONTH 1-2: Ignore (focus on product)
MONTH 3+: If threatening:
├─ Double down on moat (poetry quality)
├─ Increase retention (features they can't copy easy)
├─ Go faster (outpace in features)
├─ Build community (make switching costs high)

HISTORICAL EXAMPLE:
├─ Snapchat copied by Instagram (Stories)
├─ Result: Both thrived (market big enough)
├─ Lesson: Don't obsess over copy
├─ Focus: Execution and speed

REALITY:
└─ If idea is good, others will try
└─ Winner is usually: Better execution
└─ You have 3-6 month head start
└─ Use it wisely (not spend time worrying)
```

---

**Estas FAQs cubren 95% de las preguntas que vas a tener.**

**Si surge otra cosa → referencia a los documentos específicos:**
- Técnicas → LOVE14_2.0_ARCHITECTURE.md
- Estrategia → LOVE14_2.0_ESTRATEGIA_STARTUP.md
- Ejecución → LOVE14_2.0_2WEEK_PLAN.md
- Métricas → LOVE14_2.0_METRICAS.md

**Buena suerte. Vas a necesitarla. 🚀**
