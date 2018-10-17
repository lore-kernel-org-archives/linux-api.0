From: Miklos Szeredi <miklos@szeredi.hu>
Subject: statx(2) API and documentation
Date: Wed, 17 Oct 2018 20:24:38 +0200
Message-ID: <CAJfpegsxFUGeczcC-pzK0WWROjv48_PvXtNun-f5QJMoUDn1Dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Kerrisk <mtk.manpages@gmail.com>, David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

I'm trying to implement statx for fuse and ran into the following issues:

- Need a STATX_ATTRIBUTES bit, so that userspace can explicitly ask
for stx_attribute; otherwise if querying has non-zero cost, then
filesystem cannot do it without regressing performance.

- STATX_ALL definition is unclear, can this change, or is it fixed?
If it's the former, than that's a backward compatibility nightmare.
If it's the latter, then what's the point?

- STATX_ATIME is cleared from stx_mask on SB_RDONLY, and on NFS it is
also cleared on MNT_NOATIME, but not on MNT_RDONLY.  We need some sort
of guideline in the documentation about what constitutes
"unsupported": does atime become unsupported because filesystem is
remounted r/o?  If so, why isn't this case handled consistently in the
VFS and filesystems?

- What about fields that are not cached when statx() is called with
AT_STATX_DONT_SYNC?  E.g. stx_btime is supported by the filesystem,
but getting it requires a roundtrip to the server.  Requesting
STATX_BTIME in the mask and adding  AT_STATX_DONT_SYNC to the flags
means the filesystem has to decide which it will honor.   My feeling
is that it should honor AT_STATX_DONT_SYNC and clear STATX_BTIME in
stx_mask.   Documentation has no word about this case.

Thanks,
Miklos
