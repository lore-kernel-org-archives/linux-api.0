From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v8 1/2] seccomp: add a return code to trap to userspace
Date: Thu, 1 Nov 2018 14:40:02 +0100
Message-ID: <20181101134001.GA23232@redhat.com>
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
> +static struct file *init_listener(struct seccomp_filter *filter)
> +{
> +	struct file *ret = ERR_PTR(-EBUSY);
> +	struct seccomp_filter *cur, *last_locked = NULL;
> +	int filter_nesting = 0;
> +
> +	for (cur = current->seccomp.filter; cur; cur = cur->prev) {
> +		mutex_lock_nested(&cur->notify_lock, filter_nesting);
> +		filter_nesting++;
> +		last_locked = cur;
> +		if (cur->notif)
> +			goto out;
> +	}

Somehow I no longer understand why do you need to take all locks. Isn't
the first filter's notify_lock enough? IOW,

		for (cur = current->seccomp.filter; cur; cur = cur->prev) {
			if (cur->notif)
				return ERR_PTR(-EBUSY);
			first = cur;
		}

		if (first)
			mutex_lock(&first->notify_lock);

		... initialize filter->notif ...

	out:
		if (first)
			mutex_unlock(&first->notify_lock);

		return ret;

Oleg.
