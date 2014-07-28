From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [RFC PATCHv2 00/11] Adding FreeBSD's Capsicum security framework
Date: Mon, 28 Jul 2014 14:13:11 -0700
Message-ID: <87ha21qja0.fsf@x220.int.ebiederm.org>
References: <1406296033-32693-1-git-send-email-drysdale@google.com>
	<871tt796i0.fsf@x220.int.ebiederm.org>
	<CAHse=S_7Jpb9bTXHgU8q8_UZ=ce2gwdq8C15a+jbfO_pHmV_iA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHse=S_7Jpb9bTXHgU8q8_UZ=ce2gwdq8C15a+jbfO_pHmV_iA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(David Drysdale's message of "Mon, 28 Jul 2014 17:04:16 +0100")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> writes:

> On Sat, Jul 26, 2014 at 10:04 PM, Eric W. Biederman
> <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>> David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> writes:

>>> 1) Capsicum Capabilities
>>> ------------------------
>>>
>>> The most significant aspect of Capsicum is associating *rights* with
>>> (some) file descriptors, so that the kernel only allows operations on an
>>> FD if the rights permit it.  This allows userspace applications to
>>> sandbox themselves by tightly constraining what's allowed with both
>>> input and outputs; for example, tcpdump might restrict itself so it can
>>> only read from the network FD, and only write to stdout.
>>>
>>> The kernel thus needs to police the rights checks for these file
>>> descriptors (referred to as 'Capsicum capabilities', completely
>>> different than POSIX.1e capabilities), and the best place to do this is
>>> at the points where a file descriptor from userspace is converted to a
>>> struct file * within the kernel.
>>>
>>>   [Policing the rights checks anywhere else, for example at the system
>>>   call boundary, isn't a good idea because it opens up the possibility
>>>   of time-of-check/time-of-use (TOCTOU) attacks [2] where FDs are
>>>   changed (as openat/close/dup2 are allowed in capability mode) between
>>>   the 'check' at syscall entry and the 'use' at fget() invocation.]
>>>
>>> However, this does lead to quite an invasive change to the kernel --
>>> every invocation of fget() or similar functions (fdget(),
>>> sockfd_lookup(), user_path_at(),...) needs to be annotated with the
>>> rights associated with the specific operations that will be performed on
>>> the struct file.  There are ~100 such invocations that need
>>> annotation.
>>
>> And it is silly.  Roughly you just need a locking version of
>> fcntl(F_SETFL).
>>
>> That is make the restriction in the struct file not in the fd to file
>> lookup.
>
> The file status flags are far too coarse -- for example, O_RDONLY
> doesn't prevent fchmod(2).
>
> Also, because they're associated with the struct file there is no way
> to pass a file descriptor with only a subset of rights across a UNIX
> socket (how do I send a read-only FD corresponding to my
> O_RDWR file?).

You can't.  Unix domain sockets pass struct file references.
That is passing a file descriptor with a unix domain sockets is the
equivlanet of dup().

You absolutely must make your struct file read-only before passing it,
otherwise the the receiver will have a read-write instance.

This notion that a shared structure should have different semantics
depending on who is looking at it, sounds like a maintenance nightmare
to me. 

>> Files in unix have been capabilities for more than 20 years.  That is
>> what file descriptor passing in unix domain sockets are all about.  We
>> don't need an additional ``capability rights'' layer on top of file
>> descriptors.
>
> True, the ability to pass FDs across UNIX sockets is one of the
> key things that makes them analogous to object-capabilities and
> suitable as the substratum for Capsicum.  But the coarseness of the
> existing rights, and the lack of coherent policing of those rights,
> means that an (opt-in) extension like Capsicum is useful.

Finer grained restrictions are perfectly sensible.

I don't see how it make sense to place those restrictions in
struct fdtable instead of in struct file.

I see two sensible implementations:
- Add a seccomp bpf filter to struct file.
- Add permission bits to struct file.

The bpf filter would allow for a simple code extension that would
allow any arbitrary policy to be applied.

Adding permisison bits to struct file for gating access to
file_operations and inode_operations would result in the fastest
possible implementation and something very easy to audit and
understand.  But there like ioctl or read/write on IB control files
where finer grained permissions might be desirable.

For a lot of operations we alread have bits like FMODE_READ and
FMODE_CAN_READ on struct file for reasons such as performance
so that only a single cache line needs to be touched.

It might be that it would be worth having both.  Something cheap and
genrally accessible and something fast.

>> Going farther one huge thing your work and the capsicum work in general
>> is missing is an implementation of revoke.  With a little care a good
>> implementation of bits reporting and controlling which methods are
>> available on which file descriptors should be a good start on
>> a revoke implementation for linux as well.
>
> Yeah, revocation is interesting.  There was been some discussion of
> it for Capsicum a while ago:
> https://lists.cam.ac.uk/pipermail/cl-capsicum-discuss/2011-January/msg00002.html
> but I don't think a firm conclusion was reached.  As I understand it,
> there's also a theoretical argument that revocation can be constructed
> on top of the capability system, by handing out capabilities to proxy
> objects that can then change their behaviour so they no longer pass
> operations through.

I believe the capsicum approach is so far from allowing general proxy
objects that, that is not a compelling case.

>>> 3) Allowing Capability Mode
>>> ---------------------------
>>>
>>> Capsicum also includes 'capability mode', which locks down the available
>>> syscalls so the rights restrictions can't just be bypassed by opening
>>> new file descriptors.  More precisely, capability mode prevents access
>>> to syscalls that access global namespaces, such as the filesystem or the
>>> IP:port space.
>>>
>>> The existing seccomp-bpf functionality of the kernel is a good mechanism
>>> for implementing capability mode, but there are a few additional details
>>> that also need to be addressed.
>>>
>>>  a) The capability mode filter program needs to apply process-wide, not
>>>     just to the current thread.
>>>
>>>  b) In capability mode, new files can still be opened with openat(2) but
>>>     only if they are beneath an existing directory file descriptor.
>>
>> Which raises the question is that worth it?
>
> From a practical point of view, still allowing (directory-relative) filesystem
> access means it's much easier for an application to adapt to Capsicum.
>
> A simple example is something like unzip/tar -xf, where locking it down
> is conceptually as simple as:
>  - apply a CAP_READ restriction to the FD for the input file
>  - apply a CAP_WRITE+CAP_LOOKUP restriction to the DFD for the
>    output directory
>  - enter capability mode.
> Then the worst a malicious input file can do is to write files under the
> output directory -- which it could do anyway.
>
> Similarly, migrating an application that writes temporary files out to
> some tempdir is much more straightforward if openat(dfd,...) is still
> allowed.


>>>  c) In capability mode it should still be possible for a process to send
>>>     signals to itself with kill(2)/tgkill(2).


> seL4 may have a much simpler (and more formally-correct) model, but
> the aim of Capsicum is to get some of the benefits of that well-analysed
> model without the need for a (massive) migration effort -- and in a way
> that allows co-existence of migrated and unmigrated code.

Alright. About the same target as seccomp then.  Aiming at something
that is simple to adopt sounds like a reasonable goal.

>>> 5) New openat(2) O_BENEATH Flag
>>> -------------------------------
>>>
>>> For Capsicum capabilities that are directory file descriptors, the
>>> Capsicum framework only allows openat(cap_dfd, path, ...) operations to
>>> work for files that are beneath the specified directory (and even that
>>> only when the directory FD has the CAP_LOOKUP right), rejecting paths
>>> that start with "/" or include "..".  The same restriction applies
>>> process-wide for a process in capability mode.
>>>
>>> As this seemed like functionality that might be more generally useful,
>>> I've implemented it independently as a new O_BENEATH flag for openat(2).
>>> The Capsicum code then always triggers the use of that flag when the dfd
>>> is a Capsicum capability, or when the prctl(2) command described above
>>> is in play.
>>>
>>>   [FreeBSD has the openat(2) relative-only behaviour for capability DFDs
>>>   and processes in capability mode, but does not include the O_BENEATH
>>>   flag.]
>>
>> If you are going to allow open I would think the simple solution here is
>> to just create a mount namespace that only has available the files you
>> would like to export to the process, and force all of the file
>> descriptors into that mount namespace.

> I think that's a lot harder for application writers to do -- they would need
> to have CAP_SYS_ADMIN to set up the namespace & mounts before
> dropping privileges.  

They only need CAP_SYS_ADMIN in their local user namespace, which anyone
is allowed to create.

> And the net result would again be much less
> fine-grained (e.g. for the unzip example above, the specific capability
> rights prevent reading of any files that already exist in the output
> directory).

Nope.  What you can implement today if you want fine grained limitations
like this is to create a mount namespace with exactly the subdirectory
tree you want to allow access to and to return a file descriptor that
points into that mount namespace.  (When complete the only user of that
mount namespace would be your file descriptor).

In fact that solution is sufficiently performant and simple that even
if you came up with a better user space interface for it that is how we
would want to implement it.

And frankly that already exists today so I think a fairly large burden
of proof needs to be met to suggest that we need to add additional
functionality to the kernel.

Furthermore I think it makes sense for application authors to use
as otherwise they will have to wait a year or so for the debates to be
finished and your new functionality to be merged.

Additionally unless there is a process wide restriction to relative
paths I can trivially escape your relative path implementation by simply
doing open(.) and getting a struct file without any of those
restrictions.

Eric
