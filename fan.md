# Guía de Configuración de Control Térmico (Thinkfan) - ThinkPad X230

Este documento detalla los pasos técnicos para configurar el control manual del ventilador y la gestión de sensores de temperatura en hardware ThinkPad utilizando el controlador nativo del kernel.

## 1. Búsqueda e Identificación de Sensores

Para que el software de control pueda monitorear la tempe```markdownratura, es necesario identificar las rutas exactas en el sistema de archivos virtual `/sys`.

### Método A: Búsqueda en el subsistema hwmon
Ejecute el siguiente comando para encontrar los sensores de temperatura del procesador (Ivy Bridge):

```bash
find /sys/devices/platform/coretemp.0/hwmon -name "temp1_input"
```

### Método B: Interfaz Nativa de ThinkPad (Recomendado)
Para mayor estabilidad en modelos clásicos, se puede utilizar la interfaz unificada que ofrece el controlador `thinkpad_acpi`:

- Ruta del sensor: `/proc/acpi/ibm/thermal`
- Ruta del ventilador: `/proc/acpi/ibm/fan`

## 2. Configuración del Módulo del Kernel

Por razones de seguridad, el control externo del ventilador está desactivado por defecto en el kernel Linux. Para habilitarlo, se debe configurar el parámetro `fan_control`.

1.  **Crear el archivo de configuración:**
    `sudo nano /etc/modprobe.d/thinkpad_acpi.conf`

2.  **Añadir el parámetro de habilitación:**
    ```text
    options thinkpad_acpi fan_control=1
    ```

3.  **Aplicar cambios sin reiniciar:**
    ```bash
    sudo modprobe -r thinkpad_acpi && sudo modprobe thinkpad_acpi
    ```

## 3. Configuración de Thinkfan (`/etc/thinkfan.conf`)

El archivo principal de configuración define qué sensores leer y qué niveles de velocidad aplicar según la temperatura alcanzada.

```yaml
# Definición de Sensores
sensors:
  - tpacpi: /proc/acpi/ibm/thermal

# Definición del Ventilador
fans:
  - tpacpi: /proc/acpi/ibm/fan

# Curva de Niveles (Nivel, Temperatura de Inicio, Temperatura de Parada)
# El nivel 127 activa el modo "Full Speed" (disengaged)
levels:
  - [0,  0, 55]
  - [1, 52, 60]
  - [2, 57, 63]
  - [3, 61, 66]
  - [6, 65, 75]
  - [7, 72, 85]
  - [127, 82, 32767]
```

## 4. Gestión del Servicio

Para asegurar que la configuración se aplique desde el arranque del sistema, se utiliza el gestor de servicios `systemd`.

- **Habilitar e iniciar:**
  ```bash
  sudo systemctl enable --now thinkfan.service
  ```

- **Verificar estado:**
  ```bash
  sudo systemctl status thinkfan.service
  ```

## 5. Comandos de Monitoreo en Tiempo Real

Para verificar que el ventilador responde correctamente a los cambios de temperatura, se puede utilizar el siguiente comando de seguimiento:

```bash
watch -n 1 "cat /proc/acpi/ibm/fan | grep -E 'speed|level'"
```