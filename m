From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Documenting MS_LAZYTIME
Date: Fri, 20 Feb 2015 09:49:34 -0600
Message-ID: <54E7578E.4090809@redhat.com>
References: <CAHO5Pa0k7QkV_6BDjwTVxa7LV9tFyN9nGFFcSvOC6HYO08wfrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <CAHO5Pa0k7QkV_6BDjwTVxa7LV9tFyN9nGFFcSvOC6HYO08wfrw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
To: Michael Kerrisk <mtk.manpages@gmail.com>, Theodore Ts'o <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, linux-man@vger.kernel.org, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 2/20/15 2:50 AM, Michael Kerrisk wrote:
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
>        MS_LAZYTIME (since Linux 3.20)
>               Only  update  filetimes (atime, mtime, ctime) on the in=
-
>               memory version of the file  inode.   The  on-disk  time=
=E2=80=90
>               stamps are updated only when:

"filetimes" and "file inode" seems a bit awkward.  How about:

>        MS_LAZYTIME (since Linux 3.20)
>		Reduce on-disk updates of inode timestamps (atime, mtime, ctime)
> 		by maintaining these changes only in memory, unless:

(maybe I'm bike-shedding too much, if so, sorry).

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
> *             (d)  more than 24 hours have passed since the i-node wa=
s
> *                  written to disk.

Please don't use "i-node" - simply "inode" is much more common in the m=
anpages
AFAICT.

>               This mount option significantly reduces  writes  to  th=
e
>               inode  table  for workloads that perform frequent rando=
m
>               writes to preallocated files.

This seems like an overly specific description of a single workload out
of many which may benefit, but what do others think?  "inode table" is =
also
fairly extN-specific.

-Eric
=20
> *             As at Linux 3.20, this option is supported only on ext4=
=2E
> ]]
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
