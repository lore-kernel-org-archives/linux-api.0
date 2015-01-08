From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [v8 2/5] ext4: adds project ID support
Date: Thu, 8 Jan 2015 09:26:25 +0100
Message-ID: <20150108082625.GA15339@quack.suse.cz>
References: <1418102548-5469-1-git-send-email-lixi@ddn.com>
 <1418102548-5469-3-git-send-email-lixi@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1418102548-5469-3-git-send-email-lixi-LfVdkaOWEx8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue 09-12-14 13:22:25, Li Xi wrote:
> This patch adds a new internal field of ext4 inode to save project
> identifier. Also a new flag EXT4_INODE_PROJINHERIT is added for
> inheriting project ID from parent directory.
  I have noticed one thing you apparently changed in v7 of the patch set.
See below.

> Signed-off-by: Li Xi <lixi-LfVdkaOWEx8@public.gmane.org>
> Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> ---
>  fs/ext4/ext4.h          |   21 +++++++++++++++++----
>  fs/ext4/ialloc.c        |    6 ++++++
>  fs/ext4/inode.c         |   29 +++++++++++++++++++++++++++++
>  fs/ext4/namei.c         |   17 +++++++++++++++++
>  fs/ext4/super.c         |    1 +
>  include/uapi/linux/fs.h |    1 +
>  6 files changed, 71 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 29c43e7..8bd1da9 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -377,16 +377,18 @@ struct flex_groups {
>  #define EXT4_EA_INODE_FL	        0x00200000 /* Inode used for large EA */
>  #define EXT4_EOFBLOCKS_FL		0x00400000 /* Blocks allocated beyond EOF */
>  #define EXT4_INLINE_DATA_FL		0x10000000 /* Inode has inline data. */
> +#define EXT4_PROJINHERIT_FL		FS_PROJINHERIT_FL /* Create with parents projid */
  How did FS_PROJINHERIT_FL get here? There used to be 0x20000000 in older
version of the patch set which is correct - this definition is defining
ext4 on-disk format. As such it is an ext4 specific flag and should be
definined to a fixed constant independed of any other filesystem. It seems
you are somewhat mixing what is an on-disk format flag value and what is a
flag value passed from userspace. These two may be different things and you
need to convert between the values when getting / setting flags...

								Honza
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
