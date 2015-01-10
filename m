From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCHv10 man-pages 5/5] execveat.2: initial man page for
 execveat(2)
Date: Sat, 10 Jan 2015 03:03:00 +0000
Message-ID: <20150110030300.GU22149@ZenIV.linux.org.uk>
References: <20150109205926.GT4574@brightrain.aerifal.cx>
 <20150109210941.GL22149@ZenIV.linux.org.uk>
 <20150109212852.GU4574@brightrain.aerifal.cx>
 <20150109215042.GM22149@ZenIV.linux.org.uk>
 <20150109221728.GW4574@brightrain.aerifal.cx>
 <20150109223300.GO22149@ZenIV.linux.org.uk>
 <20150109224252.GY4574@brightrain.aerifal.cx>
 <20150109225743.GP22149@ZenIV.linux.org.uk>
 <20150109231248.GZ4574@brightrain.aerifal.cx>
 <20150109233644.GR22149@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150109233644.GR22149-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rich Felker <dalias-/miJ2pyFWUyWIDz0JBNUog@public.gmane.org>
Cc: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Jan 09, 2015 at 11:36:44PM +0000, Al Viro wrote:
> On Fri, Jan 09, 2015 at 06:12:48PM -0500, Rich Felker wrote:
> 
> > I'm not sure where you're disagreeing with me. open of procfs symlinks
> > does not resolve the symlink and open the resulting pathname. They are
> > "magic symlinks" which are bound to the inode of the open file. I
> > don't see why this action, which is already special for magic
> > symlinks, can't check a flag on the magic symlink and possibly close
> > the corresponding file descriptor as part of its action.
> 
> _What_ action?  ->follow_link()?  As in "the same thing that e.g.
> stat(2) would trigger"?

To elaborate a bit: the fundamental method for symlink traversal is
->follow_link().  It gets dentry of the object itself + opaque context.
Usually it just obtains some string (== symlink contents) and calls
nd_set_link(context, string).  In that case the string will be interpreted
by its callers in usual way.  Another possibility is to call
nd_jump_link(context, location), which will reset the current position
(directory in which the symlink has been found and relative to which it
would be interpreted) to given location in tree.  It might actually do
both - then the string will be interpreted relative to the new location.
Once the pathname resolution is done with the string stored by nd_set_link(),
it calls another method - ->put_link().  That one releases the object
that contains this string; it gets an opaque pointer returned by
->follow_link().  Returning ERR_PTR(-Esomething) indicates an error, so does
nd_set_link(context, ERR_PTR(-Esomething)).

readlink(2) is using a different method (->readlink()) and any object whose
->follow_link() only uses nd_set_link() can use generic_readlink as its
->readlink instance - that will call ->follow_link(), copy the string
stored by nd_set_link() to userland buffer and use ->put_link() to release
whatever needs to be released.  Most of the symlinks are doing just that.

procfs "magical" symlinks have ->follow_link() that uses nd_jump_link();
they obviously can't use generic_readlink() (there is no string left
by ->follow_link() for caller to traverse), so they have non-standard
->readlink() instances - ones that use d_path() to generate a plausible
pathname of the would-be destination of their ->follow_link().  Or something
like pipe:[696969], etc.

Note, however, that ->readlink() is used only by readlink(2) syscall; as far
as pathname resolution is concerned it is completely irrelevant.  What matters
is ->follow_link().

Now, the callers do not know (and do not care) what a particular symlink _is_.
A symlink is just a dentry with inode that has non-NULL ->follow_link()
method.  That's it.  Moreover, _any_ pathname resolution is using the
same method for symlink traversal, be it open(2), stat(2), whatever.  If
a symlink is to be traversed, that's it - the only choice VFS has is whether
to traverse it at all or not (think of stat(2) vs lstat(2) difference, or
O_NOFOLLOW, etc.)

_After_ the traversal it's too late to do this sort of thing - after all,
how do you tell if your current position had been set by the traversal of
your symlink or that of any normal /proc/self/fd/<n>?

And doing that _during_ the traversal would really suck - stray ls -lR /proc
could race with that open() done by script interpreter.

It might be possible to work around that, but trying that rapidly gets into
very ugly territory, *especially* since the handling of the final component
of open(2) (fs/namei.c:do_last()) is already far too convoluted.
