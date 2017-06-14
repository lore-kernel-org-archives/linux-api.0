From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 2/4] swait: add the missing killable swaits
Date: Wed, 14 Jun 2017 15:20:15 -0700
Message-ID: <20170614222017.14653-3-mcgrof@kernel.org>
References: <20170614222017.14653-1-mcgrof@kernel.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170614222017.14653-1-mcgrof@kernel.org>
Sender: stable-owner@vger.kernel.org
To: gregkh@linuxfoundation.org
Cc: mfuzzey@parkeon.com, ebiederm@xmission.com, dmitry.torokhov@gmail.com, wagi@monom.org, dwmw2@infradead.org, jewalt@lgsinnovations.com, rafal@milecki.pl, arend.vanspriel@broadcom.com, rjw@rjwysocki.net, yi1.li@linux.intel.com, atull@kernel.org, moritz.fischer@ettus.com, pmladek@suse.com, johannes.berg@intel.com, emmanuel.grumbach@intel.com, luciano.coelho@intel.com, kvalo@codeaurora.org, luto@kernel.org, torvalds@linux-foundation.org, keescook@chromium.org, takahiro.akashi@linaro.org, dhowells@redhat.com, pjones@redhat.com, hdegoede@redhat.com, alan@linux.intel.com, tytso@mit.edu, mtk.manpages@gmail.com, paul.gortmaker@windriver.com, mtosatti@redhat.com, mawilcox@microsoft.com, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, L
List-Id: linux-api@vger.kernel.org

Code in kernel which incorrectly used the non-killable variants could
end up having waits killed improperly. The respective killable waits
have been upstream for a while:

  o wait_for_completion_killable()
  o wait_for_completion_killable_timeout()

swait has been upstream since v4.6. Older kernels have had the
above variants in place for a long time.

Cc: stable <stable@vger.kernel.org> # 4.6
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 include/linux/swait.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/include/linux/swait.h b/include/linux/swait.h
index c1f9c62a8a50..2c700694d50a 100644
--- a/include/linux/swait.h
+++ b/include/linux/swait.h
@@ -169,4 +169,29 @@ do {									\
 	__ret;								\
 })
 
+#define __swait_event_killable(wq, condition)				\
+	___swait_event(wq, condition, TASK_KILLABLE, 0, schedule())
+
+#define swait_event_killable(wq, condition)				\
+({									\
+	int __ret = 0;							\
+	if (!(condition))						\
+		__ret = __swait_event_killable(wq, condition);		\
+	__ret;								\
+})
+
+#define __swait_event_killable_timeout(wq, condition, timeout)		\
+	___swait_event(wq, ___wait_cond_timeout(condition),		\
+		       TASK_KILLABLE, timeout,				\
+		       __ret = schedule_timeout(__ret))
+
+#define swait_event_killable_timeout(wq, condition, timeout)		\
+({									\
+	long __ret = timeout;						\
+	if (!___wait_cond_timeout(condition))				\
+		__ret = __swait_event_killable_timeout(wq,		\
+						condition, timeout);	\
+	__ret;								\
+})
+
 #endif /* _LINUX_SWAIT_H */
-- 
2.11.0
