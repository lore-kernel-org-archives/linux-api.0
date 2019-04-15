From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/4] clone: add CLONE_PIDFD
Date: Mon, 15 Apr 2019 12:52:09 +0200
Message-ID: <20190415105209.GA22204@redhat.com>
References: <20190414201436.19502-1-christian@brauner.io>
 <20190414201436.19502-3-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190414201436.19502-3-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, jannh@google.com, dhowells@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, serge@hallyn.com, luto@kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, tglx@linutronix.de, mtk.manpages@gmail.com, akpm@linux-foundation.org, cyphar@cyphar.com, joel@joelfernandes.org, dancol@google.com
List-Id: linux-api@vger.kernel.org

On 04/14, Christian Brauner wrote:
>
> @@ -2260,6 +2363,10 @@ long _do_fork(unsigned long clone_flags,
>  	}
>
>  	put_pid(pid);
> +
> +	if (clone_flags & CLONE_PIDFD)
> +		nr = pidfd;
> +

Well, this doesn't look nice ...

CLONE_PARENT_SETTID doesn't look very usefule, so what if we add

	if ((clone_flags & (CLONE_PIDFD|CLONE_PARENT_SETTID)) ==
	                   (CLONE_PIDFD|CLONE_PARENT_SETTID))
		return ERR_PTR(-EINVAL);

at the start of copy_process() ?

Then it can do

	if (clone_flags & CLONE_PIDFD) {
		retval = pidfd_create(pid, &pidfdf);
		if (retval < 0)
			goto bad_fork_free_pid;
		retval = put_user(retval, parent_tidptr)
		if (retval < 0)
			goto bad_fork_free_pid;
	}

Oleg.
