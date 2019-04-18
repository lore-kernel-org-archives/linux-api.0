From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v1 2/4] clone: add CLONE_PIDFD
Date: Thu, 18 Apr 2019 11:36:30 +0200
Message-ID: <20190418093629.6fshxhambc2zzjdk@brauner.io>
References: <20190416170233.10208-1-christian@brauner.io>
 <20190416170233.10208-3-christian@brauner.io>
 <20190417142253.GH32622@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190417142253.GH32622@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, jannh@google.com, dhowells@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, serge@hallyn.com, luto@kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, tglx@linutronix.de, mtk.manpages@gmail.com, akpm@linux-foundation.org, cyphar@cyphar.com, joel@joelfernandes.org, dancol@google.com
List-Id: linux-api@vger.kernel.org

On Wed, Apr 17, 2019 at 04:22:54PM +0200, Oleg Nesterov wrote:
> On 04/16, Christian Brauner wrote:
> >
> > +	if (clone_flags & CLONE_PIDFD) {
> > +		retval = pidfd_create(pid, &pidfdf);
> > +		if (retval < 0)
> > +			goto bad_fork_free_pid;
> > +		pidfd = retval;
> > +	}
> 
> ...
> 
> > +	if (clone_flags & CLONE_PIDFD) {
> > +		fd_install(pidfd, pidfdf);
> > +		put_user(pidfd, parent_tidptr);
> 
> put_user() can fail, I don't think this error should be silently ignored,
> this can lead to the hard-to-trigger/debug problems.
> 
> Why can't we do put_user-with-check along with pidfd_create() above?

I've moved put_user() right were pidfd_create() is called but I think
then it makes sense to change pidfd_create() to also do the fd_install()
such that the following sequence creates the pidfd, installs it, and
calls put_user() and calls ksys_close() on error. Any objections Oleg?

+       if (clone_flags & CLONE_PIDFD) {
+               retval = pidfd_create(pid);
+               if (retval < 0)
+                       goto bad_fork_free_pid;
+
+               pidfd = retval;
+               retval = put_user(pidfd, parent_tidptr);
+               if (retval)
+                       goto bad_fork_put_pidfd;
+       }

Christian
