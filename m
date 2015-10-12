From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v10 24/46] xfs: Add richacl support
Date: Mon, 12 Oct 2015 07:57:34 +0200
Message-ID: <CAHc6FU55eOK4gWH1bhKvoujQ1zkT+we0xcfPUOeWrF_X0XHXZg@mail.gmail.com>
References: <1444604337-17651-1-git-send-email-andreas.gruenbacher@gmail.com>
	<1444604337-17651-25-git-send-email-andreas.gruenbacher@gmail.com>
	<20151012001033.GA27164@dastard>
	<CAHpGcMKeJHDegs2cYKaJdX4Tw43Jp30Nv_2WoSNZfBzGJKu=BQ@mail.gmail.com>
	<20151012040545.GC27164@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151012040545.GC27164@dastard>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS-devel Mailing List <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 12, 2015 at 6:05 AM, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wro=
te:
> On Mon, Oct 12, 2015 at 03:51:15AM +0200, Andreas Gr=C3=BCnbacher wro=
te:
>> 2015-10-12 2:10 GMT+02:00 Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>:
>> > On Mon, Oct 12, 2015 at 12:58:35AM +0200, Andreas Gruenbacher wrot=
e:
>> >> diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
>> >> index 5d47b4d..05dd312 100644
>> >> --- a/fs/xfs/Kconfig
>> >> +++ b/fs/xfs/Kconfig
>> >> @@ -52,6 +52,17 @@ config XFS_POSIX_ACL
>> >>
>> >>         If you don't know what Access Control Lists are, say N.
>> >>
>> >> +config XFS_RICHACL
>> >> +        bool "XFS Rich Access Control Lists (EXPERIMENTAL)"
>> >> +        depends on XFS_FS
>> >> +        select FS_RICHACL
>> >> +        help
>> >> +          Richacls are an implementation of NFSv4 ACLs, extended=
 by file masks
>> >> +          to cleanly integrate into the POSIX file permission mo=
del.  To learn
>> >> +       more about them, see http://www.bestbits.at/richacl/.
>> >> +
>> >> +          If you don't know what Richacls are, say N.
>> >> +
>> >
>> > So now we have multiple compile time ACL configs that we have to
>> > test. Personally, I see no reason for making either posix or rich
>> > acls compile time dependent. How about we just change CONFIG_FS_XF=
S
>> > to have "select FS_POSIX_ACL" and "select FS_RICHACL"
>> > unconditionally, and then we can get rid of all the conditional
>> > code?
>>
>> I'm sure neither kind of ACLs makes sense on many tiny systems, it
>> should be possible to disable them. XFS may not make sense on those
>> kinds of systems either, that is not my call to make though.
>
> Well, the smallest systems that use XFS are typically 1-2 disk NAS
> boxes, and I can see them wanting richacls. As it is, the xfs kernel
> module is almost 1MB of object code, so it you have a small embedded
> box you don't want XFS. Almost all distros turn on ACL support I'm
> not sure that it makes sense to have these config options in XFS
> anymore....

You have me convinced about removing CONFIG_XFS_RICHACL.

>> >> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_forma=
t.h
>> >> index 9590a06..8c6da45 100644
>> >> --- a/fs/xfs/libxfs/xfs_format.h
>> >> +++ b/fs/xfs/libxfs/xfs_format.h
>> >> @@ -461,10 +461,18 @@ xfs_sb_has_ro_compat_feature(
>> >>  #define XFS_SB_FEAT_INCOMPAT_FTYPE   (1 << 0)        /* filetype=
 in dirent */
>> >>  #define XFS_SB_FEAT_INCOMPAT_SPINODES        (1 << 1)        /* =
sparse inode chunks */
>> >>  #define XFS_SB_FEAT_INCOMPAT_META_UUID       (1 << 2)        /* =
metadata UUID */
>> >> +
>> >> +#ifdef CONFIG_XFS_RICHACL
>> >> +#define XFS_SB_FEAT_INCOMPAT_RICHACL (1 << 3)        /* richacls=
 */
>> >> +#else
>> >> +#define XFS_SB_FEAT_INCOMPAT_RICHACL 0
>> >> +#endif
>> >> +
>> >
>> > Regardless of whether we build in richacl support, this is wrong.
>> > Feature bits are on-disk format definitions, so it will always hav=
e
>> > this value whether or not the kernel supports the feature.
>>
>> This is so that xfs_mount_validate_sb() will complain when mounting =
a
>> richacl filesystem on a kernel which doesn't have richacl suport
>> compiled in. The same effect can be had with extra code there of
>> course.
>
> If the kernel doesn't know about a feature, then it will report
> "unknown feature". However, as of this patch set, the kernel will
> know about the richacl feature, and so the correct error message
> is to say "Rich ACLs not supported by this kernel".
>
> Also, from a disk format perspective, this is a this is a read-only
> compat feature, as kernels that don't have richacl support are still
> able to mount and walk the filesystem without errors occurring. It's
> only when allowing modifications are made that problems will arise,
> so why did you make it an incompat feature?

As a read-only compat flag, kernels that cannot enforce richacls would
still be able to mount richacl file systems read-only. That's a
problem when acls are used to forbid read/execute access.

>> >> +int
>> >> +xfs_set_richacl(struct inode *inode, struct richacl *acl)
>> >> +{
>> >> +     struct xfs_inode *ip =3D XFS_I(inode);
>> >> +     umode_t mode =3D inode->i_mode;
>> >> +     int error;
>> >> +
>> >> +     if (acl) {
>> >> +             /* Don't allow acls with unmapped identifiers. */
>> >> +             if (richacl_has_unmapped_identifiers(acl))
>> >> +                     return -EINVAL;
>> >> +
>> >> +             if (richacl_equiv_mode(acl, &mode) =3D=3D 0) {
>> >> +                     xfs_set_mode(inode, mode);
>> >> +                     acl =3D NULL;
>> >> +             }
>> >
>> > Comment needed here - why does this now seem to accidentally fall
>> > through to removing the ACL?
>>
>> Setting an ACL that is equivalent to a file mode is the same as
>> removing any existing ACLs and doing a chmod to that equivalent file
>> mode. It's the sams as with POSIX ACLs, and the code is the same as
>> well. I'll add a comment though.
>>
>> > Also, why is this in the XFS specific
>> > code when it's generic richacl functionality that is being checked=
?
>>
>> This turns into two non-atomic operations if we move it into generic=
 code.
>
> I don't follow you - this isn't an atomic operation to begin with...

Right, I shouldn't have used the term atomic. It's one inode operation
under i_mutex, and the filesystem can pack it into one transaction.

Thanks,
Andreas
