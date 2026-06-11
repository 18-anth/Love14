// ARCHIVO DE CONFIGURACIÓN Y SETUP

import 'package:love14/services/surprise_service.dart';
import 'package:love14/models/freemium_model.dart';

/// Configuración e Inicialización del Sistema Surprises
class SurprisesConfig {
  // Configuración de precios
  static const Map<String, double> PRICING = {
    'monthly': 9.99,
    'quarterly': 24.99,
    'yearly': 79.99,
  };

  // Descuentos
  static const Map<String, String> DISCOUNTS = {
    'quarterly': '17%',
    'yearly': '34%',
  };

  // Límites del plan gratis
  static const int FREE_PLAN_SURPRISE_LIMIT = 1;
  static const int FREE_PLAN_FLOWER_LIMIT = 1;
  static const int FREE_PLAN_PHOTOS_LIMIT = 0;
  static const int FREE_PLAN_VIDEO_LIMIT = 0;

  // Límites del plan premium
  static const int PREMIUM_PLAN_SURPRISE_LIMIT = 999;
  static const int PREMIUM_PLAN_FLOWER_LIMIT = 999;
  static const int PREMIUM_PLAN_PHOTOS_LIMIT = 50;
  static const int PREMIUM_PLAN_VIDEO_LIMIT = 5;

  // Duración de expiración de sorpresa (en días)
  static const int SURPRISE_DEFAULT_EXPIRATION = 365;

  // Límites de tamaño de archivo
  static const int MAX_PHOTO_SIZE = 10 * 1024 * 1024; // 10 MB
  static const int MAX_VIDEO_SIZE = 100 * 1024 * 1024; // 100 MB
  static const int MAX_MUSIC_SIZE = 50 * 1024 * 1024; // 50 MB

  /// Inicializar sistema Surprises
  /// Llamar una sola vez al iniciar la app
  static Future<void> initialize() async {
    try {
      // Inicializar servicio de sorpresas
      SurpriseService().initialize();

      print('[SurprisesConfig] Sistema Surprises inicializado exitosamente');
    } catch (e) {
      print('[SurprisesConfig] Error al inicializar: $e');
      rethrow;
    }
  }

  /// Crear plan gratis por defecto para usuario nuevo
  static FreemiumPlan getDefaultFreePlan() {
    return FreemiumPlan.createFreePlan();
  }

  /// Crear plan premium
  static FreemiumPlan getDefaultPremiumPlan() {
    return FreemiumPlan.createPremiumPlan();
  }

  /// Obtener configuración de precios para UI
  static Map<String, dynamic> getPricingConfig() {
    return {
      'monthly': {
        'name': 'Plan Mensual',
        'price': PRICING['monthly'],
        'currency': 'USD',
        'billingCycle': '1 mes',
        'features': [
          'Sorpresas ilimitadas',
          'Múltiples flores',
          'Fotos y videos',
          'Música personalizada',
          'Cartas con IA',
          'QR personalizado',
        ],
      },
      'quarterly': {
        'name': 'Plan Trimestral',
        'price': PRICING['quarterly'],
        'currency': 'USD',
        'billingCycle': '3 meses',
        'discount': DISCOUNTS['quarterly'],
        'features': [
          'Todo del plan mensual',
          'Analytics avanzados',
          '15% de descuento',
        ],
      },
      'yearly': {
        'name': 'Plan Anual',
        'price': PRICING['yearly'],
        'currency': 'USD',
        'billingCycle': '12 meses',
        'discount': DISCOUNTS['yearly'],
        'features': [
          'Todo del plan trimestral',
          'Soporte prioritario',
          '34% de descuento',
          'Mejor valor',
        ],
      },
    };
  }

  /// Validar tamaño de archivo
  static bool isFileSizeValid(int fileSize, String fileType) {
    switch (fileType.toLowerCase()) {
      case 'photo':
        return fileSize <= MAX_PHOTO_SIZE;
      case 'video':
        return fileSize <= MAX_VIDEO_SIZE;
      case 'music':
        return fileSize <= MAX_MUSIC_SIZE;
      default:
        return false;
    }
  }

  /// Obtener mensaje de error para tamaño de archivo
  static String getFileSizeError(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'photo':
        return 'La foto no debe exceder 10 MB';
      case 'video':
        return 'El video no debe exceder 100 MB';
      case 'music':
        return 'La música no debe exceder 50 MB';
      default:
        return 'Archivo muy grande';
    }
  }
}

/// Estructura de datos esperada en Firebase
/// Usar como referencia para validar

class FirebaseDataStructure {
  /// Documento de Surprise en la colección 'surprises'
  static Map<String, dynamic> surpriseTemplate() {
    return {
      'surpriseId': 'string - uuid generado por app',
      'creatorId': 'string - uid del usuario creador',
      'recipientName': 'string - nombre de quien recibe',
      'creatorName': 'string - nombre de quien envía',
      'title': 'string - título de la sorpresa',
      'description': 'string - descripción',
      'customMessage': 'string (opcional) - mensaje personalizado',
      'flower': {
        'type': 'string - tipo de flor (rosa, girasol, etc)',
        'color': 'string (opcional)',
        'quantity': 'number - cantidad (default 1)',
        'addedAt': 'string ISO 8601',
      },
      'photoUrls': 'array de strings (optional)',
      'videoUrl': 'string (optional) - URL en Storage',
      'musicUrl': 'string (optional) - URL en Storage',
      'aiLetter': 'string (optional) - carta generada',
      'specialDate': 'string ISO 8601 - fecha especial',
      'publicUrl': 'string - URL pública',
      'qrCode': 'string - QR codificado en base64',
      'status': 'string - draft|published|viewed|archived',
      'createdAt': 'string ISO 8601',
      'viewedAt': 'string ISO 8601 (optional)',
      'expiresAt': 'string ISO 8601 (optional)',
      'analytics': {
        'views': 'number - cantidad de vistas',
        'shares': 'number - cantidad de comparticiones',
      },
      'premium': 'number - 0 para free, 1 para premium',
    };
  }

  /// Documento de Plan de Usuario en 'user_plans'
  static Map<String, dynamic> userPlanTemplate() {
    return {
      'plan': 'string - free|premium',
      'createdAt': 'string ISO 8601',
      'upgradeDate': 'string ISO 8601 (optional)',
      'expiresAt': 'string ISO 8601 (optional)',
      'surprisesCreated': 'number - contador',
      'surprisesLimit': 'number - límite según plan',
      'features': 'array de strings - features habilitadas',
      'monthlyPrice': 'number - precio (opcional)',
    };
  }
}

/// Constantes de Flores
class FlowerConstants {
  static const List<String> FLOWER_TYPES = [
    'rosa',
    'girasol',
    'tulipan',
    'margarita',
    'clavel',
    'lirio',
    'orquidea',
    'amapola',
    'loto',
    'sakura',
  ];

  static const Map<String, String> FLOWER_COLORS = {
    'rosa': 'rojo,rosa,blanco',
    'girasol': 'amarillo,naranja',
    'tulipan': 'rojo,amarillo,rosa,morado',
    'margarita': 'blanco,amarillo',
    'clavel': 'rojo,rosa,blanco',
    'lirio': 'blanco,rosa,morado',
    'orquidea': 'morado,blanco,rosa',
    'amapola': 'rojo,naranja',
    'loto': 'rosa,blanco',
    'sakura': 'rosa,blanco',
  };
}

/// Constantes de Planes
class PlanConstants {
  static const String PLAN_FREE = 'free';
  static const String PLAN_PREMIUM = 'premium';

  static const List<String> PLAN_FEATURES_PREMIUM = [
    'multipleFlowers',
    'customMusic',
    'photos',
    'videos',
    'aiLetter',
    'customQR',
    'analytics',
    'customExpiration',
    'teamAccess',
  ];

  static const List<String> PLAN_FEATURES_FREE = [];
}

/// Analytics para Conversión
class AnalyticsConstants {
  // Eventos para rastrear conversión
  static const String EVENT_SURPRISE_CREATED = 'surprise_created';
  static const String EVENT_SURPRISE_PUBLISHED = 'surprise_published';
  static const String EVENT_SURPRISE_SHARED = 'surprise_shared';
  static const String EVENT_SURPRISE_VIEWED = 'surprise_viewed';
  static const String EVENT_PREMIUM_VIEWED = 'premium_screen_viewed';
  static const String EVENT_PREMIUM_PURCHASED = 'premium_purchased';
  static const String EVENT_PREMIUM_TRIAL_STARTED = 'premium_trial_started';

  // Propiedades personalizadas
  static const String PROP_USER_PLAN = 'user_plan';
  static const String PROP_SURPRISE_TYPE = 'surprise_type';
  static const String PROP_MEDIA_COUNT = 'media_count';
}

/// URLs y Endpoints (TODO)
class ApiConstants {
  static const String BASE_URL = 'https://api.love14.app/v1';
  static const String SURPRISE_ENDPOINT = '/surprises';
  static const String PLANS_ENDPOINT = '/plans';
  static const String PAYMENTS_ENDPOINT = '/payments';
  static const String AI_ENDPOINT = '/ai/generate';

  // Webhook de pagos
  static const String WEBHOOK_PAYMENT = '/webhooks/payment';
  static const String WEBHOOK_SUBSCRIPTION = '/webhooks/subscription';
}

/// Mensajes de Error Personalizados
class ErrorMessages {
  static const String SURPRISE_NOT_FOUND = 'Sorpresa no encontrada';
  static const String USER_NOT_AUTHENTICATED = 'Usuario no autenticado';
  static const String FREE_PLAN_LIMIT_REACHED =
      'Alcanzaste el límite de sorpresas en tu plan gratis';
  static const String FEATURE_PREMIUM_ONLY = 'Esta característica solo está disponible en Premium';
  static const String FILE_TOO_LARGE = 'Archivo demasiado grande';
  static const String INVALID_SURPRISE_DATA = 'Datos de sorpresa inválidos';
  static const String PAYMENT_FAILED = 'Error al procesar el pago';
  static const String AI_GENERATION_FAILED = 'Error al generar contenido IA';
  static const String UPLOAD_FAILED = 'Error al cargar archivo';
}

/// Mensajes de Éxito Personalizados
class SuccessMessages {
  static const String SURPRISE_CREATED = 'Sorpresa creada exitosamente';
  static const String SURPRISE_PUBLISHED = '¡Sorpresa publicada! Comparte el enlace';
  static const String SURPRISE_UPDATED = 'Sorpresa actualizada';
  static const String SURPRISE_DELETED = 'Sorpresa eliminada';
  static const String UPGRADED_TO_PREMIUM = '¡Bienvenido a Premium!';
  static const String FILE_UPLOADED = 'Archivo cargado exitosamente';
  static const String LETTER_GENERATED = 'Carta generada con éxito';
}

/// Setup para desarrollo local
class DevelopmentConfig {
  // Variables de desarrollo
  static const bool DEBUG_MODE = true;
  static const bool LOG_FIREBASE_CALLS = true;
  static const bool MOCK_AI_RESPONSES = false; // True para testing sin API IA

  /// Mock letter para testing
  static String getMockAILetter() {
    return '''
Mi amor,

En cada momento contigo, descubro nuevas razones para amarte. 
Tu sonrisa ilumina mis días más grises, y tu presencia 
transforma lo ordinario en lo extraordinario.

Eres mi ancla en la tormenta, mi luz en la oscuridad,
mi razón para creer en los milagros.

Esta sorpresa es un pequeño reflejo del amor infinito 
que siento por ti. Eres mi para siempre.

Con amor infinito,
Tu amor
    ''';
  }
}
