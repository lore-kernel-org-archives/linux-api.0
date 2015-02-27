From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Documenting MS_LAZYTIME
Date: Fri, 27 Feb 2015 09:01:10 +0100
Message-ID: <54F02446.2050008@gmail.com>
References: <CAHO5Pa0k7QkV_6BDjwTVxa7LV9tFyN9nGFFcSvOC6HYO08wfrw@mail.gmail.com> <54E7578E.4090809@redhat.com> <20150221025636.GB7922@thunk.org> <54EEDE23.6080009@gmail.com> <20150226133113.GD11217@thunk.org> <54EF2161.90607@gmail.com> <20150227000409.GC17174@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150227000409.GC17174-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ext4 Developers List <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux btrfs Developers List <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, XFS Developers <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux-Fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 02/27/2015 01:04 AM, Theodore Ts'o wrote:
> On Thu, Feb 26, 2015 at 02:36:33PM +0100, Michael Kerrisk (man-pages)=
 wrote:
>>
>>     The disadvantage of MS_STRICTATIME | MS_LAZYTIME is that
>>     in the case of a system crash, the atime and mtime fields
>>     on disk might be out of date by at most 24 hours.
>=20
> I'd change to "The disadvantage of MS_LAZYTIME is that..."  and
> perhaps move that so it's clear it applies to any use of MS_LAZYTIME
> has this as a downside.
>=20
> Does that make sense?

Thanks, Ted. Got it. So, now we have:

       MS_LAZYTIME (since Linux 3.20)
              Reduce  on-disk  updates  of  inode  timestamps  (atime,
              mtime, ctime) by maintaining these changes only in  mem=E2=
=80=90
              ory.  The on-disk timestamps are updated only when:

              (a)  the inode needs to be updated for some change unre=E2=
=80=90
                   lated to file timestamps;

              (b)  the application  employs  fsync(2),  syncfs(2),  or
                   sync(2);

              (c)  an undeleted inode is evicted from memory; or

              (d)  more  than 24 hours have passed since the inode was
                   written to disk.

              This mount significantly reduces writes needed to update
              the  inode's  timestamps,  especially  mtime  and atime.
              However, in the event of a system crash, the  atime  and
              mtime  fields  on  disk might be out of date by up to 24
              hours.

              Examples of workloads where this option could be of sig=E2=
=80=90
              nificant  benefit include frequent random writes to pre=E2=
=80=90
              allocated files, as well as cases where the  MS_STRICTA=E2=
=80=90
              TIME  mount  option  is also enabled.  (The advantage of
              (MS_STRICTATIME |  MS_LAZYTIME)  is  that  stat(2)  will
              return  the  correctly  updated  atime,  but  the  atime
              updates will be flushed to disk only when (1) the  inode
              needs  to  be  updated for filesystem / data consistency
              reasons or (2) the inode is pushed out of memory, or (3)
              the filesystem is unmounted.)

Cheers,

Michael


--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
