From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: [PATCH v3 1/4] seccomp: Provide matching filter for introspection
Date: Wed,  9 Aug 2017 12:01:54 -0700
Message-ID: <1502305317-85052-2-git-send-email-keescook@chromium.org>
References: <1502305317-85052-1-git-send-email-keescook@chromium.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1502305317-85052-1-git-send-email-keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Fabricio Voznika <fvoznika-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Tycho Andersen <tycho-FCduhRhOUaTQT0dZR+AlfA@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Both the upcoming logging improvements and changes to RET_KILL will need
to know which filter a given seccomp return value originated from. In
order to delay logic processing of result until after the seccomp loop,
this adds a single pointer assignment on matches. This will allow both
log and RET_KILL logic to work off the filter rather than doing more
expensive tests inside the time-critical run_filters loop.

Running tight cycles of getpid() with filters attached shows no measurable
difference in speed.

Suggested-by: Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Reviewed-by: Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 kernel/seccomp.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 98b59b5db90b..1f3347fc2605 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -171,10 +171,14 @@ static int seccomp_check_filter(struct sock_filter *filter, unsigned int flen)
 /**
  * seccomp_run_filters - evaluates all seccomp filters against @sd
  * @sd: optional seccomp data to be passed to filters
+ * @match: stores struct seccomp_filter that resulted in the return value,
+ *         unless filter returned SECCOMP_RET_ALLOW, in which case it will
+ *         be unchanged.
  *
  * Returns valid seccomp BPF response codes.
  */
-static u32 seccomp_run_filters(const struct seccomp_data *sd)
+static u32 seccomp_run_filters(const struct seccomp_data *sd,
+			       struct seccomp_filter **match)
 {
 	struct seccomp_data sd_local;
 	u32 ret = SECCOMP_RET_ALLOW;
@@ -198,8 +202,10 @@ static u32 seccomp_run_filters(const struct seccomp_data *sd)
 	for (; f; f = f->prev) {
 		u32 cur_ret = BPF_PROG_RUN(f->prog, sd);
 
-		if ((cur_ret & SECCOMP_RET_ACTION) < (ret & SECCOMP_RET_ACTION))
+		if ((cur_ret & SECCOMP_RET_ACTION) < (ret & SECCOMP_RET_ACTION)) {
 			ret = cur_ret;
+			*match = f;
+		}
 	}
 	return ret;
 }
@@ -566,6 +572,7 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
 			    const bool recheck_after_trace)
 {
 	u32 filter_ret, action;
+	struct seccomp_filter *match = NULL;
 	int data;
 
 	/*
@@ -574,7 +581,7 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
 	 */
 	rmb();
 
-	filter_ret = seccomp_run_filters(sd);
+	filter_ret = seccomp_run_filters(sd, &match);
 	data = filter_ret & SECCOMP_RET_DATA;
 	action = filter_ret & SECCOMP_RET_ACTION;
 
@@ -638,6 +645,11 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
 		return 0;
 
 	case SECCOMP_RET_ALLOW:
+		/*
+		 * Note that the "match" filter will always be NULL for
+		 * this action since SECCOMP_RET_ALLOW is the starting
+		 * state in seccomp_run_filters().
+		 */
 		return 0;
 
 	case SECCOMP_RET_KILL:
-- 
2.7.4
