From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: statx(2) API and documentation
Date: Wed, 17 Oct 2018 21:04:37 +0200
Message-ID: <CAJfpeguvJZbP83mSULc74Yhpp_CPMBW1XvcgbvCbLnF7QCncUA@mail.gmail.com>
References: <CAJfpegsxFUGeczcC-pzK0WWROjv48_PvXtNun-f5QJMoUDn1Dw@mail.gmail.com>
 <006890C4-64D4-4DE2-A1F0-335FFFD585BB@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <006890C4-64D4-4DE2-A1F0-335FFFD585BB@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, David Howells <dhowells@redhat.com>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 17, 2018 at 8:45 PM, Andreas Dilger <adilger@dilger.ca> wrote:
> On Oct 17, 2018, at 12:24 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>
>> I'm trying to implement statx for fuse and ran into the following issues:
>>
>> - Need a STATX_ATTRIBUTES bit, so that userspace can explicitly ask
>> for stx_attribute; otherwise if querying has non-zero cost, then
>> filesystem cannot do it without regressing performance.
>
> Seems reasonable.
>
>> - STATX_ALL definition is unclear, can this change, or is it fixed?
>> If it's the former, than that's a backward compatibility nightmare.
>> If it's the latter, then what's the point?
>
> The value can change over time.  It is intended to reflect the current
> state of affairs at the time the userspace program and kernel are compiled.
> The value sent from userspace lets the kernel know what fields are in
> the userspace struct, so it doesn't try to set fields that aren't there.

What's the point of a userspace program specifying STATX_ALL?  Without
a way to programmatically query the interface definition it's useless:
there's no way to guess which mask bit corresponds to which field, and
what that field represents.

And there will be programs out there which specify STATX_ALL without
considering that in the future it may become slower as it is now due
to a recompile.

So what's the point exactly?

> The value in the kernel allows masking off new fields from userspace that
> it doesn't understand.

Okay, but that has nothing to do with the UAPI.  Even as an internal
flag we should be careful, as it might grow uses which can have
similar issues as the userspace one above.

>
>> - STATX_ATIME is cleared from stx_mask on SB_RDONLY, and on NFS it is
>> also cleared on MNT_NOATIME, but not on MNT_RDONLY.  We need some sort
>> of guideline in the documentation about what constitutes
>> "unsupported": does atime become unsupported because filesystem is
>> remounted r/o?  If so, why isn't this case handled consistently in the
>> VFS and filesystems?
>
> Strange.  I'd think that if userspace is requesting atime, it should
> get an atime value.  The fact that the kernel is not updating atime
> due to mount options just means that atime might be old.  That doesn't
> mean (IMHO) that atime doesn't exist.

Right, OTOH I sort of see the value in  NFS: no roundtrip to server if
atime value is useless anyway.

>> - What about fields that are not cached when statx() is called with
>> AT_STATX_DONT_SYNC?  E.g. stx_btime is supported by the filesystem,
>> but getting it requires a roundtrip to the server.  Requesting
>> STATX_BTIME in the mask and adding  AT_STATX_DONT_SYNC to the flags
>> means the filesystem has to decide which it will honor.   My feeling
>> is that it should honor AT_STATX_DONT_SYNC and clear STATX_BTIME in
>> stx_mask.   Documentation has no word about this case.
>
> The btime value shouldn't change over the lifetime of a file, so
> DONT_SYNC shouldn't have any effect on its validity?

Not validity, but presence in the cache.  Network filesystem or fuse
may or may not have it available in the cache at the time the inode is
first initialized on loookup.  So when statx(..., AT_STATX_DONT_SYNC,
STATX_BTIME) comes along, it may need a roundtrip to the server.  What
should it do?

Thanks,
Miklos
