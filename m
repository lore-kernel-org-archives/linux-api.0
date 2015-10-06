From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v8 00/41] Richacls
Date: Tue, 6 Oct 2015 15:12:36 +0200
Message-ID: <CAHc6FU5aZJDC3N1iGyVeHfbqMyquM93ONJvUR-t0a9+AjmtAXQ@mail.gmail.com>
References: <1443391772-10171-1-git-send-email-agruenba@redhat.com>
	<20151004062313.GA20212@infradead.org>
	<CAHc6FU53mXg1k0KCNkWEjxyuC8iAUgWh-A76qX=C3Yth+qEyuQ@mail.gmail.com>
	<5612C85C.2060407@gmail.com>
	<20151006094935.GA14144@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151006094935.GA14144-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Oct 6, 2015 at 11:49 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> On Mon, Oct 05, 2015 at 02:58:36PM -0400, Austin S Hemmelgarn wrote:
>> I think the point is that a new VFS feature that is easy to integrate in
>> multiple filesystems should have support for those filesystems.  A decade
>> ago, just having ext* support would probably have been fine, but these days,
>> XFS, BTRFS, and F2FS are used just as much (if not more) on production
>> systems as ext4, and having support for them right from the start would
>> significantly help with adoption of richacls.
>
> That's one reason.  The other is that actually wiring it up for more
> than a single consumer shows its actually reasonable generic.

The filesystem interface now is the same as for POSIX ACLs, used by a
dozen or so filesystems already.

>  I don't want to end up with a situration like Posix ACLs again where
> different file systems using different on disk formats again.

Any file system could choose a different on-disk format than the one
that ext4 currently uses, but I don't see a reason why any should.
Apart from uid / gid mappings that is the same as the user-space xattr
format. Network file systems like NFSv4 and CIFS with their predefined
over-the-wire formats obviously are another story.

Thanks,
Andreas
