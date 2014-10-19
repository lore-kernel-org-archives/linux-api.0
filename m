From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCHv4 RESEND 0/3] syscalls,x86: Add execveat() system call
Date: Sun, 19 Oct 2014 22:29:21 +0100
Message-ID: <20141019212921.GI7996@ZenIV.linux.org.uk>
References: <1401975635-6162-1-git-send-email-drysdale@google.com>
 <CALCETrVraoD+r4zxBoGd+BV5P275AXcRV_R00SSr8fjQzRHnUg@mail.gmail.com>
 <20141019202034.GH7996@ZenIV.linux.org.uk>
 <CALCETrVZUW2iPtfFJtGnWd2RsYLwjGRGYuujrVqcOsO5oBB8Cg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrVZUW2iPtfFJtGnWd2RsYLwjGRGYuujrVqcOsO5oBB8Cg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Oct 19, 2014 at 01:37:54PM -0700, Andy Lutomirski wrote:
> > The question I hadn't seen really answered through all of that was how to
> > deal with #!...  "Just use d_path()" isn't particulary appealing - if that
> > file has a pathname reachable for you, you could bloody well use _that_
> > from the very beginning.
> 
> Does this matter for absolute paths after #! (or for absolute paths to
> ELF interpreters)?  Does anyone use relative paths there?

It's not about what's after #!; it's what we *append* to what's after #!
that is interesting.  Recall how #! works - we turn execve() of something
that starts with e.g. "#!/usr/bin/make -f\n" into execve of /usr/bin/make,
with (/usr/bin/make, -f, name of that file, argv[1]..argv[argc]) as
arguments list.  With make(1) doing opening and reading the file, as it
would for any makefile.  Or /bin/sh opening and reading the script, etc.

Pathname of interpreter is a non-issue (and ELF ones don't go anywhere
near that path anyway).

> Does execve("/proc/self/fd/N", ...) not work correctly now?

Yes, it does.  And if procfs is there, this syscall is completely pointless.
The main argument in favour of adding it to the kernel (rather than doing
in userland) has been "but what of the people who don't want procfs mounted
in there?".

> Presumably relative paths should be relative to the execed program, or
> maybe there should be a flag to execveat that disallows that behavior
> entirely, or maybe it should never work, even through /proc.  I don't
> really like the idea that an fd pointing at a *file* should allow
> access to its directory.

Huh?  What are you talking about?  And who the hell cares whether it's
absolute or relative?

> I'm not convinced that these semantics are better than /proc/self/fd's
> in many contexts.  I don't really like the idea that catting some file
> can *change* the position of one of my open file descriptors.

Er...  You do realize that if descriptor refers to the same file,
cat <&<that descriptor> will change position of your other descriptor,
right?  BTW, on *BSD /dev/stdin *does* have a dup()-style semantics.
They do it at the price of very convoluted code in their VFS, but that's
how it works there.  And in Plan 9, and (AFAIK) in Solaris...
