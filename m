From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH -mm v9 6/8] proc: add kpageidle file
Date: Fri, 24 Jul 2015 17:17:26 +0300
Message-ID: <20150724141726.GE8100@esperanza>
References: <cover.1437303956.git.vdavydov@parallels.com>
 <d7a78b72053cf529c0c9ff6cbc02ffbb3d58fe35.1437303956.git.vdavydov@parallels.com>
 <CAP=VYLqiNfQJ6oyQg2GszeHwdOmeY_uD3XPvw=++weJOKdx4_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAP=VYLqiNfQJ6oyQg2GszeHwdOmeY_uD3XPvw=++weJOKdx4_g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Gortmaker <paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andres Lagar-Cavilla <andreslc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Raghavendra K T <raghavendra.kt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML doc <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 24, 2015 at 10:08:25AM -0400, Paul Gortmaker wrote:

> fs/proc/page.c:341:4: error: implicit declaration of function
> 'pmdp_clear_young_notify' [-Werror=implicit-function-declaration]
> fs/proc/page.c:347:4: error: implicit declaration of function
> 'ptep_clear_young_notify' [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> make[3]: *** [fs/proc/page.o] Error 1
> make[2]: *** [fs/proc] Error 2

My bad, sorry.

It's already been reported by the kbuild-test-robot, see

  [linux-next:master 3983/4215] fs/proc/page.c:332:4: error: implicit declaration of function 'pmdp_clear_young_notify'

The fix is:

From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH] mmu_notifier: add missing stubs for clear_young

This is a compilation fix for !CONFIG_MMU_NOTIFIER.

Fixes: mmu-notifier-add-clear_young-callback
Signed-off-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index a5b17137c683..a1a210d59961 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -471,6 +471,8 @@ static inline void mmu_notifier_mm_destroy(struct mm_struct *mm)
 
 #define ptep_clear_flush_young_notify ptep_clear_flush_young
 #define pmdp_clear_flush_young_notify pmdp_clear_flush_young
+#define ptep_clear_young_notify ptep_test_and_clear_young
+#define pmdp_clear_young_notify pmdp_test_and_clear_young
 #define	ptep_clear_flush_notify ptep_clear_flush
 #define pmdp_huge_clear_flush_notify pmdp_huge_clear_flush
 #define pmdp_huge_get_and_clear_notify pmdp_huge_get_and_clear
