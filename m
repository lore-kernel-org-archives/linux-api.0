From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [REVIEW][PATCH 2/6] signal: Fail sigqueueinfo if si_signo != sig
Date: Tue, 25 Sep 2018 19:19:02 +0200
Message-ID: <20180925171906.19683-2-ebiederm@xmission.com>
References: <87h8idv6nw.fsf@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87h8idv6nw.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, linux-arch@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

The kernel needs to validate that the contents of struct siginfo make
sense as siginfo is copied into the kernel, so that the proper union
members can be put in the appropriate locations.  The field si_signo
is a fundamental part of that validation.  As such changing the
contents of si_signo after the validation make no sense and can result
in nonsense values in the kernel.

As such simply fail if someone is silly enough to set si_signo out of
sync with the signal number passed to sigqueueinfo.

I don't expect a problem as glibc's sigqueue implementation sets
"si_signo = sig" and CRIU just returns to the kernel what the kernel
gave to it.

If there is some application that calls sigqueueinfo directly that has
a problem with this added sanity check we can revisit this when we see
what kind of crazy that application is doing.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/signal.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 7b49c31d3fdb..e445b0a63faa 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3306,7 +3306,8 @@ static int do_rt_sigqueueinfo(pid_t pid, int sig, siginfo_t *info)
 	    (task_pid_vnr(current) != pid))
 		return -EPERM;
 
-	info->si_signo = sig;
+	if (info->si_signo != sig)
+		return -EINVAL;
 
 	/* POSIX.1b doesn't mention process groups.  */
 	return kill_proc_info(sig, info, pid);
@@ -3354,7 +3355,8 @@ static int do_rt_tgsigqueueinfo(pid_t tgid, pid_t pid, int sig, siginfo_t *info)
 	    (task_pid_vnr(current) != pid))
 		return -EPERM;
 
-	info->si_signo = sig;
+	if (info->si_signo != sig)
+		return -EINVAL;
 
 	return do_send_specific(tgid, pid, sig, info);
 }
-- 
2.17.1
