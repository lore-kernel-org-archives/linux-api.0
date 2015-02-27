From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Documenting MS_LAZYTIME
Date: Fri, 27 Feb 2015 09:36:03 +0100
Message-ID: <54F02C73.5090601@gmail.com>
References: <CAHO5Pa0k7QkV_6BDjwTVxa7LV9tFyN9nGFFcSvOC6HYO08wfrw@mail.gmail.com> <54E7578E.4090809@redhat.com> <20150221025636.GB7922@thunk.org> <54EEDE23.6080009@gmail.com> <20150226133113.GD11217@thunk.org> <54EF2161.90607@gmail.com> <20150227000409.GC17174@thunk.org> <54F02446.2050008@gmail.com> <20150227080800.GA20442@mew>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150227080800.GA20442@mew>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, XFS Developers <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>, Linux-Fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ext4 Developers List <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux btrfs Developers List <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello Omar,

On 02/27/2015 09:08 AM, Omar Sandoval wrote:
> On Fri, Feb 27, 2015 at 09:01:10AM +0100, Michael Kerrisk (man-pages)=
 wrote:
>> On 02/27/2015 01:04 AM, Theodore Ts'o wrote:
>>> On Thu, Feb 26, 2015 at 02:36:33PM +0100, Michael Kerrisk (man-page=
s) wrote:
>>>>
>>>>     The disadvantage of MS_STRICTATIME | MS_LAZYTIME is that
>>>>     in the case of a system crash, the atime and mtime fields
>>>>     on disk might be out of date by at most 24 hours.
>>>
>>> I'd change to "The disadvantage of MS_LAZYTIME is that..."  and
>>> perhaps move that so it's clear it applies to any use of MS_LAZYTIM=
E
>>> has this as a downside.
>>>
>>> Does that make sense?
>>
>> Thanks, Ted. Got it. So, now we have:
>>
>>        MS_LAZYTIME (since Linux 3.20)
>>               Reduce  on-disk  updates  of  inode  timestamps  (atim=
e,
>>               mtime, ctime) by maintaining these changes only in  me=
m=E2=80=90
>>               ory.  The on-disk timestamps are updated only when:
>>
>>               (a)  the inode needs to be updated for some change unr=
e=E2=80=90
>>                    lated to file timestamps;
>>
>>               (b)  the application  employs  fsync(2),  syncfs(2),  =
or
>>                    sync(2);
>>
>>               (c)  an undeleted inode is evicted from memory; or
>>
>>               (d)  more  than 24 hours have passed since the inode w=
as
>>                    written to disk.
>>
>>               This mount significantly reduces writes needed to upda=
te
> "This mount option"?

Thanks, fixed.

>>               the  inode's  timestamps,  especially  mtime  and atim=
e.
>>               However, in the event of a system crash, the  atime  a=
nd
>>               mtime  fields  on  disk might be out of date by up to =
24
>>               hours.
>>
>>               Examples of workloads where this option could be of si=
g=E2=80=90
>>               nificant  benefit include frequent random writes to pr=
e=E2=80=90
>>               allocated files, as well as cases where the  MS_STRICT=
A=E2=80=90
>>               TIME  mount  option  is also enabled.  (The advantage =
of
>>               (MS_STRICTATIME |  MS_LAZYTIME)  is  that  stat(2)  wi=
ll
>>               return  the  correctly  updated  atime,  but  the  ati=
me
>>               updates will be flushed to disk only when (1) the  ino=
de
>>               needs  to  be  updated for filesystem / data consisten=
cy
>>               reasons or (2) the inode is pushed out of memory, or (=
3)
>>               the filesystem is unmounted.)
> Is it necessary to repeat the reasons for flushing, which are stated
> above?

Good point. I replaced this piece with just a few words referring=20
to the list above.

Thanks,

Michael


--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
