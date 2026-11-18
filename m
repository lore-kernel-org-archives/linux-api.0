Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794964155;
	b=FLv6Xs1eWgsfJSoil85chrLxeTujMtJihDfkZsBnqpwUHnjR7KCLpBFpnoqhDzn7GpzK
	 VLSXPnm2Z3SmRHrd15o/Bml+rNUX41CcITwHAtjvgX3h9uRokobAjSTDYLKqbPzbuCqSt
	 W7IUengp+5B/8WEWE2aKOXnFV8r6uus49h8MciwVbYvsFIfrbzay57pgfFrwYm3IUXSuX
	 SbYgIkHZPnmAgIT3toc2e6VVNDvDyl63cRr7C+vW7EkLvGz82PfRuLXtIWKDkkNmYc3NM
	 lCcZrdSu4Oyk/QxJO6WSpgo+aNc4LhwfE4Eq/5+CPFLJyOvdhO4acSpl5iRprCn3WEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794964155;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:X-Mailer:
	 References:In-Reply-To;
	bh=PZ+3qJZoMU255+lkasu7qmvLXDM4HNJXEBMWPQ3TNF4=;
	b=R89zhyYt6BnJ26e+MD6h91Bh7io7L8ZezS3Mkery6F40avGlBAeq8INFYNQn+AZvk4uW
	 6GjRPyxI1G4ck1iQVPkEpAcbjduS2kk01hAHUWb8m7MYUJnt7Lj5XOLrp49mqJhKRdZ3M
	 5KYWzklmpqAA6xLLCdfO6S5FGO+U73X8lSZ2pcXbH2lcABk0LZKgjfZF/QY0pKxxanaVv
	 mrEZeje04FtcOfghTrDZ2LHhHXdRuLDmh93Gv8GPCdFIx+vhbRYoLx6DDyVkB1LG2mvP6
	 wuaXPE6UrmBwxdKDkw6oc4BsxobSKM8YTDhV8YxKUJAbpAQlwF62K8SsmyUMQINPVBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VHAwCAgm;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E003606A32C
	for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 01:09:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8E003606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VHAwCAgm
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4bb6adaf0f1so4217115e9.0
        for <linux-api@vger.kernel.org>; Tue, 17 Nov 2026 17:09:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794964153; x=1795568953; darn=vger.kernel.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=PZ+3qJZoMU255+lkasu7qmvLXDM4HNJXEBMWPQ3TNF4=;
        b=VHAwCAgmRb/DGKYR9+ms8Cf5qCi3Gd0oKLrclEBf59rwhhv6AicK3WbCXcEYRh1w/j
         TMeOENMtGAPul3mf5lYMHgFjNJZXDbiiHTTL2mbrYoQsOmyXjsOFJLM21gOrSmUQVi6V
         xWuvUmFk6jZ5GwhXghxHEC33NVY6qFgeJY6mLRkJuSH1XofE2oM6y5qhOper74Z6DOfg
         1YDGnIxC27pkz7PmkdpPTqtR7hQhw3QW7YJ2pcCKk0F1kc6Io4WAl3z+02G3DFU0NE5i
         T1o+OR6jx8pAltoBpMCMU5pl9RosEDcMzv5mBY0yfqWhe+MQQ1d83BTZNl2aAy8fyDRk
         I1Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794964153; x=1795568953;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=PZ+3qJZoMU255+lkasu7qmvLXDM4HNJXEBMWPQ3TNF4=;
        b=0mvMQtjJWvZTOr0JX1c2hWrwX/rg/ZAM6OjzxrT8iiNjOBMA6PcvLpChIgq6tLUnI2
         +ldiq6gj1657PpEzww2+4J2Fslv/1XySTag7oN4i6QCPJTnt+qM1oZxilVt6N/Rg5gF6
         yvx8NFcihUKrsedUqeTKF93eFYyY/abDF63LYl2yi837sKA2Me5erzihJoJHXD5a7PxF
         ijqFXOAZ0qBmmVx3GuJOw1JY56JPo84BVQ86mZoS4Vszytu9pkWJEBilnBPvVqew/2u3
         o0Ul7gkp89yGHbEwK5wi/eU9lD5VzBTmiuoRxwvswilxcaszyr8AdQa5WCpccuNoJc/r
         ZDZw==
X-Forwarded-Encrypted: i=1; AL+hErEYdPEl4OzApOgg5id0rt6aiMHefprfXkyfsQKyMyHU/EYIzehUkP3y2KbxJ7Zv4o1NPzUfNCgROms=@vger.kernel.org
X-Gm-Message-State: APuU4Z/1HhoWLYMtzRmQBObvYbxZrOH92V/K29QLry439WSYl/sfDFII
	zqzNorVjkgnNviya3ahkejlezQAl0XqsJutBAIYujmP2YChLpcwWXaLR
X-Gm-Gg: AYBFou2qVvODz66nfrjmIq0YggQBM5AlaQ0Th13D5keg6NePJN8C5EegIBYS/84ILY2
	oaHuT6bl9gz4HJZJDAv06wLh7ARY3GSNVenvEjp+YndSyep3n9ceoA0ytCAAZNiXPIsH66r2qfI
	Z6dm5hTqUBkBfoQzrx/Gx7ZmV9/adDd2KZVsRKxWZzYhFaOKT57XJlvPmHn67LszB4zlfjUIZ7J
	JSVz/731xs+yNucxbLeDovlyaFvdJvggsgX47bJGDc1+KqTVuxElWSkEls3sncFf/SCfeyNTzhr
	peG+hKexmShR6lnZ58MBeZ5egdiZm+4VAXpzhNjGDJzSH00xkerZW8mqgwDdO/jY4DziNGSic3V
	FEVLAYF4qU6UO4y3YXYEHaKMxQM3+kLfy+ucXlIjEvthDekBSzlPQKfc+S2gYfnLmyr2JAhPBsZ
	rrUhedmAZcmOyn2mX2JI1kULf/xU53bWC4qxRtD4Fcvs+UhO5PVfeuHMTdnQC/Te2xU6Rw+0PPo
	LKmEy34SGDRPy6mszc9HUvWaoAYPKrMNKAGRV3wTTjFhSI+qgNFG6DjdLHUkkETDP/ymPkr3p1p
	R5b1orFdkOPtIbyXA38Ofv9fWA==
X-Received: by 2002:a05:600c:474c:b0:4bb:6a2d:b426 with SMTP id 5b1f17b1804b1-4bb7d5d40fdmr17867305e9.1.1794964152741;
        Tue, 17 Nov 2026 17:09:12 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb7d256f64sm23087625e9.1.2026.11.17.17.09.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2026 17:09:11 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=b1a8dff5fd09ce748c6816739f5ee431ea78e5cf3134c99d90e2f9bc2bde;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Wed, 18 Nov 2026 02:09:06 +0100
Message-Id: <DMXXOPD9UDNP.2YP9ROMHFLM9E@gmail.com>
Subject: Re: [RFC PATCH v4 00/10] add provenance time (ptime)
From: "koraynilay" <koray.fra@gmail.com>
To: "Jeff Layton" <jlayton@kernel.org>, "koraynilay" <koray.fra@gmail.com>,
 "David Sterba" <dsterba@suse.com>, "Namjae Jeon" <linkinjeon@kernel.org>,
 "Sungjong Seo" <sj1557.seo@samsung.com>, "Alexander Viro"
 <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>, "Trond
 Myklebust" <trondmy@kernel.org>, "Anna Schumaker" <anna@kernel.org>, "Chuck
 Lever" <cel@kernel.org>, "Konstantin Komarov"
 <almaz.alexandrovich@paragon-software.com>, "Paulo Alcantara"
 <pc@manguebit.org>
Cc: "Chris Mason" <mason@kernel.org>, "Yuezhang Mo" <yuezhang.mo@sony.com>,
 "Jan Kara" <jack@suse.cz>, "NeilBrown" <neil@brown.name>, "Olga
 Kornievskaia" <okorniev@redhat.com>, "Dai Ngo" <Dai.Ngo@oracle.com>, "Tom
 Talpey" <tom@talpey.com>, "Ronnie Sahlberg" <ronniesahlberg@gmail.com>,
 "Shyam Prasad N" <sprasad@microsoft.com>, "Bharath SM"
 <bharathsm@microsoft.com>, "Sergey Senozhatsky" <senozhatsky@chromium.org>,
 "ChenXiaoSong" <chenxiaosong@chenxiaosong.com>, "Darrick J . Wong"
 <djwong@kernel.org>, "Sean Smith" <defendthedisabled@gmail.com>, "Andrey
 Albershteyn" <aalbersh@kernel.org>, "Pedro Falcato" <pfalcato@suse.de>,
 "Amir Goldstein" <amir73il@gmail.com>, =?utf-8?q?Pali_Roh=C3=A1r?=
 <pali@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <exfat@lists.linux.dev>, <ntfs3@lists.linux.dev>,
 <linux-cifs@vger.kernel.org>, <linux-nfs@vger.kernel.org>,
 <linux-api@vger.kernel.org>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261115180343.576773-1-koray.fra@gmail.com>
 <fc53ec55d315a4b96ec1e6f250ad3763f2189755.camel@kernel.org>
In-Reply-To: <fc53ec55d315a4b96ec1e6f250ad3763f2189755.camel@kernel.org>

--b1a8dff5fd09ce748c6816739f5ee431ea78e5cf3134c99d90e2f9bc2bde
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

Hello and thanks for replying,

On Wed Nov 18, 2026 at 12:53 AM CET, Jeff Layton wrote:
> On Sun, 2026-11-15 at 19:03 +0100, koraynilay wrote:
>> This is an initial implementation of a new timestamp to indicate the
>> time when a file/directory was initially created.
>>=20
>> This patch series takes inspiration from the one by Sean Smith
>> <defendthedisabled@gmail.com> [1], but using
>> file_setattr()/file_getattr() as suggested by Darrick J. Wong
>> <djwong@kernel.org> in [2].
>>=20
>> The semantics of this new timestamp should be at least these:
>> - it should be the same as btime on a newly created file
>> - it's user-settable, so it can be preserved for backups, filesystem
>>   conversions, archives and any similar operation
>> - it should be preserved every time mtime gets preserved
>>=20
>> and the correspondence with the other timestamps is as follows:
>>=20
>> ctime <-> btime
>> mtime <-> ptime
>>=20
>
> I'm not sure how to interpret the correspondence above.

  |-----\_-----------------|-----------|
  |       \_      change/  |   birth/  |
  |         \_ modification|  creation |
  |           \------------|-----------|
  | inode time |   ctime   |   btime   |
  |------------|-----------|-----------|
  | file time  |   mtime   |   ptime   |
  |------------|-----------|-----------|
 =20
("file" as in "the concept of this file", I'd say "file content" but
that would be incorrect for symlinks)

so ctime is "inode change time", btime is "inode birth/creation time",
while mtime is "file content change/modification time" and ptime would
be "file content creation time" (same as Window's or MacOS's creation
time).

Does this make more sense?

>
>> Examples:
>> 1) a .zsh_history file created in 2019, then after a few years the user
>>    decides to switch to another filesystem, copying the .zsh_history to
>>    the new home, in that case btime would have the timestamp of the copy
>>    and ptime would have the 2019 timestamp (just like mtime would have
>>    been preserved)
>> 2) a symlink created in 2020 from the home directory to a /path going
>>    through the same process as the .zsh_history, in this case it would
>>    also make sense to sync the ptime to the 2020 timestamp instead of
>>    keeping only the btime (so the inode creation time).
>>=20
>> The proof-of-concept code (for testing) for stat(1) and cp(1) is
>> available at https://github.com/koraynilay/coreutils (master branch)
>> (Note: these coreutils code changes are a prototype and won't be
>> submitted upstream as-is, but they work as expected in simple stat and
>> cp -a/--preserve=3Dptime tests)
>>=20
>> Lastly, the name "provenance" and "ptime" are not final, I personally
>> don't have a strong opinion on any name, but while testing with stat(1)
>> I noticed that "Provenance" is definitely too long for the normal
>> output, so another option which would fit well is "Origin time",
>> abbreviated as "ntime" (OrigiN time) and not as "otime", as that would
>> conflict with btrfs' internal naming and create confusion.
>>=20
>> v2 changes:
>> - fix permission bypass leading to ptime update on immutable and
>>   append-only files (found by sashiko[3])
>> - normalize ptime timestamp as done in fs/attr.c:notify_change() (found
>>   by sashiko[3])
>> - fix wording in vfs patch to be like the cover-letter
>>=20
>> v3 changes:
>> - vfs: reject setting ptime with -EOPNOTSUPP on filesystems that do not
>>   support it instead of silently ignoring it (found by sashiko[4])
>> - vfs: fix not being able to clear immutable and append-only on files
>>   with ptime, and allow updating immutable/append-only atomically along
>>   with ptime (found by sashiko[4])
>> - btrfs: validate on-disk ptime nanoseconds and reset to otime if
>>   invalid (found by sashiko[4])
>> - btrfs: avoid re-assigning ptime on unrelated chattr calls (found by
>>   sashiko[4])
>> - add ntfs3 and exfat support as suggested by Amir Goldstein[5], but no
>>   vfat, smb, or nfs4 yet as they are a bit more complex
>> - move the introduction of fileattr_has_fsx_mask() from the btrfs patch
>>   to a standalone patch in the series
>> - btrfs: add fileattr_[gs]et to symlink and special file operations
>>=20
>> v4 changes:
>> - vfs: implement fsx_xflags_mask as suggested by Amir Goldstein[6];
>> - add SMB (ksmbd/cifs) and nfs (nfsd/nfs) support as requested in
>>   previous threads;
>>=20
>> Note:
>> to apply this patch 2 previous patches[7][8] from the ksmbd/cifs
>> subsystem are needed.
>>=20
>> New Question:
>> should I rename fileattr_has_fsx_mask() to something like
>> fileattr_has_unsupported_fsx() and keep its code as-is, or should I add
>> the fsx_xflags_mask & ~allowed check in it and keep the name as-is? (or
>> both?)
>>=20
>> Thanks.
>>=20
>> [1]: https://lore.kernel.org/20260405195007.1306-2-DefendTheDisabled@gma=
il.com
>> [2]: https://lore.kernel.org/20260407014129.GC6192@frogsfrogsfrogs
>> [3]: https://sashiko.dev/#/patchset/20261027220532.736352-1-koray.fra%40=
gmail.com
>> [4]: https://sashiko.dev/#/patchset/20261028134728.294127-1-koray.fra%40=
gmail.com
>> [5]: https://lore.kernel.org/CAOQ4uxiuy0VwZj+3M-zRqQ49WTpHZpiaQ+6MZ8z8Wd=
LjyQM_zA@mail.gmail.com/
>> [6]: https://lore.kernel.org/CAOQ4uxjtuTDT63vJdYaq+RHQEQFLTksp66e46OMN99=
WhJz3SbA@mail.gmail.com/
>> [7]: https://lore.kernel.org/linux-cifs/20261112111637.184045-2-koray.fr=
a@gmail.com/
>> [8]: https://lore.kernel.org/linux-cifs/20261115155308.415734-1-koray.fr=
a@gmail.com/
>>=20
>>=20
>> koraynilay (10):
>>   vfs: add provenance time (ptime)
>>   vfs: add fileattr_has_fsx_mask()
>>   ntfs3: make crtime user-settable using ptime
>>   exfat: make crtime user-settable using ptime
>>   btrfs: add provenance time (ptime)
>>   vfs: add __vfs_fileattr_set_locked() for inode_lock()'d callers
>>   nfsd: add provenance time (ptime) via FATTR4_TIME_CREATE
>>   nfs: add provenance time (ptime) via FATTR4_TIME_CREATE
>>   ksmbd: add provenance time (ptime) and map it to CreationTime
>>   cifs: add provenance time (ptime) and map it to SMB's CreationTime
>>=20
>>  fs/btrfs/btrfs_inode.h          |   4 +
>>  fs/btrfs/delayed-inode.c        |   6 ++
>>  fs/btrfs/inode.c                |  29 +++++-
>>  fs/btrfs/ioctl.c                |  24 ++++-
>>  fs/btrfs/print-tree.c           |   1 +
>>  fs/btrfs/tree-log.c             |   3 +
>>  fs/exfat/exfat_fs.h             |   2 +
>>  fs/exfat/file.c                 |  42 ++++++++-
>>  fs/exfat/namei.c                |   1 +
>>  fs/file_attr.c                  | 156 ++++++++++++++++++++++++++------
>>  fs/nfs/inode.c                  |  27 +++++-
>>  fs/nfs/internal.h               |   2 +
>>  fs/nfs/nfs4proc.c               |  56 +++++++++++-
>>  fs/nfs/nfs4xdr.c                |  19 ++--
>>  fs/nfs/symlink.c                |   1 +
>>  fs/nfsd/nfs4proc.c              |   9 ++
>>  fs/nfsd/nfs4xdr.c               |  40 +++++---
>>  fs/nfsd/vfs.c                   |  17 ++++
>>  fs/nfsd/vfs.h                   |   4 +-
>>  fs/nfsd/xdr4.h                  |   3 +
>>  fs/ntfs3/file.c                 |  20 +++-
>>  fs/ntfs3/frecord.c              |   8 +-
>>  fs/smb/client/cifsfs.c          |   8 ++
>>  fs/smb/client/inode.c           |   7 +-
>>  fs/smb/client/ioctl.c           | 109 ++++++++++++++++------
>>  fs/smb/server/smb2pdu.c         |  37 +++++---
>>  fs/smb/server/vfs.c             |  43 ++++++++-
>>  fs/smb/server/vfs.h             |   1 +
>>  fs/stat.c                       |   2 +
>>  include/linux/fileattr.h        |  29 +++++-
>>  include/linux/nfs_xdr.h         |   3 +
>>  include/linux/stat.h            |   1 +
>>  include/uapi/linux/btrfs_tree.h |   3 +-
>>  include/uapi/linux/fs.h         |   9 +-
>>  include/uapi/linux/stat.h       |   7 +-
>>  35 files changed, 614 insertions(+), 119 deletions(-)
>>=20
>>=20
>> base-commit: 3bc1fb9c3b20cd478c83496ab16addecb401770d
>> prerequisite-patch-id: 049ae0eba275b5be35a238833107e0b251a55aa2
>> prerequisite-patch-id: 614f0bc9411391403d4e9702bafeb31b0ec04ec1
>> prerequisite-patch-id: ddf636b9d33d82ea206ce265d817371350bf8858
>
> I think this is going to be very hard to do properly, because the
> kernel can't really manage this on its own. Something in userland is
> going to have to set this value if you want to update it to something
> other than the original inode instantiation time (aka btime).
>
> It really sounds like what you want is the ability to make the btime
> settable. Personally I think the decision to forbid that was wrong-
> headed and that it should have been settable from userland from the
> beginning. Maybe we should just revisit that decision.

Originally I just wanted to have btime settable, yes, and if btime was
settable I wouldn't have made this RFC PATCH either, but after reading
the already existing discussions about it, I can understand having an
"immutable inode creation time", like ctime exists, so even after making
btime settable, a new timestamp would be necessary anyway (e.g. for the
people who want btime to exist as a forensics timestamp).

> Failing that, why not just track this in an xattr of some sort, since
> this is really just an opaque blob once you allow it to be settable. If
> the xattr isn't present, then you can just use the value of the btime
> as-is. FWIW, I think samba does this today, so you could try to sync
> with its behavior here.

(This is copied and adapted from [2])

I actually have been using fully userspace xattrs[1] for a few months,
mostly for backups, and it "works"; but last month I wanted to merge 2
FSs (and have another merge I have to do), so I ran [1] on all files and
then compared all metadata/data between source and destination and
noticed there were quite a lot of files that didn't have the xattr set.
So I looked online and learned that xattrs only work on regular
files/directories, not on symlinks or anything else (and the missing
ones were of symlinks).
This is what prompted me to search more if anyone had already proposed a
new timestamp (instead of making btime settable) and found the email
thread from april linked in the cover letter, which gave me the excuse
to finally work on a proper patch.

> That seems a lot simpler than adding an entirely new inode timestamp
> that is always going to be a copy of the btime, except in rare cases.
> Having to patch all of the on-disk filesystems with a new per-inode
> field is a lot more work.

> This patch is quite simple, but changing btrfs, then ext4, xfs, etc is a
> mess, and inevitably you can't get these timestamps until you upgrade you=
r
> filesystems.

So yeah while I do agree it touches a lot of code that could create
problems, IMO this is the best solution and it would complete files'
timestamps like other OSs have (and this, I think, is necessary for
both backup/archival and migrations).

Thanks,
koraynilay

[1]: https://github.com/koraynilay/btime-to-xattr
[2]: https://lore.kernel.org/DMGS4KQLY24Q.14MUTR6U93GIC@gmail.com/

--b1a8dff5fd09ce748c6816739f5ee431ea78e5cf3134c99d90e2f9bc2bde
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCavz6sgAKCRDmj22qf5IG
XJc2AQDEw3DLWknN6hhurcFZrcIQwXM4vVkKq7ZARVMraoydvAEAstnUK3kjAUAY
kVmRWWr3a9czwpWam0GcL2q7iV+QsgE=
=OJC6
-----END PGP SIGNATURE-----

--b1a8dff5fd09ce748c6816739f5ee431ea78e5cf3134c99d90e2f9bc2bde--
