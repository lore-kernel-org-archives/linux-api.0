From: Rickard Strandqvist <rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>
Subject: [PATCH] tools: testing: selftests: powerpc: pmu: ebb: ebb.c:  Remove unused function
Date: Sun,  7 Dec 2014 21:50:59 +0100
Message-ID: <1417985459-16501-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>
Cc: Rickard Strandqvist <rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Remove the function event_bhrb_init() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>
---
 tools/testing/selftests/powerpc/pmu/ebb/ebb.c |    5 -----
 tools/testing/selftests/powerpc/pmu/ebb/ebb.h |    1 -
 2 files changed, 6 deletions(-)

diff --git a/tools/testing/selftests/powerpc/pmu/ebb/ebb.c b/tools/testing/selftests/powerpc/pmu/ebb/ebb.c
index d7a72ce..75af212 100644
--- a/tools/testing/selftests/powerpc/pmu/ebb/ebb.c
+++ b/tools/testing/selftests/powerpc/pmu/ebb/ebb.c
@@ -324,11 +324,6 @@ void event_ebb_init(struct event *e)
 	e->attr.config |= (1ull << 63);
 }
 
-void event_bhrb_init(struct event *e, unsigned ifm)
-{
-	e->attr.config |= (1ull << 62) | ((u64)ifm << 60);
-}
-
 void event_leader_ebb_init(struct event *e)
 {
 	event_ebb_init(e);
diff --git a/tools/testing/selftests/powerpc/pmu/ebb/ebb.h b/tools/testing/selftests/powerpc/pmu/ebb/ebb.h
index e44eee5..a71596a 100644
--- a/tools/testing/selftests/powerpc/pmu/ebb/ebb.h
+++ b/tools/testing/selftests/powerpc/pmu/ebb/ebb.h
@@ -46,7 +46,6 @@ static inline void ebb_enable_pmc_counting(int pmc)
 bool ebb_check_count(int pmc, u64 sample_period, int fudge);
 void event_leader_ebb_init(struct event *e);
 void event_ebb_init(struct event *e);
-void event_bhrb_init(struct event *e, unsigned ifm);
 void setup_ebb_handler(void (*callee)(void));
 void standard_ebb_callee(void);
 int ebb_event_enable(struct event *e);
-- 
1.7.10.4
