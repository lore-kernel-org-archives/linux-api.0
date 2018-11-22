From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH v1 2/2] signal: add procfd_signal() syscall
Date: Thu, 22 Nov 2018 01:48:07 -0600
Message-ID: <20181122074807.GB15484@mail.hallyn.com>
References: <20181119103241.5229-1-christian@brauner.io>
 <20181119103241.5229-3-christian@brauner.io>
 <20181119223954.GA4992@cisco>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181119223954.GA4992@cisco>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: Christian Brauner <christian@brauner.io>, ebiederm@xmission.com, linux-kernel@vger.kernel.org, serge@hallyn.com, jannh@google.com, luto@kernel.org, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, dancol@google.com, timmurray@google.com, linux-man@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 19, 2018 at 03:39:54PM -0700, Tycho Andersen wrote:
> On Mon, Nov 19, 2018 at 11:32:39AM +0100, Christian Brauner wrote:
> >
> > +/**
> > + *  sys_procfd_signal - send a signal to a process through a process file
> > + *                      descriptor
> > + *  @fd: the file descriptor of the process
> > + *  @sig: signal to be sent
> > + *  @info: the signal info
> > + *  @flags: future flags to be passed
> > + */
> > +SYSCALL_DEFINE4(procfd_signal, int, fd, int, sig, siginfo_t __user *, info,
> > +		int, flags)
> > +{
> 
> Can I just register an objection here that I think using a syscall
> just for this is silly?
> 
> My understanding is that the concern is that some code might do:
> 
> unknown_fd = recv_fd();
> ioctl(unknown_fd, SOME_IOCTL, NULL); // where SOME_IOCTL == PROC_FD_KILL
> // whoops, unknown_fd was a procfd and we killed a task!

This could just be my own mental model, but for something like "kill a
task", an ioctl just seems wrong.  Syscall seems more natural.

I'd ack either method.

-serge
