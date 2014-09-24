From: Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 3/4] quota: add project quota support
Date: Thu, 25 Sep 2014 07:56:31 +0800
Message-ID: <CAPTn0cBTx+1w5p+bxNTNdPad5Lot0-Quo6b6SvSG2AYFhA4d6Q@mail.gmail.com>
References: <CAPTn0cD=FHKix_Lq1+qwOVDj6ko9DHfFeDGhbg0HfKFUhtZyDw@mail.gmail.com>
	<8EDAF5F3-347B-4E6C-AEFF-9643E957B830@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8EDAF5F3-347B-4E6C-AEFF-9643E957B830-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Cc: "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ext4 Developers List <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, "viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dmitry Monakhov <dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Sep 25, 2014 at 3:46 AM, Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org> wrote:
> On Sep 24, 2014, at 14:15, Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> Adds project quota support for ext4
>
> This patch adds mount options for enabling/disabling project quota
> accounting and enforcement. A new specific inode is also used for
> project quota accounting.
>
> Signed-off-by: Li Xi <lixi <at> ddn.com>
> Signed-off-by: Dmitry Monakhov <dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> ---
> @@ -5084,7 +5155,18 @@ static int ext4_statfs(struct dentry *de
>   buf->f_fsid.val[0] = fsid & 0xFFFFFFFFUL;
>   buf->f_fsid.val[1] = (fsid >> 32) & 0xFFFFFFFFUL;
>
> - return 0;
> + if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_PROJECT) &&
> +    ext4_test_inode_flag(inode, EXT4_INODE_PROJINHERIT) &&
>
>
> Does it make sense to check for the PROJINHERIT flag, or only if
> the inode has a non-zero project quota?  I thought it is possible to
> have project quota on an inode that is not marked to be inherited?
This is trying to keep the same semantics with XFS. XFS returns
the project quota limits when statfs only if the inode has PROJINHERIT
flag. I think it is reasonable, since when a directory has PROJINHERIT,
the directory tree tend to has the same project ID.

xfs_fs_statfs():
...
    if ((ip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
        ((mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD))) ==
                  (XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD))
        xfs_qm_statvfs(ip, statp);

>
> +    sb_has_quota_usage_enabled(sb, PRJQUOTA) &&
> +    sb_has_quota_limits_enabled(sb, PRJQUOTA)) {
> +     err = ext4_statfs_project(sb, EXT4_I(inode)->i_projid, buf);
> +     if (err) {
> + ext4_warning(sb, "Cannot get quota of project %u\n",
>
>
> What is the benefit of this warning message?  Would it be better to
> return the fs-wide statfs() data if the project quota is not found?
Yeah, that is exactly what statfs() is doing in current codes. statfs()
will first get the fs-wide data, and then try to get project data. Even
it fails to get project data, it will return successfully with fs-wide
data. Anyway, I will remove this message. :)

Regards,
Li Xi
