# 001 — Arquitectura MVC en PHP puro

**Fase:** 0  
**Tipo:** Arquitectónica

---

## Contexto

El proyecto necesita una estructura organizada, mantenible y defendible ante tribunal académico, desarrollada en PHP puro sin frameworks, dentro de un límite de 64 horas reales.

---

## Decisión tomada

Arquitectura MVC manual en PHP puro con cuatro capas: Core (Router, Database, Controller base), Controllers, Models y Views. Único punto de entrada en `public/index.php`.

---

## Alternativas descartadas

| Alternativa | Motivo |
|---|---|
| Laravel / Symfony | Aunque ofrecen una arquitectura más completa, se descartan para mantener control total del desarrollo dentro del tiempo disponible |
| Repository Pattern | Añade capa sin beneficio real a esta escala |
| DI Container | Sobreingeniería para un TFG |

---

## Justificación técnica

MVC es el patrón más extendido en desarrollo web y el que los módulos del ciclo DAW contemplan directamente. Separa responsabilidades de forma clara y facilita explicar el código ante tribunal pregunta a pregunta.

---

## Impacto en tiempo (64h)

Fase 0 completada en ~2.5h.
