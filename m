From: Pranith Kumar <bobby.prani@gmail.com>
Subject: Re: [PATCH] fs: XFS_IOC_FS[SG]SETXATTR to FS_IOC_FS[SG]ETXATTR promotion
Date: Fri, 29 Jan 2016 19:56:44 -0500
Message-ID: <CAJhHMCAvTJj=bX=uE1oK+DzG8aGNGvM-BkY83+H4BgzQiNBa+A@mail.gmail.com>
References: <1442146833-13652-1-git-send-email-lixi@ddn.com>
 <1442146833-13652-4-git-send-email-lixi@ddn.com> <20160103230534.GE6682@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160103230534.GE6682@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Li Xi <pkuelelixi@gmail.com>, "open list:OVERLAYFS FILESYSTEM" <linux-fsdevel@vger.kernel.org>, linux-ext4@vger.kernel.org, "open list:KERNEL SELFTEST F..." <linux-api@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, adilger@dilger.ca, Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>, hch@infradead.org, dmonakhov@openvz.org
List-Id: linux-api@vger.kernel.org

On Sun, Jan 3, 2016 at 6:05 PM, Dave Chinner <david@fromorbit.com> wrot=
e:
> On Sun, Sep 13, 2015 at 09:20:32PM +0900, Li Xi wrote:
>> This patch adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR ioctl interface
>> support for ext4. The interface is kept consistent with
>> XFS_IOC_FSGETXATTR/XFS_IOC_FSGETXATTR.
>>
>> Signed-off-by: Li Xi <lixi@ddn.com>
>> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
>> Reviewed-by: Jan Kara <jack@suse.cz>
>

Hello,

This commit breaks building latest qemu as follows:

In file included from /usr/include/xfs/xfs.h:58:0,
                 from /home/pranith/qemu/block/raw-posix.c:96:
/usr/include/xfs/xfs_fs.h:42:8: error: redefinition of =E2=80=98struct =
fsxattr=E2=80=99
 struct fsxattr {
        ^
In file included from /home/pranith/qemu/block/raw-posix.c:59:0:
/usr/include/linux/fs.h:155:8: note: originally defined here
 struct fsxattr {
        ^
/home/pranith/qemu/rules.mak:57: recipe for target 'block/raw-posix.o' =
failed

I think this is caused by moving the fsxattr struct around. Is the
header inclusion messed up somehow?

Thanks,

--=20
Pranith
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
