From: =?UTF-8?Q?P=c3=a1draig_Brady?= <P@draigBrady.com>
Subject: Re: [PATCH v3 8/9] vfs: copy_file_range() can do a pagecache copy
 with splice
Date: Fri, 25 Sep 2015 22:58:42 +0100
Message-ID: <5605C392.80008@draigBrady.com>
References: <1443214096-12769-1-git-send-email-Anna.Schumaker@Netapp.com>
 <1443214096-12769-9-git-send-email-Anna.Schumaker@Netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443214096-12769-9-git-send-email-Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andros-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 25/09/15 21:48, Anna Schumaker wrote:
> The NFS server will need some kind offallback for filesystems that do=
n't
> have any kind of copy acceleration, and it should be generally useful=
 to
> have an in-kernel copy to avoid lots of switches between kernel and u=
ser
> space.
>=20
> I make this configurable by adding two new flags.  Users who only wan=
t a
> reflink can pass COPY_FR_REFLINK, and users who want a full data copy=
 can
> pass COPY_FR_COPY.  The default (flags=3D0) means to first attempt a
> reflink, but use the pagecache if that fails.
>=20
> I moved the rw_verify_area() calls into the fallback code since some
> filesystems can handle reflinking a large range.
>=20
> Signed-off-by: Anna Schumaker <Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>

Reviewed-by: P=E1draig Brady <P@draigBrady.com>

LGTM. For my reference, for cp(1), mv(1), install(1), this will avoid
user space copies in the normal case, client side copies in the network
file system case, and provide a more generalized interface to reflink()=
=2E

coreutils pseudo code is:

  unsigned int cfr_flags =3D COPY_FR_COPY;
  if (mode =3D=3D mv)
    cfr_flags =3D 0; /* reflink falling back to normal */
  else if (mode =3D=3D cp) {
    if --reflink || --reflink=3D=3Dalways
      cfr_flags =3D COPY_FR_REFLINK;
    else if --reflink=3D=3Dauto
      cfr_flags =3D 0; /* reflink falling back to normal */
  }
  if vfs_copy_file_range(..., cfr_flags) =3D=3D ENOTSUP
    normal_user_space_copy();

thanks,
P=E1draig.
