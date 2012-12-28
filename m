From: Andrey Vagin <avagin@openvz.org>
Subject: [PATCH 1/3] signal: allow to send any siginfo to itself
Date: Fri, 28 Dec 2012 14:22:59 +0400
Message-ID: <1356690181-1796-2-git-send-email-avagin@openvz.org>
References: <1356690181-1796-1-git-send-email-avagin@openvz.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1356690181-1796-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: criu@openvz.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Andrey Vagin <avagin@openvz.org>, Oleg Nesterov <oleg@redhat.com>, Serge Hallyn <serge.hallyn@canonical.com>, Andrew Morton <akpm@linux-foundation.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Al Viro <viro@zeniv.linux.org.uk>, Michael Kerrisk <mtk.manpages@gmail.com>, Pavel Emelyanov <xemul@parallels.com>, Cyrill Gorcunov <gorcunov@openvz.org>
List-Id: linux-api@vger.kernel.org

A kernel prevents of sending siginfo with positive si_code, because
these codes is reserved for kernel. I think we can allow to send any
siginfo to itself. This operation should not be dangerous.

This functionality is required for restoring signals.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
CC: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 kernel/signal.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 7aaa51d..ac5f5e7 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2944,7 +2944,8 @@ SYSCALL_DEFINE3(rt_sigqueueinfo, pid_t, pid, int, sig,
 	/* Not even root can pretend to send signals from the kernel.
 	 * Nor can they impersonate a kill()/tgkill(), which adds source info.
 	 */
-	if (info.si_code >= 0 || info.si_code == SI_TKILL) {
+	if (((info.si_code >= 0 || info.si_code == SI_TKILL)) &&
+	    (task_pid_vnr(current) != pid)) {
 		/* We used to allow any < 0 si_code */
 		WARN_ON_ONCE(info.si_code < 0);
 		return -EPERM;
@@ -2964,7 +2965,8 @@ long do_rt_tgsigqueueinfo(pid_t tgid, pid_t pid, int sig, siginfo_t *info)
 	/* Not even root can pretend to send signals from the kernel.
 	 * Nor can they impersonate a kill()/tgkill(), which adds source info.
 	 */
-	if (info->si_code >= 0 || info->si_code == SI_TKILL) {
+	if ((info->si_code >= 0 || info->si_code == SI_TKILL) &&
+	    (task_pid_vnr(current) != pid)) {
 		/* We used to allow any < 0 si_code */
 		WARN_ON_ONCE(info->si_code < 0);
 		return -EPERM;
-- 
1.7.11.7
