From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH 0/2] serial: console: add two features
Date: Mon, 19 Oct 2015 14:40:22 +0900
Message-ID: <1445233224-23150-1-git-send-email-yamada.masahiro@socionext.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-serial@vger.kernel.org
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>, Kevin Cernekee <cernekee@gmail.com>, Jiri Slaby <jslaby@suse.com>, Rob Herring <robh@kernel.org>, linux-api@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, Wang Long <long.wanglong@huawei.com>, Noam Camus <noamc@ezchip.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Eddie Huang <eddie.huang@mediatek.com>
List-Id: linux-api@vger.kernel.org

1/2: add MMIO16 register interface support
2/2: allow to input clock frequency from kernel parameter



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
 include/uapi/linux/serial.h          |  9 +++++----
 7 files changed, 61 insertions(+), 15 deletions(-)

-- 
1.9.1
