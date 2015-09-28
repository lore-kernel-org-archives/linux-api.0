From: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v8 00/41] Richacls
Date: Mon, 28 Sep 2015 19:10:06 +0200
Message-ID: <CAHpGcM++=D1yrkVmZsKwdQCQj4yPdwGGNbmF-Bma7Yo_+kpNQQ@mail.gmail.com>
References: <1443391772-10171-1-git-send-email-agruenba@redhat.com>
	<20150928163543.GF1358@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150928163543.GF1358-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Cc: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS-devel Mailing List <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

2015-09-28 18:35 GMT+02:00 J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>:
> On Mon, Sep 28, 2015 at 12:08:51AM +0200, Andreas Gruenbacher wrote:
>> here's another update of the richacl patch queue.  At this stage, I would
>> like to ask for final feedback so that the core and ext4 code (patches
>> 1-19) can be merged in the 4.4 merge window.  The nfsd and nfs code should
>> then go through the respective maintainer trees.
>
> I've been over the core richacl and nfsd parts very carefully, and they
> definitely look ready to me.

Thanks a lot for all that work, by the way.

>> Changes since the last posting (https://lwn.net/Articles/656704/):
>>
>> * The MAY_DELETE_SELF permission now also overrides the sticky
>>    directory checks.
>>
>> * Fix the permission check algorithm to apply the owner mask instead
>>   of the group mask to user entries matching the current owner. That way,
>>   the owner will retain the permissions in those entries when creating
>>   objects with create mode 0700 and similar. (A chmod to mode 0700 already
>>   creates an owner@:rwpx::allow ace, which was hiding this bug.)
>>
>> * Fix richacl_apply_masks to properly insert deny aces when raising the
>>   permissions of the other class. The bug could be triggered by
>>   chmod'ing a group@:r::allow acl to mode 0077, for example.
>>
>> * Various cleanups and improvements to comments.
>>
>>
>> The complete patch queue is available here:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/agruen/linux-richacl.git \
>>           richacl-2015-09-28
>>
>>
>> The richacl user-space utilitites and test suite are available here:
>>
>>   https://github.com/andreas-gruenbacher/richacl/
>>
>>
>> Open issues in nfs:
>>
>> * When a user or group name cannot be mapped, nfs's idmapper always maps it
>>   to nobody. That's good enough for mapping the file owner and owning
>>   group, but not for identifiers in acls. For now, to get the nfs richacl
>>   support somewhat working, I'm explicitly checking if mapping has resulted
>>   in uid/gid 99 in the kernel.
>>
>> * When the nfs server replies with NFS4ERR_BADNAME for any user or group
>>   name lookup, the client will stop sending numeric uids and gids to the
>>   server even when the lookup wasn't numeric.  From then on, the client
>>   will translate uids and gids that have no mapping to the string "nobody",
>>   and the server will reject them.  This problem is not specific to acls.
>
> Do you have fixes in mind for these two issues?

I'm not sure how to best fix the idmapper problem, with backwards
compatibility and all. The second problem shouldn't be too hard to
fix.

Thanks,
Andreas
