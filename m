From: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Subject: Re: Documenting MS_LAZYTIME
Date: Fri, 20 Feb 2015 05:32:58 -0700
Message-ID: <44893EA7-B11A-469A-9911-6CE2E8B26EB4@dilger.ca>
References: <CAHO5Pa0k7QkV_6BDjwTVxa7LV9tFyN9nGFFcSvOC6HYO08wfrw@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHO5Pa0k7QkV_6BDjwTVxa7LV9tFyN9nGFFcSvOC6HYO08wfrw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Ext4 Developers List <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux btrfs Developers List <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, XFS Developers <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux-Fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Feb 20, 2015, at 1:50 AM, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> w=
rote:
>=20
> Hello Ted,
>=20
> Based on your commit message 0ae45f63d4e, I I wrote the documentation
> below for MS_LAZYTIME, to go into the mount(2) man page. Could you
> please check it over and let me know if it's accurate. In particular,
> I added pieces marked with "*" below that were not part of the commit
> message and I'd like confirmation that they're accurate.
>=20
> Thanks,
>=20
> Michael
>=20
> [[
>       MS_LAZYTIME (since Linux 3.20)
>              Only  update  filetimes (atime, mtime, ctime) on the in-
>              memory version of the file  inode.   The  on-disk  time=E2=
=80=90
>              stamps are updated only when:
>=20
>              (a)  the inode needs to be updated for some change unre=E2=
=80=90
>                   lated to file timestamps;
>=20
>              (b)  the application  employs  fsync(2),  syncfs(2),  or
>                   sync(2);
>=20
>              (c)  an undeleted inode is evicted from memory; or
>=20
> *             (d)  more than 24 hours have passed since the i-node wa=
s
> *                  written to disk.
>=20
>              This mount option significantly reduces  writes  to  the
>              inode  table  for workloads that perform frequent random
>              writes to preallocated files.
>=20
> *             As at Linux 3.20, this option is supported only on ext4=
=2E

I _think_ that the lazytime mount option is generic for all filesystems=
=2E
I believe ext4 has an extra optimization for it, but that's it.

Cheers, Andreas
