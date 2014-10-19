From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCHv4 RESEND 0/3] syscalls,x86: Add execveat() system call
Date: Sun, 19 Oct 2014 13:37:54 -0700
Message-ID: <CALCETrVZUW2iPtfFJtGnWd2RsYLwjGRGYuujrVqcOsO5oBB8Cg@mail.gmail.com>
References: <1401975635-6162-1-git-send-email-drysdale@google.com>
 <CALCETrVraoD+r4zxBoGd+BV5P275AXcRV_R00SSr8fjQzRHnUg@mail.gmail.com> <20141019202034.GH7996@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141019202034.GH7996-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Oct 19, 2014 at 1:20 PM, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org> wrote:
> On Fri, Oct 17, 2014 at 02:45:03PM -0700, Andy Lutomirski wrote:
>
>> For example, I want to be able to reliably do something like nsenter
>> --namespace-flags-here toybox sh.  Toybox's shell is unusual in that
>> it is more or less fully functional, so this should Just Work (tm),
>> except that the toybox binary might not exist in the namespace being
>> entered.  If execveat were available, I could rig nsenter or a similar
>> tool to open it with O_CLOEXEC, enter the namespace, and then call
>> execveat.
>
> The question I hadn't seen really answered through all of that was how to
> deal with #!...  "Just use d_path()" isn't particulary appealing - if that
> file has a pathname reachable for you, you could bloody well use _that_
> from the very beginning.

Does this matter for absolute paths after #! (or for absolute paths to
ELF interpreters)?  Does anyone use relative paths there?

Does execve("/proc/self/fd/N", ...) not work correctly now?
Presumably relative paths should be relative to the execed program, or
maybe there should be a flag to execveat that disallows that behavior
entirely, or maybe it should never work, even through /proc.  I don't
really like the idea that an fd pointing at a *file* should allow
access to its directory.

>
> Frankly, I wonder if it would make sense to provide something like
> dupfs.  We can't mount it by default on /dev/fd (more's the pity), but
> it might be a good thing to have.
>
> What it is, for those who are not familiar with Plan 9: a filesystem with
> one directory and a bunch of files in it.  Directory contents depends on
> who's looking; for each opened descriptor in your descriptor table, you'll
> see two files there.  One series is 0, 1, ... - opening one of those gives
> dup().  IOW, it's *not* giving you a new struct file; it gives you a new
> reference to existing one, complete with sharing IO position, etc.  Another
> is 0ctl, 1ctl, ... - those are read-only and reading from them gives pretty
> much a combination of our /proc/self/fdinfo/n with readlink of /proc/self/fd/n.
>
> It's actually a better match for what one would expect at /dev/fd than what
> we do.  Example:
>
> ; echo 'read i; cat /dev/fd/0; echo "The first line was $i"' >a.sh
> ; (echo 'line 1';echo 'line 2') >a
> ; cat a|sh a.sh
> line 2
> The first line was line 1
> ; sh a.sh <a
> line 1
> line 2
> The first line was line 1
> ;
>
> See what's going on?  Opening /dev/fd/0 (aka /dev/stdin) does a fresh open
> of whatever your stdin is; if it's a pipe - fine, you've just added yourself
> as additional reader.  But if it's a regular file, you've got yourself
> a brand-new opened file, with IO position of its own.  Sitting at the
> beginning of the file.
>
> Moreover, try that with stdin being a socket and you'll see cat(1) failing
> to open that sucker.
>
> We _can't_ blindly replace /dev/fd with it - it has to be a sysadmin choice;
> semantics is different.  However, there's no reason why it can't be mounted
> in environments where you want to avoid procfs - it's certainly exposing less
> than procfs would.
>
> And these days we can implement relatively cheaply.  It's a window that will
> close after a while, but right now we can change ->atomic_open() calling
> conventions.  Instead of having it return 0 or error, let's switch to returning
> NULL, ERR_PTR(error) *or* an extra reference to preexisting struct file.
> Same as we did for ->lookup(), and for similar reason.
>
> Right now we have 8 instances of ->atomic_open() and one place calling that
> method.  Changing the API like that would be trivial (and it's a trivial
> conversion - replace return ret; with return ERR_PTR(ret); through all
> instances, so any out-of-tree filesystems could follow easily).  We certainly
> can't do anything of that sort with ->open() - there would be thousands
> instances to convert.  ->atomic_open(), OTOH, is still new enough for
> that to be feasible.
>
> What we get from that conversion is an ability to do dup-style semantics
> easily.
>         * give root directory an ->atomic_open() instance that would be
> handling opens.
>         * make lookups in there fail with ENOENT if you don't have such a
> descriptor at the moment.  Otherwise bind all of them to the same inode.
> The only method it needs is ->getattr(), and that would look into your
> descriptor table for descriptor with number derived from dentry (stashed
> in ->d_fsdata at lookup time) and do what fstat() would.
>         * have those dentries always fail ->d_revalidate(), to force
> everything towards ->atomic_open().
>         * for ...ctl names, ->atomic_open() would act in normal fashion;
> again, only one inode is needed.  ->read() would pick descriptor number
> from ->d_fsdata and report on whatever you have with that number at the
> time.
>
> I'll try to put a prototype of that together; I think it's at least
> interesting to try.  And that ought to be safe to mount even in very
> restricted environments, making arguments along the lines of "but we can't
> get the path by opened file without the big bad wol^Wprocfs and we can't
> have that in our environment" much weaker...
>
> Comments?

I'm not convinced that these semantics are better than /proc/self/fd's
in many contexts.  I don't really like the idea that catting some file
can *change* the position of one of my open file descriptors.  Also,
for execveat in particular, I want to be able to setns into a
completely unknown namespace and exec something, so a new fs won't
help if it's not mounted.

An alternative solution to proc-lite would be to have a heavily
stripped-down variant of /proc.  It could self as a real directory
(not a symlink), with the normal semantics for /proc/self/fd, and it
could have very little else (possibly nothing at all; possibly exe,
root, and cwd).

--Andy
\
