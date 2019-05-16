From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v1 1/2] pid: add pidfd_open()
Date: Thu, 16 May 2019 17:29:16 +0200
Message-ID: <20190516152915.3t2wofeu3xsyhfbd@brauner.io>
References: <20190516135944.7205-1-christian@brauner.io>
 <20190516142659.GB22564@redhat.com>
 <20190516145607.j43xyj26k6l5vmbd@yavin>
 <20190516150611.GC22564@redhat.com>
 <20190516151202.hrawrx7hxllmz2di@yavin>
 <20190516152252.GD22564@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190516152252.GD22564@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>, jannh@google.com, viro@zeniv.linux.org.uk, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, arnd@arndb.de, akpm@linux-foundation.org, dhowells@redhat.com, ebiederm@xmission.com, elena.reshetova@intel.com, keescook@chromium.org, luto@amacapital.net, luto@kernel.org, tglx@linutronix.de, linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, linux-xtensa@linux-xtensa.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-kselftest@vger.kernel.org, joel@joelfernandes.org, dancol@goo
List-Id: linux-api@vger.kernel.org

On Thu, May 16, 2019 at 05:22:53PM +0200, Oleg Nesterov wrote:
> On 05/17, Aleksa Sarai wrote:
> >
> > On 2019-05-16, Oleg Nesterov <oleg@redhat.com> wrote:
> > > On 05/17, Aleksa Sarai wrote:
> > > > On 2019-05-16, Oleg Nesterov <oleg@redhat.com> wrote:
> > > > > On 05/16, Christian Brauner wrote:
> > > > > > With the introduction of pidfds through CLONE_PIDFD it is possible to
> > > > > > created pidfds at process creation time.
> > > > >
> > > > > Now I am wondering why do we need CLONE_PIDFD, you can just do
> > > > >
> > > > > 	pid = fork();
> > > > > 	pidfd_open(pid);
> > > >
> > > > While the race window would be exceptionally short, there is the
> > > > possibility that the child will die
> > >
> > > Yes,
> > >
> > > > and their pid will be recycled
> > > > before you do pidfd_open().
> > >
> > > No.
> > >
> > > Unless the caller's sub-thread does wait() before pidfd_open(), of course.
> > > Or unless you do signal(SIGCHILD, SIG_IGN).
> >
> > What about CLONE_PARENT?
> 
> I should have mentioned CLONE_PARENT ;)
> 
> Of course in this case the child can be reaped before pidfd_open(). But how often
> do you or other people use clone(CLONE_PARENT) ? not to mention you can trivially
> eliminate/detect this race if you really need this.
> 
> Don't get me wrong, I am not trying to say that CLONE_PIDFD is a bad idea.
> 
> But to me pidfd_open() is much more useful. Say, as a perl programmer I can easily
> use pidfd_open(), but not CLONE_PIDFD.

Right, but for a libc, service- or container manager CLONE_PIDFD is much
nicer when spawning processes quickly. :) I think both are very good to
have.

Thanks, Oleg. As always super helpful reviews. :)
Christian
