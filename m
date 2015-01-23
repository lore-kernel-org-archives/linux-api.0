From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [v8 4/5] ext4: adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR
 interface support
Date: Fri, 23 Jan 2015 12:53:07 +1100
Message-ID: <20150123015307.GD24722@dastard>
References: <1418102548-5469-1-git-send-email-lixi@ddn.com>
 <1418102548-5469-5-git-send-email-lixi@ddn.com>
 <54C11733.7080801@yandex-team.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54C11733.7080801-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Cc: Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Jan 22, 2015 at 06:28:51PM +0300, Konstantin Khlebnikov wrote:
> On 09.12.2014 08:22, Li Xi wrote:
> >+static int ext4_ioctl_setproject(struct file *filp, __u32 projid)
> >+{
> >+	struct inode *inode = file_inode(filp);
> >+	struct super_block *sb = inode->i_sb;
> >+	struct ext4_inode_info *ei = EXT4_I(inode);
> >+	int err;
> >+	handle_t *handle;
> >+	kprojid_t kprojid;
> >+	struct ext4_iloc iloc;
> >+	struct ext4_inode *raw_inode;
> >+
> >+	struct dquot *transfer_to[EXT4_MAXQUOTAS] = { };
> >+
> >+	/* Make sure caller can change project. */
> >+	if (!capable(CAP_SYS_ADMIN))
> >+		return -EACCES;
> >+
> >+	if (projid != EXT4_DEF_PROJID
> >+	    && !EXT4_HAS_RO_COMPAT_FEATURE(sb,
> >+			EXT4_FEATURE_RO_COMPAT_PROJECT))
> >+		return -EOPNOTSUPP;
> >+
> >+	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
> >+			EXT4_FEATURE_RO_COMPAT_PROJECT)) {
> >+		BUG_ON(__kprojid_val(EXT4_I(inode)->i_projid)
> >+		       != EXT4_DEF_PROJID);
> >+		if (projid != EXT4_DEF_PROJID)
> >+			return -EOPNOTSUPP;
> >+		else
> >+			return 0;
> >+	}
> >+
> >+	kprojid = make_kprojid(&init_user_ns, (projid_t)projid);
> 
> Maybe current_user_ns()?
> This code should be user-namespace aware from the beginning.

No, the code is correct. Project quotas have nothing to do with
UIDs and so should never have been included in the uid/gid
namespace mapping infrastructure in the first place.

Point in case: directory subtree quotas can be used as a resource
controller for limiting space usage within separate containers that
share the same underlying (large) filesystem via mount namespaces.

Cheers,

Dave.

PS: can you please trim your reply to just the sections of the
patch you are commenting to? Finding replies like this in a large
patch is like searching for a needle in a haystack...
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
