From: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v8 00/41] Richacls
Date: Tue, 29 Sep 2015 16:54:37 +0200
Message-ID: <CAHpGcMKfNewTJOL0ono8kCDoU8YZvxGfuLe3XP6VCGKuZL3mnA@mail.gmail.com>
References: <1443391772-10171-1-git-send-email-agruenba@redhat.com>
	<20150928163543.GF1358@fieldses.org>
	<CAHpGcM++=D1yrkVmZsKwdQCQj4yPdwGGNbmF-Bma7Yo_+kpNQQ@mail.gmail.com>
	<20150928174648.GA3190@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150928174648.GA3190-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Cc: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS-devel Mailing List <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

2015-09-28 19:46 GMT+02:00 J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>:
> On Mon, Sep 28, 2015 at 07:10:06PM +0200, Andreas Gr=C3=BCnbacher wro=
te:
>> 2015-09-28 18:35 GMT+02:00 J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>:
>> > On Mon, Sep 28, 2015 at 12:08:51AM +0200, Andreas Gruenbacher wrot=
e:
>> >> Open issues in nfs:
>> >>
>> >> * When a user or group name cannot be mapped, nfs's idmapper alwa=
ys maps it
>> >>   to nobody. That's good enough for mapping the file owner and ow=
ning
>> >>   group, but not for identifiers in acls. For now, to get the nfs=
 richacl
>> >>   support somewhat working, I'm explicitly checking if mapping ha=
s resulted
>> >>   in uid/gid 99 in the kernel.
>> >>
>> >> * When the nfs server replies with NFS4ERR_BADNAME for any user o=
r group
>> >>   name lookup, the client will stop sending numeric uids and gids=
 to the
>> >>   server even when the lookup wasn't numeric.  From then on, the =
client
>> >>   will translate uids and gids that have no mapping to the string=
 "nobody",
>> >>   and the server will reject them.  This problem is not specific =
to acls.
>> >
>> > Do you have fixes in mind for these two issues?
>>
>> I'm not sure how to best fix the idmapper problem, with backwards
>> compatibility and all.
>
> I haven't looked at the current nfsidmap interface....  So it's
> completely lacking any way to communicate failure?

Yes, when a user doesn't exist, idmapper maps that to the nobody
uid/gid. That's the failure mode of stat. In the acl case, we do want
to map user and group names to their respective ids where possible (so
that the acl makes sense in the local system context), but we do want
to preserve the original user and group names when there is no such
mapping instead of mapping to the nobody uid/gid.

>> The second problem shouldn't be too hard to fix.
>
> Is it enough to turn off the failover in the case there's no possibil=
ity
> it could have been caused by a numeric id?

Yes, I believe that would be enough.

> If any user can set ACLs with arbitrary strings as names, then we'd b=
e
> giving any user unprivileged user the ability to turn off numeric
> idmapping, so I think we need to fix that.

The bug can be triggered by unprivileged users with nfs4_setfacl.

Thanks,
Andreas
