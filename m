From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH v6 2/2] selftests: add tests for pidfd_send_signal()
Date: Tue, 1 Jan 2019 11:02:03 -0600
Message-ID: <20190101170203.GA15661@mail.hallyn.com>
References: <20181229222756.30027-1-christian@brauner.io>
 <20181229222756.30027-2-christian@brauner.io>
 <20181230210245.GA30252@mail.hallyn.com>
 <20181230232711.7aayb7vnhogbv4co@brauner.io>
 <20190101150743.ikrrfcogqec2oqeh@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190101150743.ikrrfcogqec2oqeh@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, luto@kernel.org, arnd@arndb.de, keescook@chromium.org, akpm@linux-foundation.org, jannh@google.com, oleg@redhat.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, dancol@google.com, timmurray@google.com, fweimer@redhat.com, tglx@linutronix.de, x86@kernel.org, ebiederm@xmission.com
List-Id: linux-api@vger.kernel.org

On Tue, Jan 01, 2019 at 04:07:44PM +0100, Christian Brauner wrote:
> On Mon, Dec 31, 2018 at 12:27:13AM +0100, Christian Brauner wrote:
> > On Sun, Dec 30, 2018 at 03:02:45PM -0600, Serge Hallyn wrote:
> > > On Sat, Dec 29, 2018 at 11:27:56PM +0100, Christian Brauner wrote:
> > > > As suggested by Andrew Morton in [1] add selftests for the new
> > > > sys_pidfd_send_signal() syscall.
> > > > This tests whether we can send a signal to an existing process and whether
> > > > sending a signal to a process that has already exited fails with ESRCH.
> > > > 
> > > > [1]: https://lore.kernel.org/lkml/20181228152012.dbf0508c2508138efc5f2bbe@linux-foundation.org/
> > > > 
> > > > Cc: Arnd Bergmann <arnd@arndb.de>
> > > > Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> > > > Cc: Kees Cook <keescook@chromium.org>
> > > > Cc: Serge Hallyn <serge@hallyn.com>
> > > 
> > > Acked-by: Serge Hallyn <serge@hallyn.com>
> > > 
> > > Not saying you need to do this, but it would be neat if you could test
> > > sending to a pid which has been recycled :)
> > 
> > Yeah, I thought about it but it's a little weird code. First of all, we
> > can't set /proc/sys/kernel/pid_max to a very low value since this is a
> > system wide setting. So we need to recycle a lot via fork(). Something
> > along the lines of:
> > - unshare pid namespace
> > - fork to create pid 1 in new pid namespace
> > - cycle with fork() until pid > 300 since pids lower than 300 are
> >   reserved by the kernel.
> >   (That means if we simply use the first fork() after we created pid 1 we
> >   would never be able to recycle the pid since we skip over it. :))
> > - get pidfd to the pid > 300 we just created
> > - wait on the pid > 300
> > - cycle via fork() until we have reached the same pid > 300 again
> > - send SIGSTOP to that recycled process
> > - test that we cannot send SIGCONT to this SIGSTOPed task via the pidfd we
> >   received before
> > - send SIGCONT to the SIGSTOPed recycled pid and exit
> 
> Ok, I have something like this in my tree now that tests for pid
> recycling. I'm going to send it out tomorrow since I reckon Andrew and
> others will be off today.
> But fwiw it sits in https://github.com/brauner/linux/commits/2018-12-02/procfds

Thanks, that shows off the advantages of the new syscall :)

-serge
