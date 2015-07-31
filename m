From: David Drysdale <drysdale@google.com>
Subject: Re: [PATCHv2 1/1] Documentation: describe how to add a system call
Date: Fri, 31 Jul 2015 10:48:32 +0100
Message-ID: <CAHse=S-jtynT-1Pk8+JMd98wViao-bJh3K8TtGKPk7RXWgy=rg@mail.gmail.com>
References: <1438242731-27756-1-git-send-email-drysdale@google.com>
 <1438242731-27756-2-git-send-email-drysdale@google.com> <20150730185007.GC16452@x>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20150730185007.GC16452@x>
Sender: linux-doc-owner@vger.kernel.org
To: Josh Triplett <josh@joshtriplett.org>, Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Linux API <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, Shuah Khan <shuahkh@osg.samsung.com>, Jonathan Corbet <corbet@lwn.net>, Eric B Munson <emunson@akamai.com>, Randy Dunlap <rdunlap@infradead.org>, Andrea Arcangeli <aarcange@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Oleg Nesterov <oleg@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Lutomirski <luto@amacapital.net>, Al Viro <viro@zeniv.linux.org.uk>, Rusty Russell <rusty@rustcorp.com.au>, Peter Zijlstra <peterz@infradead.org>, Vivek Goyal <vgoyal@redhat.com>, Alexei Starovoitov <ast@plumgrid.com>, David Herrmann <dh.herrmann@gmail.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Miklos
List-Id: linux-api@vger.kernel.org

On Thu, Jul 30, 2015 at 7:50 PM, Josh Triplett <josh@joshtriplett.org> wrote:
> On Thu, Jul 30, 2015 at 08:52:11AM +0100, David Drysdale wrote:
>> Add a document describing the process of adding a new system call,
>> including the need for a flags argument for future compatibility, and
>> covering 32-bit/64-bit concerns (albeit in an x86-centric way).
>>
>> Signed-off-by: David Drysdale <drysdale@google.com>
>> Reviewed-by: Michael Kerrisk <mtk.manpages@gmail.com>
>> Reviewed-by: Eric B Munson <emunson@akamai.com>
>> Reviewed-by: Kees Cook <keescook@chromium.org>
>> Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
>
> A few comments below.  I also agree with Ingo's comment about
> documenting the param-structure approach in addition to flags.

Many thanks for looking through the doc in detail!

I'll send out an updated doc today; I'm then on vacation for the next
week so I'll collate further feedback after I return.

>> --- /dev/null
>> +++ b/Documentation/adding-syscalls.txt
>> @@ -0,0 +1,463 @@
>> +Adding a New System Call
>> +========================
>> +
>> +This document describes what's involved in adding a new system call to the
>> +Linux kernel, over and above the normal submission advice in
>> +Documentation/SubmittingPatches.
>> +
>> +
>> +System Call Alternatives
>> +------------------------
>> +
>> +The first thing to consider when adding a new system call is whether one of
>> +the alternatives might be suitable instead.  Although system calls are the
>> +most traditional and most obvious interaction points between userspace and the
>> +kernel, there are other possibilities -- choose what fits best for your
>> +interface.
>> +
>> + - If the operations involved can be made to look like a filesystem-like
>> +   object, it may make more sense to create a new filesystem or device.  This
>> +   also makes it easier to encapsulate the new functionality in a kernel module
>> +   rather than requiring it to be built into the main kernel.
>> +     - If the new functionality involves operations where the kernel notifies
>> +       userspace that something has happened, then returning a new file
>> +       descriptor for the relevant object allows userspace to use
>> +       poll/select/epoll to receive that notification.
>> +     - However, operations that don't map to read(2)/write(2)-like operations
>> +       have to be implemented as ioctl(2) requests, which can lead to a
>> +       somewhat opaque API.
>> + - If you're just exposing runtime system information, a new node in sysfs
>> +   (see Documentation/filesystems/sysfs.txt) or the /proc filesystem may be
>> +   more appropriate.  However, access to these mechanisms requires that the
>> +   relevant filesystem is mounted, which might not always be the case (e.g.
>> +   in a namespaced/sandboxed/chrooted environment).  Avoid adding anything to
>> +   debugfs, as this is not considered a 'production' interface to userspace.
>
> s/anything/any "API"/

Done.

>> + - If the operation is specific to a particular file or file descriptor, then
>> +   an additional fcntl(2) command option may be more appropriate.  However,
>> +   fcntl(2) is a multiplexing system call that hides a lot of complexity, so
>> +   this option is best for when the new function is closely analogous to
>> +   existing fcntl(2) functionality, or the new functionality is very simple
>> +   (for example, getting/setting a simple flag related to a file descriptor).
>> + - If the operation is specific to a particular task or process, then an
>> +   additional prctl(2) command option may be more appropriate.  As with
>> +   fcntl(2), this system call is a complicated multiplexor so is best reserved
>> +   for near-analogs of existing prctl() commands or getting/setting a simple
>> +   flag related to a process.
>> +
>> +
>> +Designing the API
>> +-----------------
>> +
>> +A new system call forms part of the API of the kernel, and has to be supported
>> +indefinitely.  As such, it's a very good idea to explicitly discuss the
>> +interface on the kernel mailing list, and to plan for future extensions of the
>> +interface.  In particular:
>> +
>> +  **Include a flags argument for every new system call**
>> +
>> +The syscall table is littered with historical examples where this wasn't done,
>> +together with the corresponding follow-up system calls (eventfd/eventfd2,
>> +dup2/dup3, inotify_init/inotify_init1,  pipe/pipe2, renameat/renameat2), so
>> +learn from the history of the kernel and include a flags argument from the
>> +start.
>> +
>> +Also, to make sure that userspace programs can safely use flags between kernel
>> +versions, check whether the flags value holds any unknown flags, and reject the
>> +sycall (with EINVAL) if it does:
>> +
>> +    if (flags & ~(THING_FLAG1 | THING_FLAG2 | THING_FLAG3))
>> +        return -EINVAL;
>> +
>> +(If no flags values are used yet, check that the flags argument is zero.)
>
> Some things to add a this point, before talking about adding a new file
> descriptor:
>
> If you want to provide userspace with a handle to a kernel object, do so
> in the form of a file descriptor.  Do not invent a new type of userspace
> object handle with its own namespace.  The kernel already has numerous
> system calls and well-defined semantics for managing and passing around
> file descriptors, as well as for cleaning up when the file descriptor is
> no longer in use.
>
> If your new system call returns a file descriptor, think about what it
> means to use the poll(2) family of syscalls on that file descriptor.  If
> you want to send an event to userspace associated with your kernel
> object, you should do so by making your file descriptor ready for
> reading or writing.

Good points, I've added a couple of paragraphs along these lines:

"
If your new system call allows userspace to refer to a kernel object, it
should use a file descriptor as the handle for that object -- don't invent a
new type of userspace object handle when the kernel already has mechanisms and
well-defined semantics for using file descriptors.

[snip: existing text on CLOEXEC]

If your system call returns a new file descriptor, you should also consider
what it means to use the poll(2) family of system calls on that file
descriptor. Making a file descriptor ready for reading or writing is the
normal way for the kernel to indicate to userspace that an event has
occurred on the corresponding kernel object.
"

(Given that I'm working on Capsicum, which treats file descriptors as
object capabilities, the first of those points is particularly important!)

>> +If your new xyzzy(2) system call returns a new file descriptor, then the flags
>> +argument should include a value that is equivalent to setting O_CLOEXEC on the
>> +new FD.  This makes it possible for userspace to close the timing window
>> +between xyzzy() and calling fcntl(fd, F_SETFD, FD_CLOEXEC), where an
>> +unexpected fork() and execve() in another thread could leak a descriptor to
>> +the exec'ed program. (However, resist the temptation to re-use the actual value
>> +of the O_CLOEXEC constant, as it is architecture-specific and is part of a
>> +numbering space of O_* flags that is fairly full.)
>> +
>> +If your new xyzzy(2) system call involves a filename argument:
>> +
>> +    int sys_xyzzy(const char __user *path, ..., unsigned int flags);
>> +
>> +you should also consider whether an xyzzyat(2) version is more appropriate:
>> +
>> +    int sys_xyzzyat(int dfd, const char __user *path, ..., unsigned int flags);
>> +
>> +This allows more flexibility for how userspace specifies the file in question;
>> +in particular it allows userspace to request the functionality for an
>> +already-opened file descriptor using the AT_EMPTY_PATH flag, effectively giving
>> +an fxyzzy(3) operation for free:
>> +
>> + - xyzzyat(AT_FDCWD, path, ..., 0) is equivalent to xyzzy(path,...)
>> + - xyzzyat(fd, "", ..., AT_EMPTY_PATH) is equivalent to fxyzzy(fd, ...)
>> +
>> +(For more details on the rationale of the *at() calls, see the openat(2) man
>> +page; for an example of AT_EMPTY_PATH, see the statat(2) man page.)
>> +
>> +If your new xyzzy(2) system call involves a parameter describing an offset
>> +within a file, make its type loff_t so that 64-bit offsets can be supported
>> +even on 32-bit architectures.
>> +
>> +If your new xyzzy(2) system call involves administrative functionality, it
>
> s/administrative/privileged/

Done.

>> +needs to be governed by the appropriate Linux capability bit (checked with a
>> +call to capable()), as described in the capabilities(7) man page.
>> +
>> + - If there is an existing capability that governs related functionality, then
>> +   use that.  However, avoid combining lots of only vaguely related functions
>> +   together under the same bit, as this goes against capabilities' purpose of
>> +   splitting the power of root.  In particular, avoid adding new uses of the
>> +   already overly-general CAP_SYS_ADMIN capability.
>> + - If there is no related capability, then consider adding a new capability
>> +   bit -- but bear in mind that the numbering space is limited, and each new
>> +   bit needs to be understood and administered by sysadmins.
>
> Many previous discussions on this topic seem to have concluded that it's
> almost impossible to add a new capability without breaking existing
> programs.  I would suggest not even mentioning this possibility.

I'm not particularly knowledgable about capabilities (at least, not the
POSIX.1e/Linux kind), so I'll confess that I got this suggestion from
Michael Kerrisk.

Michael, do you agree that we should just drop the possibility of adding
new capability bits?

Also, Josh, do you have any references to the earlier discussions on the
topic so I can update the Sources section?

> There's another possibility here that should be discussed:
>
> "If your system call manipulates a process other than the calling
> process, the correct permission check is ptrace_may_access, which checks
> either that the calling process has all the same permissions as the
> target process or that the calling process has the necessary
> capabilities to manipulate any process."

I've added a paragraph along those lines:

"
If your new xyzzy(2) system call manipulates a process other than the calling
process, it should be restricted (using a call to ptrace_may_access()) so that
only a calling process with the same permissions as the target process, or
with the necessary capabilities, can manipulate the target process.
"

>> +Finally, be aware that some non-x86 architectures have an easier time if
>> +system call parameters that are explicitly 64-bit fall on odd-numbered
>> +arguments (i.e. parameter 1, 3, 5), to allow use of contiguous pairs of 32-bit
>> +registers.
>
> "Alternatively, note that this limitation does not apply to parameters
> passed in a data structure, as mentioned above."
>
> (in reference to the new additions Ingo proposed)

Done.

>> +Proposing the API
>> +-----------------
>> +
>> +To make new system calls easy to review, it's best to divide up the patchset
>> +into separate chunks.  These should include at least the following items as
>> +distinct commits (each of which is described further below):
>> +
>> + - The core implementation of the system call together with prototypes, generic
>
> s/call together/call, together/

Done.

>> +   numbering and fallback stub implementation.
>
> And any Kconfig bits.

Done.

>> + - Wiring up of the new system call for one particular architecture, usually
>> +   x86 (including all of x86_64, x86_32 and x32).
>> + - A demonstration of the use of the new system call in userspace via a
>> +   selftest in tools/testing/selftests/.
>> + - A draft man-page for the new system call.
>
> "either as a patch to the man-pages repository (not the kernel), or in
> plain-text format in the cover letter".

Done.

>> +New system call proposals, like any change to the kernel's API, should always
>> +be cc'ed to linux-api@vger.kernel.org
>> +
>> +
>> +Generic System Call Implementation
>> +----------------------------------
>> +
>> +The main entry point for your new xyzzy(2) system call will be called
>> +sys_xyzzy(), but you add this entry point with the appropriate
>> +SYSCALL_DEFINEn() macro rather than explicitly.  The 'n' indicates the number
>> +of arguments to the system call, and the macro takes the system call name
>> +followed by the (type, name) pairs for the parameters as arguments.  Using
>> +this macro allows metadata about the new system call to be made available for
>> +other tools.
>> +
>> +The new entry point also needs a corresponding function prototype, in
>> +include/linux/syscalls.h, marked as asmlinkage to match the way that system
>> +calls are invoked:
>> +
>> +    asmlinkage long sys_xyzzy(...);
>> +
>> +Some architectures (e.g. x86) have their own architecture-specific syscall
>> +tables, but several other architectures share a generic syscall table. Add your
>> +new system call to the generic list by adding an entry to the list in
>> +include/uapi/asm-generic/unistd.h:
>> +
>> +    #define __NR_xyzzy 292
>> +    __SYSCALL(__NR_xyzzy, sys_xyzzy)
>> +
>> +Also update the __NR_syscalls count to reflect the additional system call, and
>> +note that if multiple new system calls are added in the same merge window,
>> +your new syscall number may get adjusted to resolve conflicts.
>> +
>> +The file kernel/sys_ni.c provides a fallback stub implementation of each system
>> +call, returning -ENOSYS.  Add your new system call here too:
>> +
>> +    cond_syscall(sys_xyzzy);
>
> Please add something like this as well, to go along with the
> cond_syscall bit:
>
> Your new system call should be optional.  Add a new Kconfig option
> CONFIG_XYZZY_SYSCALL" (typically in init/Kconfig), possibly depending on
> EXPERT, with a description of the new system call.  Make the source
> files implementing your system call depend on that new Kconfig option
> (obj-$(CONFIG_XYZZY_SYSCALL) += xyzzy.c).

Added a paragraph along those lines:

"
Your new kernel functionality, and the system call that controls it, should
normally be optional, so add a CONFIG option (typically to init/Kconfig) for
it. As usual for new CONFIG options:

 - Include a description of the new functionality and system call controlled
   by the option.
 - Make the option depend on EXPERT if it should be hidden from normal users.
 - Make any new source files implementing the function dependent on the CONFIG
   option in the Makefile (e.g. "obj-$(CONFIG_XYZZY_SYSCALL) += xyzzy.c").
 - Double check that the kernel still builds with the new CONFIG option turned
   off.
"

>> +To summarize, you need a commit that includes:
>> +
>> + - SYSCALL_DEFINEn(xyzzy, ...) for the entry point
>> + - corresponding prototype in include/linux/syscalls.h
>> + - generic table entry in include/uapi/asm-generic/unistd.h
>> + - fallback stub in kernel/sys_ni.c
>
> - new Kconfig symbol, typically in init/Kconfig

Done.

>> +Testing
>> +-------
>> +
>> +A new system call should obviously be tested; it is also useful to provide
>> +reviewers with a demonstration of how user space programs will use the system
>> +call.  A good way to combine these aims is to include a simple self-test
>> +program in a new directory under tools/testing/selftests/.
>> +
>> +For a new system call, there will obviously be no libc wrapper function and so
>> +the test will need to invoke it using syscall(); also, if the system call
>> +involves a new userspace-visible structure, the corresponding header will need
>> +to be installed to compile the test.
>> +
>> +Make sure the selftest runs successfully on all supported architectures.  For
>> +example, check that it works when compiled as an x86_64 (-m64), x86_32 (-m32)
>> +and x32 (-mx32) ABI program.
>
> "Make sure the kernel compiles when you configure out your new system
> call."

Added, albeit higher up.

>> +Man Page
>> +--------
>> +
>> +All new system calls should come with a complete man page, ideally using groff
>> +markup, but plain text will do.  If groff is used, it's helpful to include a
>> +pre-rendered ASCII version of the man page in the cover email for the
>> +patchset, for the convenience of reviewers.
>> +
>> +The man page should be cc'ed to linux-man@vger.kernel.org
>> +For more details, see https://www.kernel.org/doc/man-pages/patches.html
>> +
>> +References and Sources
>> +----------------------
>> +
>> + - LWN article from Michael Kerrisk on use of flags argument in system calls:
>> +   https://lwn.net/Articles/585415/
>> + - LWN article from Michael Kerrisk on how to handle unknown flags in a system
>> +   call: https://lwn.net/Articles/588444/
>> + - LWN article from Jake Edge describing constraints on 64-bit system call
>> +   arguments: https://lwn.net/Articles/311630/
>> + - Pair of LWN articles from David Drysdale that describe the system call
>> +   implementation paths in detail for v3.14:
>> +    - https://lwn.net/Articles/604287/
>> +    - https://lwn.net/Articles/604515/
>> + - Architecture-specific requirements for system calls are discussed in the
>> +   syscall(2) man-page:
>> +   http://man7.org/linux/man-pages/man2/syscall.2.html#NOTES
>> + - Collated emails from Linus Torvalds discussing the problems with ioctl():
>> +   http://yarchive.net/comp/linux/ioctl.html
>> + - "How to not invent kernel interfaces", Arnd Bergmann,
>> +   http://www.ukuug.org/events/linux2007/2007/papers/Bergmann.pdf
>> + - LWN article from Michael Kerrisk on avoiding new uses of CAP_SYS_ADMIN:
>> +   https://lwn.net/Articles/486306/
>> +
>
> Nit: why is there a blank line here but not elsewhere in this list?

I was originally trying to separate references from sources, but as I
added more things the distinction got blurred -- removed.

>> + - Recommendation from Andrew Morton that all related information for a new
>> +   system call should come in the same email thread:
>> +   https://lkml.org/lkml/2014/7/24/641
>> + - Recommendation from Michael Kerrisk that a new system call should come with
>> +   a man page: https://lkml.org/lkml/2014/6/13/309
>> + - Suggestion from Thomas Gleixner that x86 wire-up should be in a separate
>> +   commit: https://lkml.org/lkml/2014/11/19/254
>> + - Suggestion from Greg Kroah-Hartman that it's good for new system calls to
>> +   come with a man-page & selftest: https://lkml.org/lkml/2014/3/19/710
>> + - Discussion from Michael Kerrisk of new system call vs. prctl(2) extension:
>> +   https://lkml.org/lkml/2014/6/3/411
>> + - Numbering oddities arising from (re-)use of O_* numbering space flags:
>> +    - commit 75069f2b5bfb ("vfs: renumber FMODE_NONOTIFY and add to uniqueness
>> +      check")
>> +    - commit 12ed2e36c98a ("fanotify: FMODE_NONOTIFY and __O_SYNC in sparc
>> +      conflict")
>> +    - commit bb458c644a59 ("Safer ABI for O_TMPFILE")
>> + - Discussion from Matthew Wilcox about restrictions on 64-bit arguments:
>> +   https://lkml.org/lkml/2008/12/12/187
>> + - Recommendation from Greg Kroah-Hartman that unknown flags should be
>> +   policed: https://lkml.org/lkml/2014/7/17/577
>> + - Recommendation from Linus Torvalds that x32 system calls should prefer
>> +   compatibility with 64-bit versions rather than 32-bit versions:
>> +   https://lkml.org/lkml/2011/8/31/244
>> --
>> 2.5.0.rc2.392.g76e840b
