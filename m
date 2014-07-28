From: David Drysdale <drysdale@google.com>
Subject: Re: [RFC PATCHv2 00/11] Adding FreeBSD's Capsicum security framework
Date: Mon, 28 Jul 2014 17:04:16 +0100
Message-ID: <CAHse=S_7Jpb9bTXHgU8q8_UZ=ce2gwdq8C15a+jbfO_pHmV_iA@mail.gmail.com>
References: <1406296033-32693-1-git-send-email-drysdale@google.com> <871tt796i0.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <871tt796i0.fsf@x220.int.ebiederm.org>
Sender: linux-security-module-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: LSM List <linux-security-module@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Meredydd Luff <meredydd@senatehouse.org>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, Andy Lutomirski <luto@amacapital.net>, Paolo Bonzini <pbonzini@redhat.com>, Paul Moore <paul@paul-moore.com>, Christoph Hellwig <hch@infradead.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sat, Jul 26, 2014 at 10:04 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> David Drysdale <drysdale@google.com> writes:
>
>> The last couple of versions of FreeBSD (9.x/10.x) have included the
>> Capsicum security framework [1], which allows security-aware
>> applications to sandbox themselves in a very fine-grained way.  For
>> example, OpenSSH now (>= 6.5) uses Capsicum in its FreeBSD version to
>> restrict sshd's credentials checking process, to reduce the chances of
>> credential leakage.
>>
>> It would be good to have equivalent functionality in Linux, so I've been
>> working on getting the Capsicum framework running in the kernel, and I'd
>> appreciate some feedback/opinions on the general approach.
>>
>> I'm attaching a corresponding draft patchset for reference, but
>> hopefully this cover email can cover the significant features to save
>> everyone having to look through the code details.  (It does mean this is
>> a long email though -- apologies for that.)
>>
>>
>> 1) Capsicum Capabilities
>> ------------------------
>>
>> The most significant aspect of Capsicum is associating *rights* with
>> (some) file descriptors, so that the kernel only allows operations on an
>> FD if the rights permit it.  This allows userspace applications to
>> sandbox themselves by tightly constraining what's allowed with both
>> input and outputs; for example, tcpdump might restrict itself so it can
>> only read from the network FD, and only write to stdout.
>>
>> The kernel thus needs to police the rights checks for these file
>> descriptors (referred to as 'Capsicum capabilities', completely
>> different than POSIX.1e capabilities), and the best place to do this is
>> at the points where a file descriptor from userspace is converted to a
>> struct file * within the kernel.
>>
>>   [Policing the rights checks anywhere else, for example at the system
>>   call boundary, isn't a good idea because it opens up the possibility
>>   of time-of-check/time-of-use (TOCTOU) attacks [2] where FDs are
>>   changed (as openat/close/dup2 are allowed in capability mode) between
>>   the 'check' at syscall entry and the 'use' at fget() invocation.]
>>
>> However, this does lead to quite an invasive change to the kernel --
>> every invocation of fget() or similar functions (fdget(),
>> sockfd_lookup(), user_path_at(),...) needs to be annotated with the
>> rights associated with the specific operations that will be performed on
>> the struct file.  There are ~100 such invocations that need
>> annotation.
>
> And it is silly.  Roughly you just need a locking version of
> fcntl(F_SETFL).
>
> That is make the restriction in the struct file not in the fd to file
> lookup.

The file status flags are far too coarse -- for example, O_RDONLY
doesn't prevent fchmod(2).

Also, because they're associated with the struct file there is no way
to pass a file descriptor with only a subset of rights across a UNIX
socket (how do I send a read-only FD corresponding to my
O_RDWR file?).

> Files in unix have been capabilities for more than 20 years.  That is
> what file descriptor passing in unix domain sockets are all about.  We
> don't need an additional ``capability rights'' layer on top of file
> descriptors.

True, the ability to pass FDs across UNIX sockets is one of the
key things that makes them analogous to object-capabilities and
suitable as the substratum for Capsicum.  But the coarseness of the
existing rights, and the lack of coherent policing of those rights,
means that an (opt-in) extension like Capsicum is useful.

> In fact internal to linux with FMODE_READ and friends we already have
> restrictions on which methods are allowed on linux file descriptors.
> So this whole entire abstraction layer you are adding seems just plain
> broken.
>
> Going farther one huge thing your work and the capsicum work in general
> is missing is an implementation of revoke.  With a little care a good
> implementation of bits reporting and controlling which methods are
> available on which file descriptors should be a good start on
> a revoke implementation for linux as well.

Yeah, revocation is interesting.  There was been some discussion of
it for Capsicum a while ago:
https://lists.cam.ac.uk/pipermail/cl-capsicum-discuss/2011-January/msg00002.html
but I don't think a firm conclusion was reached.  As I understand it,
there's also a theoretical argument that revocation can be constructed
on top of the capability system, by handing out capabilities to proxy
objects that can then change their behaviour so they no longer pass
operations through.

>> 2) Capsicum Capabilities Data Structure
>> ---------------------------------------
>>
>> Internally, the rights associated with a Capsicum capability FD are
>> stored in a special struct file wrapper.  For a normal file, the rights
>> check inside fget() falls through, but for a capability wrapper the
>> rights in the wrapper are checked and (if capable) the underlying
>> wrapped struct file is returned.
>>
>>   [This is approximately the implementation that was present in FreeBSD
>>   9.x.  For FreeBSD 10.x, the wrapper file was removed and the rights
>>   associated with a file descriptor are now stored in the fdtable. As
>>   that impacts memory use for all processes, whether Capsicum users or
>>   not, I've stuck with the FreeBSD 9.x approach.]
>
> I have already mentioned that this is an insane choice of semantics
> right?  Adding an extra layer on top of a data structure that is a
> perfectly good restrictor of rights.
>
> If you can't add the restriction on struct file itself I would argue
> that the semantics of capsicum are fundamentally broken.
>
> I can not imagine why in the world you would want and extra layer of
> indirection, complication, and maintenance.

See above.

>> 3) Allowing Capability Mode
>> ---------------------------
>>
>> Capsicum also includes 'capability mode', which locks down the available
>> syscalls so the rights restrictions can't just be bypassed by opening
>> new file descriptors.  More precisely, capability mode prevents access
>> to syscalls that access global namespaces, such as the filesystem or the
>> IP:port space.
>>
>> The existing seccomp-bpf functionality of the kernel is a good mechanism
>> for implementing capability mode, but there are a few additional details
>> that also need to be addressed.
>>
>>  a) The capability mode filter program needs to apply process-wide, not
>>     just to the current thread.
>>
>>  b) In capability mode, new files can still be opened with openat(2) but
>>     only if they are beneath an existing directory file descriptor.
>
> Which raises the question is that worth it?

>From a practical point of view, still allowing (directory-relative) filesystem
access means it's much easier for an application to adapt to Capsicum.

A simple example is something like unzip/tar -xf, where locking it down
is conceptually as simple as:
 - apply a CAP_READ restriction to the FD for the input file
 - apply a CAP_WRITE+CAP_LOOKUP restriction to the DFD for the
   output directory
 - enter capability mode.
Then the worst a malicious input file can do is to write files under the
output directory -- which it could do anyway.

Similarly, migrating an application that writes temporary files out to
some tempdir is much more straightforward if openat(dfd,...) is still
allowed.

>>  c) In capability mode it should still be possible for a process to send
>>     signals to itself with kill(2)/tgkill(2).
>
> Again is it worth it?
>
> I would think you would want capability mode to default to the minium
> set of system calls you could get away with (to keep kernel code
> auditing to a minium) and only add things if the performance gain of
> using the syscall exceeds the pain.

The set of syscalls allowed in capability mode is based more on the
principle of restricting access to global namespaces, to prevent (in
particular) the confused deputy problem.  Allowing kill(self) is a pragmatic
compromise to make it easier to migrate existing applications to use
Capsicum.

> If you look at a kernel like sel4 it succeeds in with an object
> capability model with many fewer system calls than you are proposing
> to export.  Roughly just read, write and close.
>
> Consider the fact if you really want a kernel layer you can completely
> trust and rely on someone needs to write a formal proof of that layer.
> Short of that someone certainly needs to audit the kernel code very
> closely so simplicity of semantics and simplicity of implementation are
> very important.

seL4 may have a much simpler (and more formally-correct) model, but
the aim of Capsicum is to get some of the benefits of that well-analysed
model without the need for a (massive) migration effort -- and in a way
that allows co-existence of migrated and unmigrated code.

>> This v2 patchset copes with these as follows:
>>
>>  a) Kees Cook's incoming seccomp(2) patchset covers thread
>>     synchronization of filters.
>>
>>  b) A new prctl(PR_SET_OPENAT_BENEATH) operation implicitly sets the
>>     O_BENEATH flag (see below) for all file-open operations for all
>>     threads of the current process, by adding a new openat_beneath
>>     flag in task_struct.
>>
>>  c) An extension to the seccomp_data structure that includes the current
>>     task's tid and tgid values allows for BPF programs that check a
>>     kill(2)/tgkill(2) argument against the current thread, in a manner
>>     that is robust against fork(2)/clone(2).
>>
>> The combination of these features with the existing seccomp-bpf
>> functionality gives the tools needed to implement capability mode.
>>
>>
>> 4) New System Calls
>> -------------------
>>
>> To allow userspace applications to access the Capsicum capability
>> functionality, I'm proposing two new system calls: cap_rights_limit(2)
>> and cap_rights_get(2).  I guess these could potentially be implemented
>> elsewhere (e.g. as fcntl(2) operations?) but the changes seem
>> significant enough that new syscalls are warranted.
>>
>>   [FreeBSD 10.x actually includes six new syscalls for manipulating the
>>   rights associated with a Capsicum capability -- the capability rights
>>   can police that only specific fcntl(2) or ioctl(2) commands are
>>   allowed, and FreeBSD sets these with distinct syscalls.]
>
> ioctls?  In a sandbox?  Ick.
>
>> 5) New openat(2) O_BENEATH Flag
>> -------------------------------
>>
>> For Capsicum capabilities that are directory file descriptors, the
>> Capsicum framework only allows openat(cap_dfd, path, ...) operations to
>> work for files that are beneath the specified directory (and even that
>> only when the directory FD has the CAP_LOOKUP right), rejecting paths
>> that start with "/" or include "..".  The same restriction applies
>> process-wide for a process in capability mode.
>>
>> As this seemed like functionality that might be more generally useful,
>> I've implemented it independently as a new O_BENEATH flag for openat(2).
>> The Capsicum code then always triggers the use of that flag when the dfd
>> is a Capsicum capability, or when the prctl(2) command described above
>> is in play.
>>
>>   [FreeBSD has the openat(2) relative-only behaviour for capability DFDs
>>   and processes in capability mode, but does not include the O_BENEATH
>>   flag.]
>
> If you are going to allow open I would think the simple solution here is
> to just create a mount namespace that only has available the files you
> would like to export to the process, and force all of the file
> descriptors into that mount namespace.
>
> Eric

I think that's a lot harder for application writers to do -- they would need
to have CAP_SYS_ADMIN to set up the namespace & mounts before
dropping privileges.  And the net result would again be much less
fine-grained (e.g. for the unzip example above, the specific capability
rights prevent reading of any files that already exist in the output
directory).
