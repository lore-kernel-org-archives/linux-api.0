From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [v5 4/5] Adds ioctl interface support for ext4 project
Date: Sun, 26 Oct 2014 08:49:37 +0100
Message-ID: <264DF8EC-51FD-495C-BB97-C84921F7B20A@arndb.de>
References: <1414300973-1118-1-git-send-email-lixi@ddn.com> <1414300973-1118-5-git-send-email-lixi@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414300973-1118-5-git-send-email-lixi-LfVdkaOWEx8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org



On October 26, 2014 6:22:52 AM CET, Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> #define EXT4_IOC_PRECACHE_EXTENTS	_IO('f', 18)
>+#define EXT4_IOC_GETPROJECT		_IOR('f', 19, long)
>+#define EXT4_IOC_SETPROJECT		_IOW('f', 20, long)


>+		projid = (__u32)from_kprojid(&init_user_ns,
>+					     EXT4_I(inode)->i_projid);
>+		return put_user(projid, (__u32 __user *) arg);
>+	}
>+	case EXT4_IOC_SETPROJECT:
>+	{
>+		__u32 projid;
>+
>+		if (get_user(projid, (__u32 __user *) arg))
>+			return -EFAULT;
>+
>+		return ext4_ioctl_setproject(filp, 

Types don't match. Please use __u32 in the command definition instead of long, otherwise 32 bit compact won't work.

     Arnd
