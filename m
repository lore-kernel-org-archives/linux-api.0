From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCHv4 RESEND 0/3] syscalls,x86: Add execveat() system call
Date: Sun, 19 Oct 2014 16:35:05 -0700
Message-ID: <CALCETrW1bWcRZxJcKS0tdCxy++Y=ndoxeh5HuZrLMLHnk+i5NA@mail.gmail.com>
References: <1401975635-6162-1-git-send-email-drysdale@google.com>
 <CALCETrVraoD+r4zxBoGd+BV5P275AXcRV_R00SSr8fjQzRHnUg@mail.gmail.com>
 <20141019202034.GH7996@ZenIV.linux.org.uk> <CALCETrVZUW2iPtfFJtGnWd2RsYLwjGRGYuujrVqcOsO5oBB8Cg@mail.gmail.com>
 <20141019212921.GI7996@ZenIV.linux.org.uk> <CALCETrVTiO6YKRYAAe-eBgQvpUqrtE0=KrKJj2T_XJ9iSRDtmA@mail.gmail.com>
 <20141019224251.GJ7996@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141019224251.GJ7996@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Drysdale <drysdale@google.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Meredydd Luff <meredydd@senatehouse.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sun, Oct 19, 2014 at 3:42 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sun, Oct 19, 2014 at 03:16:03PM -0700, Andy Lutomirski wrote:
>
>> Oh, you mean that #!/usr/bin/make -f would turn into /usr/bin/make
>> /dev/fd/3?  That could be interesting, although I can imagine it
>> breaking things, especially if /dev/fd/3 isn't set up like that, e.g.
>> early in boot.
>
> Sigh...  What I mean is that fexecve(fd, ...) would have to put _something_
> into argv when it execs the interpreter of #! file.  Simply because the
> interpreter (which can be anything whatsoever) has no fscking idea what
> to do with some descriptor it has before execve().  Hell, it doesn't have
> any idea *which* descriptor had it been.
>
> You need to put some pathname that would yield your script upon open(2).
> If you bothered to read those patches, you'd see that they do supply
> one, generating it with d_path().  Which isn't particulary reliable.
>
> I'm not sure there's any point putting any of that in the kernel - if
> you *do* have that pathname, you can just pass it.

Hmm.

This issue certainly makes fexecve or execveat less attractive, at
least in cases where d_path won't work.

On the other hand, if you want to run a static binary on a cloexec fd
(or, for that matter, a dynamic binary if you trust the interpreter to
close the extra copy of the fd it gets) in a namespace or chroot where
the binary is invisible, then you need kernel help.

It's too bad that script interpreters don't have a mechanism to open
their scripts by fd.

>
>> Aside from the general scariness of allowing one process to actually
>> dup another process's fds, I feel like this is asking for trouble wrt
>> the various types of file locks.
>
> Who said anything about another process's fds?  That, indeed, would be
> a recipe for serious trouble.  It's a filesystem with one directory,
> not with one directory for each process...
>

This still has issues with locks if you pass an fd to a child process,
but I guess that you get what you ask for if you do that.

> FWIW, they (Plan 9) do have procfs and there they have /proc/<pid>/fd.
> Which is a regular file, with contents consisting of \n-terminated
> lines (one per descriptor in <pid>'s descriptor table>) in the same
> format as in *ctl (they put descriptor number as the first field in
> those).
>
> Unlike our solution, they do not allow to get to any process' files via
> procfs.  They do allow /dev/stdin-style access to your own files via
> dupfs.  And yes, for /dev/stdin and friends dup-style semantics is better -
> you get consistent behaviours for pipes and redirects from file that way.
> See the example I've posted upthread.  Besides, for things like sockets
> our semantics simply fails - they really depend on having only one
> struct file for given socket; it's dup or nothing there.  The same goes
> for a lot of things like eventfd, etc.

Fair enough.

--Andy
