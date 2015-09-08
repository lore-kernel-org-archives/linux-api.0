From: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 0/8] VFS: In-kernel copy system call
Date: Tue, 8 Sep 2015 14:23:23 -0400
Message-ID: <55EF279B.3020101@Netapp.com>
References: <1441397823-1203-1-git-send-email-Anna.Schumaker@Netapp.com>
 <55EEFCEE.5090000@draigBrady.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55EEFCEE.5090000-V8g9lnOeT5ydJdNcDFJN0w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?Q?P=c3=a1draig_Brady?= <P@draigBrady.com>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andros-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 09/08/2015 11:21 AM, P=C3=A1draig Brady wrote:
> On 04/09/15 21:16, Anna Schumaker wrote:
>> Copy system calls came up during Plumbers a couple of weeks ago, bec=
ause
>> several filesystems (including NFS and XFS) are currently working on=
 copy
>> acceleration implementations.  We haven't heard from Zach Brown in a=
 while,
>> so I volunteered to push his patches upstream so individual filesyst=
ems
>> don't need to keep writing their own ioctls.
>=20
> Just mentioning that this is just pertaining to the data, not the met=
adata.
> Providing metadata copying facilities would be _very_ useful, as
> most file system specific details relate to the metadata, and having
> VFS operations for that would avoid the plethora of details in each u=
serspace tool,
> and theoretically support translations between disparate metadata.

Metadata copying could be added later if somebody really wants it.

>=20
>> The first three patches are a simple reposting of Zach's patches fro=
m several
>> months ago, with one minor error code fix.  The remaining patches ad=
d in a
>> fallback mechanism when filesystems don't provide a copy function.  =
This is
>> especially useful when doing a server-side copy on NFS (using the ne=
w COPY
>> operation in NFS v4.2).  This fallback can be disabled by passing th=
e flag
>> COPY_REFLINK to the system call.
>=20
> I see copy_file_range() is a reflink() on BTRFS?
> That's a bit surprising, as it avoids the copy completely.
> cp(1) for example considered doing a BTRFS clone by default,
> but didn't due to expectations that users actually wanted
> the data duplicated on disk for resilience reasons,
> and for performance reasons so that write latencies were
> restricted to the copy operation, rather than being
> introduced at usage time as the dest file is CoW'd.
>=20
> If reflink() is a possibility for copy_file_range()
> then could it be done optionally with a flag?

The idea is that filesystems get to choose how to handle copies in the =
default case.  BTRFS could do a reflink, but NFS could do a server side=
 copy instead.  I can change the default behavior to only do a data cop=
y (unless the reflink flag is specified) instead, if that is desirable.

What does everybody think?

Anna

>=20
> thanks,
> P=C3=A1draig
>=20
