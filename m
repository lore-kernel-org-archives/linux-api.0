From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCHv10 man-pages 5/5] execveat.2: initial man page for execveat(2)
Date: Fri, 09 Jan 2015 16:13:27 -0600
Message-ID: <87lhlbvbzs.fsf@x220.int.ebiederm.org>
References: <1416830039-21952-1-git-send-email-drysdale@google.com>
	<1416830039-21952-6-git-send-email-drysdale@google.com>
	<54AFF813.7050604@gmail.com>
	<20150109161302.GQ4574@brightrain.aerifal.cx>
	<CAHse=S88Jy5ZKM_VY5onfvxX7dTMngnxuHfuLeSuzvKvQNP19A@mail.gmail.com>
	<20150109204815.GR4574@brightrain.aerifal.cx>
	<20150109205626.GK22149@ZenIV.linux.org.uk>
	<20150109205926.GT4574@brightrain.aerifal.cx>
	<20150109210941.GL22149@ZenIV.linux.org.uk>
	<20150109212852.GU4574@brightrain.aerifal.cx>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150109212852.GU4574-C3MtFaGISjmo6RMmaWD+6Sb1p8zYI1N1@public.gmane.org> (Rich Felker's
	message of "Fri, 9 Jan 2015 16:28:52 -0500")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rich Felker <dalias-/miJ2pyFWUyWIDz0JBNUog@public.gmane.org>
Cc: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Rich Felker <dalias-/miJ2pyFWUyWIDz0JBNUog@public.gmane.org> writes:

> On Fri, Jan 09, 2015 at 09:09:41PM +0000, Al Viro wrote:

> The "magic open-once magic symlink" approach is really the cleanest
> solution I can find. In the case where the interpreter does not open
> the script, nothing terribly bad happens; the magic symlink just
> sticks around until _exit or exec. In the case where the interpreter
> opens it more than once, you get a failure, but as far as I know
> existing interpreters don't do this, and it's arguably bad design. In
> any case it's a caught error.

And it doesn't work without introducing security vulnerabilities into
the kernel, because it breaks close-on-exec semantics.

All you have to do is pick a file descriptor, good canidates are 0 and
255 and make it a convention that that file descriptor is used for
fexecve.  At least when you want to support scripts.  Otherwise you can
set close-on-exec.

That results in no accumulation of file descriptors  because everyone
always uses the same file descriptor.

Regardless you don't have a patch and you aren't proposing code and the
code isn't actually broken so please go away.

Eric
