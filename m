From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v8 10/41] richacl: Permission check algorithm
Date: Mon, 28 Sep 2015 12:29:05 -0400
Message-ID: <20150928162905.GE1358@fieldses.org>
References: <1443391772-10171-1-git-send-email-agruenba@redhat.com>
 <1443391772-10171-11-git-send-email-agruenba@redhat.com>
 <20150928160855.GD1358@fieldses.org>
 <CAHpGcMLHxF8uqbv-hCjKFHKxwemn0QdxZifT7WC95oHs7D3MfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHpGcMLHxF8uqbv-hCjKFHKxwemn0QdxZifT7WC95oHs7D3MfA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas =?utf-8?Q?Gr=C3=BCnbacher?= <andreas.gruenbacher-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS-devel Mailing List <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Sep 28, 2015 at 06:25:23PM +0200, Andreas Gr=C3=BCnbacher wrote=
:
> 2015-09-28 18:08 GMT+02:00 J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>:
> > On Mon, Sep 28, 2015 at 12:09:01AM +0200, Andreas Gruenbacher wrote=
:
> >> +     /*
> >> +      * Check if the acl grants the requested access and determin=
e which
> >> +      * file class the process is in.
> >> +      */
> >> +     richacl_for_each_entry(ace, acl) {
> >> +             unsigned int ace_mask =3D ace->e_mask;
> >> +
> >> +             if (richace_is_inherit_only(ace))
> >> +                     continue;
> >> +             if (richace_is_owner(ace)) {
> >> +                     if (!uid_eq(current_fsuid(), inode->i_uid))
> >> +                             continue;
> >> +                     goto entry_matches_owner;
> >> +             } else if (richace_is_group(ace)) {
> >> +                     if (!in_owning_group)
> >> +                             continue;
> >> +             } else if (richace_is_unix_user(ace)) {
> >> +                     if (!uid_eq(current_fsuid(), ace->e_id.uid))
> >> +                             continue;
> >> +                     goto entry_matches_owner;
> >> +             } else if (richace_is_unix_group(ace)) {
> >> +                     if (!in_group_p(ace->e_id.gid))
> >> +                             continue;
> >> +             } else
> >> +                     goto entry_matches_everyone;
> >> +
> >> +             /*
> >> +              * Apply the group file mask to entries other than o=
wner@ and
> >> +              * everyone@ or user entries matching the owner.
> >
> > The above also skips the following group_mask application on any un=
ix
> > group.
>=20
> Really? How does it do that?

Sorry, I meant "unix user", not "unix group"!

--b.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
