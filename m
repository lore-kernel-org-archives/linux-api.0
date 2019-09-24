From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: For review: pidfd_open(2) manual page
Date: Tue, 24 Sep 2019 09:38:18 +0200
Message-ID: <20190924073817.zb7vr5he4wbibl7j@wittgenstein>
References: <90399dee-53d8-a82c-3871-9ec8f94601ce@gmail.com>
 <87tv939td6.fsf@mid.deneb.enyo.de>
 <63566f1f-667d-50ca-ae85-784924d09af4@gmail.com>
 <874l12924w.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <874l12924w.fsf@mid.deneb.enyo.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fw@deneb.enyo.de>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Jann Horn <jannh@google.com>, Daniel Colascione <dancol@google.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Joel Fernandes <joel@joelfernandes.org>, Linux API <linux-api@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>
List-Id: linux-api@vger.kernel.org

On Mon, Sep 23, 2019 at 10:41:19PM +0200, Florian Weimer wrote:
> * Michael Kerrisk:
> 
> >>>        static
> >>>        int pidfd_open(pid_t pid, unsigned int flags)
> >>>        {
> >>>            return syscall(__NR_pidfd_open, pid, flags);
> >>>        }
> >> 
> >> Please call this function something else (not pidfd_open), so that the
> >> example continues to work if glibc provides the system call wrapper.
> >
> > I figured that if the syscall does get added to glibc, then I would
> > modify the example. In the meantime, this does seem the most natural
> > way of doing things, since the example then uses the real syscall
> > name as it would be used if there were a wrapper function.
> 
> The problem is that programs do this as well, so they fail to build
> once they are built on a newer glibc version.
> 
> > But, this leads to the question: what do you think the likelihood
> > is that this system call will land in glibc?
> 
> Quite likely.  It's easy enough to document, there are no P&C issues,
> and it doesn't need any new types.

My previous mail probably didn't make it so here it is again: I think
especially with the recently established glibc consensus to provide
wrappers for all new system calls (with some sensible exceptions) I'd
expect this to be the case.

> 
> pidfd_send_signal is slightly more difficult because we probably need
> to add rt_sigqueueinfo first, for consistency.

Oh, huh. Somehow I thought we already provide that.

Christian
