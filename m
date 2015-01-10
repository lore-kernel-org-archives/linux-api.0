From: Rich Felker <dalias@aerifal.cx>
Subject: Re: [PATCHv10 man-pages 5/5] execveat.2: initial man page for
 execveat(2)
Date: Fri, 9 Jan 2015 22:41:44 -0500
Message-ID: <20150110034144.GC4574@brightrain.aerifal.cx>
References: <20150109210941.GL22149@ZenIV.linux.org.uk>
 <20150109212852.GU4574@brightrain.aerifal.cx>
 <20150109215042.GM22149@ZenIV.linux.org.uk>
 <20150109221728.GW4574@brightrain.aerifal.cx>
 <20150109223300.GO22149@ZenIV.linux.org.uk>
 <20150109224252.GY4574@brightrain.aerifal.cx>
 <20150109225743.GP22149@ZenIV.linux.org.uk>
 <20150109231248.GZ4574@brightrain.aerifal.cx>
 <20150109233644.GR22149@ZenIV.linux.org.uk>
 <20150110030300.GU22149@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150110030300.GU22149@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Drysdale <drysdale@google.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Andy Lutomirski <luto@amacapital.net>, Meredydd Luff <meredydd@senatehouse.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, David Miller <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Stephen Rothwell <sfr@canb.auug.org.au>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, sparclinux@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sat, Jan 10, 2015 at 03:03:00AM +0000, Al Viro wrote:
> On Fri, Jan 09, 2015 at 11:36:44PM +0000, Al Viro wrote:
> > On Fri, Jan 09, 2015 at 06:12:48PM -0500, Rich Felker wrote:
> > 
> > > I'm not sure where you're disagreeing with me. open of procfs symlinks
> > > does not resolve the symlink and open the resulting pathname. They are
> > > "magic symlinks" which are bound to the inode of the open file. I
> > > don't see why this action, which is already special for magic
> > > symlinks, can't check a flag on the magic symlink and possibly close
> > > the corresponding file descriptor as part of its action.
> > 
> > _What_ action?  ->follow_link()?  As in "the same thing that e.g.
> > stat(2) would trigger"?
> 
> To elaborate a bit: the fundamental method for symlink traversal is
> ->follow_link().  It gets dentry of the object itself + opaque context.
> Usually it just obtains some string (== symlink contents) and calls
> nd_set_link(context, string).  In that case the string will be interpreted
> by its callers in usual way.  Another possibility is to call
> nd_jump_link(context, location), which will reset the current position
> (directory in which the symlink has been found and relative to which it
> would be interpreted) to given location in tree.  It might actually do
> both - then the string will be interpreted relative to the new location.
> Once the pathname resolution is done with the string stored by nd_set_link(),
> it calls another method - ->put_link().  That one releases the object
> that contains this string; it gets an opaque pointer returned by
> ->follow_link().  Returning ERR_PTR(-Esomething) indicates an error, so does
> nd_set_link(context, ERR_PTR(-Esomething)).
> 
> readlink(2) is using a different method (->readlink()) and any object whose
> ->follow_link() only uses nd_set_link() can use generic_readlink as its
> ->readlink instance - that will call ->follow_link(), copy the string
> stored by nd_set_link() to userland buffer and use ->put_link() to release
> whatever needs to be released.  Most of the symlinks are doing just that.
> 
> procfs "magical" symlinks have ->follow_link() that uses nd_jump_link();
> they obviously can't use generic_readlink() (there is no string left
> by ->follow_link() for caller to traverse), so they have non-standard
> ->readlink() instances - ones that use d_path() to generate a plausible
> pathname of the would-be destination of their ->follow_link().  Or something
> like pipe:[696969], etc.
> 
> Note, however, that ->readlink() is used only by readlink(2) syscall; as far
> as pathname resolution is concerned it is completely irrelevant.  What matters
> is ->follow_link().
> 
> Now, the callers do not know (and do not care) what a particular symlink _is_.
> A symlink is just a dentry with inode that has non-NULL ->follow_link()
> method.  That's it.  Moreover, _any_ pathname resolution is using the
> same method for symlink traversal, be it open(2), stat(2), whatever.  If
> a symlink is to be traversed, that's it - the only choice VFS has is whether
> to traverse it at all or not (think of stat(2) vs lstat(2) difference, or
> O_NOFOLLOW, etc.)
> 
> _After_ the traversal it's too late to do this sort of thing - after all,
> how do you tell if your current position had been set by the traversal of
> your symlink or that of any normal /proc/self/fd/<n>?

Thanks for clarifying how this all works in the kernel. It makes it
easier to understand what the costs (especially complexity costs) of
different implementation options might be for the kernel.

> And doing that _during_ the traversal would really suck - stray ls -lR /proc
> could race with that open() done by script interpreter.

IMO this one issue is easily solvable by limiting the special action
to calls by the owning pid.

Rich
