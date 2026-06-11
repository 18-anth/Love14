# 🌼 Flores Amarillas (Love14)

Una aplicación Flutter romántica y multiplatforma que combina poesía, flores 3D interactivas y música para crear una experiencia única. Construida con Firebase para gestión de usuarios y bases de datos en tiempo real.

---

## 📋 Tabla de Contenidos

- [Características](#características)
- [Requisitos Previos](#requisitos-previos)
- [Instalación](#instalación)
- [Configuración](#configuración)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Dependencias](#dependencias)
- [Uso](#uso)
- [Arquitectura](#arquitectura)
- [Características Técnicas](#características-técnicas)
- [Plataformas Soportadas](#plataformas-soportadas)
- [Contribuciones](#contribuciones)

---

## ✨ Características

### 🎭 Sistema de Autenticación

- **Login y Registro** con Firebase Authentication
- **Recuperación de contraseña** vía correo electrónico
- **Roles de usuario**: Cliente y Administrador
- **Persistencia de sesión** con SharedPreferences

### 🌸 Contenido Romántico

- **Galería de Flores 3D Interactivas**
  - Diente de León (Dandelion)
  - Flor Amarilla (Yellow Flower)
  - Margarita (Daisy)
  - Rosa Amarilla (Yellow Rose)
  - Tulipán (Tulip)
- **Poemas Personalizados** con animaciones
- **Favoritos**: Guardar poemas y flores preferidas

### 🎵 Multimedia

- **Música de Fondo Automática** en la web
- **Reproducción de Video** integrada
- **Gestor de Imágenes** con soporte para subidas

### 🎨 Interfaz de Usuario

- **Temas Claro y Oscuro** personalizables
- **Diseño Responsivo** para todos los dispositivos
- **Animaciones Suaves** con Flutter Animate
- **Glassmorphism** para efectos visuales modernos
- **Navegación Intuitiva** con barra inferior

### 🔗 Conectividad

- **Soporte Offline** con pantalla de desconexión
- **Detección de Conectividad** en tiempo real
- **Sincronización Automática** cuando la conexión se restaura

### 👥 Funciones Administrativas

- **Panel de Control** para administradores
- **Gestión de Contenido**
- **Carga de Archivos** (imágenes, videos)

---

## 📦 Requisitos Previos

- **Flutter**: ^3.8.1
- **Dart**: 3.8.1 o superior
- **Git**: Para clonar el repositorio
- **Firebase Project**: Para configuración de Backend
- **Node.js**: Para algunas herramientas de desarrollo

### Requisitos por Plataforma

| Plataforma | Requisitos |
| ----------- | ----------- |
| **Android** | Android SDK 21+, Gradle |
| **iOS** | Xcode 12+, CocoaPods, iOS 11+ |
| **Web** | Chrome/Firefox (Dart SDK Web) |
| **Windows** | Visual Studio 2019+, CMake |
| **Linux** | GCC, CMake, GTK 3.0+ |
| **macOS** | Xcode, CocoaPods, macOS 10.11+ |

---

## 🚀 Instalación

### 1. Clonar el Repositorio

```bash
git clone https://github.com/18-anth/Love14.git
cd Love14
```

### 2. Instalar Dependencias de Flutter

```bash
flutter pub get
```

### 3. Configurar Variables de Entorno

Crea un archivo `assets/env.txt` con tus credenciales de Firebase:

```env
API_KEY=tu_api_key
AUTH_DOMAIN=tu_auth_domain
DATABASE_URL=tu_database_url
PROJECT_ID=tu_project_id
STORAGE_BUCKET=tu_storage_bucket
MESSAGING_SENDER_ID=tu_messaging_sender_id
APP_ID=tu_app_id
MEASUREMENT_ID=tu_measurement_id
AUDIO=tu_url_audio
```

### 4. Configurar Google Services (Android/iOS)

- Descarga `google-services.json` de Firebase Console
- Colócalo en `android/app/`
- También configura `GoogleService-Info.plist` para iOS en `ios/Runner/`

### 5. Ejecutar la Aplicación

**Web:**

```bash
flutter run -d chrome
```

**Android:**

```bash
flutter run
```

**iOS:**

```bash
flutter run -d ios
```

**Windows:**

```bash
flutter run -d windows
```

**Linux:**

```bash
flutter run -d linux
```

**macOS:**

```bash
flutter run -d macos
```

---

## 🔧 Configuración

### Firebase Setup

1. Crea un proyecto en [Firebase Console](https://console.firebase.google.com)
2. Habilita:
   - **Authentication** (Email/Password)
   - **Realtime Database**
   - **Cloud Storage**
   - **Hosting** (opcional, para web)

3. Configura las reglas de seguridad en Realtime Database:

```json
{
  "rules": {
    "Control": {
      "$uid": {
        ".read": "$uid === auth.uid",
        ".write": "$uid === auth.uid"
      }
    },
    "users": {
      "$uid": {
        ".read": "$uid === auth.uid",
        ".write": "$uid === auth.uid"
      }
    }
  }
}
```

### Variables de Entorno

Las variables se cargan desde `assets/env.txt` mediante la clase `EnvLoader`:

- **API_KEY**: Clave de API de Firebase
- **AUTH_DOMAIN**: Dominio de autenticación
- **DATABASE_URL**: URL de Realtime Database
- **PROJECT_ID**: ID del proyecto Firebase
- **STORAGE_BUCKET**: Bucket de almacenamiento
- **MESSAGING_SENDER_ID**: ID de Firebase Cloud Messaging
- **APP_ID**: ID de aplicación
- **MEASUREMENT_ID**: ID de Google Analytics
- **AUDIO**: URL de la música de fondo

---

## 📁 Estructura del Proyecto

```bash
lib/
├── main.dart                          # Punto de entrada principal
├── env_loader.dart                    # Cargador de variables de entorno
│
├── Config/                            # Pantallas de configuración
│   ├── LoginScreen.dart               # Pantalla de inicio de sesión
│   └── Register.dart                  # Pantalla de registro
│
├── Client/                            # Vistas del cliente
│   └── ClientScreen.dart              # Pantalla principal del cliente
│
├── admin/                             # Vistas administrativas
│   ├── AdminScreen.dart               # Panel de administrador
│   └── Home/
│       └── Upload.dart                # Carga de contenido
│
├── Screens/                           # Pantallas principales
│   ├── home_screen.dart               # Pantalla de inicio
│   ├── Flowers_screen.dart            # Galería de flores
│   ├── favorites_screen.dart          # Pantalla de favoritos
│   ├── profile_screen.dart            # Perfil del usuario
│   ├── notifications_screen.dart      # Notificaciones
│   ├── amapilla_screen.dart           # Pantalla de amapola
│   └── model_3d_example_screen.dart   # Ejemplo de modelo 3D
│
├── Widgets/                           # Widgets reutilizables
│   ├── animated_flower.dart           # Flores animadas
│   ├── bottom_nav_bar.dart            # Barra de navegación inferior
│   ├── custom_navigation_rail.dart    # Carril de navegación personalizado
│   ├── poem_card.dart                 # Tarjeta de poema
│   ├── model_3d_viewer.dart           # Visualizador 3D
│   ├── DienteLeonScreen.dart          # Widget diente de león
│   ├── Flower3DScreen.dart            # Widget flor 3D
│   ├── Margarita_flower.dart          # Widget margarita
│   ├── RosaAmarillaScreen.dart        # Widget rosa amarilla
│   ├── Tulipan_flower.dart            # Widget tulipán
│   ├── YellowFlowerPainter.dart       # Painter de flor amarilla
│   ├── PullToRefreshWrapper.dart      # Wrapper para deslizar para actualizar
│   ├── romantic_button.dart           # Botón romántico personalizado
│   ├── robot_3d_model.dart            # Modelo 3D de robot
│   └── video_player.dart              # Reproductor de video
│
├── Views/                             # Vistas y layouts
│   ├── RefreshWrapper.dart            # Wrapper de actualización
│   ├── RestartWidget.dart             # Widget reiniciable
│   ├── connectivity_service.dart      # Servicio de conectividad
│   ├── offline_screen.dart            # Pantalla sin conexión
│   ├── splash_screen.dart             # Pantalla de inicio
│   └── OnboardingScreen.dart          # Pantalla de incorporación
│
├── Controllers/                       # Controladores (Provider)
│   ├── theme_controller.dart          # Controlador de temas
│   └── poem_controller.dart           # Controlador de poemas
│
├── Router/                            # Configuración de rutas
│   └── routes.dart                    # Definición de rutas
│
├── layout/                            # Layouts
│   ├── poem.dart                      # Layout de poema
│   └── User.dart                      # Layout de usuario
│
└── Utils/                             # Utilidades
    ├── app_colors.dart                # Paleta de colores
    ├── app_styles.dart                # Estilos de la aplicación
    ├── constants.dart                 # Constantes globales
    └── helpers.dart                   # Funciones auxiliares
```

---

## 📚 Dependencias

### Dependencias Principales

| Paquete | Versión | Propósito |
| --------- | --------- | ---------- |
| `flutter` | SDK | Framework principal |
| `provider` | ^6.1.5 | Gestión de estado |
| `firebase_core` | ^3.13.0 | Backend Firebase |
| `firebase_auth` | ^5.3.1 | Autenticación |
| `firebase_database` | ^11.0.2 | Base de datos en tiempo real |
| `firebase_storage` | ^12.4.5 | Almacenamiento de archivos |
| `cloud_firestore` | ^5.4.4 | Firestore (opcional) |
| `connectivity_plus` | ^6.1.3 | Detección de conectividad |
| `shared_preferences` | ^2.3.3 | Almacenamiento local |
| `google_fonts` | ^6.2.1 | Fuentes Google |
| `flutter_animate` | ^4.5.0 | Animaciones |
| `glassmorphism` | ^3.0.0 | Efectos visuales |
| `model_viewer_plus` | ^1.9.3 | Visualizador de modelos 3D |
| `flutter_3d_controller` | ^2.3.0 | Control de objetos 3D |
| `image_picker` | ^1.1.2 | Selección de imágenes |
| `file_picker` | ^10.1.9 | Selector de archivos |
| `video_player` | ^2.9.5 | Reproductor de video |
| `chewie` | ^1.11.3 | Player de video mejorado |
| `just_audio` | ^0.10.3 | Reproductor de audio |
| `animated_text_kit` | ^4.2.3 | Animaciones de texto |
| `share_plus` | ^11.0.0 | Compartir contenido |

### Dependencias de Desarrollo

```yaml
flutter_test:
  sdk: flutter
flutter_lints: ^5.0.0
```

---

## 💻 Uso

### Flujo de Usuario

1. **Inicio de Sesión/Registro**
   - Los usuarios se autentican con Firebase
   - Se almacena el rol (Cliente o Admin)

2. **Pantalla Principal**
   - Los clientes ven la galería de flores
   - Los admins ven el panel de control

3. **Exploración de Flores**
   - Ver flores 3D interactivas
   - Leer poemas asociados
   - Añadir a favoritos

4. **Perfil y Configuración**
   - Cambiar tema (claro/oscuro)
   - Ver notificaciones
   - Editar perfil

### Acceso Administrativo

Los administradores pueden:

- Cargar nuevas flores 3D
- Añadir y editar poemas
- Gestionar usuarios
- Ver estadísticas

---

## 🏗️ Arquitectura

### Patrón de Diseño: MVC + Provider

```bash
┌─────────────────────────────────────┐
│           UI Layer (Widgets)         │
│  Screens, Widgets, Views             │
└────────────┬────────────────────────┘
             │
┌────────────▼────────────────────────┐
│    Business Logic Layer (Provider)   │
│  Controllers, State Management       │
└────────────┬────────────────────────┘
             │
┌────────────▼────────────────────────┐
│       Data Layer (Firebase)          │
│  Authentication, Database, Storage   │
└─────────────────────────────────────┘
```

### Gestión de Estado

```dart
// Provider para temas
ChangeNotifierProvider(create: (_) => ThemeController())

// Provider para poemas
ChangeNotifierProvider(create: (_) => PoemController())
```

### Flujo de Datos

```bash
Firebase
    ↓
Provider Controllers
    ↓
UI Widgets
    ↓
User Interaction
    ↓
Firebase (updates)
```

---

## 🔐 Características Técnicas

### Seguridad

- ✅ Variables de entorno en `assets/env.txt`
- ✅ Reglas de seguridad en Firebase Realtime Database
- ✅ Validación de correo electrónico
- ✅ Recuperación segura de contraseña

### Performance

- ✅ Carga lazy de imágenes 3D
- ✅ Compresión de imágenes
- ✅ Caché local con SharedPreferences
- ✅ Optimización de animaciones

### Accesibilidad

- ✅ Contraste de colores optimizado
- ✅ Soporte para temas claros y oscuros
- ✅ Navegación intuitiva
- ✅ Fuentes redimensionables

### Compatibilidad

- ✅ Responsive design
- ✅ Soporte multiidioma (es/en)
- ✅ Múltiples orientaciones (vertical/horizontal)
- ✅ Compatibilidad con Android 5.0+

---

## 📱 Plataformas Soportadas

| Plataforma | Estado | Requisitos |
| ----------- | -------- | ----------- |
| **Android** | ✅ Completo | API 21+ |
| **iOS** | ✅ Completo | iOS 11+ |
| **Web** | ✅ Completo | Chrome/Firefox |
| **Windows** | ✅ Completo | Windows 10+ |
| **Linux** | ✅ Completo | GTK 3.0+ |
| **macOS** | ✅ Completo | macOS 10.11+ |

---

## 📞 Soporte y Contribuciones

### Reportar Bugs

Si encuentras un bug, por favor abre un issue en GitHub con:

- Descripción del problema
- Pasos para reproducir
- Versión de Flutter y dispositivo
- Logs de error

### Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

---

## 📄 Licencia

Este proyecto está bajo licencia privada. Todos los derechos reservados.

---

## 👨‍💻 Autor

## **Anthony Estuardo**

- GitHub: [@18-anth](https://github.com/18-anth)
- Repositorio: [Love14](https://github.com/18-anth/Love14)

---

## 🔗 Enlaces Útiles

- [Documentación de Flutter](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [Model Viewer Plus](https://pub.dev/packages/model_viewer_plus)

---

## 📊 Estadísticas del Proyecto

- **Lenguaje Principal**: Dart
- **Framework**: Flutter 3.8.1+
- **Líneas de Código**: ~5000+
- **Archivos**: 40+
- **Dependencias**: 25+

---

## 🎯 Roadmap Futuro

- [ ] Soporte multiidioma completo
- [ ] Sistema de notificaciones push
- [ ] Integración con redes sociales
- [ ] Galería de flores expandida
- [ ] Sistema de comentarios
- [ ] Modo offline mejorado
- [ ] Soporte para accesibilidad ampliado

---

**¡Gracias por usar Flores Amarillas!** 🌼💛
