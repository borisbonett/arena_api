# 🐱 ArenaGato API

¡Bienvenido a la API Rest para el sistema de gestión y compra de productos de arena para gatos! Este backend está construido sobre **Ruby on Rails** en modo API, utilizando **PostgreSQL** como base de datos y autenticación segura basada en **JSON Web Tokens (JWT)**.

El sistema maneja un flujo completo de venta, control estricto de inventario (stock) y registro histórico de precios adaptado a **Pesos Colombianos (COP)**.

---

## 🚀 Características del Proyecto

- **Autenticación JWT Nativa:** Registro e inicio de sesión seguro. Generación de tokens con expiración dinámica (24 horas en desarrollo, 2 horas en producción).
- **Control de Roles:** Soporte para roles de usuario (`user` y `admin`). Por defecto, los nuevos registros adquieren el rol `user`.
- **Internacionalización (I18n):** Validaciones automáticas y mensajes de error del sistema completamente traducidos al **Español**.
- **Manejo de Stock Dinámico:** Validaciones en los modelos que impiden compras si el stock está agotado o si se solicita más de lo disponible en bodega.
- **Historial de Precios Protegido:** Las compras capturan de forma inmutable el precio del producto al momento de la transacción en COP (sin decimales), blindando la contabilidad contra futuros cambios de precios en el catálogo.

---

## 🛠️ Tecnologías Utilizadas

- **Backend:** Ruby on Rails (Modo API)
- **Base de Datos:** PostgreSQL
- **Autenticación:** JWT (Json Web Token) & `has_secure_password` (Bcrypt)
- **ORM / Herramientas:** Active Record, DBeaver (Recomendado para visualización)

---

## 📊 Arquitectura de la Base de Datos

### Relaciones Clave:

- Un `User` tiene muchas `Purchases` (Compras).
- Un `Product` tiene muchas `Purchases`.
- Una `Purchase` pertenece a un `User` y a un `Product` (Relación Muchos a Muchos a través de la tabla intermedia).

---

## 🔌 Endpoints Principales de la API

### 1. Autenticación y Usuarios

#### 🔹 Registro de Usuario

- **Ruta:** `POST /api/v1/auth/register`
- **Acceso:** Público
- **Body (form-data):**
  ```json
  {
    "name": "Juan Perez",
    "email": "juan@example.com",
    "password": "mi_password_seguro",
    "password_confirmation": "mi_password_seguro"
  }
  ```

#### 🔹 Inicio de Sesión (Login)

- **Ruta:** `POST /api/v1/auth/login`
- **Acceso:** Público
- **Body (JSON / form-data):**
  ```json
  {
    "email": "juan@example.com",
    "password": "mi_password_seguro"
  }
  ```
- **Respuesta Exitosa (200 OK):** Devuelve el `token`, la fecha de expiración (`exp`), el `role` y el `username`.

---

### 2. Módulo de Compras (Purchases)

#### 🔹 Registrar una Compra

- **Ruta:** `POST /api/v1/buy`
- **Acceso:** **Protegido** (Requiere Token JWT)
- **Headers:** `Authorization: Bearer <TU_TOKEN_JWT>`
- **Body (form-data):**
  - `product_id`: ID del producto en la base de datos (Ej: `1`).
  - `quantity`: Cantidad de unidades a comprar (Ej: `3`).

- **Lógica Interna Automática:**
  1. Valida que el token pertenezca a un usuario válido (`@current_user`).
  2. Comprueba si hay suficiente `stock` en la tabla de productos.
  3. Copia el precio actual del producto al registro de la compra (en enteros COP).
  4. Resta automáticamente las unidades compradas del inventario del producto (`decrement!`).

---

## 🧪 Pruebas en Postman (Pasos Rápidos)

1.  **Iniciar el Servidor:** Ejecuta `rails server` en tu terminal.
2.  **Obtener Token:** Haz la petición a `/api/v1/auth/login`. Copia el `token` del JSON de respuesta.
3.  **Configurar Compra:** Crea una pestaña `POST` hacia `http://localhost:3000/api/v1/buy`.
4.  **Inyectar Token:** Ve a la pestaña **Authorization**, selecciona **Bearer Token** y pega el código.
5.  **Enviar Datos:** En la pestaña **Body** (`form-data`), agrega el `product_id` y la `quantity`. Haz clic en **Send**.

---

## ⚙️ Configuración del Idioma (Español)

Para mantener los mensajes de error del sistema en español, la API utiliza el módulo `I18n` configurado en `config/application.rb`:

```ruby
config.i18n.default_locale = :es
```
