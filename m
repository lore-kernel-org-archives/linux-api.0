From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v8 1/2] seccomp: add a return code to trap to userspace
Date: Thu, 1 Nov 2018 14:56:34 +0100
Message-ID: <20181101135633.GB23232@redhat.com>
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
> +static int seccomp_notify_release(struct inode *inode, struct file *file)
> +{
> +	struct seccomp_filter *filter = file->private_data;
> +	struct seccomp_knotif *knotif;
> +
> +	mutex_lock(&filter->notify_lock);
> +
> +	/*
> +	 * If this file is being closed because e.g. the task who owned it
> +	 * died, let's wake everyone up who was waiting on us.
> +	 */
> +	list_for_each_entry(knotif, &filter->notif->notifications, list) {
> +		if (knotif->state == SECCOMP_NOTIFY_REPLIED)
> +			continue;
> +
> +		knotif->state = SECCOMP_NOTIFY_REPLIED;
> +		knotif->error = -ENOSYS;
> +		knotif->val = 0;
> +
> +		complete(&knotif->ready);
> +	}
> +
> +	wake_up_all(&filter->notif->wqh);

Why? __fput() is not possible if there is another user of this file sleeping
in seccomp_notify_poll().

> +	kfree(filter->notif);

Hmm, this looks wrong... we can't kfree ->notif if its ->notifications list
is not empty, otherwise seccomp_do_user_notification()->list_del(&n.list)
can write to the freed memory.

I think _release() should do list_for_each_entry_safe() + list_del_init()
and seccomp_do_user_notification() should use list_del_init() too.

Or, simpler, seccomp_do_user_notification() should do

	if (!match->notif)
		goto out;

instead of "goto remove_list".

Oleg.
