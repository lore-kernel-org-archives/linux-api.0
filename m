From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH v7 2/2] selftests: add tests for pidfd_send_signal()
Date: Tue, 8 Jan 2019 11:25:54 -0700
Message-ID: <20190108182554.GB28330@cisco>
References: <20190102161654.9093-1-christian@brauner.io>
 <20190102161654.9093-2-christian@brauner.io>
 <20190108175306.GF29009@cisco>
 <20190108175415.GA22353@mail.hallyn.com>
 <20190108175843.GA26016@cisco>
 <20190108181742.GA22614@mail.hallyn.com>
 <20190108182023.GA28330@cisco>
 <20190108182444.e6kq2gqftde23jou@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190108182444.e6kq2gqftde23jou@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, luto@kernel.org, arnd@arndb.de, keescook@chromium.org, akpm@linux-foundation.org, jannh@google.com, oleg@redhat.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, dancol@google.com, timmurray@google.com, fweimer@redhat.com, tglx@linutronix.de, x86@kernel.org, ebiederm@xmission.com
List-Id: linux-api@vger.kernel.org

On Tue, Jan 08, 2019 at 07:24:46PM +0100, Christian Brauner wrote:
> On Tue, Jan 08, 2019 at 11:20:23AM -0700, Tycho Andersen wrote:
> > On Tue, Jan 08, 2019 at 12:17:42PM -0600, Serge E. Hallyn wrote:
> > > On Tue, Jan 08, 2019 at 10:58:43AM -0700, Tycho Andersen wrote:
> > > > On Tue, Jan 08, 2019 at 11:54:15AM -0600, Serge E. Hallyn wrote:
> > > > > On Tue, Jan 08, 2019 at 10:53:06AM -0700, Tycho Andersen wrote:
> > > > > > On Wed, Jan 02, 2019 at 05:16:54PM +0100, Christian Brauner wrote:
> > > > > > > +			/*
> > > > > > > +			 * Stop the child so we can inspect whether we have
> > > > > > > +			 * recycled pid PID_RECYCLE.
> > > > > > > +			 */
> > > > > > > +			close(pipe_fds[0]);
> > > > > > > +			ret = kill(recycled_pid, SIGSTOP);
> > > > > > > +			close(pipe_fds[1]);
> > > > > > > +			if (ret) {
> > > > > > > +				(void)wait_for_pid(recycled_pid);
> > > > > > > +				_exit(PIDFD_ERROR);
> > > > > > > +			}
> > > > > > 
> > > > > > Sorry for being late to the party, but I wonder if this whole thing
> > > > > > couldn't be simplified with /proc/sys/kenrel/ns_last_pid?
> > > > > 
> > > > > no, bc it's not namespaced :)
> > > > 
> > > > Huh? It looks like it is...
> > > > 
> > > > static int pid_ns_ctl_handler(struct ctl_table *table, int write,
> > > >                 void __user *buffer, size_t *lenp, loff_t *ppos)
> > > > {
> > > >         struct pid_namespace *pid_ns = task_active_pid_ns(current);
> > > >         struct ctl_table tmp = *table;
> > > >         int ret, next;
> > > > 
> > > >         if (write && !ns_capable(pid_ns->user_ns, CAP_SYS_ADMIN))
> > > >                 return -EPERM;
> > > > 
> > > >         ...
> > > 
> > > Oh - hah, but that's ns_last_pid.  You'd want pid_max.  And that one
> > > is not namespaced.
> > 
> > Perhaps I'm misunderstanding, but isn't the point of all this code to
> > get the same pid again? So can't we just fork(), kill(), then set
> > ns_last_pid to pid-1, and fork() again to re-use?
> 
> Maybe. It's just a selftest that works reliably as it is so unless
> there's a technical issue with the patch I'm not going to do another
> version just because of that unless people feel super strongly about
> this.
> Another advantage is that the code we have right now works even when
> CONFIG_CHECKPOINT_RESTORE is not selected.

No, it's fine as is. Just a lot less code if we do it the other way.

Cheers,

Tycho
