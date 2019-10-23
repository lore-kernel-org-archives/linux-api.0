From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH 3/7] Add a UFFD_SECURE flag to the userfaultfd API.
Date: Wed, 23 Oct 2019 12:21:18 -0700
Message-ID: <CALCETrWY+5ynDct7eU_nDUqx=okQvjm=Y5wJvA4ahBja=CQXGw@mail.gmail.com>
References: <20191012191602.45649-1-dancol@google.com> <20191012191602.45649-4-dancol@google.com>
 <CALCETrVZHd+csdRL-uKbVN3Z7yeNNtxiDy-UsutMi=K3ZgCiYw@mail.gmail.com>
 <CAKOZuevUqs_Oe1UEwguQK7Ate3ai1DSVSij=0R=vmz9LzX4k6Q@mail.gmail.com>
 <CALCETrUyq=J37gU-MYXqLdoi7uH7iNNVRjvcGUT11JA1QuTFyg@mail.gmail.com>
 <CAG48ez3P27-xqdjKLqfP_0Q_v9K92CgEjU4C=kob2Ax7=NoZbA@mail.gmail.com> <20191023190959.GA9902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191023190959.GA9902@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, Daniel Colascione <dancol@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Pavel Emelyanov <xemul@virtuozzo.com>, Lokesh Gidra <lokeshgidra@google.com>, Nick Kralevich <nnk@google.com>, Nosh Minwalla <nosh@google.com>, Tim Murray <timmurray@google.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 23, 2019 at 12:10 PM Andrea Arcangeli <aarcange@redhat.com> wrote:
>
> Hello,
>
> On Sat, Oct 12, 2019 at 06:14:23PM -0700, Andy Lutomirski wrote:
> > [adding more people because this is going to be an ABI break, sigh]
>
> That wouldn't break the ABI, no more than when if you boot a kernel
> built with CONFIG_USERFAULTFD=n.
>
> All non-cooperative features can be removed any time in a backwards
> compatible way, the only precaution is to mark their feature bits as
> reserved so they can't be reused for something else later.
>
> > least severely restricted.  A .read implementation MUST NOT ACT ON THE
> > CALLING TASK.  Ever.  Just imagine the effect of passing a userfaultfd
> > as stdin to a setuid program.
>
> With UFFD_EVENT_FORK, the newly created uffd that controls the child,
> is not passed to the parent nor to the child. Instead it's passed to
> the CRIU monitor only, which has to be already running as root and is
> fully trusted and acts a hypervisor (despite there is no hypervisor).
>
> By the time execve runs and any suid bit in the execve'd inode becomes
> relevant, well before the new userland executable code can run, the
> kernel throws away the "old_mm" controlled by any uffd and all
> attached uffds are released as well.
>
> All I found is your "A .read implementation MUST NOT ACT ON THE
> CALLING TASK" as an explanation that something is broken but I need
> further clarification.

There are two things going on here.

1. Daniel wants to add LSM labels to userfaultfd objects.  This seems
reasonable to me.  The question, as I understand it, is: who is the
subject that creates a uffd referring to a forked child?  I'm sure
this is solvable in any number of straightforward ways, but I think
it's less important than:

2. The existing ABI is busted independently of #1.  Suppose you call
userfaultfd to get a userfaultfd and enable UFFD_FEATURE_EVENT_FORK.
Then you do:

$ sudo <&[userfaultfd number]

Sudo will read it and get a new fd unexpectedly added to its fd table.
It's worse if SCM_RIGHTS is involved.

So I think we either need to declare that UFFD_FEATURE_EVENT_FORK is
only usable by global root or we need to remove it and maybe re-add it
in some other form.


--Andy
