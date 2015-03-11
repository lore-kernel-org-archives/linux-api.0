From: Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [v9 4/5] ext4: adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR interface support
Date: Wed, 11 Mar 2015 10:33:47 +0300
Message-ID: <CALYGNiPQW0ppMzPLpv+bpKYWgLviVomtEQ6gcX-4w0zZdEE=3A@mail.gmail.com>
References: <1426043003-31043-1-git-send-email-lixi@ddn.com>
	<1426043003-31043-5-git-send-email-lixi@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426043003-31043-5-git-send-email-lixi-LfVdkaOWEx8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, =?UTF-8?B?0JTQvNC40YLRgNC40Lkg0JzQvtC90LDRhdC+0LI=?= <dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 11, 2015 at 6:03 AM, Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> This patch adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR ioctl interface
> support for ext4. The interface is kept consistent with
> XFS_IOC_FSGETXATTR/XFS_IOC_FSGETXATTR.
>
> Signed-off-by: Li Xi <lixi-LfVdkaOWEx8@public.gmane.org>
> ---


> @@ -503,8 +490,8 @@ typedef struct xfs_swapext
>  #define XFS_IOC_ALLOCSP                _IOW ('X', 10, struct xfs_flock64)
>  #define XFS_IOC_FREESP         _IOW ('X', 11, struct xfs_flock64)
>  #define XFS_IOC_DIOINFO                _IOR ('X', 30, struct dioattr)
> -#define XFS_IOC_FSGETXATTR     _IOR ('X', 31, struct fsxattr)
> -#define XFS_IOC_FSSETXATTR     _IOW ('X', 32, struct fsxattr)
> +#define XFS_IOC_FSGETXATTR     FS_IOC_FSGETXATTR
> +#define XFS_IOC_FSSETXATTR     FS_IOC_FSSETXATTR

XFS ioctls use letter 'X'.

>
> @@ -163,6 +193,8 @@ struct inodes_stat_t {
>  #define        FS_IOC_GETVERSION               _IOR('v', 1, long)
>  #define        FS_IOC_SETVERSION               _IOW('v', 2, long)
>  #define FS_IOC_FIEMAP                  _IOWR('f', 11, struct fiemap)
> +#define FS_IOC_FSGETXATTR              _IOR('f', 31, struct fsxattr)
> +#define FS_IOC_FSSETXATTR              _IOW('f', 32, struct fsxattr)

You add 'f'. They're different.

>  #define FS_IOC32_GETFLAGS              _IOR('f', 1, int)
>  #define FS_IOC32_SETFLAGS              _IOW('f', 2, int)
>  #define FS_IOC32_GETVERSION            _IOR('v', 1, int)
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
