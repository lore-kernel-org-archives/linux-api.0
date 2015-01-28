From: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Subject: [PATCH v10 0/2] Add Spreadtrum SoC bindings and serial driver support
Date: Wed, 28 Jan 2015 19:08:42 +0800
Message-ID: <1422443324-25082-1-git-send-email-chunyan.zhang@spreadtrum.com>
References: <sc9836-serial-v10>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <sc9836-serial-v10>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: gregkh@linuxfoundation.org
Cc: mark.rutland@arm.com, gnomes@lxorguk.ukuu.org.uk, heiko@sntech.de, andrew@lunn.ch, jslaby@suse.cz, lanqing.liu@spreadtrum.com, arnd@arndb.de, zhang.lyra@gmail.com, zhizhou.zhang@spreadtrum.com, geng.ren@spreadtrum.com, antonynpavlov@gmail.com, linux-serial@vger.kernel.org, grant.likely@linaro.org, orsonzhai@gmail.com, florian.vaussard@epfl.ch, devicetree@vger.kernel.org, jason@lakedaemon.net, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, hytszk@gmail.com, robh+dt@kernel.org, wei.qiao@spreadtrum.com, linux-arm-kernel@lists.infradead.org, peter@hurleysoftware.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, galak@codeaurora.org, shawn.guo@linaro.org
List-Id: linux-api@vger.kernel.org

Changes from v9:
	- Added SUPPORT_SYSRQ definition for sprd serial

Changes from v8:
	- Removed a few unuseful code lines.

Chunyan Zhang (2):
  Documentation: DT: Add bindings for Spreadtrum SoC Platform
  tty/serial: Add Spreadtrum sc9836-uart driver support

 Documentation/devicetree/bindings/arm/sprd.txt     |   11 +
 .../devicetree/bindings/serial/sprd-uart.txt       |    7 +
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 drivers/tty/serial/Kconfig                         |   18 +
 drivers/tty/serial/Makefile                        |    1 +
 drivers/tty/serial/sprd_serial.c                   |  793 ++++++++++++++++++++
 include/uapi/linux/serial_core.h                   |    3 +
 7 files changed, 834 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/sprd.txt
 create mode 100644 Documentation/devicetree/bindings/serial/sprd-uart.txt
 create mode 100644 drivers/tty/serial/sprd_serial.c

-- 
1.7.9.5
