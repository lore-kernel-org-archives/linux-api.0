From: Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 4/6] Documentations: Add explanations of the case for non-configurable masters
Date: Mon,  1 Feb 2016 16:20:35 +0800
Message-ID: <1454314835-9294-1-git-send-email-zhang.chunyan@linaro.org>
References: <1454313529-8860-5-git-send-email-zhang.chunyan@linaro.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454313529-8860-5-git-send-email-zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
Cc: robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, nicolas.guion-qxv4g6HH51o@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

For some STM hardware (e.g. ARM CoreSight STM), the masterID associated
to a source is set at the hardware level and not user configurable.
Since the masterID information isn't available to SW, introducing
a new value of -1 to reflect this reality.

Signed-off-by: Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 Documentation/trace/stm.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/trace/stm.txt b/Documentation/trace/stm.txt
index ea035f9..f03bc2b 100644
--- a/Documentation/trace/stm.txt
+++ b/Documentation/trace/stm.txt
@@ -47,6 +47,12 @@ through 127 in it. Now, any producer (trace source) identifying itself
 with "user" identification string will be allocated a master and
 channel from within these ranges.
 
+$ cat /config/stp-policy/dummy_stm.my-policy/user/masters
+-1 -1
+
+Would indicate the masters for this rule are set in hardware and
+not configurable in user space.
+
 These rules can be nested, for example, one can define a rule "dummy"
 under "user" directory from the example above and this new rule will
 be used for trace sources with the id string of "user/dummy".
-- 
1.9.1
