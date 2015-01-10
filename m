From: Rich Felker <dalias-/miJ2pyFWUyWIDz0JBNUog@public.gmane.org>
Subject: Re: [PATCHv10 man-pages 5/5] execveat.2: initial man page for
 execveat(2)
Date: Fri, 9 Jan 2015 20:33:24 -0500
Message-ID: <20150110013324.GB4574@brightrain.aerifal.cx>
References: <20150109161302.GQ4574@brightrain.aerifal.cx>
 <CAHse=S88Jy5ZKM_VY5onfvxX7dTMngnxuHfuLeSuzvKvQNP19A@mail.gmail.com>
 <20150109204815.GR4574@brightrain.aerifal.cx>
 <20150109205626.GK22149@ZenIV.linux.org.uk>
 <20150109205926.GT4574@brightrain.aerifal.cx>
 <20150109210941.GL22149@ZenIV.linux.org.uk>
 <20150109212852.GU4574@brightrain.aerifal.cx>
 <87lhlbvbzs.fsf@x220.int.ebiederm.org>
 <20150109223843.GX4574@brightrain.aerifal.cx>
 <87mw5rtowa.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87mw5rtowa.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Jan 09, 2015 at 07:17:41PM -0600, Eric W. Biederman wrote:
> Rich Felker <dalias-/miJ2pyFWUyWIDz0JBNUog@public.gmane.org> writes:
> 
> > I'm not proposing code because I'm a libc developer not a kernel
> > developer. I know what's needed for userspace to provide a conforming
> > fexecve to applications, not how to implement that on the kernel side,
> > although I'm trying to provide constructive ideas. The hostility is
> > really not necessary.
> 
> Conforming to what?
> 
> The open group fexecve says nothing about requiring a file descriptor
> passed to fexecve to have O_CLOEXEC.

It doesn't require it but it allows it, and in multithreaded programs
that might run child processes (or library code that might be used in
such situations), O_CLOEXEC is mandatory everywhere to avoid fd leaks.

> Further looking at open group specification of exec it seems to indicate
> the preferred way to handle this is for the kernel to return O_NOEXEC
> and then libc gets to figure out how to run the shell script.  Is that
> the kind of ``conforming'' implementation you are looking for?

This is a complex issue, and does not apply to native #! support
(which is a supported executable format and thus not ENOEXEC) but
rather standard POSIX shell scripts (which don't have a #! line at
all). In this case the behavior of fexecve is perhaps under-specified.
However, in cases where execve would succeed (without causing
ENOEXEC), I think it's at least undesirable, if not non-conforming,
for fexecve to fail.

Should we request clarification from the Austin Group?

Rich
