From: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v8 10/41] richacl: Permission check algorithm
Date: Mon, 28 Sep 2015 18:25:23 +0200
Message-ID: <CAHpGcMLHxF8uqbv-hCjKFHKxwemn0QdxZifT7WC95oHs7D3MfA@mail.gmail.com>
References: <1443391772-10171-1-git-send-email-agruenba@redhat.com>
	<1443391772-10171-11-git-send-email-agruenba@redhat.com>
	<20150928160855.GD1358@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150928160855.GD1358-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Cc: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS-devel Mailing List <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

2015-09-28 18:08 GMT+02:00 J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>:
> On Mon, Sep 28, 2015 at 12:09:01AM +0200, Andreas Gruenbacher wrote:
>> +     /*
>> +      * Check if the acl grants the requested access and determine which
>> +      * file class the process is in.
>> +      */
>> +     richacl_for_each_entry(ace, acl) {
>> +             unsigned int ace_mask = ace->e_mask;
>> +
>> +             if (richace_is_inherit_only(ace))
>> +                     continue;
>> +             if (richace_is_owner(ace)) {
>> +                     if (!uid_eq(current_fsuid(), inode->i_uid))
>> +                             continue;
>> +                     goto entry_matches_owner;
>> +             } else if (richace_is_group(ace)) {
>> +                     if (!in_owning_group)
>> +                             continue;
>> +             } else if (richace_is_unix_user(ace)) {
>> +                     if (!uid_eq(current_fsuid(), ace->e_id.uid))
>> +                             continue;
>> +                     goto entry_matches_owner;
>> +             } else if (richace_is_unix_group(ace)) {
>> +                     if (!in_group_p(ace->e_id.gid))
>> +                             continue;
>> +             } else
>> +                     goto entry_matches_everyone;
>> +
>> +             /*
>> +              * Apply the group file mask to entries other than owner@ and
>> +              * everyone@ or user entries matching the owner.
>
> The above also skips the following group_mask application on any unix
> group.

Really? How does it do that?

Thanks,
Andreas
