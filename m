From: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 5/7] signal/testing: Don't look for __SI_FAULT in userspace
Date: Tue, 18 Jul 2017 09:06:49 -0500
Message-ID: <20170718140651.15973-5-ebiederm@xmission.com>
References: <87o9shg7t7.fsf_-_@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <87o9shg7t7.fsf_-_-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Andrei Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Willy Tarreau <w@1wt.eu>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Fix the debug print statements in these tests where they reference
si_codes and in particular __SI_FAULT.  __SI_FAULT is a kernel
internal value and should never be seen by userspace.

While I am in there also fix si_code_str.  si_codes are an enumeration
there are not a bitmap so == and not & is the apropriate operation to
test for an si_code.

Cc: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Fixes: 5f23f6d082a9 ("x86/pkeys: Add self-tests")
Fixes: e754aedc26ef ("x86/mpx, selftests: Add MPX self test")
Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 tools/testing/selftests/x86/mpx-mini-test.c   |  3 +--
 tools/testing/selftests/x86/protection_keys.c | 13 ++++++-------
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/x86/mpx-mini-test.c b/tools/testing/selftests/x86/mpx-mini-test.c
index a8df159a8924..ec0f6b45ce8b 100644
--- a/tools/testing/selftests/x86/mpx-mini-test.c
+++ b/tools/testing/selftests/x86/mpx-mini-test.c
@@ -391,8 +391,7 @@ void handler(int signum, siginfo_t *si, void *vucontext)
 		br_count++;
 		dprintf1("#BR 0x%jx (total seen: %d)\n", status, br_count);
 
-#define __SI_FAULT      (3 << 16)
-#define SEGV_BNDERR     (__SI_FAULT|3)  /* failed address bound checks */
+#define SEGV_BNDERR     3  /* failed address bound checks */
 
 		dprintf2("Saw a #BR! status 0x%jx at %016lx br_reason: %jx\n",
 				status, ip, br_reason);
diff --git a/tools/testing/selftests/x86/protection_keys.c b/tools/testing/selftests/x86/protection_keys.c
index 3237bc010e1c..23927845518d 100644
--- a/tools/testing/selftests/x86/protection_keys.c
+++ b/tools/testing/selftests/x86/protection_keys.c
@@ -212,19 +212,18 @@ void dump_mem(void *dumpme, int len_bytes)
 	}
 }
 
-#define __SI_FAULT      (3 << 16)
-#define SEGV_BNDERR     (__SI_FAULT|3)  /* failed address bound checks */
-#define SEGV_PKUERR     (__SI_FAULT|4)
+#define SEGV_BNDERR     3  /* failed address bound checks */
+#define SEGV_PKUERR     4
 
 static char *si_code_str(int si_code)
 {
-	if (si_code & SEGV_MAPERR)
+	if (si_code == SEGV_MAPERR)
 		return "SEGV_MAPERR";
-	if (si_code & SEGV_ACCERR)
+	if (si_code == SEGV_ACCERR)
 		return "SEGV_ACCERR";
-	if (si_code & SEGV_BNDERR)
+	if (si_code == SEGV_BNDERR)
 		return "SEGV_BNDERR";
-	if (si_code & SEGV_PKUERR)
+	if (si_code == SEGV_PKUERR)
 		return "SEGV_PKUERR";
 	return "UNKNOWN";
 }
-- 
2.10.1
