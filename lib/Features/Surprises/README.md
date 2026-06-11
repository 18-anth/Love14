# Sistema Surprises - Documentación Completa

## Descripción General

El sistema Surprises es una plataforma para crear, compartir y visualizar experiencias románticas personalizadas con arquitectura empresarial, gestión de estado con Provider, y monetización mediante modelo Freemium.

## Arquitectura

```bash
Features/Surprises/
├── Domain/
│   └── models/
│       ├── surprise_model.dart       # Modelo principal de sorpresa
│       ├── flower_model.dart         # Tipos de flores
│       └── freemium_model.dart       # Sistema de suscripción
├── Data/
│   └── repositories/                 # Capa de datos
├── Services/
│   ├── surprise_service.dart         # Lógica de negocio
│   ├── ai_service.dart               # Integración con IA
│   └── payment_service.dart          # Procesamiento de pagos
├── Providers/
│   └── surprise_provider.dart        # State management (Provider)
├── Presentation/
│   ├── create_surprise_screen.dart   # Creación de sorpresa
│   ├── my_prises_screen.dart         # Mis sorpresas
│   ├── surprise_view_screen.dart     # Visualización
│   └── premium_plans_screen.dart     # Planes Premium
├── Widgets/
│   ├── flower_widgets.dart           # Widgets de flores
│   ├── premium_widgets.dart          # Widgets premium
│   └── surprise_widgets.dart         # Widgets generales
└── surprise_routes.dart              # Navegación
```

## Flujo Completo

### 1. Creación de Sorpresa (Formulario de 5 Pasos)

```dart
CreateSurpriseScreen(userId: userId)
```

**Pasos:**

1. **Información básica** - Nombres, título, descripción, fecha
2. **Selección de flor** - Elegir flor principal
3. **Multimedia** - Fotos, videos, música (solo Premium)
4. **Carta** - Generar con IA (solo Premium)
5. **Publicar** - Confirmar y publicar

**Ejemplo de uso:**

```dart
SurpriseNavigator.goToCreate(context, currentUserId);
```

### 2. Gestión de Estado (Provider)

```dart
// Inicializar para usuario
context.read<SurpriseProvider>().initializeForUser(userId);

// Crear sorpresa
provider.startNewSurprise(
  creatorId: userId,
  recipientName: 'María',
  creatorName: 'Juan',
  title: 'Sorpresa especial',
  description: 'Una sorpresa romántica',
  flower: Flower(type: FlowerType.rosa),
  specialDate: DateTime.now(),
);

// Agregar multimedia
await provider.addPhotos([imagePath1, imagePath2]);
await provider.addVideo(videoPath);
await provider.addMusic(musicPath);

// Generar carta IA
await provider.generateAILetter(occasion: 'Aniversario');

// Publicar
await provider.publishSurprise();
```

### 3. Visualización de Sorpresa

**Pública (cualquiera):**

```dart
SurpriseNavigator.goToView(context, surpriseId, isPublicView: true);
```

**Privada (solo creador):**

```dart
SurpriseNavigator.goToView(context, surpriseId, isPublicView: false);
```

### 4. Sistema Freemium

**Plan Gratis:**

- 1 sorpresa
- 1 flor
- 1 poema
- URL pública

**Plan Premium ($9.99/mes):**

- Sorpresas ilimitadas
- Múltiples flores
- Fotos y videos
- Música personalizada
- Cartas IA
- QR personalizado
- Analytics avanzados

```dart
// Verificar si es premium
provider.isPremium // bool

// Upgradar a premium
await provider.upgradeToPremium(userId);

// Verificar si tiene característica
provider.userPlan?.hasFeature(PlanFeature.customMusic);

// Listar planes
PaymentService().getPricingPlans();
```

## Firebase Configuration

### Collections

#### `surprises`

```dart
{
  'creatorId': 'uid_user_1',
  'recipientName': 'María',
  'creatorName': 'Juan',
  'title': 'Sorpresa especial',
  'description': 'Descripción...',
  'flower': {
    'type': 'rosa',
    'color': 'rojo',
    'quantity': 1,
    'addedAt': '2024-01-01T00:00:00Z'
  },
  'photoUrls': ['url1', 'url2'],
  'videoUrl': 'video_url',
  'musicUrl': 'music_url',
  'aiLetter': 'Carta generada por IA...',
  'specialDate': '2024-02-14T00:00:00Z',
  'publicUrl': 'https://love14.app/surprise/uuid',
  'qrCode': 'base64_encoded_qr',
  'status': 'published', // draft, published, viewed, archived
  'createdAt': '2024-01-01T00:00:00Z',
  'viewedAt': '2024-01-02T00:00:00Z',
  'expiresAt': null,
  'analytics': {
    'views': 10,
    'shares': 2
  },
  'premium': 1 // 1 = premium, 0 = free
}
```

#### `user_plans`

```dart
{
  'plan': 'premium', // free, premium
  'createdAt': '2024-01-01T00:00:00Z',
  'upgradeDate': '2024-01-01T00:00:00Z',
  'expiresAt': '2025-01-01T00:00:00Z',
  'surprisesCreated': 5,
  'surprisesLimit': 999,
  'features': ['multipleFlowers', 'customMusic', 'photos', 'videos', 'aiLetter'],
  'monthlyPrice': 9.99
}
```

### Reglas de Seguridad

Ver `firebase_rules.json`:

- Solo creador puede escribir sorpresa
- Sorpresas publicadas son públicas
- Cada usuario solo puede leer su plan
- Validaciones strict de datos

### Firebase Storage

```bash
storage/
└── surprises/
    └── {surpriseId}/
        ├── photo_0.jpg
        ├── photo_1.jpg
        ├── video.mp4
        └── music.mp3
```

## Servicios

### SurpriseService

```dart
final service = SurpriseService();

// CRUD
await service.createSurprise(...);
final surprise = await service.getSurprise(id);
final surprises = await service.getUserSurprises(userId);
await service.updateSurprise(id, data);
await service.publishSurprise(id);
await service.deleteSurprise(id);

// Media
final url = await service.uploadPhoto(surpriseId, bytes, index);
final url = await service.uploadVideo(surpriseId, filePath);
final url = await service.uploadMusic(surpriseId, filePath);

// Freemium
final plan = await service.getUserPlan(userId);
final canCreate = await service.canCreateSurprise(userId);
await service.incrementSurpriseCount(userId);
final hasFeature = await service.hasFeature(userId, feature);

// Analytics
await service.markAsViewed(surpriseId);
await service.trackShare(surpriseId);
```

### AIService

```dart
final ai = AIService();

// Generar carta
final letter = await ai.generateRomanticLetter(
  creatorName: 'Juan',
  recipientName: 'María',
  occasion: 'Aniversario',
  customTheme: 'pasión',
);

// Generar poema
final poem = await ai.generatePoem(
  theme: 'love',
  style: 'modern',
);
```

### PaymentService

```dart
final payment = PaymentService();

// Procesar pago
final success = await payment.processPremiumUpgrade(
  userId: userId,
  paymentToken: stripeToken,
  months: 12,
);

// Obtener planes
final plans = payment.getPricingPlans();
```

## Widgets Reutilizables

### FlowerSelector

```dart
FlowerSelector(
  selectedFlower: flower,
  onFlowerSelected: (flower) {},
  enableMultiple: true,
)
```

### SurpriseCard

```dart
SurpriseCard(
  surprise: surprise,
  onTap: () {},
  onShare: () {},
  onDelete: () {},
)
```

### PricingCard

```dart
PricingCard(
  planName: 'Premium',
  price: 9.99,
  currency: 'USD',
  features: ['Feature 1', 'Feature 2'],
  onUpgrade: () {},
  isCurrentPlan: false,
)
```

## Navegación

```dart
// Crear sorpresa
SurpriseNavigator.goToCreate(context, userId);

// Ver mis sorpresas
SurpriseNavigator.goToMyPrises(context, userId);

// Ver sorpresa específica
SurpriseNavigator.goToView(context, surpriseId, isPublicView: true);

// Planes premium
SurpriseNavigator.goToPremium(context, userId);
```

## Setup Inicial

### 1. Firebase Setup

- Crear proyecto en Firebase Console
- Habilitar Authentication (Email/Password)
- Habilitar Firestore
- Habilitar Storage
- Configurar reglas de seguridad (ver firebase_rules.json)

### 2. Configuración del Proyecto

```dart
// En main.dart, inicializar servicios
SurpriseService().initialize();

// Inicializar provider cuando usuario autentique
context.read<SurpriseProvider>().initializeForUser(userId);
```

### 3. Integración de Pagos (TODO)

- Integrar Stripe SDK
- Implementar webhook de confirmación
- Actualizar `PaymentService` con lógica real

### 4. Integración IA (TODO)

- Agregar API key de Gemini en env.txt
- Actualizar `_getApiKey()` en AIService

## Ejemplo Completo

```dart
// 1. Iniciar app
void main() async {
  // ... setup Firebase ...
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SurpriseProvider()),
        // ... otros providers ...
      ],
      child: MyApp(),
    ),
  );
}

// 2. En pantalla, crear sorpresa
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.read<SurpriseProvider>();
    
    return ElevatedButton(
      onPressed: () {
        SurpriseNavigator.goToCreate(context, userId);
      },
      child: Text('Crear Sorpresa'),
    );
  }
}

// 3. Flujo completo en CreateSurpriseScreen
// - Paso 1: Datos básicos
// - Paso 2: Seleccionar flor
// - Paso 3: Agregar multimedia (Premium)
// - Paso 4: Generar carta IA (Premium)
// - Paso 5: Publicar y obtener URL

// 4. Ver sorpresa publicada
SurpriseNavigator.goToView(context, surpriseId);

// 5. Compartir URL pública
// https://love14.app/surprise/{surpriseId}
```

## Optimizaciones para Conversión

### 1. UX Freemium

- Mostrar banners de features limitadas
- Offer upgrade en puntos estratégicos
- Free trial de 7 días para Premium

### 2. Monetización

- Plan mensual: $9.99
- Plan trimestral: $24.99 (17% descuento)
- Plan anual: $79.99 (34% descuento)

### 3. Social

- Compartir con link público
- QR code personalizado
- Analytics de vistas y comparticiones

### 4. Retención

- Notificaciones cuando sorpresa es vista
- Sugerencias de nuevas sorpresas
- Integración con calendario (fechas especiales)

## Troubleshooting

### Firebase Rules Error

- Verificar que las reglas están correctamente cargadas
- Asegurarse que auth.uid está disponible
- Verificar permiso de lectura/escritura

### Media Upload Falló

- Verificar permisos en Firebase Storage
- Validar tamaño máximo de archivo
- Verificar conexión a internet

### AI Letter No Se Genera

- Verificar API key de Gemini
- Comprobar cuota de llamadas a API
- Revisar logs de error en console

## Próximas Mejoras

- [ ] Integración Stripe completa
- [ ] Webhooks de pago
- [ ] Análisis de conversión
- [ ] A/B testing de precios
- [ ] Email marketing
- [ ] Push notifications
- [ ] Recomendaciones personalizadas
- [ ] Video editing in-app
