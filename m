From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v1 6/6] eeprom: Add to MAINTAINERS for eeprom framework
Date: Thu,  5 Mar 2015 09:46:31 +0000
Message-ID: <1425548791-13152-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1425548685-12887-1-git-send-email-srinivas.kandagatla@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425548685-12887-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Kumar Gala <galak@codeaurora.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>, andrew@lunn.ch, Arnd Bergmann <arnd@arndb.de>, broonie@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
List-Id: linux-api@vger.kernel.org

This patch adds MAINTAINERS to eeprom framework.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index d66a97d..ee7ba92 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3657,6 +3657,15 @@ T:	git git://git.alsa-project.org/alsa-kernel.git
 S:	Maintained
 F:	sound/usb/misc/ua101.c
 
+EEPROM FRAMEWORK
+M:	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
+M:	Maxime Ripard <maxime.ripard@free-electrons.com>
+S:	Maintained
+F:	drivers/eeprom/
+F:	Documentation/devicetree/bindings/eeprom/
+F:	include/linux/eeprom-provider.h
+F:	include/linux/eeprom-consumer.h
+
 EXTENSIBLE FIRMWARE INTERFACE (EFI)
 M:	Matt Fleming <matt.fleming@intel.com>
 L:	linux-efi@vger.kernel.org
-- 
1.9.1
