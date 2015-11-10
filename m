From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v15 00/22] Richacls (Core and Ext4)
Date: Tue, 10 Nov 2015 10:43:46 -0600
Message-ID: <CAH2r5ms1ckC59o9sbBEBAWQA0Q3tGOs=YJpk01xg19zThJDt-w@mail.gmail.com>
References: <1447067343-31479-1-git-send-email-agruenba@redhat.com>
 <20151110112943.GA17038@infradead.org> <CAHc6FU5g7=wd1Wt4+GCaLJjNu7giruZyAON3VcYn-A=ffYMsmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHc6FU5g7=wd1Wt4+GCaLJjNu7giruZyAON3VcYn-A=ffYMsmw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, XFS Developers <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 10, 2015 at 6:39 AM, Andreas Gruenbacher
<agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, Nov 10, 2015 at 12:29 PM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>> On Mon, Nov 09, 2015 at 12:08:41PM +0100, Andreas Gruenbacher wrote:
>>> Here is another update to the richacl patch queue.  This posting contains
>>> the patches ready to be merged; the patches later in the queue still need
>>> some more review.
<snip>
>> and still abuses xattrs instead of a proper syscall interface.
>> That's far from being ready to merge.
>
> The xattr syscall interface is what's used for very similar kinds of
> things today; using it for richacls as well sure does not count as
> abuse. Things could be improved in the xattr interface and in its
> implementation, but we need more substantial reasons than that for
> reimplementing the wheel once again.

I don't have strong disagreement with using pseudo-xattrs to
store/retrieve ACLs (we already do this) but retrieving/setting an ACL
all at once can be awkward  when ACLs are quite large e.g. when it
encodes to over 1MB (not all administrators think about the size of
ACLs when they add hundreds of users or groups or apps to ACLs).

The bigger problem is that when ACLs are created -- after -- the file
is created there is a potential race (harder to deal with in cluster
and network file systems).   Ideally we should be able to optionally
pass all the security information needed to create a file in the
create call itself.  For apps which don't care they can continue to
use the old syscalls.

In the meantime, I don't mind the approach of staging this in via a
pseudo-xattr, Samba can deal with that (and it will make some of the
backup and data movement tools easier for the cifs.ko client which
currently rely on a cifs specific xattr).

In cifs.ko I still need to enable the SMB3 ACL helper functions
(currently only enabled for the older cifs dialect) since that will
make it easier, and figure out a way to allow helper tools to view
"claims based ACLs" (DAC), not just traditional
CIFS/NTFS/SMB3/RichACLs.
-- 
Thanks,

Steve
