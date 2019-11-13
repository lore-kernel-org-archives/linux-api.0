From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v15 5/9] namei: LOOKUP_IN_ROOT: chroot-like scoped
 resolution
Date: Wed, 13 Nov 2019 02:59:41 +0000
Message-ID: <20191113025941.GE26530@ZenIV.linux.org.uk>
References: <20191105090553.6350-1-cyphar@cyphar.com>
 <20191105090553.6350-6-cyphar@cyphar.com>
 <20191113020307.GB26530@ZenIV.linux.org.uk>
 <20191113024414.wlmvtjstpnkxa36n@yavin.dot.cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191113024414.wlmvtjstpnkxa36n@yavin.dot.cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Christian Brauner <christian.brauner@ubuntu.com>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Alexan
List-Id: linux-api@vger.kernel.org

On Wed, Nov 13, 2019 at 01:44:14PM +1100, Aleksa Sarai wrote:
> On 2019-11-13, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Tue, Nov 05, 2019 at 08:05:49PM +1100, Aleksa Sarai wrote:
> > 
> > > @@ -2277,12 +2277,20 @@ static const char *path_init(struct nameidata *nd, unsigned flags)
> > >  
> > >  	nd->m_seq = read_seqbegin(&mount_lock);
> > >  
> > > -	/* Figure out the starting path and root (if needed). */
> > > -	if (*s == '/') {
> > > +	/* Absolute pathname -- fetch the root. */
> > > +	if (flags & LOOKUP_IN_ROOT) {
> > > +		/* With LOOKUP_IN_ROOT, act as a relative path. */
> > > +		while (*s == '/')
> > > +			s++;
> > 
> > Er...  Why bother skipping slashes?  I mean, not only link_path_walk()
> > will skip them just fine, you are actually risking breakage in this:
> >                 if (*s && unlikely(!d_can_lookup(dentry))) {
> >                         fdput(f);
> >                         return ERR_PTR(-ENOTDIR);
> >                 }
> > which is downstream from there with you patch, AFAICS.
> 
> I switched to stripping the slashes at your suggestion a few revisions
> ago[1], and had (wrongly) assumed we needed to handle "/" somehow in
> path_init(). But you're quite right about link_path_walk() -- and I'd be
> more than happy to drop it.

That, IIRC, was about untangling the weirdness around multiple calls of
dirfd_path_init() and basically went "we might want just strip the slashes
in case of that flag very early in the entire thing, so that later the
normal logics for absolute/relative would DTRT".  Since your check is
right next to checking for absolute pathnames (and not in the very
beginning of path_init()), we might as well turn the check for
absolute pathname into *s == '/' && !(flags & LOOKUP_IN_ROOT) and be
done with that.
