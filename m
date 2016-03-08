From: Chunyan Zhang <zhang.chunyan@linaro.org>
Subject: [RESEND PATCH V4 2/4] Documentations: Add explanations of the case for non-configurable masters
Date: Tue,  8 Mar 2016 14:33:53 +0800
Message-ID: <1457418835-31417-3-git-send-email-zhang.chunyan@linaro.org>
References: <1457418835-31417-1-git-send-email-zhang.chunyan@linaro.org>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1457418835-31417-1-git-send-email-zhang.chunyan@linaro.org>
Sender: linux-doc-owner@vger.kernel.org
To: mathieu.poirier@linaro.org, alexander.shishkin@linux.intel.com
Cc: mike.leach@arm.com, Michael.Williams@arm.com, al.grant@arm.com, tor@ti.com, nicolas.guion@st.com, pratikp@codeaurora.org, zhang.lyra@gmail.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

For some STM hardware (e.g. ARM CoreSight STM), the masterID associated
to a source is set at the hardware level and not user configurable.
Since the masterID information isn't available to SW, introducing
a new value of -1 to reflect this reality.

Signed-off-by: Chunyan Zhang <zhang.chunyan@linaro.org>
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

