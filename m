From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH v8 1/2] seccomp: add a return code to trap to userspace
Date: Tue, 30 Oct 2018 09:54:03 -0600
Message-ID: <20181030155403.GC7343@cisco>
References: <20181029224031.29809-1-tycho@tycho.ws>
 <20181029224031.29809-2-tycho@tycho.ws>
 <20181030150254.GB3385@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181030150254.GB3385@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian@brauner.io>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Aleksa Sarai <asarai@suse.de>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Oct 30, 2018 at 04:02:54PM +0100, Oleg Nesterov wrote:
> On 10/29, Tycho Andersen wrote:
> >
> > +static long seccomp_notify_recv(struct seccomp_filter *filter,
> > +				void __user *buf)
> > +{
> > +	struct seccomp_knotif *knotif = NULL, *cur;
> > +	struct seccomp_notif unotif;
> > +	ssize_t ret;
> > +
> > +	memset(&unotif, 0, sizeof(unotif));
> > +
> > +	ret = down_interruptible(&filter->notif->request);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	mutex_lock(&filter->notify_lock);
> > +	list_for_each_entry(cur, &filter->notif->notifications, list) {
> > +		if (cur->state == SECCOMP_NOTIFY_INIT) {
> > +			knotif = cur;
> > +			break;
> > +		}
> > +	}
> > +
> > +	/*
> > +	 * If we didn't find a notification, it could be that the task was
> > +	 * interrupted by a fatal signal between the time we were woken and
> > +	 * when we were able to acquire the rw lock.
> > +	 *
> > +	 * This is the place where we handle the extra high semaphore count
> > +	 * mentioned in seccomp_do_user_notification().
> > +	 */
> > +	if (!knotif) {
> > +		ret = -ENOENT;
> > +		goto out;
> > +	}
> > +
> > +	unotif.id = knotif->id;
> > +	unotif.pid = task_pid_vnr(knotif->task);
> > +	if (knotif->signaled)
> > +		unotif.flags |= SECCOMP_NOTIF_FLAG_SIGNALED;
> > +	unotif.data = *(knotif->data);
> 
> Tycho, I forgot everything about seccomp, most probably I am wrong but let me
> ask anyway.
> 
> __seccomp_filter(SECCOMP_RET_TRACE) does
> 
> 		/*
> 		 * Recheck the syscall, since it may have changed. This
> 		 * intentionally uses a NULL struct seccomp_data to force
> 		 * a reload of all registers. This does not goto skip since
> 		 * a skip would have already been reported.
> 		 */
> 		if (__seccomp_filter(this_syscall, NULL, true))
> 			return -1;
> 
> and the next seccomp_run_filters() can return SECCOMP_RET_USER_NOTIF, right?
> seccomp_do_user_notification() doesn't check recheck_after_trace and it simply
> does n.data = sd.
> 
> Doesn't this mean that "unotif.data = *(knotif->data)" can hit NULL ?
> 
> seccomp_run_filters() does populate_seccomp_data() in this case, but this
> won't affect "seccomp_data *sd" passed to seccomp_do_user_notification().

Oof, yes, you're right. Seems like there are no other users of sd in
__seccomp_filter(). Seems to me like we can just do the
populate_seccomp_data() one level higher in __seccomp_filter()?

Tycho


>From 9e0f75ea51a2c328567910df3122a236ebeccab0 Mon Sep 17 00:00:00 2001
From: Tycho Andersen <tycho@tycho.ws>
Date: Tue, 30 Oct 2018 09:51:14 -0600
Subject: [PATCH] seccomp: hoist struct seccomp_data recalculation higher

Signed-off-by: Tycho Andersen <tycho@tycho.ws>
---
 kernel/seccomp.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 4c5fb6ced4cd..1525cb753ad2 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -257,7 +257,6 @@ static int seccomp_check_filter(struct sock_filter *filter, unsigned int flen)
 static u32 seccomp_run_filters(const struct seccomp_data *sd,
 			       struct seccomp_filter **match)
 {
-	struct seccomp_data sd_local;
 	u32 ret = SECCOMP_RET_ALLOW;
 	/* Make sure cross-thread synced filter points somewhere sane. */
 	struct seccomp_filter *f =
@@ -267,11 +266,6 @@ static u32 seccomp_run_filters(const struct seccomp_data *sd,
 	if (unlikely(WARN_ON(f == NULL)))
 		return SECCOMP_RET_KILL_PROCESS;
 
-	if (!sd) {
-		populate_seccomp_data(&sd_local);
-		sd = &sd_local;
-	}
-
 	/*
 	 * All filters in the list are evaluated and the lowest BPF return
 	 * value always takes priority (ignoring the DATA).
@@ -821,6 +815,7 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
 	u32 filter_ret, action;
 	struct seccomp_filter *match = NULL;
 	int data;
+	struct seccomp_data sd_local;
 
 	/*
 	 * Make sure that any changes to mode from another thread have
@@ -828,6 +823,11 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
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
2.17.1
