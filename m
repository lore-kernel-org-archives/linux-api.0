From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH RFC 2/3] nvmem: set the size for the nvmem binary file.
Date: Tue, 11 Aug 2015 12:03:36 +0100
Message-ID: <1439291016-18333-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1439290931-18232-1-git-send-email-srinivas.kandagatla@linaro.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1439290931-18232-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Lunn <andrew@lunn.ch>, wxt@rock-chips.com, linux-api@vger.kernel.org, Rob Herring <robh+dt@kernel.org>, sboyd@codeaurora.org, arnd@arndb.de, linux-arm-kernel@lists.infradead.org, khilman@kernel.org, s.hauer@pengutronix.de, linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, mporter@konsulko.com, pantelis.antoniou@konsulko.com, devicetree@vger.kernel.org, Mark Brown <broonie@kernel.org>, maitysanchayan@gmail.com, p.zabel@pengutronix.de, Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
List-Id: linux-api@vger.kernel.org

This patch sets the actual size of binary file to the nvmem size.
Previously this was not possible as the core was using the static global
data structures for attributes.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/nvmem/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 103f6aa..414ed23 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -312,6 +312,7 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 			   config->read_only;
 	nvmem->bin = bin_attr_template;
 	nvmem->bin.attr.mode = nvmem->read_only ? : (S_IRUSR | S_IWUSR);
+	nvmem->bin.size = nvmem->size;
 	device_initialize(&nvmem->dev);
 
 	dev_dbg(&nvmem->dev, "Registering nvmem device %s\n", config->name);
-- 
1.9.1
