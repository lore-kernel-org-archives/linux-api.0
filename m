From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v8 1/2] seccomp: add a return code to trap to userspace
Date: Tue, 30 Oct 2018 16:02:54 +0100
Message-ID: <20181030150254.GB3385@redhat.com>
References: <20181029224031.29809-1-tycho@tycho.ws>
 <20181029224031.29809-2-tycho@tycho.ws>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181029224031.29809-2-tycho@tycho.ws>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian@brauner.io>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Aleksa Sarai <asarai@suse.de>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 10/29, Tycho Andersen wrote:
>
> +static long seccomp_notify_recv(struct seccomp_filter *filter,
> +				void __user *buf)
> +{
> +	struct seccomp_knotif *knotif = NULL, *cur;
> +	struct seccomp_notif unotif;
> +	ssize_t ret;
> +
> +	memset(&unotif, 0, sizeof(unotif));
> +
> +	ret = down_interruptible(&filter->notif->request);
> +	if (ret < 0)
> +		return ret;
> +
> +	mutex_lock(&filter->notify_lock);
> +	list_for_each_entry(cur, &filter->notif->notifications, list) {
> +		if (cur->state == SECCOMP_NOTIFY_INIT) {
> +			knotif = cur;
> +			break;
> +		}
> +	}
> +
> +	/*
> +	 * If we didn't find a notification, it could be that the task was
> +	 * interrupted by a fatal signal between the time we were woken and
> +	 * when we were able to acquire the rw lock.
> +	 *
> +	 * This is the place where we handle the extra high semaphore count
> +	 * mentioned in seccomp_do_user_notification().
> +	 */
> +	if (!knotif) {
> +		ret = -ENOENT;
> +		goto out;
> +	}
> +
> +	unotif.id = knotif->id;
> +	unotif.pid = task_pid_vnr(knotif->task);
> +	if (knotif->signaled)
> +		unotif.flags |= SECCOMP_NOTIF_FLAG_SIGNALED;
> +	unotif.data = *(knotif->data);

Tycho, I forgot everything about seccomp, most probably I am wrong but let me
ask anyway.

__seccomp_filter(SECCOMP_RET_TRACE) does

		/*
		 * Recheck the syscall, since it may have changed. This
		 * intentionally uses a NULL struct seccomp_data to force
		 * a reload of all registers. This does not goto skip since
		 * a skip would have already been reported.
		 */
		if (__seccomp_filter(this_syscall, NULL, true))
			return -1;

and the next seccomp_run_filters() can return SECCOMP_RET_USER_NOTIF, right?
seccomp_do_user_notification() doesn't check recheck_after_trace and it simply
does n.data = sd.

Doesn't this mean that "unotif.data = *(knotif->data)" can hit NULL ?

seccomp_run_filters() does populate_seccomp_data() in this case, but this
won't affect "seccomp_data *sd" passed to seccomp_do_user_notification().

Oleg.
