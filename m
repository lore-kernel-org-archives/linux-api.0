From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: Documenting MS_LAZYTIME
Date: Fri, 20 Feb 2015 14:22:07 +0100
Message-ID: <CAKgNAkj4EtiWpxOPFtfYn4=E1ukLjESwe7yvyNHdp04BP+kj-g@mail.gmail.com>
References: <CAHO5Pa0k7QkV_6BDjwTVxa7LV9tFyN9nGFFcSvOC6HYO08wfrw@mail.gmail.com>
 <44893EA7-B11A-469A-9911-6CE2E8B26EB4@dilger.ca>
Reply-To: mtk.manpages@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <44893EA7-B11A-469A-9911-6CE2E8B26EB4@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Cc: Theodore Ts'o <tytso@mit.edu>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, linux-man <linux-man@vger.kernel.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 20 February 2015 at 13:32, Andreas Dilger <adilger@dilger.ca> wrote:
> On Feb 20, 2015, at 1:50 AM, Michael Kerrisk <mtk.manpages@gmail.com>=
 wrote:
>>
>> Hello Ted,
>>
>> Based on your commit message 0ae45f63d4e, I I wrote the documentatio=
n
>> below for MS_LAZYTIME, to go into the mount(2) man page. Could you
>> please check it over and let me know if it's accurate. In particular=
,
>> I added pieces marked with "*" below that were not part of the commi=
t
>> message and I'd like confirmation that they're accurate.
>>
>> Thanks,
>>
>> Michael
>>
>> [[
>>       MS_LAZYTIME (since Linux 3.20)
>>              Only  update  filetimes (atime, mtime, ctime) on the in=
-
>>              memory version of the file  inode.   The  on-disk  time=
=E2=80=90
>>              stamps are updated only when:
>>
>>              (a)  the inode needs to be updated for some change unre=
=E2=80=90
>>                   lated to file timestamps;
>>
>>              (b)  the application  employs  fsync(2),  syncfs(2),  o=
r
>>                   sync(2);
>>
>>              (c)  an undeleted inode is evicted from memory; or
>>
>> *             (d)  more than 24 hours have passed since the i-node w=
as
>> *                  written to disk.
>>
>>              This mount option significantly reduces  writes  to  th=
e
>>              inode  table  for workloads that perform frequent rando=
m
>>              writes to preallocated files.
>>
>> *             As at Linux 3.20, this option is supported only on ext=
4.
>
> I _think_ that the lazytime mount option is generic for all filesyste=
ms.
> I believe ext4 has an extra optimization for it, but that's it.

Ah yes, looking at the code again, that makes sense. I think you're
right, and I've struck that last sentence. Thanks, Andreas.

Cheers,

Michael


--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
