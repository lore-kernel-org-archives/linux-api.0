From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v7 1/4] vfs: add copy_file_range syscall and vfs helper
Date: Tue, 27 Oct 2015 11:03:37 -0500
Message-ID: <CAH2r5mtRzSX3dZAXZwgVLQfjjfrkX8X=7b2uxQJ+De=5JjmqCw@mail.gmail.com>
References: <1445628736-13058-1-git-send-email-Anna.Schumaker@Netapp.com> <1445628736-13058-2-git-send-email-Anna.Schumaker@Netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445628736-13058-2-git-send-email-Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Cc: "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, clm-b10kYP2dOMg@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, andros-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The patch set looks good so far, and copy offload is important for
CIFS/SMB3 (not just Windows/Mac/Samba but most servers support one of
the various methods available to do this over the network via CIFS and
also SMB2/SMB3).  I have only implemented two ways of copy offload in
cifs.ko so far but will look at adding the remaining mechanisms.

Currently cifs.ko does have a similar restriction to the below one
that you have in your patch1, but I was planning to relax it (as long
as source and target are on the same server) since some of the
important use cases are having the server do copy offload from one
share to another.   So we should support the case where the files are
on the same file system type (nfs, cifs etc.) but not necessarily on
the same superblock (for the case of cifs they will be on the same
server, but with some forms of copy offload that would not necessarily
have to be on the same server).

The following check should be removed (an alternative would be to
check that source and target are the same filesystem type ie nfs, or
cifs or xfs etc. or simply let the file systems check file_in and
file_out's validity)

> +       /* this could be relaxed once a method supports cross-fs copies */
> +       if (inode_in->i_sb != inode_out->i_sb ||
> +           file_in->f_path.mnt != file_out->f_path.mnt)
> +               return -EXDEV;




-- 
Thanks,

Steve
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
