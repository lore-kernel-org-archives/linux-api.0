From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v1 05/10] serial: mps2-uart: add support for early console
Date: Wed,  2 Dec 2015 09:33:05 +0000
Message-ID: <1449048790-25859-6-git-send-email-vladimir.murzin@arm.com>
References: <1449048790-25859-1-git-send-email-vladimir.murzin@arm.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1449048790-25859-1-git-send-email-vladimir.murzin@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de, linux@arm.linux.org.uk, gregkh@linuxfoundation.org, daniel.lezcano@linaro.org, tglx@linutronix.de, u.kleine-koenig@pengutronix.de, afaerber@suse.de, mcoquelin.stm32@gmail.com
Cc: Mark.Rutland@arm.com, Pawel.Moll@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, jslaby@suse.cz, robh+dt@kernel.org, devicetree@vger.kernel.org, linux-serial@vger.kernel.org, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This adds support early console for MPS2 UART which can be enabled via
earlycon=3Dmps2,0x40004000

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
 drivers/tty/serial/Kconfig     |    1 +
 drivers/tty/serial/mps2-uart.c |   30 ++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index e98bfea..33d1365 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1477,6 +1477,7 @@ config SERIAL_MPS2_UART_CONSOLE
 =09bool "MPS2 UART console support"
 =09depends on SERIAL_MPS2_UART
 =09select SERIAL_CORE_CONSOLE
+=09select SERIAL_EARLYCON
=20
 config SERIAL_MPS2_UART
 =09bool "MPS2 UART port"
diff --git a/drivers/tty/serial/mps2-uart.c b/drivers/tty/serial/mps2-uart.=
c
index 09bac16..5f3252e 100644
--- a/drivers/tty/serial/mps2-uart.c
+++ b/drivers/tty/serial/mps2-uart.c
@@ -445,6 +445,36 @@ static struct console mps2_uart_console =3D {
=20
 #define MPS2_SERIAL_CONSOLE (&mps2_uart_console)
=20
+static void mps2_early_putchar(struct uart_port *port, int ch)
+{
+
+=09while (readb(port->membase + UARTn_STATE) & UARTn_STATE_TX_FULL)
+=09=09cpu_relax();
+
+=09writeb((unsigned char)ch, port->membase + UARTn_DATA);
+}
+
+
+static void mps2_early_write(struct console *con, const char *s, unsigned =
n)
+{
+=09struct earlycon_device *dev =3D con->data;
+
+=09uart_console_write(&dev->port, s, n, mps2_early_putchar);
+}
+
+static int __init mps2_early_console_setup(struct earlycon_device *device,
+=09=09=09=09=09   const char *opt)
+{
+=09if (!device->port.membase)
+=09=09return -ENODEV;
+
+=09device->con->write =3D mps2_early_write;
+
+=09return 0;
+}
+EARLYCON_DECLARE(mps2, mps2_early_console_setup);
+OF_EARLYCON_DECLARE(mps2, "arm,mps2-uart", mps2_early_console_setup);
+
 #else
 #define MPS2_SERIAL_CONSOLE NULL
 #endif
--=20
1.7.9.5
