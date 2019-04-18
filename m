From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2 2/5] clone: add CLONE_PIDFD
Date: Thu, 18 Apr 2019 15:12:07 +0200
Message-ID: <20190418131206.GB13701@redhat.com>
References: <20190418101841.4476-1-christian@brauner.io>
 <20190418101841.4476-3-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190418101841.4476-3-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, jannh@google.com, dhowells@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, serge@hallyn.com, luto@kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, tglx@linutronix.de, mtk.manpages@gmail.com, akpm@linux-foundation.org, cyphar@cyphar.com, joel@joelfernandes.org, dancol@google.com
List-Id: linux-api@vger.kernel.org

On 04/18, Christian Brauner wrote:
>
> @@ -1674,13 +1729,14 @@ static __latent_entropy struct task_struct *copy_process(
>  					unsigned long clone_flags,
>  					unsigned long stack_start,
>  					unsigned long stack_size,
> +					int __user *parent_tidptr,
>  					int __user *child_tidptr,
>  					struct pid *pid,
>  					int trace,
>  					unsigned long tls,
>  					int node)
>  {
> -	int retval;
> +	int pidfd = -1, retval;

it seems that initialization is unneeded, but this is cosmetic.

I see no technical problems, feel free to add my reviewed-by.


But let me ask a couple of questions...


Why O_CLOEXEC? I am just curious, I do not really care.


Should we allow CLONE_THREAD | CLONE_PIDFD ?


Are you sure we will never need to extend this interface? If not, then perhaps it
make sense to add something like

	if (CLONE_PIDFD) {
		unsigned long not_used_yet;
		if (get_user(not_used_yet, parent_tidptr) ||
		    not_used_yet != 0)
			return -EINVAL;
	}

this way we can easily add more arguments in future or even turn CLONE_PIDFD into
CLONE_MORE_ARGS_IN_PARENT_TIDPTR.

Not that I think this is really good idea, sys_clone2() makes more sense, but still.

Oleg.
