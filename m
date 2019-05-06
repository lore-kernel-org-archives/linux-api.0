From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH v6 5/6] binfmt_*: scope path resolution of interpreters
Date: Mon, 6 May 2019 20:37:37 +0200
Message-ID: <CAG48ez0-CiODf6UBHWTaog97prx=VAd3HgHvEjdGNz344m1xKw@mail.gmail.com>
References: <20190506165439.9155-1-cyphar@cyphar.com> <20190506165439.9155-6-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190506165439.9155-6-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>, Andy Lutomirski <luto@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Christian Brauner <christian@brauner.io>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <asarai@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>, containers@lists.linux-foundation.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, kernel list <linux-kernel@vger.kern>
List-Id: linux-api@vger.kernel.org

On Mon, May 6, 2019 at 6:56 PM Aleksa Sarai <cyphar@cyphar.com> wrote:
> The need to be able to scope path resolution of interpreters became
> clear with one of the possible vectors used in CVE-2019-5736 (which
> most major container runtimes were vulnerable to).
>
> Naively, it might seem that openat(2) -- which supports path scoping --
> can be combined with execveat(AT_EMPTY_PATH) to trivially scope the
> binary being executed. Unfortunately, a "bad binary" (usually a symlink)
> could be written as a #!-style script with the symlink target as the
> interpreter -- which would be completely missed by just scoping the
> openat(2). An example of this being exploitable is CVE-2019-5736.
>
> In order to get around this, we need to pass down to each binfmt_*
> implementation the scoping flags requested in execveat(2). In order to
> maintain backwards-compatibility we only pass the scoping AT_* flags.
>
> To avoid breaking userspace (in the exceptionally rare cases where you
> have #!-scripts with a relative path being execveat(2)-ed with dfd !=
> AT_FDCWD), we only pass dfd down to binfmt_* if any of our new flags are
> set in execveat(2).

This seems extremely dangerous. I like the overall series, but not this patch.

> @@ -1762,6 +1774,12 @@ static int __do_execve_file(int fd, struct filename *filename,
>
>         sched_exec();
>
> +       bprm->flags = flags & (AT_XDEV | AT_NO_MAGICLINKS | AT_NO_SYMLINKS |
> +                              AT_THIS_ROOT);
[...]
> +#define AT_THIS_ROOT           0x100000 /* - Scope ".." resolution to dirfd (like chroot(2)). */

So now what happens if there is a setuid root ELF binary with program
interpreter "/lib64/ld-linux-x86-64.so.2" (like /bin/su), and an
unprivileged user runs it with execveat(..., AT_THIS_ROOT)? Is that
going to let the unprivileged user decide which interpreter the
setuid-root process should use? From a high-level perspective, opening
the interpreter should be controlled by the program that is being
loaded, not by the program that invoked it.


In my opinion, CVE-2019-5736 points out two different problems:

The big problem: The __ptrace_may_access() logic has a special-case
short-circuit for "introspection" that you can't opt out of; this
makes it possible to open things in procfs that are related to the
current process even if the credentials of the process wouldn't permit
accessing another process like it. I think the proper fix to deal with
this would be to add a prctl() flag for "set whether introspection is
allowed for this process", and if userspace has manually un-set that
flag, any introspection special-case logic would be skipped.

An additional problem: /proc/*/exe can be used to open a file for
writing; I think it may have been Andy Lutomirski who pointed out some
time ago that it would be nice if you couldn't use /proc/*/fd/* to
re-open files with more privileges, which is sort of the same thing.
