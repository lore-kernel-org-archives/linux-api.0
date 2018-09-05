From: David Howells <dhowells@redhat.com>
Subject: [PATCH 08/11] UAPI: sound: Fix use of u32 and co. in
	UAPI headers
Date: Wed, 05 Sep 2018 16:55:30 +0100
Message-ID: <153616293089.23468.13515059526628668970.stgit@warthog.procyon.org.uk>
References: <153616286704.23468.584491117180383924.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <alsa-devel-bounces@alsa-project.org>
In-Reply-To: <153616286704.23468.584491117180383924.stgit@warthog.procyon.org.uk>
List-Unsubscribe: <http://mailman.alsa-project.org/mailman/options/alsa-devel>,
 <mailto:alsa-devel-request@alsa-project.org?subject=unsubscribe>
List-Archive: <http://mailman.alsa-project.org/pipermail/alsa-devel/>
List-Post: <mailto:alsa-devel@alsa-project.org>
List-Help: <mailto:alsa-devel-request@alsa-project.org?subject=help>
List-Subscribe: <http://mailman.alsa-project.org/mailman/listinfo/alsa-devel>,
 <mailto:alsa-devel-request@alsa-project.org?subject=subscribe>
Errors-To: alsa-devel-bounces@alsa-project.org
Sender: alsa-devel-bounces@alsa-project.org
To: linux-api@vger.kernel.org, linux-kbuild@vger.kernel.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, moderated for non-subscribers <alsa-devel@alsa-project.org>, Takashi Iwai <tiwai@suse.com>
List-Id: linux-api@vger.kernel.org

Fix the use of u32 and co. in UAPI headers as these are not defined.  Switch
to using the __u32-style equivalents instead.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jaroslav Kysela <perex@perex.cz>
cc: Takashi Iwai <tiwai@suse.com>
cc: alsa-devel@alsa-project.org (moderated for non-subscribers)
---

 include/uapi/sound/skl-tplg-interface.h |  106 ++++++++++++++++---------------
 1 file changed, 54 insertions(+), 52 deletions(-)

diff --git a/include/uapi/sound/skl-tplg-interface.h b/include/uapi/sound/skl-tplg-interface.h
index f58cafa42f18..f39352cef382 100644
--- a/include/uapi/sound/skl-tplg-interface.h
+++ b/include/uapi/sound/skl-tplg-interface.h
@@ -10,6 +10,8 @@
 #ifndef __HDA_TPLG_INTERFACE_H__
 #define __HDA_TPLG_INTERFACE_H__
 
+#include <linux/types.h>
+
 /*
  * Default types range from 0~12. type can range from 0 to 0xff
  * SST types start at higher to avoid any overlapping in future
@@ -143,10 +145,10 @@ enum skl_module_param_type {
 };
 
 struct skl_dfw_algo_data {
-	u32 set_params:2;
-	u32 rsvd:30;
-	u32 param_id;
-	u32 max;
+	__u32 set_params:2;
+	__u32 rsvd:30;
+	__u32 param_id;
+	__u32 max;
 	char params[0];
 } __packed;
 
@@ -163,68 +165,68 @@ enum skl_tuple_type {
 /* v4 configuration data */
 
 struct skl_dfw_v4_module_pin {
-	u16 module_id;
-	u16 instance_id;
+	__u16 module_id;
+	__u16 instance_id;
 } __packed;
 
 struct skl_dfw_v4_module_fmt {
-	u32 channels;
-	u32 freq;
-	u32 bit_depth;
-	u32 valid_bit_depth;
-	u32 ch_cfg;
-	u32 interleaving_style;
-	u32 sample_type;
-	u32 ch_map;
+	__u32 channels;
+	__u32 freq;
+	__u32 bit_depth;
+	__u32 valid_bit_depth;
+	__u32 ch_cfg;
+	__u32 interleaving_style;
+	__u32 sample_type;
+	__u32 ch_map;
 } __packed;
 
 struct skl_dfw_v4_module_caps {
-	u32 set_params:2;
-	u32 rsvd:30;
-	u32 param_id;
-	u32 caps_size;
-	u32 caps[HDA_SST_CFG_MAX];
+	__u32 set_params:2;
+	__u32 rsvd:30;
+	__u32 param_id;
+	__u32 caps_size;
+	__u32 caps[HDA_SST_CFG_MAX];
 } __packed;
 
 struct skl_dfw_v4_pipe {
-	u8 pipe_id;
-	u8 pipe_priority;
-	u16 conn_type:4;
-	u16 rsvd:4;
-	u16 memory_pages:8;
+	__u8 pipe_id;
+	__u8 pipe_priority;
+	__u16 conn_type:4;
+	__u16 rsvd:4;
+	__u16 memory_pages:8;
 } __packed;
 
 struct skl_dfw_v4_module {
 	char uuid[SKL_UUID_STR_SZ];
 
-	u16 module_id;
-	u16 instance_id;
-	u32 max_mcps;
-	u32 mem_pages;
-	u32 obs;
-	u32 ibs;
-	u32 vbus_id;
-
-	u32 max_in_queue:8;
-	u32 max_out_queue:8;
-	u32 time_slot:8;
-	u32 core_id:4;
-	u32 rsvd1:4;
-
-	u32 module_type:8;
-	u32 conn_type:4;
-	u32 dev_type:4;
-	u32 hw_conn_type:4;
-	u32 rsvd2:12;
-
-	u32 params_fixup:8;
-	u32 converter:8;
-	u32 input_pin_type:1;
-	u32 output_pin_type:1;
-	u32 is_dynamic_in_pin:1;
-	u32 is_dynamic_out_pin:1;
-	u32 is_loadable:1;
-	u32 rsvd3:11;
+	__u16 module_id;
+	__u16 instance_id;
+	__u32 max_mcps;
+	__u32 mem_pages;
+	__u32 obs;
+	__u32 ibs;
+	__u32 vbus_id;
+
+	__u32 max_in_queue:8;
+	__u32 max_out_queue:8;
+	__u32 time_slot:8;
+	__u32 core_id:4;
+	__u32 rsvd1:4;
+
+	__u32 module_type:8;
+	__u32 conn_type:4;
+	__u32 dev_type:4;
+	__u32 hw_conn_type:4;
+	__u32 rsvd2:12;
+
+	__u32 params_fixup:8;
+	__u32 converter:8;
+	__u32 input_pin_type:1;
+	__u32 output_pin_type:1;
+	__u32 is_dynamic_in_pin:1;
+	__u32 is_dynamic_out_pin:1;
+	__u32 is_loadable:1;
+	__u32 rsvd3:11;
 
 	struct skl_dfw_v4_pipe pipe;
 	struct skl_dfw_v4_module_fmt in_fmt[MAX_IN_QUEUE];
