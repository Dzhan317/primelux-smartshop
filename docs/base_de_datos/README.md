#  Base de datos

En esta carpeta se recoge todo lo relacionado con el diseño de la base de datos del proyecto.

Incluye el modelo entidad-relación (E/R), el esquema en SQL y otros diagramas que ayudan a entender cómo está organizada la información.

---

##  Modelo de datos

La base de datos está diseñada para cubrir las necesidades principales de un e-commerce.

Incluye entidades como:

- Usuarios y direcciones  
- Productos, variantes e imágenes  
- Categorías  
- Carritos, pedidos y pagos  
- Reseñas, interacciones y mensajes  

También se utilizan tablas intermedias para gestionar relaciones entre entidades, como productos y categorías o pedidos y productos.

---

##  Evolución del modelo

El modelo actual parte de una versión inicial más compleja que se simplificó para adaptarse mejor al tiempo disponible.

Aun así, mantiene una estructura suficiente para cubrir las funcionalidades principales y permite futuras mejoras.

---

##  Contenido

- Modelo E/R  
- Diagrama de casos de uso  
- Archivo `schema.sql` con la creación de tablas  

---

##  Nota

El modelo puede ajustarse ligeramente durante el desarrollo si se detectan mejoras.
