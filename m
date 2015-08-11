From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH RFC 3/3] nvmem: add permission flags in nvmem_config
Date: Tue, 11 Aug 2015 12:03:44 +0100
Message-ID: <1439291024-18375-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1439290931-18232-1-git-send-email-srinivas.kandagatla@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1439290931-18232-1-git-send-email-srinivas.kandagatla@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Lunn <andrew@lunn.ch>, arnd@arndb.de, khilman@kernel.org, devicetree@vger.kernel.org, linux-api@vger.kernel.org, s.hauer@pengutronix.de, sboyd@codeaurora.org, linux-kernel@vger.kernel.org, maitysanchayan@gmail.com, pantelis.antoniou@konsulko.com, Rob Herring <robh+dt@kernel.org>, Srinivas Kandagatla <srinivas.kandagatla@linaro.org>, Mark Brown <broonie@kernel.org>, p.zabel@pengutronix.de, linux-arm-msm@vger.kernel.org, mporter@konsulko.com, linux-arm-kernel@lists.infradead.org, wxt@rock-chips.com
List-Id: linux-api@vger.kernel.org

This patch adds perm variable to nvmem_config structure which will allow
providers to specify the permissions required for the sysfs binary file.
This permission is applied on top of root-only access permissions set by
the core.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/nvmem/core.c           | 1 +
 include/linux/nvmem-provider.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 414ed23..7481387 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -312,6 +312,7 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 			   config->read_only;
 	nvmem->bin = bin_attr_template;
 	nvmem->bin.attr.mode = nvmem->read_only ? : (S_IRUSR | S_IWUSR);
+	nvmem->bin.attr.mode |= config->perm;
 	nvmem->bin.size = nvmem->size;
 	device_initialize(&nvmem->dev);
 
diff --git a/include/linux/nvmem-provider.h b/include/linux/nvmem-provider.h
index 0b68caf..de9a61f 100644
--- a/include/linux/nvmem-provider.h
+++ b/include/linux/nvmem-provider.h
@@ -23,6 +23,7 @@ struct nvmem_config {
 	const struct nvmem_cell_info	*cells;
 	int			ncells;
 	bool			read_only;
+	u16			perm; /* visibility in sysfs */
 };
 
 #if IS_ENABLED(CONFIG_NVMEM)
-- 
1.9.1
