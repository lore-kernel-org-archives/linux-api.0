From: Chunyan Zhang <zhang.chunyan@linaro.org>
Subject: [PATCH V2 1/6] stm class: Add ioctl get_options interface
Date: Wed,  3 Feb 2016 16:15:32 +0800
Message-ID: <1454487337-30184-2-git-send-email-zhang.chunyan@linaro.org>
References: <1454487337-30184-1-git-send-email-zhang.chunyan@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454487337-30184-1-git-send-email-zhang.chunyan@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: mathieu.poirier@linaro.org, alexander.shishkin@linux.intel.com
Cc: robh@kernel.org, broonie@kernel.org, pratikp@codeaurora.org, nicolas.guion@st.com, corbet@lwn.net, mark.rutland@arm.com, mike.leach@arm.com, tor@ti.com, al.grant@arm.com, zhang.lyra@gmail.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

There is already an interface of set_options, but no get_options yet.
Before setting any options, one would may want to see the current
status of that option by means of get_options interface. This
interface has been used in CoreSight STM driver.

Signed-off-by: Chunyan Zhang <zhang.chunyan@linaro.org>
---
 drivers/hwtracing/stm/core.c | 11 +++++++++++
 include/linux/stm.h          |  3 +++
 include/uapi/linux/stm.h     |  1 +
 3 files changed, 15 insertions(+)

diff --git a/drivers/hwtracing/stm/core.c b/drivers/hwtracing/stm/core.c
index b6445d9..86bb4e3 100644
--- a/drivers/hwtracing/stm/core.c
+++ b/drivers/hwtracing/stm/core.c
@@ -571,6 +571,17 @@ stm_char_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 						    options);
 
 		break;
+
+	case STP_GET_OPTIONS:
+		if (stm_data->get_options)
+			err = stm_data->get_options(stm_data,
+						    stmf->output.master,
+						    stmf->output.channel,
+						    stmf->output.nr_chans,
+						    &options);
+
+		return copy_to_user((void __user *)arg, &options, sizeof(u64));
+
 	default:
 		break;
 	}
diff --git a/include/linux/stm.h b/include/linux/stm.h
index 9d0083d..f351d62 100644
--- a/include/linux/stm.h
+++ b/include/linux/stm.h
@@ -88,6 +88,9 @@ struct stm_data {
 	long			(*set_options)(struct stm_data *, unsigned int,
 					       unsigned int, unsigned int,
 					       unsigned long);
+	long			(*get_options)(struct stm_data *, unsigned int,
+					       unsigned int, unsigned int,
+					       u64 *);
 };
 
 int stm_register_device(struct device *parent, struct stm_data *stm_data,
diff --git a/include/uapi/linux/stm.h b/include/uapi/linux/stm.h
index 626a8d3..0dab16e 100644
--- a/include/uapi/linux/stm.h
+++ b/include/uapi/linux/stm.h
@@ -46,5 +46,6 @@ struct stp_policy_id {
 #define STP_POLICY_ID_SET	_IOWR('%', 0, struct stp_policy_id)
 #define STP_POLICY_ID_GET	_IOR('%', 1, struct stp_policy_id)
 #define STP_SET_OPTIONS		_IOW('%', 2, __u64)
+#define STP_GET_OPTIONS		_IOR('%', 3, __u64)
 
 #endif /* _UAPI_LINUX_STM_H */
-- 
1.9.1
