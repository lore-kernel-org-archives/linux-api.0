From: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv6 RFC 0/3] syscalls,x86: Add execveat() system call
Date: Fri, 7 Nov 2014 13:20:58 +0000
Message-ID: <CAHse=S-ECjFoZprku+Qb2iDp9auQgWLvYoxxC7-dquOqPWbeTg@mail.gmail.com>
References: <1415290033-15771-1-git-send-email-drysdale@google.com> <CALCETrXPVpiPp27Q08K2D=Vt66ZhUZn3GBNEcTvejVUZjy0kyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrXPVpiPp27Q08K2D=Vt66ZhUZn3GBNEcTvejVUZjy0kyQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Rich Felker <dalias-/miJ2pyFWUyWIDz0JBNUog@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 6, 2014 at 4:55 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> On Thu, Nov 6, 2014 at 8:07 AM, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>> Here's another pass at this. Some things to discuss in particular:
>>
>> 1) The current approach for interpreted execs (i.e. mostly "#!" scripts)
>>    gives them an argv[1] filename like "/dev/fd/<fd>/<path>".  This
>>    means that script execution in a /proc-less system isn't going to
>>    work, at least until interpreters get smart enough to spot and
>>    special-case the leading "/dev/fd/<fd>", or until there's something
>>    to use in place of /dev/fd -> /proc/self/fd (e.g. Al's dupfs
>>    suggestion, https://lkml.org/lkml/2014/10/19/141).
>>
>>    So is an execveat(2) that (currently) only works for non-interpreted
>>    programs still useful?
>
> I think it is.  I would make sure to return a distinguishable error
> code in the event that the failure happens because of one of the
> unsupported cases.
>
>>
>> 2) I don't like having to add a new LOOKUP_EMPTY_NOPATH flag
>>    just to prevent O_PATH fds from being fexecve()ed -- alternative
>>    suggestions welcomed.  (More generally, I don't have a great
>>    feel for what O_PATH is for; how bad would it be to just allow
>>    them to be fexecve()ed?)
>
> If you fexecve an O_PATH fd, does it at least check that you have
> execute permission on the inode?  If so, it seems okay to allow it.

Yes, the same checks will happen for an O_PATH fd as for a normal fd.
I'll add an explicit test case for that too.

> --Andy
>
>>
>> .........
>>
>> This patch set adds execveat(2) for x86, and is derived from Meredydd
>> Luff's patch from Sept 2012 (https://lkml.org/lkml/2012/9/11/528).
>>
>> The primary aim of adding an execveat syscall is to allow an
>> implementation of fexecve(3) that does not rely on the /proc
>> filesystem, at least for executables (rather than scripts).  The
>> current glibc version of fexecve(3) is implemented via /proc, which
>> causes problems in sandboxed or otherwise restricted environments.
>>
>> Given the desire for a /proc-free fexecve() implementation, HPA
>> suggested (https://lkml.org/lkml/2006/7/11/556) that an execveat(2)
>> syscall would be an appropriate generalization.
>>
>> Also, having a new syscall means that it can take a flags argument
>> without back-compatibility concerns.  The current implementation just
>> defines the AT_EMPTY_PATH and AT_SYMLINK_NOFOLLOW flags, but other
>> flags could be added in future -- for example, flags for new namespaces
>> (as suggested at https://lkml.org/lkml/2006/7/11/474).
>>
>> Related history:
>>  - https://lkml.org/lkml/2006/12/27/123 is an example of someone
>>    realizing that fexecve() is likely to fail in a chroot environment.
>>  - http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=514043 covered
>>    documenting the /proc requirement of fexecve(3) in its manpage, to
>>    "prevent other people from wasting their time".
>>  - https://bugzilla.kernel.org/show_bug.cgi?id=74481 documented that
>>    it's not possible to fexecve() a file descriptor for a script with
>>    close-on-exec set (which is possible with the implementation here).
>
> Confused.  How does it work for a close-on-exec script?  I understand
> how it works for a close-on-exec ELF binary.

My bad, it doesn't -- I forgot to update that part of the commit
description, it's left over from the version that used d_path().

> --Andy
>
>>  - https://bugzilla.redhat.com/show_bug.cgi?id=241609 described a
>>    problem where a process that did setuid() could not fexecve()
>>    because it no longer had access to /proc/self/fd; this has since
>>    been fixed.
>>
>>
>> Changes since v5:
>>  - Set new flag in bprm->interp_flags for O_CLOEXEC fds, so that binfmts
>>    that invoke an interpreter fail the exec (as they will not be able
>>    to access the invoked file). [Andy Lutomirski]
>>  - Don't truncate long paths. [Andy Lutomirski]
>>  - Commonize code to open the executed file. [Eric W. Biederman]
>>  - Mark O_PATH file descriptors so they cannot be fexecve()ed.
>>  - Make self-test more helpful, and add additional cases:
>>      - file offset non-zero
>>      - binary file without execute bit
>>      - O_CLOEXEC fds
>>
>> Changes since v4, suggested by Eric W. Biederman:
>>  - Use empty filename with AT_EMPTY_PATH flag rather than NULL
>>    pathname to request fexecve-like behaviour.
>>  - Build pathname as "/dev/fd/<fd>/<filename>" (or "/dev/fd/<fd>")
>>    rather than using d_path().
>>  - Patch against v3.17 (bfe01a5ba249)
>>
>> Changes since Meredydd's v3 patch:
>>  - Added a selftest.
>>  - Added a man page.
>>  - Left open_exec() signature untouched to reduce patch impact
>>    elsewhere (as suggested by Al Viro).
>>  - Filled in bprm->filename with d_path() into a buffer, to avoid use
>>    of potentially-ephemeral dentry->d_name.
>>  - Patch against v3.14 (455c6fdbd21916).
>>
>>
>> David Drysdale (2):
>>   syscalls,x86: implement execveat() system call
>>   syscalls,x86: add selftest for execveat(2)
>>
>>  arch/x86/ia32/audit.c                   |   1 +
>>  arch/x86/ia32/ia32entry.S               |   1 +
>>  arch/x86/kernel/audit_64.c              |   1 +
>>  arch/x86/kernel/entry_64.S              |  28 +++
>>  arch/x86/syscalls/syscall_32.tbl        |   1 +
>>  arch/x86/syscalls/syscall_64.tbl        |   2 +
>>  arch/x86/um/sys_call_table_64.c         |   1 +
>>  fs/binfmt_em86.c                        |   4 +
>>  fs/binfmt_misc.c                        |   4 +
>>  fs/binfmt_script.c                      |  10 +
>>  fs/exec.c                               | 115 ++++++++++--
>>  fs/namei.c                              |   8 +-
>>  include/linux/binfmts.h                 |   4 +
>>  include/linux/compat.h                  |   3 +
>>  include/linux/fs.h                      |   1 +
>>  include/linux/namei.h                   |   1 +
>>  include/linux/sched.h                   |   4 +
>>  include/linux/syscalls.h                |   4 +
>>  include/uapi/asm-generic/unistd.h       |   4 +-
>>  kernel/sys_ni.c                         |   3 +
>>  lib/audit.c                             |   3 +
>>  tools/testing/selftests/Makefile        |   1 +
>>  tools/testing/selftests/exec/.gitignore |   7 +
>>  tools/testing/selftests/exec/Makefile   |  25 +++
>>  tools/testing/selftests/exec/execveat.c | 321 ++++++++++++++++++++++++++++++++
>>  25 files changed, 542 insertions(+), 15 deletions(-)
>>  create mode 100644 tools/testing/selftests/exec/.gitignore
>>  create mode 100644 tools/testing/selftests/exec/Makefile
>>  create mode 100644 tools/testing/selftests/exec/execveat.c
>>
>> --
>> 2.1.0.rc2.206.gedb03e5
>
>
>
> --
> Andy Lutomirski
> AMA Capital Management, LLC
