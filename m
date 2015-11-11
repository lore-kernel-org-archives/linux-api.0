From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v15 00/22] Richacls (Core and Ext4)
Date: Tue, 10 Nov 2015 23:57:07 -0800
Message-ID: <20151111075707.GA23752@infradead.org>
References: <1447067343-31479-1-git-send-email-agruenba@redhat.com>
 <20151110112943.GA17038@infradead.org>
 <CAHc6FU5g7=wd1Wt4+GCaLJjNu7giruZyAON3VcYn-A=ffYMsmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHc6FU5g7=wd1Wt4+GCaLJjNu7giruZyAON3VcYn-A=ffYMsmw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, XFS Developers <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 10, 2015 at 01:39:52PM +0100, Andreas Gruenbacher wrote:
> > It still has the same crappy fs interfaces with lots of boilerplate
> > code
> 
> Could you please be more specific so that I can trace this complaint
> to some actual code?

if (IS_RICHACL())
	richacl_foo()
else
	posix_acl_foo()

for every call from the filesystem is the major one that came to mind.

> > and still abuses xattrs instead of a proper syscall interface.
> > That's far from being ready to merge.
> 
> The xattr syscall interface is what's used for very similar kinds of
> things today; using it for richacls as well sure does not count as
> abuse. Things could be improved in the xattr interface and in its
> implementation, but we need more substantial reasons than that for
> reimplementing the wheel once again.

And it's a horrible interface.  Look at all the pain for example in
XFS which has a different ACL format, or in fact everyone who just
uses a different xattr name or even none at all.  And all the mess
of people trying to shoe horn crazy interfaces into xattrs.

It was an experiment worth trying with Posix ACLs, but it failed, so
do not repeat it.
