## Módulo de Reportes de Ventas

El sistema cuenta con un módulo de reportes diseñado para analizar las ventas realizadas, visualizando componentes gráficos e indicadores clave de rendimiento (KPIs).

### ¿Cómo acceder?
1. Inicia sesión en el sistema usando una cuenta válida (por ejemplo, `admin@gmail.com` con contraseña default `123456`).
2. En el menú lateral (Sidebar), da clic en el apartado **"📊 Reportes"**.
3. Accederás al panel principal donde podrás visualizar los datos y aplicar diferentes filtros de búsqueda cruzados (Fechas, Tipo de Producto, Género, y Empleado).

### ¿Qué métricas se muestran?
El panel muestra:
- **Total Recaudado:** Sumatoria monetaria de las ventas seleccionadas.
- **Cantidad de Ventas:** Número total de facturas únicas registradas.
- **Promedio por Venta:** Relación entre el total facturado y el número de ventas.
- **Productos Vendidos:** Sumatoria de las unidades (cantidad) de productos despachados.

Además incluye tres gráficos estadísticos:
1. **Gráfico Circular:** Ventas agrupadas por Tipo de Producto (CD / Vinilo)
2. **Gráfico Circular:** Ventas agrupadas por Género musical (Rock, Pop, Jazz, etc.)
3. **Gráfico de Barras horizontales:** Top 5 de los productos más vendidos según unidades comercializadas.

### ¿Cómo generar datos de prueba?
Para visualizar correctamente los reportes, el sistema cuenta con "seeds":
1. Ejecuta en tu terminal el comando: `rails db:seed`
2. Este comando se encargará de crear usuarios de prueba, registrar los roles necesarios, cargar artículos y además, inyectará **facturas de venta y line items al azar** asignados a diferentes clientes y fechas de los últimos 60 días para engrosar el dataset del módulo.
