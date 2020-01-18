From: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH v3 0/2] openat2: minor uapi cleanups
Date: Sat, 18 Jan 2020 18:09:41 +0000
Message-ID: <20200118180941.GT8904@ZenIV.linux.org.uk>
References: <20200115144831.GJ8904@ZenIV.linux.org.uk>
 <20200118120800.16358-1-cyphar@cyphar.com>
 <20200118152833.GS8904@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200118152833.GS8904-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Laight <david.laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org>, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, quae-l4MFkWPWeOkX2WXlbB3fKg@public.gmane.org, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, Jan 18, 2020 at 03:28:33PM +0000, Al Viro wrote:

> #work.openat2 updated, #for-next rebuilt and force-pushed.  There's
> a massive update of #work.namei as well, also pushed out; not in
> #for-next yet, will post the patch series for review later today.

BTW, looking through that code again, how could this
static bool legitimize_root(struct nameidata *nd)
{
        /*
         * For scoped-lookups (where nd->root has been zeroed), we need to
         * restart the whole lookup from scratch -- because set_root() is wrong
         * for these lookups (nd->dfd is the root, not the filesystem root).
         */
        if (!nd->root.mnt && (nd->flags & LOOKUP_IS_SCOPED))
                return false;

possibly trigger?  The only things that ever clean ->root.mnt are

	1) failing legitimize_path(nd, &nd->root, nd->root_seq) in
legitimize_root() itself.  If *ANY* legitimize_path() has failed,
we are through - RCU pathwalk is given up.  In particular, if you
look at the call chains leading to legitimize_root(), you'll see
that it's called by unlazy_walk() or unlazy_child() and failure
has either of those buggger off immediately.  The same goes for
their callers; fail any of those and we are done; the very next
thing that will be done with that nameidata is going to be
terminate_walk().  We don't look at its fields, etc. - just return
to the top level ASAP and call terminate_walk() on it.  Which is where
we run into
                if (nd->flags & LOOKUP_ROOT_GRABBED) {
                        path_put(&nd->root);
                        nd->flags &= ~LOOKUP_ROOT_GRABBED;
                }
paired with setting LOOKUP_ROOT_GRABBED just before the attempt
to legitimize in legitimize_root().  The next thing *after*
terminate_walk() is either path_init() or the end of life for
that struct nameidata instance.
	This is really, really fundamental for understanding the whole
thing - a failure of unlazy_walk/unlazy_child means that we are through
with that attempt.

	2) complete_walk() doing
                if (!(nd->flags & (LOOKUP_ROOT | LOOKUP_IS_SCOPED)))
                        nd->root.mnt = NULL;   
Can't happen with LOOKUP_IS_SCOPED in flags, obviously.

	3) path_init().  Where it's followed either by leaving through
        if (*s == '/' && !(flags & LOOKUP_IN_ROOT)) {
		....
        }
(and LOOKUP_IS_SCOPED includes LOOKUP_IN_ROOT) or with a failure exit
(no calls of *anything* but terminate_walk() after that or with
        if (flags & LOOKUP_IS_SCOPED) {
                nd->root = nd->path;
... and that makes damn sure nd->root.mnt is not NULL.

And neither of the LOOKUP_IS_SCOPED bits ever gets changed in nd->flags -
they remain as path_init() has set them.

The same, BTW, goes for the check you've added in the beginning of
set_root() - set_root() is called only with NULL nd->root.mnt (trivial to
prove) and that is incompatible with LOOKUP_IS_SCOPED.  I'm kinda-sorta
OK with having WARN_ON() there for a while, but IMO the check in the
beginning of legitimize_root() should go away - this kind of defensive
programming only makes harder to reason about the behaviour of the
entire thing.  And fs/namei.c is too convoluted as it is...
