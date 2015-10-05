From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v8 00/41] Richacls
Date: Mon, 5 Oct 2015 20:45:40 +0200
Message-ID: <CAHc6FU53mXg1k0KCNkWEjxyuC8iAUgWh-A76qX=C3Yth+qEyuQ@mail.gmail.com>
References: <1443391772-10171-1-git-send-email-agruenba@redhat.com>
	<20151004062313.GA20212@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151004062313.GA20212-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun, Oct 4, 2015 at 8:23 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> On Mon, Sep 28, 2015 at 12:08:51AM +0200, Andreas Gruenbacher wrote:
>> Hello,
>>
>> here's another update of the richacl patch queue.  At this stage, I would
>> like to ask for final feedback so that the core and ext4 code (patches
>> 1-19) can be merged in the 4.4 merge window.  The nfsd and nfs code should
>> then go through the respective maintainer trees.
>
> Now way in this form even if everyone agrees we should have these
> bastard ACLs.  I certainly disagree.

Well, thanks for having a look at the patches.

> Ayway, back to the VFS <-> FS interface.  You still require tons of
> boilderplate code in the filesystem which isn't required and we got rid
> of for Posix ACLs.  The filesystem should not look at the userspace
> xattr format, please follow a model similar to ->get_acl and ->set_acl
> for Posix ACLs.

I will repost a version that has this cleaned up.

> After that the wire up should be so trivial that you can wire up btrfs,
> xfs and f2fs as well, which is important to make the feature mergeable.

Why would the patch queue become more mergeable by having support for
more filesystems in it? The filesystem specific code really isn't all
that interesting.

> And honestly I tink adding even more overload to xattrs is a really bad
> idea and after 10 years of experience with that junk we really need to
> learn and make new overloads proper system calls.

Thanks,
Andreas
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
