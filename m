From: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] stm class: Adding master and channel parameter to ioctl function
Date: Thu, 26 Mar 2015 15:46:11 -0600
Message-ID: <1427406371-6699-1-git-send-email-mathieu.poirier@linaro.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peter.lachner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, norbert.schulz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, keven.boell-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yann.fouassier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, laurent.fert-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kaixu.xia-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hey Alex,

Have a look at the following patch and see if you agree with my approach.  If so
simply add the code to a third version. 

Thanks,
Mathieu

>From 70b4709b668ef59b303dabeff73ed850a4980cfc Mon Sep 17 00:00:00 2001
From: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Date: Thu, 26 Mar 2015 15:33:03 -0600
Subject: [PATCH] stm class: Adding master and channel parameter to ioctl
 function

Just like the "write" function, architecture specific device need
to know about master and channels to do the correct operations on
a ioctl call.

Since this information is embedded in the stm_file structure that
is private to the stm class core, adding extra parameters to convey
the values is simple and clean.

Signed-off-by: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/hwtracing/stm/core.c | 12 ++++++++++--
 include/linux/stm.h          |  5 +++--
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/hwtracing/stm/core.c b/drivers/hwtracing/stm/core.c
index 9e82634590dc..ca71b06bbfea 100644
--- a/drivers/hwtracing/stm/core.c
+++ b/drivers/hwtracing/stm/core.c
@@ -511,9 +511,17 @@ stm_char_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		return stm_char_policy_get_ioctl(stmf, (void __user *)arg);
 
 	default:
-		if (stm_data->ioctl)
-			err = stm_data->ioctl(stm_data, cmd, arg);
+		if (stm_data->ioctl) {
+			/* users shouldn't call device specific ioctl before
+			 * getting a channel using the proper potocol
+			 */
+			if (!stmf->output.nr_chans)
+				return -EINVAL;
 
+			err = stm_data->ioctl(stm_data, stmf->output.master,
+					      stmf->output.channel, cmd, arg);
+
+		}
 		break;
 	}
 
diff --git a/include/linux/stm.h b/include/linux/stm.h
index 976c94d8f17f..84dd83c47fe7 100644
--- a/include/linux/stm.h
+++ b/include/linux/stm.h
@@ -62,8 +62,9 @@ struct stm_data {
 					unsigned int);
 	void			(*unlink)(struct stm_data *, unsigned int,
 					  unsigned int);
-	long			(*ioctl)(struct stm_data *, unsigned int,
-					 unsigned long);
+	long			(*ioctl)(struct stm_data *,
+					 unsigned int, unsigned int,
+					 unsigned int, unsigned long);
 };
 
 int stm_register_device(struct device *parent, struct stm_data *stm_data,
-- 
1.9.1
