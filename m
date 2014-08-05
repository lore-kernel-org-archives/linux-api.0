From: Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH 0/3] tty: serial: Add mediatek UART driver
Date: Tue,  5 Aug 2014 12:54:10 +0200
Message-ID: <1407236054-30994-1-git-send-email-matthias.bgg@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rdunlap@infradead.org, gregkh@linuxfoundation.org, jslaby@suse.cz, grant.likely@linaro.org, matthias.bgg@gmail.com, heikki.krogerus@linux.intel.com, alan@linux.intel.com, paul.gortmaker@windriver.com, asierra@xes-inc.com, mwelling@ieee.org, dianders@chromium.org, m-karicheri2@ti.com, jschultz@xes-inc.com, mingo@elte.hu, balbi@ti.com, heiko@sntech.de, devicetree@vger.kernel.org, linux-doc@vger.kernel.org, linux-serial@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This patch set adds support for the UART found in Mediatek SoCs.
The chip is a changed version of a 8250 controller.
Especially it introduces a new register called highspeed. The value
in this register has to be set depending on the baudrate. The value
in the register influences the way the divisor has to be calculated.

The patch series is build against v3.16-rc1 and tested on mt6589. Should
work as well on mt6577 and mt6582.

Thanks,
Matthias

Matthias Brugger (3):
  tty: serial: 8250: Add new capability for highspeed register
  tty: serial: 8250: Add Mediatek UART driver
  DTS: serial: Add bindings documention for the Mediatek UARTs

 .../devicetree/bindings/serial/mtk-uart.txt        |   19 ++
 drivers/tty/serial/8250/8250.h                     |    1 +
 drivers/tty/serial/8250/8250_core.c                |   47 +++++
 drivers/tty/serial/8250/8250_mtk.c                 |  211 ++++++++++++++++++++
 drivers/tty/serial/8250/Kconfig                    |    7 +
 drivers/tty/serial/8250/Makefile                   |    1 +
 include/uapi/linux/serial_reg.h                    |    6 +
 7 files changed, 292 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/serial/mtk-uart.txt
 create mode 100644 drivers/tty/serial/8250/8250_mtk.c

-- 
1.7.9.5
