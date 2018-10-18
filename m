From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: statx(2) API and documentation
Date: Thu, 18 Oct 2018 22:21:37 +0200
Message-ID: <CAJfpeguEriFyL4cpB1ZmoHi_03ouiGgMxFE0u1iZSriDa5bCjw@mail.gmail.com>
References: <CAJfpegsxFUGeczcC-pzK0WWROjv48_PvXtNun-f5QJMoUDn1Dw@mail.gmail.com>
 <4893.1539878663@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4893.1539878663@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 18, 2018 at 6:04 PM, David Howells <dhowells@redhat.com> wrote:
> Miklos Szeredi <miklos@szeredi.hu> wrote:
>
>> I'm trying to implement statx for fuse and ran into the following issues:
>>
>> - Need a STATX_ATTRIBUTES bit, so that userspace can explicitly ask
>> for stx_attribute; otherwise if querying has non-zero cost, then
>> filesystem cannot do it without regressing performance.
>
> Okay, though the way your patch implements it makes it superfluous.  I presume
> you have further patches that will actually make use of it from the fuse side?

Being worked on, yes.

>
>> - STATX_ALL definition is unclear, can this change, or is it fixed?
>> If it's the former, than that's a backward compatibility nightmare.
>> If it's the latter, then what's the point?
>
> It's the set of supported attributes known by the headers, and such can
> only be added to over time.  But yes, it's probably unnecessary.  Asking
> fsinfo() will be a better way of doing things.
>
>> - STATX_ATIME is cleared from stx_mask on SB_RDONLY,
>
> Ummm...  Where?  It's cleared on IS_NOATIME() in generic_fillattr().  I made
> the assumption that IS_NOATIME() == false indicates that there isn't an atime
> to be had.

Look at IS_NOATIME definition in <linux/fs.h>

You probably wanted inode->i_sb->s_flags & SB_NOATIME instead.

>> and on NFS it is also cleared on MNT_NOATIME, but not on MNT_RDONLY.  We
>> need some sort of guideline in the documentation about what constitutes
>> "unsupported": does atime become unsupported because filesystem is remounted
>> r/o?  If so, why isn't this case handled consistently in the VFS and
>> filesystems?
>
> STATX_ATIME should mean there is an actual atime from the "medium" in
> stx_atime, rather than something made up by the filesystem driver; it doesn't
> necessarily promise that this will be updated.

In this case generic_fillattr() and nfs_getattr() are simply buggy.

>
> There can still be an atime if the medium is read-only.
>
> atime is even more complicated with MNT_NOATIME or MNT_RDONLY because that
> doesn't stop the atime from actually being updated through another mountpoint
> on the same system.
>
> Note that stx_atime should always contain something that can be used directly
> to fill in st_atime if emulating stat() - even if STATX_ATIME is cleared.
>
>> - What about fields that are not cached when statx() is called with
>> AT_STATX_DONT_SYNC?  E.g. stx_btime is supported by the filesystem,
>> but getting it requires a roundtrip to the server.
>
> Not necessarily.  It's not cached in *struct inode*, but that doesn't mean
> that the filesystem can't cache it elsewhere.
>
>> Requesting STATX_BTIME in the mask and adding AT_STATX_DONT_SYNC to the
>> flags means the filesystem has to decide which it will honor.  My feeling is
>> that it should honor AT_STATX_DONT_SYNC and clear STATX_BTIME in stx_mask.
>> Documentation has no word about this case.
>
> From the manpage:
>
>        AT_STATX_DONT_SYNC
>               Don't synchronize anything, but rather just  take  whatever  the
>               system  has cached if possible. ...
>
> Note the "if possible".  If it's not possible, you still need to go get it if
> they explicitly asked for it.

Okay.

Thanks,
Miklos
