From: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC 0/3] simple copy offloading system call
Date: Wed, 6 May 2015 08:15:08 +0200
Message-ID: <CAHO5Pa0UEhOC3vqP9Nq4+gEH_OJPG6dgoLM9XbRLOfTRsRVSCw@mail.gmail.com>
References: <1428703236-24735-1-git-send-email-zab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1428703236-24735-1-git-send-email-zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-Fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux btrfs Developers List <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

[CC += linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org]

Zach,

Since this is a kernel-user-space API change, please CC linux-api@.
The kernel source file Documentation/SubmitChecklist notes that all
Linux kernel patches that change userspace interfaces should be CCed
to linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, so that the various parties who are
interested in API changes are informed. For further information, see
https://www.kernel.org/doc/man-pages/linux-api-ml.html

Thanks,

Michael




On Sat, Apr 11, 2015 at 12:00 AM, Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Hello everyone!
>
> Here's my current attempt at the most basic system call interface for
> offloading copying between files.  The system call and vfs function
> are relatively light wrappers around the file_operation method that
> does the heavy lifting.
>
> There was interest at LSF in getting the basic infrastructure merged
> before worrying about adding behavioural flags and more complicated
> implementations.  This series only offers a refactoring of the btrfs
> clone ioctl as an example of an implementation of the file
> copy_file_range method.
>
> I've added support for copy_file_range() to xfs_io in xfsprogs and
> have the start of an xfstest that tests the system call.  I'll send
> those to fstests@.
>
> So how does this look?
>
> Do we want to merge this and let the NFS and block XCOPY patches add
> their changes when they're ready?
>
> - z
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
