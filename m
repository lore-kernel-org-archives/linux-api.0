From: Tycho Andersen <tycho@tycho.ws>
Subject: [PATCH v10 1/4] seccomp: hoist struct seccomp_data recalculation higher
Date: Sun,  9 Dec 2018 11:24:11 -0700
Message-ID: <20181209182414.30862-2-tycho@tycho.ws>
References: <20181209182414.30862-1-tycho@tycho.ws>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181209182414.30862-1-tycho@tycho.ws>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian@brauner.io>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Aleksa Sarai <asarai@suse.de>, Jann Horn <jannh@google.com>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Tycho Andersen <tycho@tycho.ws>
List-Id: linux-api@vger.kernel.org

In the next patch, we're going to use the sd pointer passed to
__seccomp_filter() as the data to pass to userspace. Except that in some
cases (__seccomp_filter(SECCOMP_RET_TRACE), emulate_vsyscall(), every time
seccomp is inovked on power, etc.) the sd pointer will be NULL in order to
force seccomp to recompute the register data. Previously this recomputation
happened one level lower, in seccomp_run_filters(); this patch just moves
it up a level higher to __seccomp_filter().

Thanks Oleg for spotting this.

Signed-off-by: Tycho Andersen <tycho@tycho.ws>
CC: Kees Cook <keescook@chromium.org>
CC: Andy Lutomirski <luto@amacapital.net>
CC: Oleg Nesterov <oleg@redhat.com>
CC: Eric W. Biederman <ebiederm@xmission.com>
CC: "Serge E. Hallyn" <serge@hallyn.com>
Acked-by: Serge Hallyn <serge@hallyn.com>
CC: Christian Brauner <christian@brauner.io>
CC: Tyler Hicks <tyhicks@canonical.com>
CC: Akihiro Suda <suda.akihiro@lab.ntt.co.jp>
---
 kernel/seccomp.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index f2ae2324c232..96afc32e041d 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -188,7 +188,6 @@ static int seccomp_check_filter(struct sock_filter *filter, unsigned int flen)
 static u32 seccomp_run_filters(const struct seccomp_data *sd,
 			       struct seccomp_filter **match)
 {
-	struct seccomp_data sd_local;
 	u32 ret = SECCOMP_RET_ALLOW;
 	/* Make sure cross-thread synced filter points somewhere sane. */
 	struct seccomp_filter *f =
@@ -198,11 +197,6 @@ static u32 seccomp_run_filters(const struct seccomp_data *sd,
 	if (WARN_ON(f == NULL))
 		return SECCOMP_RET_KILL_PROCESS;
 
-	if (!sd) {
-		populate_seccomp_data(&sd_local);
-		sd = &sd_local;
-	}
-
 	/*
 	 * All filters in the list are evaluated and the lowest BPF return
 	 * value always takes priority (ignoring the DATA).
@@ -658,6 +652,7 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
 	u32 filter_ret, action;
 	struct seccomp_filter *match = NULL;
 	int data;
+	struct seccomp_data sd_local;
 
 	/*
 	 * Make sure that any changes to mode from another thread have
@@ -665,6 +660,11 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
 	 */
 	rmb();
 
+	if (!sd) {
+		populate_seccomp_data(&sd_local);
+		sd = &sd_local;
+	}
+
 	filter_ret = seccomp_run_filters(sd, &match);
 	data = filter_ret & SECCOMP_RET_DATA;
 	action = filter_ret & SECCOMP_RET_ACTION_FULL;
-- 
2.19.1
