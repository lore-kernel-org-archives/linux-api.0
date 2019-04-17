From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v1 2/4] clone: add CLONE_PIDFD
Date: Wed, 17 Apr 2019 16:28:12 +0200
Message-ID: <20190417142811.dq75bzkubtaixdyr@brauner.io>
References: <20190416170233.10208-1-christian@brauner.io>
 <20190416170233.10208-3-christian@brauner.io>
 <20190417142253.GH32622@redhat.com>
 <20190417142551.lhufsdffqrih3jsp@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190417142551.lhufsdffqrih3jsp@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, jannh@google.com, dhowells@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, serge@hallyn.com, luto@kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, tglx@linutronix.de, mtk.manpages@gmail.com, akpm@linux-foundation.org, cyphar@cyphar.com, joel@joelfernandes.org, dancol@google.com
List-Id: linux-api@vger.kernel.org

On Wed, Apr 17, 2019 at 04:25:51PM +0200, Christian Brauner wrote:
> On Wed, Apr 17, 2019 at 04:22:54PM +0200, Oleg Nesterov wrote:
> > On 04/16, Christian Brauner wrote:
> > >
> > > +	if (clone_flags & CLONE_PIDFD) {
> > > +		retval = pidfd_create(pid, &pidfdf);
> > > +		if (retval < 0)
> > > +			goto bad_fork_free_pid;
> > > +		pidfd = retval;
> > > +	}
> > 
> > ...
> > 
> > > +	if (clone_flags & CLONE_PIDFD) {
> > > +		fd_install(pidfd, pidfdf);
> > > +		put_user(pidfd, parent_tidptr);
> > 
> > put_user() can fail, I don't think this error should be silently ignored,

Fwiw, the same is currently done for PARENT_SETTID which seems odd as
well...
