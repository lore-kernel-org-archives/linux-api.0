From: Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFC PATCH 2/3] vfs: add d_replace()
Date: Thu, 1 Dec 2016 17:10:59 -0800
Message-ID: <20161202011059.GA4794@vader>
References: <cover.1479802448.git.osandov@fb.com>
 <527297d2dae27845b3b7ba8ad6e81ef477fddee2.1479802448.git.osandov@fb.com>
 <20161123034004.GK1555@ZenIV.linux.org.uk>
 <20161123035716.GA29697@mew>
 <CA+55aFxTQb5dFwziQ7uaHgew4xq6xKhYHpD1tGrZi9QvM6+SLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFxTQb5dFwziQ7uaHgew4xq6xKhYHpD1tGrZi9QvM6+SLw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 23, 2016 at 08:29:57AM -0800, Linus Torvalds wrote:
> On Tue, Nov 22, 2016 at 7:57 PM, Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org> wrote:
> > On Wed, Nov 23, 2016 at 03:40:04AM +0000, Al Viro wrote:
> >
> >> If it unhashed the old dentry, created a new one and attached inode to
> >> it, it _might_ have a chance.  I'm less than sure it's a good idea, but
> >> it this form it's a non-starter.
> >
> > One thing I considered was having the filesystem unhash the dentry and
> > just letting the next lookup that comes along instantiate the new one.
> > Is that better or worse than doing something like your suggestion?
> 
> I don't have the background for why you want this, but the two
> approaches should be equivalent.
> 
> However, it's not a safe operation in the general case, since the
> low-level filesystem may depend on the single unique dentry meaning
> that operations on one particular filename are serialized and that the
> dentry is unique, and your "unhash and create new" would leave old
> users with a stale dentry that is no longer "unique" in that filename.
> So you certainly cannot do even that kind of "d_replace()" in some
> general situation.
> 
> An example of that kind of situation is the whole "d_in_lookup()"
> where we use the dentry itself to guarantee uniqueness while possibly
> looking up multiple entries in parallell in the same directory.

Thanks, this was helpful. As you mentioned below, since this is for
linkat(), we're serialized on i_rwsem, so this particular case should be
fine. But if there's something that tries to serialize on the dentry
itself without holding i_rwsem at least shared, then this would
definitely be wrong. Does such a thing exist?

> So for some particular filesystem, under some very particular
> situations, such a d_replace() may be valid. But without seeing the
> background, it's hard to tell. Apparently this was discussed on the
> fsdevel list that google doesn't even index, and looking at the
> fsdevel archives is a pain. Looks like it's AT_REPLACE for linkat().

That's right, here's the thread:

[RFC PATCH 0/3] http://marc.info/?t=147980325700004&r=1&w=2
[RFC PATCH 1/3] http://marc.info/?t=147980325700006&r=1&w=2
[RFC PATCH 2/3] http://marc.info/?t=147980325700005&r=1&w=2
[RFC PATCH 3/3] http://marc.info/?t=147980325700007&r=1&w=2

(Man, I miss gmane.) I'll cc lkml on the next submission.

> In that context it superficially looks ok to me (ie it's
> filesystem-controlled and done only when we've serialized the
> directory for the link() operation anyway).  But I didn't think about
> it _that_ much.
> 
>                    Linus
