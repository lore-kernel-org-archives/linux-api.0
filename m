From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v15 3/9] namei: LOOKUP_NO_XDEV: block mountpoint crossing
Date: Thu, 14 Nov 2019 05:43:48 +0000
Message-ID: <20191114054348.GH26530@ZenIV.linux.org.uk>
References: <20191105090553.6350-1-cyphar@cyphar.com>
 <20191105090553.6350-4-cyphar@cyphar.com>
 <20191113013630.GZ26530@ZenIV.linux.org.uk>
 <20191114044945.ldedzjrb4s7i7irr@yavin.dot.cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191114044945.ldedzjrb4s7i7irr@yavin.dot.cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Christian Brauner <christian.brauner@ubuntu.com>, David Drysdale <drysdale@google.com>, Andy Lutomirski <luto@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Eric Biederman <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Ras
List-Id: linux-api@vger.kernel.org

On Thu, Nov 14, 2019 at 03:49:45PM +1100, Aleksa Sarai wrote:
> On 2019-11-13, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Tue, Nov 05, 2019 at 08:05:47PM +1100, Aleksa Sarai wrote:
> > 
> > > @@ -862,6 +870,8 @@ static int nd_jump_root(struct nameidata *nd)
> > >  void nd_jump_link(struct path *path)
> > >  {
> > >  	struct nameidata *nd = current->nameidata;
> > > +
> > > +	nd->last_magiclink.same_mnt = (nd->path.mnt == path->mnt);
> > >  	path_put(&nd->path);
> > >  
> > >  	nd->path = *path;
> > > @@ -1082,6 +1092,10 @@ const char *get_link(struct nameidata *nd)
> > >  		if (nd->flags & LOOKUP_MAGICLINK_JUMPED) {
> > >  			if (unlikely(nd->flags & LOOKUP_NO_MAGICLINKS))
> > >  				return ERR_PTR(-ELOOP);
> > > +			if (unlikely(nd->flags & LOOKUP_NO_XDEV)) {
> > > +				if (!nd->last_magiclink.same_mnt)
> > > +					return ERR_PTR(-EXDEV);
> > > +			}
> > >  		}
> > 
> > Ugh...  Wouldn't it be better to take that logics (some equivalent thereof)
> > into nd_jump_link()?  Or just have nd_jump_link() return an error...
> 
> This could be done, but the reason for stashing it away in
> last_magiclink is because of the future magic-link re-opening patches
> which can't be implemented like that without putting the open_flags
> inside nameidata (which was decided to be too ugly a while ago).
> 
> My point being that I could implement it this way for this series, but
> I'd have to implement something like last_magiclink when I end up
> re-posting the magic-link stuff in a few weeks.
> 
> Looking at all the nd_jump_link() users, the other option is to just
> disallow magic-link crossings entirely for LOOKUP_NO_XDEV. The only
> thing allowing them permits is to resolve file descriptors that are
> pointing to the same procfs mount -- and it's unclear to me how useful
> that really is (apparmorfs and nsfs will always give -EXDEV because
> aafs_mnt and nsfs_mnt are internal kernel vfsmounts).

I would rather keep the entire if (nd->flags & LOOKUP_MAGICLINK_JUMPED)
out of the get_link().  If you want to generate some error if
nd_jump_link() has been called, just do it right there.  The fewer
pieces of state need to be carried around, the better...

And as for opening them...  Why would you need full open_flags in there?
Details, please...
