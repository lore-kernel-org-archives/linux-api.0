From: Masahiro Yamada <yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org>
Subject: [PATCH v2 0/2] serial: console: add two features
Date: Tue, 20 Oct 2015 12:36:27 +0900
Message-ID: <1445312189-28876-1-git-send-email-yamada.masahiro@socionext.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Masahiro Yamada <yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org>, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vineet Gupta <Vineet.Gupta1-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>, Kevin Cernekee <cernekee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jiri Slaby <jslaby-IBi9RG/b67k@public.gmane.org>, Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Hurley <peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eddie Huang <eddie.huang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org

1/2: add MMIO16 register interface support
2/2: allow to input clock frequency from kernel parameter


Changes in v2:
  - Do not change userspace-exported macros

Masahiro Yamada (2):
  serial: support register interface with 16-bit stride for console
  serial: earlycon: allow to specify uartclk in earlycon
    kernel-parameter

 Documentation/kernel-parameters.txt  |  9 +++++----
 drivers/tty/serial/8250/8250_early.c |  5 +++++
 drivers/tty/serial/8250/8250_port.c  | 20 ++++++++++++++++++++
 drivers/tty/serial/earlycon.c        | 23 ++++++++++++++++++-----
 drivers/tty/serial/serial_core.c     |  9 +++++++--
 include/linux/serial_core.h          |  1 +
 include/uapi/linux/serial.h          |  1 +
 7 files changed, 57 insertions(+), 11 deletions(-)

-- 
1.9.1
