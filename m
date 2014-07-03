From: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 00/11] Adding FreeBSD's Capsicum security framework
 (part 1)
Date: Thu, 3 Jul 2014 19:39:27 +0100
Message-ID: <20140703183927.GA1629@google.com>
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
 <53B51E81.4090700@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <53B51E81.4090700-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, qemu-devel <qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 03, 2014 at 11:12:33AM +0200, Paolo Bonzini wrote:
> Il 30/06/2014 12:28, David Drysdale ha scritto:
> >Hi all,
> >
> >The last couple of versions of FreeBSD (9.x/10.x) have included the
> >Capsicum security framework [1], which allows security-aware
> >applications to sandbox themselves in a very fine-grained way.  For
> >example, OpenSSH now (>= 6.5) uses Capsicum in its FreeBSD version to
> >restrict sshd's credentials checking process, to reduce the chances of
> >credential leakage.
>
> Hi David,
>
> we've had similar goals in QEMU.  QEMU can be used as a virtual
> machine monitor from the command line, but it also has an API that
> lets a management tool drive QEMU via AF_UNIX sockets.  Long term,
> we would like to have a restricted mode for QEMU where all file
> descriptors are obtained via SCM_RIGHTS or /dev/fd, and syscalls can
> be locked down.
>
> Currently we do use seccomp v2 BPF filters, but unfortunately this
> didn't help very much.  QEMU supports hotplugging hence the filter
> must whitelist anything that _might_ be used in the future, which is
> generally... too much.
>
> Something like Capsicum would be really nice because it attaches
> capabilities to file descriptors.  However, I wonder however how
> extensible Capsicum could be, and I am worried about the
> proliferation of capabilities that its design naturally leads to.

True, capability rights are likely to expand over time (although
FreeBSD only expanded from 55 to 60 between 9.x and 10.x).
 
> Given Linux's previous experience with BPF filters, what do you
> think about attaching specific BPF programs to file descriptors?
> Then whenever a syscall is run that affects a file descriptor, the
> BPF program for the file descriptor (attached to a struct file* as
> in Capsicum) would run in addition to the process-wide filter.

That sounds kind of clever, but also kind of complicated.

Off the top of my head, one particular problem is that not all
fd->struct file conversions in the kernel are completely specified
by an enclosing syscall and the explicit values of its parameters.

For example, the actual contents of the arguments to io_submit(2)
aren't visible to a seccomp-bpf program (as it can't read the __user
memory for the iocb structures), and so it can't distinguish a
read from a write.

Also, there could potentially be some odd interactions with file
descriptors passed between processes, if the BPF program relies
on assumptions about the environment of the original process.  For
example, what happens if an x86_64 process passes a filter-attached
FD to an ia32 process?  Given that the syscall numbers are
arch-specific, I guess that means the filter program would have
to include arch-specific branches for any possible variant.

More generally, I suspect that keeping things simpler will end
up being more secure.  Capsicum was based on well-studied ideas
from the world of object capability-based security, and I'd be
nervous about adding complications that take us further away from
that. 

> An equivalent of PR_SET_NO_NEW_PRIVS can also be added to file
> descriptors, so that a program that doesn't lock down syscalls can
> still lock down the operations (including fcntls and ioctls) on
> specific file descriptors.
>
> Converting FreeBSD capabilities to BPF programs can be easily
> implemented in userspace.

I get the idea, but I'm not sure it would be that easy!  The
BPF-generation library would need to hold all of the mappings
from system calls (and their arguments) to the equivalent
required rights -- and vice versa.

That mapping would also need be kept closely in sync with the kernel
and other system libraries -- if a new syscall is added and libc (or
some other library) started using it, the equivalent BPF chunks would
need to be updated to cope.
 
> >  [Capsicum also includes 'capability mode', which locks down the
> >  available syscalls so the rights restrictions can't just be bypassed
> >  by opening new file descriptors; I'll describe that separately later.]
>
> This can also be implemented in userspace via seccomp and
> PR_SET_NO_NEW_PRIVS.

Well, mostly (and in fact I've got an attempt to do exactly that at
https://github.com/google/capsicum-test/blob/dev/linux-bpf-capmode.c).

But there are a few wrinkles with that approach.

First, we need Kees Cook's patches to allow seccomp filters
to be synchronized across existing threads, but hopefully they
will make it in soon.

Next, there's one awkward syscall case.  In capability mode we'd like
to prevent processes from sending signals with kill(2)/tgkill(2)
to other processes, but they should still be able to send themselves
signals.  For example, abort(3) generates:
  tgkill(gettid(), gettid(), SIGABRT)

Only allowing kill(self) is hard to encode in a seccomp-bpf program, at
least in a way that survives forking.

Finally, capability mode also turns on strict-relative lookups
process-wide; in other words, every openat(dfd, ...) operation
acts as though it has the O_BENEATH_ONLY flag set, regardless of
whether the dfd is a Capsicum capability.  I can't see a way to
do that with a BPF program (although it would be possible to add
a filter that polices the requirement to include O_BENEATH_ONLY
rather than implicitly adding it).
 
So although a capability-mode implementation in terms of seccomp-bpf
is tantalizingly close, at the moment I've got it implemented as a new
seccomp mode.

> >  [Policing the rights checks anywhere else, for example at the system
> >  call boundary, isn't a good idea because it opens up the possibility
> >  of time-of-check/time-of-use (TOCTOU) attacks [2] where FDs are
> >  changed (as openat/close/dup2 are allowed in capability mode) between
> >  the 'check' at syscall entry and the 'use' at fget() invocation.]
>
> In the case of BPF filters, I wonder if you could stash the BPF
> "environment" somewhere and then use it at fget() invocation.
> Alternatively, it can be reconstructed at fget() time, similar to
> your introduction of fgetr().

Stashing something at syscall entry to be referred to later always
makes me worry about TOCTOU vulnerabilities, but the details might
be OK in this case (given that no check occurs at syscall entry)...
 
> Thanks,
>
> Paolo

Many thanks for taking the time to comment and think of innovative
ideas!

David
