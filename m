From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v10 24/46] xfs: Add richacl support
Date: Tue, 13 Oct 2015 15:39:15 +0200
Message-ID: <CAHc6FU7aNW3drN+Mj2PHyz0Tv8RHexSuUzWCPnCA7eCWY68pHQ@mail.gmail.com>
References: <1444604337-17651-1-git-send-email-andreas.gruenbacher@gmail.com>
	<1444604337-17651-25-git-send-email-andreas.gruenbacher@gmail.com>
	<20151012001033.GA27164@dastard>
	<CAHpGcMKeJHDegs2cYKaJdX4Tw43Jp30Nv_2WoSNZfBzGJKu=BQ@mail.gmail.com>
	<20151012040545.GC27164@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151012040545.GC27164@dastard>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS-devel Mailing List <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 12, 2015 at 6:05 AM, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wro=
te:
> On Mon, Oct 12, 2015 at 03:51:15AM +0200, Andreas Gr=C3=BCnbacher wro=
te:
>> 2015-10-12 2:10 GMT+02:00 Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>:
>> > Also, I really dislike the API where passing a NULL acl means to
>> > "set this acl" actually means "remove the existing ACL". Why no
>> > ->remove_acl method called from the generic code?
>>
>> It's not uncommon, it saves inode operations and wiring-up code.
>
> I know it's common. All it does is put extra branches in the
> filesystem code to do this, because remove is a different operation
> to set. The API sucks, and we're not limited on inode operations,
> and the operator overloading makes the filesystem code unnecessarily
> complex as it has to detect when to branch out ot remove or not...

I've tried it out. The filesystem code could be simplified (see the
richacl-wip [*] branch until the next posting). Adding a
remove_richacl inode operation on top of that really doesn't help.

Thanks,
Andreas

[*] git://git.kernel.org/pub/scm/linux/kernel/git/agruen/linux-richacl.=
git
richacl-wip
