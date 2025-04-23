# Cosmo Noticias 🚀🌌

**Cosmo Noticias** es una aplicación iOS en **SwiftUI** que consume la API de [Space Flight News](https://api.spaceflightnewsapi.net/v4/docs/) para mostrar las últimas noticias sobre vuelos espaciales.  
Está arquitecturada bajo MVVM + Coordinator, con inyección de dependencias vía **Resolver** y cacheo de imágenes con **Kingfisher**.

---

## 📋 Tabla de Contenidos

- [Características](#-características)  
- [Arquitectura](#-arquitectura)  
- [Requisitos](#-requisitos)  
- [Instalación](#-instalación)  
- [Estructura de Carpetas](#-estructura-de-carpetas)  
- [Uso](#-uso)  
- [Pruebas](#-pruebas)  
  - [Unit Tests](#unit-tests)  
  - [UI Tests](#ui-tests)  
- [Contribuciones](#-contribuciones)  
- [Licencia](#-licencia)

---

## ✨ Características

- 📄 **Listado de artículos**: últimos 20 artículos, paginación infinita.  
- 🔍 **Buscador**: filtra por título y vuelve al listado original al cancelar.  
- 📑 **Detalle**: vista con imagen, título, resumen y enlace “Leer más”.  
- 🧩 **MVVM + Coordinator**: separación clara de responsabilidades.  
- 🛠️ **Inyección de dependencias** con Resolver.  
- 🏞️ **Cacheo de imágenes** con Kingfisher (memoria + disco).  
- 📝 **Soporte de rotación** y mantenimiento de estado.  
- ✅ **Unit & UI Tests**: cubren lógica de paginación, errores y flujos UI básicos.

---

## 🏗️ Arquitectura

1. **App**  
   - `CosmoNoticiasApp.swift` (@main, arranque SwiftUI + Resolver).  
   - `AppCoordinator.swift`: orquesta la navegación raíz.  
2. **DependencyInjection**  
   - `DIContainer.swift`: registra servicios y view models en Resolver.  
3. **Features/Articles**  
   - **Model**: `Article.swift`, `ArticleListResponse.swift`.  
   - **Networking**: `APIService.swift`, `SpaceFlightNewsAPI.swift`, `DefaultAPIService.swift`.  
   - **ViewModels**: `ArticlesListViewModel.swift`, `ArticleDetailViewModel.swift`.  
   - **Views**:  
     - `ArticlesListView.swift` (lista + búsqueda + pull-to-refresh).  
     - `ArticleRowView.swift` (celda con imagen + texto).  
     - `ArticleDetailView.swift` (detalle con KFImage).  
4. **Common**  
   - `ErrorView.swift`, extensiones y utilidades.  
5. **Tests**  
   - **Unit Tests**: lógica de `ArticlesListViewModel`.  
   - **UI Tests**: flujos de carga de lista, navegación y búsqueda.

---

## 🔧 Requisitos

- Xcode 15.4+  
- iOS 16.0+  
- Swift 5.8  
- Conexión a Internet para acceder a la API

---

## 🚀 Instalación

1. Clona este repositorio:  
   ```bash
   git clone https://github.com/tu_usuario/Cosmo-Noticias.git
   cd Cosmo-Noticias
   ```
2. Abre el proyecto en Xcode:  
   ```bash
   open Cosmo\ Noticias.xcodeproj
   ```
3. Espera a que Swift Package Manager resuelva **Resolver** y **Kingfisher**.  
4. Selecciona un simulador o dispositivo y pulsa **⌘R** para compilar y ejecutar.

---

## 🗂️ Estructura de Carpetas

```
Cosmo Noticias/
├─ App/
│   ├─ CosmoNoticiasApp.swift
│   └─ AppCoordinator.swift
│
├─ DependencyInjection/
│   └─ DIContainer.swift
│
├─ Features/
│   └─ Articles/
│       ├─ Model/
│       ├─ Networking/
│       ├─ ViewModels/
│       └─ Views/
│
├─ Common/
│   ├─ UIComponents/
│   └─ Extensions/
│
└─ Tests/
    ├─ UnitTests/
    └─ UITests/
```

---

## 🎬 Uso

- **Lista**: carga automáticamente los primeros 20 artículos.  
- **Scroll infinito**: al llegar al final, carga la siguiente página (`limit=20`, `offset=20,40,60…`).  
- **Buscar**: escribe en la search bar, pulsa *Buscar*.  
- **Cancelar**: al borrar el texto o pulsar *Cancelar*, vuelve al listado original.  
- **Detalle**: toca cualquier artículo para ver su detalle.

---

## 🧪 Pruebas

### Unit Tests

- Abre el esquema **CosmoNoticiasTests**.  
- Ejecuta **⌘U**.  
- Cubren:  
  - Estado inicial de `ArticlesListViewModel`.  
  - `fetchArticles()` exitoso y fallido.  
  - Paginación con `loadMoreIfNeeded()`.

### UI Tests

- Abre el esquema **CosmoNoticiasUITests**.  
- Ejecuta **⌘U**.  
- Flujos:  
  1. Carga lista y navegación a detalle.  
  2. Búsqueda (“SpaceX”) y cancelar (volver al listado).

---

## 🤝 Contribuciones

¡Contribuciones bienvenidas!  
1. Haz un fork.  
2. Crea una rama: `git checkout -b feature/nombre`.  
3. Haz commits claros y descriptivos.  
4. Abre un Pull Request describiendo tu cambio.

---

## 📄 Licencia

Este proyecto está bajo la licencia **MIT**.  
Consulta el archivo [LICENSE](./LICENSE) para más detalles.

---

> Desarrollado con ❤️ por _William Oviedo_
