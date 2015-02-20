From: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Documenting MS_LAZYTIME
Date: Fri, 20 Feb 2015 09:50:50 +0100
Message-ID: <CAHO5Pa0k7QkV_6BDjwTVxa7LV9tFyN9nGFFcSvOC6HYO08wfrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Cc: Ext4 Developers List <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux btrfs Developers List <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, XFS Developers <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux-Fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello Ted,

Based on your commit message 0ae45f63d4e, I I wrote the documentation
below for MS_LAZYTIME, to go into the mount(2) man page. Could you
please check it over and let me know if it's accurate. In particular,
I added pieces marked with "*" below that were not part of the commit
message and I'd like confirmation that they're accurate.

Thanks,

Michael

[[
       MS_LAZYTIME (since Linux 3.20)
              Only  update  filetimes (atime, mtime, ctime) on the in-
              memory version of the file  inode.   The  on-disk  time=E2=
=80=90
              stamps are updated only when:

              (a)  the inode needs to be updated for some change unre=E2=
=80=90
                   lated to file timestamps;

              (b)  the application  employs  fsync(2),  syncfs(2),  or
                   sync(2);

              (c)  an undeleted inode is evicted from memory; or

*             (d)  more than 24 hours have passed since the i-node was
*                  written to disk.

              This mount option significantly reduces  writes  to  the
              inode  table  for workloads that perform frequent random
              writes to preallocated files.

*             As at Linux 3.20, this option is supported only on ext4.
]]

--=20
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
