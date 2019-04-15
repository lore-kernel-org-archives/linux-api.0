From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH 2/4] clone: add CLONE_PIDFD
Date: Mon, 15 Apr 2019 13:42:06 +0200
Message-ID: <20190415114204.ydczeuwmi74wfsuv@brauner.io>
References: <20190414201436.19502-1-christian@brauner.io>
 <20190414201436.19502-3-christian@brauner.io>
 <20190415105209.GA22204@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190415105209.GA22204@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, jannh@google.com, dhowells@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, serge@hallyn.com, luto@kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, tglx@linutronix.de, mtk.manpages@gmail.com, akpm@linux-foundation.org, cyphar@cyphar.com, joel@joelfernandes.org, dancol@google.com
List-Id: linux-api@vger.kernel.org

On Mon, Apr 15, 2019 at 12:52:09PM +0200, Oleg Nesterov wrote:
> On 04/14, Christian Brauner wrote:
> >
> > @@ -2260,6 +2363,10 @@ long _do_fork(unsigned long clone_flags,
> >  	}
> >
> >  	put_pid(pid);
> > +
> > +	if (clone_flags & CLONE_PIDFD)
> > +		nr = pidfd;
> > +
> 
> Well, this doesn't look nice ...
> 
> CLONE_PARENT_SETTID doesn't look very usefule, so what if we add
> 
> 	if ((clone_flags & (CLONE_PIDFD|CLONE_PARENT_SETTID)) ==
> 	                   (CLONE_PIDFD|CLONE_PARENT_SETTID))
> 		return ERR_PTR(-EINVAL);
> 
> at the start of copy_process() ?
> 
> Then it can do
> 
> 	if (clone_flags & CLONE_PIDFD) {
> 		retval = pidfd_create(pid, &pidfdf);
> 		if (retval < 0)
> 			goto bad_fork_free_pid;
> 		retval = put_user(retval, parent_tidptr)
> 		if (retval < 0)
> 			goto bad_fork_free_pid;
> 	}

Uhhh Oleg, that is nifty. I have to say I like that a lot. This would
let us return the pid and the pidfd in one go and we can also start
pidfd numbering at 0.
