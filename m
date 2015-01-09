From: Rich Felker <dalias-/miJ2pyFWUyWIDz0JBNUog@public.gmane.org>
Subject: Re: [PATCHv10 man-pages 5/5] execveat.2: initial man page for
 execveat(2)
Date: Fri, 9 Jan 2015 15:48:15 -0500
Message-ID: <20150109204815.GR4574@brightrain.aerifal.cx>
References: <1416830039-21952-1-git-send-email-drysdale@google.com>
 <1416830039-21952-6-git-send-email-drysdale@google.com>
 <54AFF813.7050604@gmail.com>
 <20150109161302.GQ4574@brightrain.aerifal.cx>
 <CAHse=S88Jy5ZKM_VY5onfvxX7dTMngnxuHfuLeSuzvKvQNP19A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHse=S88Jy5ZKM_VY5onfvxX7dTMngnxuHfuLeSuzvKvQNP19A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Jan 09, 2015 at 05:46:28PM +0000, David Drysdale wrote:
> > It's AT_EXECFN,
> > /proc/self/exe, and filenames shown elsewhere in /proc that may be
> > derived in odd ways.
> >
> > I would also move the text about O_CLOEXEC to a BUGS or NOTES section
> > rather than the main description. The long-term intent should be that
> > script execution this way should work. IIRC this was discussed earlier
> > in the thread.
> 
> I may be misremembering, but I thought we hoped to be able to fix
> execveat of a script without /proc in future, but didn't expect to fix
> execveat of a script via an O_CLOEXEC fd (because in the latter
> case the fd gets closed before the script interpreter runs, so even
> if the interpreter (or a special filesystem) does clever things for names
> starting with "/dev/fd/..." the file descriptor is already gone).

I think this is a case that needs to be fixed, though it's hard. The
normal correct usage for fexecve is to always pass an O_CLOEXEC file
descriptor, and the caller can't really be expected to know whether
the file is a script or not. We discussed workarounds before and one
idea I proposed was having fexecve provide a "one open only" magic
symlink in /proc/self/ to pass to the interpreter. It would behave
like an O_PATH file descriptor magic symlink in /proc/self/fd, but
would automatically cease to exist on the first open (at which point
the interpreter would have a real O_RDONLY file descriptor for the
underlying file).

Rich
