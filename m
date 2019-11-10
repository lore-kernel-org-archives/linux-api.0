From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH 1/1] userfaultfd: require CAP_SYS_PTRACE for UFFD_FEATURE_EVENT_FORK
Date: Sun, 10 Nov 2019 09:02:45 -0800
Message-ID: <CALCETrWxkzp5mzoqq28cbZLmwYh-k_er-8ocVoLPXXUk66Yprg@mail.gmail.com>
References: <1572967777-8812-1-git-send-email-rppt@linux.ibm.com>
 <1572967777-8812-2-git-send-email-rppt@linux.ibm.com> <CAKOZuev93zDGNPX+ySg_jeUg4Z3zKMcpABekUQvHA01kTVn4=A@mail.gmail.com>
 <CALCETrX=VmSjD6kLT6tuZQ4Efhc_13vZrw1mo4Z2iKqZTT-bzg@mail.gmail.com>
 <20191105162424.GH30717@redhat.com> <CAKOZuet=g++G+biSP5bU-Rppu6fykU1TVUDj20NapqAYQY4r9A@mail.gmail.com>
 <20191107083902.GB3247@linux.ibm.com> <CAKOZuevhEXpMr49KmkBLEyMGsDz8WujKvOGCty8+p7cwVbmoXA@mail.gmail.com>
 <20191107153801.GF17896@redhat.com> <CAKOZueuKttjyRBgMkaBknzn+fzufZA+gJcd5wnKgiwmO37yN1g@mail.gmail.com>
 <20191107182259.GK17896@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191107182259.GK17896@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Daniel Colascione <dancol@google.com>, Mike Rapoport <rppt@linux.ibm.com>, Andy Lutomirski <luto@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Lokesh Gidra <lokeshgidra@google.com>, Nick Kralevich <nnk@google.com>, Nosh Minwalla <nosh@google.com>, Pavel Emelyanov <ovzxemul@gmail.com>, Tim Murray <timmurray@google.com>, Linux API <linux-api@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 7, 2019 at 10:23 AM Andrea Arcangeli <aarcange@redhat.com> wrote:
>
> On Thu, Nov 07, 2019 at 08:15:53AM -0800, Daniel Colascione wrote:
> > You're already paying for bounds checking. Receiving a message via a
> > datagram socket is basically the same thing as what UFFD's read is
> > doing anyway.
>
> Except it's synchronous and there are no dynamic allocations required
> in uffd, while af_netlink and af_unix both all deal with queue of
> events in skbs dynamically allocated.
>
> Ultimately if we strip away the skbs for performance reasons, there
> wouldn't be much code to share, so if the only benefit would be to
> call recvmsg which would still be as insecure as read for the "worse"
> case than suid, so I don't see the point.

Not sure what you mean.

>
> And should then eventfd also become a netlink then? I mean uffd was
> supposed to work like eventfd except it requires specialized events.

No. None of this even means that these objects should be sockets per
se.  The point is that anyone who calls recvmsg() and passes a control
buf *must* handle SCM_RIGHTS because even very old Unixes can
materialize file descriptors.  The only exception is if the program
knows a priori that the fd refers to a socket that can't use
SCM_RIGHTS.

In other words, failing to handle file descriptors returned by
recvmsg() is an application bug.  Failing to handle file descriptors
returned by read() is not an application bug -- it's a kernel bug.

> > If you call it with a non-empty ancillary data buffer, you know to
> > react to what you get. You're *opting into* the possibility of getting
> > file descriptors. Sure, it's theoretically possible that a program
> > calls recvmsg on random FDs it gets from unknown sources, sees
> > SCM_RIGHTS unexpectedly, and just the SCM_RIGHTS message and its FD
> > payload, but that's an outright bug, while calling read() on stdin is
> > no bug.
>
> I'm not talking about stdin and suid. recvmsg might mitigate the
> concern for suid (not certain, depends on the suid, if it's generally
> doing what you expect most suid to be doing or not), I was talking
> about the SCM_RIGHTS receiving daemon instead, the "worse" more
> concerning case than the suid.
>
> I quote below Andy's relevant email:
>
> ======
> It's worse if SCM_RIGHTS is involved.
> ======
>
> Not all software will do this after calling recvmsg:
>
>     if (cmsg->cmsg_type == SCM_RIGHTS) {
>       /* oops we got attacked and an fd was involountarily installed
>          because we received another AF_UNIX from a malicious attacker
>          in control of the other end of the SCM_RIGHTS-receiving
>          AF_UNIX connection instead of our expected socket family
>          which doesn't even support SCM_RIGHTS so we would never have
>          noticed an fd was installed after recvmsg */
>     }
>

You've misunderstood what you're quoting me as saying.  I'm saying
that the issue is worse if you pass the userfaultfd via SCM_RIGHTS to
an unsuspecting program.  It is perfectly valid to receive a file
descriptor via SCM_RIGHTS and then call read(), at least so long as
you are okay with potentially blocking.

If you receive a fd to a socket using SCM_RIGHTS and then you fail to
check cmsg_type as above, then you have a bug regardless of
userfaultfd.

--Andy
