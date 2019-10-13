From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH 3/7] Add a UFFD_SECURE flag to the userfaultfd API.
Date: Sat, 12 Oct 2019 17:51:45 -0700
Message-ID: <CAKOZuevUqs_Oe1UEwguQK7Ate3ai1DSVSij=0R=vmz9LzX4k6Q@mail.gmail.com>
References: <20191012191602.45649-1-dancol@google.com> <20191012191602.45649-4-dancol@google.com>
 <CALCETrVZHd+csdRL-uKbVN3Z7yeNNtxiDy-UsutMi=K3ZgCiYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrVZHd+csdRL-uKbVN3Z7yeNNtxiDy-UsutMi=K3ZgCiYw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Lokesh Gidra <lokeshgidra@google.com>, Nick Kralevich <nnk@google.com>, Nosh Minwalla <nosh@google.com>, Tim Murray <timmurray@google.com>
List-Id: linux-api@vger.kernel.org

On Sat, Oct 12, 2019 at 4:10 PM Andy Lutomirski <luto@kernel.org> wrote:
>
> On Sat, Oct 12, 2019 at 12:16 PM Daniel Colascione <dancol@google.com> wrote:
> >
> > The new secure flag makes userfaultfd use a new "secure" anonymous
> > file object instead of the default one, letting security modules
> > supervise userfaultfd use.
> >
> > Requiring that users pass a new flag lets us avoid changing the
> > semantics for existing callers.
>
> Is there any good reason not to make this be the default?
>
>
> The only downside I can see is that it would increase the memory usage
> of userfaultfd(), but that doesn't seem like such a big deal.  A
> lighter-weight alternative would be to have a single inode shared by
> all userfaultfd instances, which would require a somewhat different
> internal anon_inode API.

I'd also prefer to just make SELinux use mandatory, but there's a
nasty interaction with UFFD_EVENT_FORK. Adding a new UFFD_SECURE mode
which blocks UFFD_EVENT_FORK sidesteps this problem. Maybe you know a
better way to deal with it.

Right now, when a process with a UFFD-managed VMA using
UFFD_EVENT_FORK forks, we make a new userfaultfd_ctx out of thin air
and enqueue it on the message queue for the parent process. When we
dequeue that context, we get to resolve_userfault_fork, which makes up
a new UFFD file object out of thin air in the context of the reading
process. Following normal SELinux rules, the SID attached to that new
file object would be the task SID of the process *reading* the fork
event, not the SID of the new fork child. That seems wrong, because
the label we give to the UFFD should correspond to the label of the
process that UFFD controls.

To try to solve this problem, we can move the file object creation to
the fork child and enqueue the file object itself instead of just the
userfaultfd_ctx, treating the dequeue as a file-descriptor-receive
operation just like a recvmsg of an AF_UNIX socket with SCM_RIGHTS.
(This approach seems more elegant anyway, since it reflects what's
actually going on.) The trouble the early-file-object-creation
approach is that the fork child may not be allowed to create UFFD file
objects on its own and an LSM can't tell the difference between
UFFD_EVENT_FORK handling creating the file object and the fork child
just calling userfaultfd(), meaning an LSM could veto the creation of
the file object for the fork event. We can't just create a
non-ANON_INODE_SECURE file object instead: that would defeat the whole
purpose of supervising UFFD using SELinux.

But maybe we can go further: let's separate authentication and
authorization, as we do in other LSM hooks. Let's split my
inode_init_security_anon into two hooks, inode_init_security_anon and
inode_create_anon. We'd define the former to just initialize the file
object's security information --- in the SELinux case, figuring out
its class and SID --- and define the latter to answer the yes/no
question of whether a particular anonymous inode creation should be
allowed. Normally, anon_inode_getfile2() would just call both hooks.
We'd add another anon_inode_getfd flag, ANON_INODE_SKIP_AUTHORIZATION
or something, that would tell anon_inode_getfile2() to skip calling
the authorization hook, effectively making the creation always
succeed. We can then make the UFFD code pass
ANON_INODE_SKIP_AUTHORIZATION when it's creating a file object in the
fork child while creating UFFD_EVENT_FORK messages.

Granted, UFFD fork processing doesn't actually occur in the fork
child, but in copy_mm, in the parent --- but the right thing should
happen anyway, right?

I'm open to suggestions. In the meantime, I figured we'd just define a
UFFD_SECURE and make it incompatible with UFFD_EVENT_FORK.

> In any event, I don't think that "make me visible to SELinux" should
> be a choice that user code makes.

Right. The new unprivileged_userfaultfd setting is ugly, but it at
least removes the ability of unprivileged users to opt out of SELinux
supervision.
