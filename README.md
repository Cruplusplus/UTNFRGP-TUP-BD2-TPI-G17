# Sistema de Gestión de Gimnasio y Club - TPI

## Descripción del Sistema
Este proyecto consiste en el diseño e implementación de una base de datos relacional para un **Sistema de Gestión de Gimnasio y Club de Alto Rendimiento**. El sistema está desarrollado sobre **SQL Server en Docker** como parte de la materia **Base de Datos II** de la Tecnicatura Universitaria en Programación (TUP) en la **Universidad Tecnológica Nacional - Facultad Regional General Pacheco (UTN FRGP)**.

El objetivo principal es resolver la problemática operativa y logística de un complejo deportivo a gran escala, permitiendo administrar de forma eficiente:
***Identidad unificada de Personas:** Control centralizado de datos personales evitando redundancias, clasificando mediante roles si corresponden a socios, empleados o ambos en simultáneo.
***Gestión de Recursos Humanos (Empleados y Roles):** Administración de todo el personal del club (profesores, administrativos, recepción, limpieza) bajo un esquema escalable basado en roles específicos.
***Control Financiero (Membresías y Pagos):** Seguimiento unívoco de los contratos de membresías activos, su historial de renovaciones y el procesamiento de pagos utilizando tipos de datos precisos para auditorías monetarias.
***Logística de Actividades (Clases e Inscripciones):** Cronograma dinámico de actividades con control automatizado de cupos máximos y disponibles en tiempo real.

---

## Modelo de Datos y Arquitectura
 El sistema implementa una arquitectura relacional normalizada en **Tercera Forma Normal (3FN)** , diseñada estratégicamente para garantizar la máxima integridad referencial y performance en consultas complejas.

### Decisiones Clave de Diseño Técnico
1.   **Generalización/Especialización (Herencia):** Se implementó la tabla madre `Personas` vinculada en relaciones `1:1` con `Socios` y `Empleados`.  Esto permite optimizar el almacenamiento de datos de contacto y resolver la condición de negocio donde un empleado es también socio del establecimiento.
2.   **Estrategia de Claves Subrogadas e Índices Compuestos:** En la tabla intermedia `SocioMembresias` se optó por una clave primaria artificial (`IDSocioMembresia`) para agilizar los cruzamientos (`JOINs`) y mejorar la mantenibilidad del código.  Para blindar la integridad del negocio y evitar cargas incoherentes o planes solapados, se aplicó una restricción de unicidad mediante un `CONSTRAINT UNIQUE` compuesto sobre `(IDSocio, IDMembresia, FechaInicio)`.
3.   **Precisión Financiera:** Todos los campos referentes a flujos de dinero (`Precio` en membresías y `Monto` en pagos) están configurados estrictamente con el tipo de dato `MONEY` nativo de SQL Server.

---

## Requisitos Técnicos Implementados
 Para satisfacer los requisitos mínimos exigidos por la cátedra, el sistema incluye los siguientes objetos de base de datos distribuidos en archivos independientes dentro del repositorio:

*  **Vistas (Mínimo 3):** Enfocadas en reportes críticos de administración, presentismo y popularidad de actividades.
* **Procedimientos Almacenados (Mínimo 2):**
    *  *De Reporte (Parametrizado):* Extracción automatizada de asistencias e historiales de socios.
    *  *De Acción:* Procesamiento transaccional de pagos y actualización de vigencias.
* **Triggers (Mínimo 2):**
    *  `AFTER INSERT`: Automatización del descuento del cupo disponible al inscribir un socio a una clase.
    *  `AFTER DELETE`: Devolución inmediata del cupo disponible ante la cancelación de una reserva.

---

## Estructura del Repositorio
 Siguiendo las recomendaciones del profesor para una correcta gestión del proyecto[cite: 523], el código SQL está modularizado de la siguiente manera:

```text
├── README.md                  # Descripción general y documentación del TPI
├── SQL_Scripts
│   ├── 01_Creacion.sql        # Script de inicialización y estructura de tablas (DDL)
│   ├── 02_Datos.sql           # Carga de datos maestros e históricos de prueba (DML)
│   ├── 03_Vistas.sql          # Definición de las 3 vistas requeridas
│   ├── 04_Procedimientos.sql   # Lógica programada de reportes y acciones transaccionales
│   └── 05_Triggers.sql        # Automatizaciones de cupos e integridad mediante disparadores
└── Documentacion
    └── TPI_Gimnasio_DER.pdf    # Diagrama de Entidad-Relación exportado