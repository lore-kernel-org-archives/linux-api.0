From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v9 9/9] nvmem: Add to MAINTAINERS for nvmem framework
Date: Mon, 27 Jul 2015 12:17:24 +0100
Message-ID: <1437995844-12004-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1437995567-11203-1-git-send-email-srinivas.kandagatla@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437995567-11203-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: khilman@kernel.org, linux-arm-kernel@lists.infradead.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>, s.hauer@pengutronix.de, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, arnd@arndb.de, sboyd@codeaurora.org, pantelis.antoniou@konsulko.com, mporter@konsulko.com, stefan.wahren@i2se.com, wxt@rock-chips.com, Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
List-Id: linux-api@vger.kernel.org

This patch adds MAINTAINERS to nvmem framework.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8133cef..90e0d94 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7263,6 +7263,15 @@ S:	Supported
 F:	drivers/block/nvme*
 F:	include/linux/nvme.h
=20
+NVMEM FRAMEWORK
+M:	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
+M:	Maxime Ripard <maxime.ripard@free-electrons.com>
+S:	Maintained
+F:	drivers/nvmem/
+F:	Documentation/devicetree/bindings/nvmem/
+F:	include/linux/nvmem-consumer.h
+F:	include/linux/nvmem-provider.h
+
 NXP-NCI NFC DRIVER
 M:	Cl=C3=A9ment Perrochaud <clement.perrochaud@effinnov.com>
 R:	Charles Gorand <charles.gorand@effinnov.com>
--=20
1.9.1
