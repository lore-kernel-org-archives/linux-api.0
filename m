From: Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Documenting MS_LAZYTIME
Date: Fri, 27 Feb 2015 00:08:00 -0800
Message-ID: <20150227080800.GA20442@mew>
References: <CAHO5Pa0k7QkV_6BDjwTVxa7LV9tFyN9nGFFcSvOC6HYO08wfrw@mail.gmail.com>
 <54E7578E.4090809@redhat.com>
 <20150221025636.GB7922@thunk.org>
 <54EEDE23.6080009@gmail.com>
 <20150226133113.GD11217@thunk.org>
 <54EF2161.90607@gmail.com>
 <20150227000409.GC17174@thunk.org>
 <54F02446.2050008@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54F02446.2050008-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, XFS Developers <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>, Linux-Fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ext4 Developers List <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux btrfs Developers List <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 27, 2015 at 09:01:10AM +0100, Michael Kerrisk (man-pages) w=
rote:
> On 02/27/2015 01:04 AM, Theodore Ts'o wrote:
> > On Thu, Feb 26, 2015 at 02:36:33PM +0100, Michael Kerrisk (man-page=
s) wrote:
> >>
> >>     The disadvantage of MS_STRICTATIME | MS_LAZYTIME is that
> >>     in the case of a system crash, the atime and mtime fields
> >>     on disk might be out of date by at most 24 hours.
> >=20
> > I'd change to "The disadvantage of MS_LAZYTIME is that..."  and
> > perhaps move that so it's clear it applies to any use of MS_LAZYTIM=
E
> > has this as a downside.
> >=20
> > Does that make sense?
>=20
> Thanks, Ted. Got it. So, now we have:
>=20
>        MS_LAZYTIME (since Linux 3.20)
>               Reduce  on-disk  updates  of  inode  timestamps  (atime=
,
>               mtime, ctime) by maintaining these changes only in  mem=
=E2=80=90
>               ory.  The on-disk timestamps are updated only when:
>=20
>               (a)  the inode needs to be updated for some change unre=
=E2=80=90
>                    lated to file timestamps;
>=20
>               (b)  the application  employs  fsync(2),  syncfs(2),  o=
r
>                    sync(2);
>=20
>               (c)  an undeleted inode is evicted from memory; or
>=20
>               (d)  more  than 24 hours have passed since the inode wa=
s
>                    written to disk.
>=20
>               This mount significantly reduces writes needed to updat=
e
"This mount option"?

>               the  inode's  timestamps,  especially  mtime  and atime=
=2E
>               However, in the event of a system crash, the  atime  an=
d
>               mtime  fields  on  disk might be out of date by up to 2=
4
>               hours.
>=20
>               Examples of workloads where this option could be of sig=
=E2=80=90
>               nificant  benefit include frequent random writes to pre=
=E2=80=90
>               allocated files, as well as cases where the  MS_STRICTA=
=E2=80=90
>               TIME  mount  option  is also enabled.  (The advantage o=
f
>               (MS_STRICTATIME |  MS_LAZYTIME)  is  that  stat(2)  wil=
l
>               return  the  correctly  updated  atime,  but  the  atim=
e
>               updates will be flushed to disk only when (1) the  inod=
e
>               needs  to  be  updated for filesystem / data consistenc=
y
>               reasons or (2) the inode is pushed out of memory, or (3=
)
>               the filesystem is unmounted.)
Is it necessary to repeat the reasons for flushing, which are stated
above?

>=20
> Cheers,
>=20
> Michael
>=20
>=20
> --=20
> Michael Kerrisk
> Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
> Linux/UNIX System Programming Training: http://man7.org/training/
>=20
> _______________________________________________
> xfs mailing list
> xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org
> http://oss.sgi.com/mailman/listinfo/xfs

Thanks!
--=20
Omar
