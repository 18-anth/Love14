# 🎨 LOVE14 2.0 - DISEÑO UX/UI & ARQUITECTURA

---

## REDISEÑO DE FLUJOS CRÍTICOS

### 1. AUTH & ONBOARDING (Optimizado para Conversión)

```
PANTALLA 1: Splash
┌─────────────────────────────────────────┐
│                                         │
│      🌹 (Animación Lottie)            │
│                                         │
│  "Sorprende a tu pareja"               │
│                                         │
│  [COMENZAR]                            │
│                                         │
└─────────────────────────────────────────┘

PANTALLA 2: Sign Up (One-step)
┌─────────────────────────────────────────┐
│  ¡Hola! ¿Eres una pareja?               │
│                                         │
│  📧 Tu email                            │
│  [________________]                     │
│                                         │
│  📧 Email de tu pareja                  │
│  [________________]                     │
│                                         │
│  ☑️ Somos una pareja (guardamos privado) │
│                                         │
│  [SIGUIENTE] (Verificar ambos emails)   │
│                                         │
│  ¿Ya tienes cuenta? [Iniciar sesión]    │
│                                         │
└─────────────────────────────────────────┘

PANTALLA 3: Welcome Video (30s)
┌─────────────────────────────────────────┐
│  [▶ Video Playing...]                   │
│                                         │
│  "En 60 segundos crea un regalo        │
│   que hará llorar a tu pareja"         │
│                                         │
│  [Saltear] [Ver completo]               │
│                                         │
│  [SIGUIENTE]                            │
│                                         │
└─────────────────────────────────────────┘

PANTALLA 4: First Gift Creation
┌─────────────────────────────────────────┐
│  Elige tu primer regalo                 │
│                                         │
│  ┌─────────────────────────────────┐    │
│  │ 🌹 Poema de Amor               │    │
│  │ "Te amo más cada día..."       │    │
│  └─────────────────────────────────┘    │
│                                         │
│  ┌─────────────────────────────────┐    │
│  │ 😊 Poema Divertido             │    │
│  │ "Eres mi persona favorita..."  │    │
│  └─────────────────────────────────┘    │
│                                         │
│  ┌─────────────────────────────────┐    │
│  │ 💭 Reflexión Profunda           │    │
│  │ "Nuestro viaje juntos..."      │    │
│  └─────────────────────────────────┘    │
│                                         │
│  [CREAR REGALO]                         │
│                                         │
└─────────────────────────────────────────┘

PANTALLA 5: Personalization
┌─────────────────────────────────────────┐
│  Personaliza el regalo                  │
│                                         │
│  👫 Nombre de la pareja                 │
│  [Juan & María]                         │
│                                         │
│  💭 Agregar mensaje (opcional)          │
│  [Escribir aquí...]                    │
│  (200/500 caracteres)                   │
│                                         │
│  🎵 Elige la música                     │
│  ○ Romántica     ● Energética           │
│  ○ Tranquila                            │
│                                         │
│  [Preview] [SIGUIENTE]                  │
│                                         │
└─────────────────────────────────────────┘

PANTALLA 6: Preview
┌─────────────────────────────────────────┐
│  Así lo recibirá tu pareja              │
│                                         │
│  [Animation Playing...]                 │
│                                         │
│  "Juan & María"                         │
│  "Te amo"                               │
│                                         │
│  [🔊 Reproducir música]                 │
│                                         │
│  ¿Te gusta?                             │
│  [Editar] [COMPRAR]                     │
│                                         │
└─────────────────────────────────────────┘

PANTALLA 7: Checkout
┌─────────────────────────────────────────┐
│  Regalo Completo: $4.99                 │
│                                         │
│  ✅ Poema personalizado                 │
│  ✅ Animación profesional               │
│  ✅ Música romántica                    │
│  ✅ Válido 7 días                       │
│                                         │
│  💳 Pagar con:                          │
│  [Apple Pay] [Google Pay] [Tarjeta]     │
│                                         │
│  30 días: Dinero de vuelta              │
│                                         │
│  [COMPRAR SEGURO]                       │
│                                         │
└─────────────────────────────────────────┘

PANTALLA 8: Success
┌─────────────────────────────────────────┐
│                                         │
│         🎉 ¡ENVIADO! 🎉               │
│                                         │
│  Tu pareja recibirá un email en        │
│  5 minutos. Notaremos su reacción ❤️   │
│                                         │
│  [Ver mi regalo]                        │
│  [Compartir con amigos]                 │
│                                         │
│  (Auto-redirect a home en 3s)           │
│                                         │
└─────────────────────────────────────────┘

TOTAL ONBOARDING: 120 segundos
DROPOFF TARGET: <20%
CONVERSION: >80% de usuarios creando primer regalo
```

### 2. HOME SCREEN (Diseño para Retención)

```
TAB 1: INICIO
┌─────────────────────────────────────────┐
│ Love14                                  │
│ ────────────────────────────────────────│
│                                         │
│        🌹 + CREAR REGALO 💝            │
│                                         │
│  ────────────────────────────────────── │
│                                         │
│  PRÓXIMAS OCASIONES:                   │
│                                         │
│  💕 Aniversario: 14 de agosto          │
│     45 días para algo épico            │
│                                         │
│  🎂 Cumpleaños: 3 de julio             │
│     23 días para sorprenderlo          │
│                                         │
│  💐 San Valentín: 14 de febrero        │
│     -25% (OFERTA ESPECIAL)             │
│                                         │
│  ────────────────────────────────────── │
│                                         │
│  INSPIRACIÓN DEL DÍA:                  │
│                                         │
│  [Thumbnail] "Simplemente te amo"      │
│  [Thumbnail] "Nos mudamos juntos"      │
│  [Thumbnail] "5 años contigo"          │
│                                         │
│  [Ver más]                              │
│                                         │
└─────────────────────────────────────────┘

TAB 2: MIS REGALOS
┌─────────────────────────────────────────┐
│ MIS REGALOS                             │
│ ────────────────────────────────────────│
│                                         │
│  ENVIADOS:                              │
│  ┌─────────────────────────────────┐   │
│  │ 🌹 Rosa                         │   │
│  │ Enviado a María • 2 días ago    │   │
│  │ ✅ Visto • 5 emojis reacción   │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ 💭 Reflexión                   │   │
│  │ Enviado a María • 1 sem ago     │   │
│  │ ⏱️ Sin ver aún                  │   │
│  └─────────────────────────────────┘   │
│                                         │
│  RECIBIDOS:                             │
│  ┌─────────────────────────────────┐   │
│  │ 💌 Poema de amor               │   │
│  │ De María • Hace 3 días         │   │
│  │ ❤️ Lo amo                       │   │
│  │ [Responder con regalo]          │   │
│  └─────────────────────────────────┘   │
│                                         │
└─────────────────────────────────────────┘

TAB 3: PERFIL
┌─────────────────────────────────────────┐
│ PERFIL                                  │
│ ────────────────────────────────────────│
│                                         │
│  👤 Juan                                │
│  📧 juan@example.com                    │
│                                         │
│  ────────────────────────────────────── │
│                                         │
│  ESTADÍSTICAS:                          │
│  • Regalos enviados: 5                  │
│  • Regalos recibidos: 8                 │
│  • Dinero invertido: $24.95             │
│  • Reacciones: 45 ❤️ 12 😭              │
│                                         │
│  ────────────────────────────────────── │
│                                         │
│  PREFERENCIAS:                          │
│  • Música: Romántica                    │
│  • Color: Rojo                          │
│  • Notificaciones: Sí                   │
│                                         │
│  ────────────────────────────────────── │
│                                         │
│  [Mi código referral: LOVE_AB12]        │
│  [Copiar & Compartir]                   │
│                                         │
│  [Cerrar sesión]                        │
│                                         │
└─────────────────────────────────────────┘
```

---

## COLOR PALETTE & BRANDING

```
PRIMARY COLORS:
├── Rose Red: #E31B48 (Primary CTA)
├── Soft Pink: #FFB3D9 (Background)
├── Deep Purple: #6B1B47 (Typography)
└── Gold Accent: #FFD700 (Premium indicator)

SECONDARY:
├── Light Gray: #F5F5F5 (Backgrounds)
├── Dark Gray: #333333 (Text)
├── Success Green: #4CAF50 (Confirmations)
└── Error Red: #D32F2F (Errors)

TYPOGRAPHY:
├── Headers: Poppins Bold (24px)
├── Body: Inter Regular (16px)
├── Caption: Inter Light (12px)

ANIMATIONS:
├── Rose entrance: 400ms ease-out
├── Confetti: 2s explode + fade
├── Smooth transitions: 200ms ease-in-out
```

---

## COMPONENTES REUTILIZABLES

### Button Components

```dart
// Primary CTA (Comprar)
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFFE31B48),
    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  onPressed: () => navigateToCheckout(),
  child: Text('COMPRAR AHORA', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
)

// Secondary (Editar)
OutlinedButton(
  onPressed: () => navigateToEdit(),
  child: Text('EDITAR'),
)

// Premium Badge
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFFFA500)]),
    borderRadius: BorderRadius.circular(8),
  ),
  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  child: Text('PREMIUM', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
)
```

### Card Components

```dart
// Gift Card
Card(
  child: Column(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        child: GiftAnimation(giftId: giftId),
      ),
      Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(giftTitle, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(giftDescription, style: TextStyle(color: Colors.grey, fontSize: 12)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('\$${giftPrice}', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE31B48))),
                EmojiRow(reactions: giftReactions),
              ],
            ),
          ],
        ),
      ),
    ],
  ),
)
```

---

## ARQUITECTURA DE CARPETAS (FLUTTER)

```
love14/
├── lib/
│   ├── main.dart
│   ├── config/
│   │   ├── firebase_config.dart
│   │   ├── stripe_config.dart
│   │   └── constants.dart
│   │
│   ├── models/
│   │   ├── gift_model.dart
│   │   ├── couple_model.dart
│   │   ├── user_model.dart
│   │   └── payment_model.dart
│   │
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   ├── gift_provider.dart
│   │   ├── payment_provider.dart
│   │   └── referral_provider.dart
│   │
│   ├── services/
│   │   ├── firebase_service.dart
│   │   ├── stripe_service.dart
│   │   ├── email_service.dart
│   │   ├── analytics_service.dart
│   │   └── notification_service.dart
│   │
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   ├── signup_screen.dart
│   │   │   └── onboarding_screen.dart
│   │   │
│   │   ├── gift/
│   │   │   ├── gift_creation_screen.dart
│   │   │   ├── gift_preview_screen.dart
│   │   │   ├── gift_history_screen.dart
│   │   │   └── gift_checkout_screen.dart
│   │   │
│   │   ├── home/
│   │   │   ├── home_screen.dart
│   │   │   ├── profile_screen.dart
│   │   │   └── settings_screen.dart
│   │   │
│   │   └── admin/
│   │       ├── dashboard_screen.dart
│   │       └── analytics_screen.dart
│   │
│   ├── widgets/
│   │   ├── custom_button.dart
│   │   ├── gift_card.dart
│   │   ├── gift_animation.dart
│   │   ├── price_selector.dart
│   │   └── loading_indicator.dart
│   │
│   ├── utils/
│   │   ├── app_colors.dart
│   │   ├── app_styles.dart
│   │   ├── validators.dart
│   │   ├── formatters.dart
│   │   └── helpers.dart
│   │
│   └── router/
│       └── app_router.dart
│
├── assets/
│   ├── animations/
│   │   ├── rose.json
│   │   ├── confetti.json
│   │   └── loading.json
│   │
│   ├── images/
│   │   ├── logo.png
│   │   ├── placeholder.png
│   │   └── icons/
│   │
│   ├── music/
│   │   ├── romantic.mp3
│   │   ├── energetic.mp3
│   │   └── peaceful.mp3
│   │
│   └── templates/
│       ├── poem_1.txt
│       ├── poem_2.txt
│       └── ...
│
├── pubspec.yaml
└── analysis_options.yaml
```

---

## IMPLEMENTACIÓN DE VIRAL MECHANICS

### Gift Sharing Flow

```dart
// Cuando usuario envía regalo
void shareGiftViaWhatsApp(Gift gift) {
  final referralCode = _generateReferralCode(currentUser.id);
  final giftLink = 'https://love14.app/gift/${gift.id}?ref=$referralCode';
  
  final message = '''
🎁 ${currentUser.name} te envió un regalo especial en Love14

${gift.title}

${gift.description}

🎵 Incluye música romántica y personalización especial

👇 Míralo aquí:
$giftLink

¿Tienes pareja? Sorprende con Love14
  ''';
  
  SharePlus.share(
    text: message,
    subject: 'Un regalo especial de ${currentUser.name}',
  );
  
  // Track referral
  _analytics.trackReferralShare(referralCode, 'whatsapp');
}

// Cuando receptor ve regalo
void onGiftViewed(String giftId, String viewerId) {
  // Marcar como visto
  _firestore.updateGiftViewCount(giftId);
  
  // Trigger notificación al enviador
  _notifications.notifyGiftViewed(gift.senderId, giftId);
  
  // Sugerir reciprocal gift (después de 5s)
  Future.delayed(Duration(seconds: 5), () {
    _showReciprocalGiftSuggestion(viewerId, gift.senderId);
  });
}

// Sugerencia de regalo reciproco
void _showReciprocalGiftSuggestion(String viewerId, String senderIdOriginal) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('¿Quieres sorprenderlo de vuelta?'),
      content: Text('${giftData['senderName']} te acaba de sorprender.\n¿Creas un regalo para él/ella?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('Ahora no')),
        ElevatedButton(
          onPressed: () => navigateToGiftCreation(recipientId: senderIdOriginal),
          child: Text('SÍ, CREAR REGALO'),
        ),
      ],
    ),
  );
}
```

### Referral System Implementation

```dart
class ReferralService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Generar código referral único
  String generateReferralCode(String userId) {
    final code = 'LOVE_${userId.substring(0, 6).toUpperCase()}';
    return code;
  }
  
  // Rastrear referral cuando se comparte
  Future<void> trackReferralShare(String referrerId, String channel) async {
    await _firestore.collection('referrals').add({
      'referrerId': referrerId,
      'channel': channel, // whatsapp, twitter, email, etc.
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'pending',
    });
  }
  
  // Completar referral cuando nuevousuario compra
  Future<void> completeReferral(String referralCode, String newUserId) async {
    final referralDocs = await _firestore
        .collection('referrals')
        .where('code', isEqualTo: referralCode)
        .get();
    
    if (referralDocs.docs.isNotEmpty) {
      final referralId = referralDocs.docs.first.id;
      final referrerId = referralDocs.docs.first['referrerId'];
      
      // Agregar crédito al referrer
      await _firestore.collection('users').doc(referrerId).update({
        'referralCredits': FieldValue.increment(2.0),
      });
      
      // Marcar referral como completado
      await _firestore.collection('referrals').doc(referralId).update({
        'status': 'completed',
        'newUserId': newUserId,
        'completedAt': FieldValue.serverTimestamp(),
      });
    }
  }
}
```

---

## ENDPOINTS API (Backend - Node.js/Firebase Functions)

```javascript
// Firebase Cloud Functions

// 1. Create Gift
exports.createGift = functions.https.onCall(async (data, context) => {
  const { coupleId, senderId, templateId, personalization, payment } = data;
  
  // Validate payment with Stripe
  const paymentIntent = await stripe.paymentIntents.create({
    amount: payment.amount * 100,
    currency: 'usd',
    payment_method: payment.methodId,
    confirm: true,
  });
  
  if (paymentIntent.status !== 'succeeded') {
    throw new functions.https.HttpsError('payment-failed', 'Payment processing failed');
  }
  
  // Create gift document
  const giftRef = await admin.firestore().collection('gifts').add({
    coupleId,
    senderId,
    templateId,
    personalData: personalization,
    payment: {
      amount: payment.amount,
      stripeId: paymentIntent.id,
      status: 'succeeded',
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    },
    status: 'sent',
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000),
  });
  
  // Send email to recipient
  await sendGiftEmail(giftRef.id, coupleId);
  
  // Track analytics
  await admin.firestore().collection('analytics').add({
    event: 'gift_purchased',
    userId: senderId,
    amount: payment.amount,
    timestamp: admin.firestore.FieldValue.serverTimestamp(),
  });
  
  return { giftId: giftRef.id, success: true };
});

// 2. Send Gift Email
async function sendGiftEmail(giftId, coupleId) {
  const giftData = await admin.firestore().collection('gifts').doc(giftId).get();
  const coupleData = await admin.firestore().collection('couples').doc(coupleId).get();
  
  const deepLink = `https://love14.app/gift/${giftId}`;
  
  const emailContent = `
    <h1>¡Tienes un regalo especial! 🎁</h1>
    <p>${giftData.data().personalData.senderName} te ha enviado un regalo romántico en Love14.</p>
    <a href="${deepLink}" style="background: #E31B48; color: white; padding: 12px 24px; border-radius: 6px; text-decoration: none;">
      Ver mi regalo
    </a>
    <p>O abre Love14 en tu dispositivo</p>
  `;
  
  await admin.firestore().collection('emails').add({
    to: coupleData.data().userB_email,
    subject: `${giftData.data().personalData.senderName} te envió un regalo especial 💝`,
    html: emailContent,
    status: 'pending',
  });
}

// 3. Track Gift View
exports.trackGiftView = functions.https.onCall(async (data, context) => {
  const { giftId } = data;
  
  await admin.firestore().collection('gifts').doc(giftId).update({
    viewCount: admin.firestore.FieldValue.increment(1),
    lastViewedAt: admin.firestore.FieldValue.serverTimestamp(),
  });
  
  // Notify sender
  const giftData = await admin.firestore().collection('gifts').doc(giftId).get();
  
  await sendNotification(giftData.data().senderId, {
    title: '¡Tu regalo fue visto! ❤️',
    body: 'Tu pareja vio el regalo que enviaste',
    deepLink: `love14://gift/${giftId}`,
  });
  
  return { success: true };
});

// 4. Process Referral
exports.processReferral = functions.https.onCall(async (data, context) => {
  const { referralCode, newUserId } = data;
  
  const referrals = await admin.firestore()
    .collection('referrals')
    .where('code', '==', referralCode)
    .limit(1)
    .get();
  
  if (referrals.empty) {
    throw new functions.https.HttpsError('not-found', 'Referral code not found');
  }
  
  const referrerId = referrals.docs[0].data().referrerId;
  
  // Add credit to referrer
  await admin.firestore().collection('users').doc(referrerId).update({
    referralCredits: admin.firestore.FieldValue.increment(2.0),
  });
  
  // Mark as completed
  await admin.firestore().collection('referrals').doc(referrals.docs[0].id).update({
    status: 'completed',
    completedUserId: newUserId,
    completedAt: admin.firestore.FieldValue.serverTimestamp(),
  });
  
  return { success: true, creditAdded: 2.0 };
});
```

---

## MÉTRICAS Y ANALYTICS

```dart
class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  
  // Track gift creation
  void trackGiftCreated(String templateId, double amount) {
    _analytics.logEvent(
      name: 'gift_created',
      parameters: {
        'template_id': templateId,
        'amount': amount,
        'timestamp': DateTime.now().toString(),
      },
    );
  }
  
  // Track payment completion
  void trackPayment(double amount, String status) {
    _analytics.logEvent(
      name: 'payment_completed',
      parameters: {
        'amount': amount,
        'status': status,
        'currency': 'USD',
      },
    );
  }
  
  // Track referral
  void trackReferral(String referralCode, String newUserId) {
    _analytics.logEvent(
      name: 'referral_completed',
      parameters: {
        'referral_code': referralCode,
        'new_user_id': newUserId,
      },
    );
  }
  
  // Cohort analysis
  void trackRetention(String userId, int daysActive) {
    _analytics.logEvent(
      name: 'retention_check',
      parameters: {
        'user_id': userId,
        'days_active': daysActive,
      },
    );
  }
}
```

---

Esta es la arquitectura completa lista para desarrollo.
