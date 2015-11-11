From: Eric Biggers <ebiggers3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v9 0/4] VFS: In-kernel copy system call
Date: Wed, 11 Nov 2015 08:53:37 -0600
Message-ID: <20151111145337.GA2392@zzz>
References: <1447192413-15376-1-git-send-email-Anna.Schumaker@Netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1447192413-15376-1-git-send-email-Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andros-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Nov 10, 2015 at 04:53:30PM -0500, Anna Schumaker wrote:
>	out:
>		fdput(f_in);
>	out1:
>		fdput(f_out);

The fdput()s are in the wrong order.  fdget(f_in) is first at the beginning, so
fdput(f_in) needs to be last at the end.

>       /* this could be relaxed once a method supports cross-fs copies */
>       if (inode_in->i_sb != inode_out->i_sb)
>               return -EXDEV;

This allows the same superblock but different mounts --- is that intentional?
The commit message says otherwise: it says the vfs entry point requires the same
superblock and mount.


Was there a decision made on FMODE_PREAD and FMODE_PWRITE?  To me it seems
logical that the if the user explicitly specifies an offset, then the
corresponding mode should be checked.  That would check whether the file is
seekable or not, I believe.  Note that e.g. sys_sendfile() does the same thing.
