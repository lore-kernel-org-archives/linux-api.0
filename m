From: =?windows-1252?Q?P=E1draig_Brady?= <P@draigBrady.com>
Subject: Re: [PATCH v1 0/8] VFS: In-kernel copy system call
Date: Tue, 08 Sep 2015 16:21:18 +0100
Message-ID: <55EEFCEE.5090000@draigBrady.com>
References: <1441397823-1203-1-git-send-email-Anna.Schumaker@Netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441397823-1203-1-git-send-email-Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andros-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 04/09/15 21:16, Anna Schumaker wrote:
> Copy system calls came up during Plumbers a couple of weeks ago, beca=
use
> several filesystems (including NFS and XFS) are currently working on =
copy
> acceleration implementations.  We haven't heard from Zach Brown in a =
while,
> so I volunteered to push his patches upstream so individual filesyste=
ms
> don't need to keep writing their own ioctls.

Just mentioning that this is just pertaining to the data, not the metad=
ata.
Providing metadata copying facilities would be _very_ useful, as
most file system specific details relate to the metadata, and having
VFS operations for that would avoid the plethora of details in each use=
rspace tool,
and theoretically support translations between disparate metadata.

> The first three patches are a simple reposting of Zach's patches from=
 several
> months ago, with one minor error code fix.  The remaining patches add=
 in a
> fallback mechanism when filesystems don't provide a copy function.  T=
his is
> especially useful when doing a server-side copy on NFS (using the new=
 COPY
> operation in NFS v4.2).  This fallback can be disabled by passing the=
 flag
> COPY_REFLINK to the system call.

I see copy_file_range() is a reflink() on BTRFS?
That's a bit surprising, as it avoids the copy completely.
cp(1) for example considered doing a BTRFS clone by default,
but didn't due to expectations that users actually wanted
the data duplicated on disk for resilience reasons,
and for performance reasons so that write latencies were
restricted to the copy operation, rather than being
introduced at usage time as the dest file is CoW'd.

If reflink() is a possibility for copy_file_range()
then could it be done optionally with a flag?

thanks,
P=E1draig
