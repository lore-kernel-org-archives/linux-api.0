From: Rickard Strandqvist <rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>
Subject: [PATCH] tools: testing: selftests: powerpc: pmu: ebb: trace.c:  Remove some unused functions
Date: Sun,  7 Dec 2014 23:40:42 +0100
Message-ID: <1417992042-20553-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>
Cc: Rickard Strandqvist <rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Removes some functions that are not used anywhere:
trace_log_outdent() trace_log_indent()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>
---
 tools/testing/selftests/powerpc/pmu/ebb/trace.c |   26 -----------------------
 tools/testing/selftests/powerpc/pmu/ebb/trace.h |    2 --
 2 files changed, 28 deletions(-)

diff --git a/tools/testing/selftests/powerpc/pmu/ebb/trace.c b/tools/testing/selftests/powerpc/pmu/ebb/trace.c
index 251e66a..2b18b22 100644
--- a/tools/testing/selftests/powerpc/pmu/ebb/trace.c
+++ b/tools/testing/selftests/powerpc/pmu/ebb/trace.c
@@ -139,32 +139,6 @@ int trace_log_string(struct trace_buffer *tb, char *str)
 	return 0;
 }
 
-int trace_log_indent(struct trace_buffer *tb)
-{
-	struct trace_entry *e;
-
-	e = trace_alloc_entry(tb, 0);
-	if (!e)
-		return -ENOSPC;
-
-	e->type = TRACE_TYPE_INDENT;
-
-	return 0;
-}
-
-int trace_log_outdent(struct trace_buffer *tb)
-{
-	struct trace_entry *e;
-
-	e = trace_alloc_entry(tb, 0);
-	if (!e)
-		return -ENOSPC;
-
-	e->type = TRACE_TYPE_OUTDENT;
-
-	return 0;
-}
-
 static void trace_print_header(int seq, int prefix)
 {
 	printf("%*s[%d]: ", prefix, "", seq);
diff --git a/tools/testing/selftests/powerpc/pmu/ebb/trace.h b/tools/testing/selftests/powerpc/pmu/ebb/trace.h
index 926458e..6c436d7 100644
--- a/tools/testing/selftests/powerpc/pmu/ebb/trace.h
+++ b/tools/testing/selftests/powerpc/pmu/ebb/trace.h
@@ -33,8 +33,6 @@ struct trace_buffer *trace_buffer_allocate(u64 size);
 int trace_log_reg(struct trace_buffer *tb, u64 reg, u64 value);
 int trace_log_counter(struct trace_buffer *tb, u64 value);
 int trace_log_string(struct trace_buffer *tb, char *str);
-int trace_log_indent(struct trace_buffer *tb);
-int trace_log_outdent(struct trace_buffer *tb);
 void trace_buffer_print(struct trace_buffer *tb);
 void trace_print_location(struct trace_buffer *tb);
 
-- 
1.7.10.4
