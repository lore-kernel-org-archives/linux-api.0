Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795125765;
	b=1oopWze8f5DyNIex9rfOaivEHeeFVwebT95IDcLzVzheOLc09NL7qsKoe7uf/nVCcOje
	 I8Z7Gjz1k7mBLMdKsBktj9bZ136UJfGLR0q44uk7D4oNz15zfRJsNVXqMOIQP8MMt33CN
	 RvGJBegnAF8QgAydsr0jKzxYOSXqvJ8unoaZbrRP71R+qkdAJkVvZ85OIedC8X1bkbeKX
	 A4ngmGI2XtOWeX0WsVgYxPHOuayLXQXW+m/rud5pef+NGf1NcHw9yf8NbIeIXvUI2vmR3
	 Z+lAIwASXsbJzfgXr7ysdB2eNdAGonTy0ko5DzItO59hNT57qbp/F50MVugYVscvrHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795125765;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=RC1M1DCn8/ofSzuC5iVNf1vc0j24iEFLlIbk8QgE6o0=;
	b=zE7cS2SvZjVb+xWGD6PiO8VOfwT+HZ+CRnAwX4OEn8YeW0SFAyPEseLJvmonj+60bLpz
	 j0WUKPNcXDURceRtmicw+jDFS8IA4/z5Q19PcE2aRyX/srZNBXojhhRa3EFF7/zZuSdDl
	 rCWKv1MSYeIXbsj7Urpwg5U1RQTN2YKQUjq7WzRfOMryu2+seN++4TENc06gNkSEjiR6z
	 ztmgB0I6UI5Hhd+jkjs8POn92tR47vJOuz3ecNB/63i/WK0FLNw5VCNUG0m3VU6yOBP5c
	 hE3rDYE/PS5V3mwJiJsBctkogUHCz5dHrq7MFDDYBeZo5dJBofa95Z8eFpyvzEMa8mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tyT3EBKQ;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8249606A332
	for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 22:02:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D8249606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tyT3EBKQ
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4bb77a462c6so11439685e9.1
        for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 14:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795125762; x=1795730562; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=RC1M1DCn8/ofSzuC5iVNf1vc0j24iEFLlIbk8QgE6o0=;
        b=tyT3EBKQ84p6+n9pRVBCd/VKkcOJ9O3q+ZH3suyLqBe9qnxzVsUHYIM7dttdO4qa/L
         9WJv50aioxpLJEh3o5BH/gg9BQt3k4YtOSYnFzmgAdsQ1sV7dToJGs7X4+xrIar9fhjh
         3T3EE49kbtAdcblaAYu0CanLJF0S2bD/omaLuW0mRBscC9VNgbbPZag5MY2a9jUUbskU
         0oDpxyRp5GZcL+fU1WgG3qnYLtpYlcLLKsTTxImE1ert5bOuCQFaTGNm4XuObKrSrP1I
         5oJMOWdWmqkzEklCuv1QGQ9RdXhG5jbgt8jK/LDkMvE4zfcIH7Zr9FDbkOWIQvxTKOaG
         7Jzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795125762; x=1795730562;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=RC1M1DCn8/ofSzuC5iVNf1vc0j24iEFLlIbk8QgE6o0=;
        b=06WeAszAafkOFQA8XpLZQwjJfpuh8Z3tmqCoQIIcCkqATV4Wi6kK9W4RcECX/ULuE0
         SCIcqoGQtzwjxVF6iHvYj07L0Qcxhj2xcw1MAoGzyK2mdGBehQ/jX2B1dYMEbMB585r2
         0g1Ao8MFVZERV6lPMGGhqzSdSlM8CYQi/CH3EeCgqYev2rvT8ogcbdp/+t5u5lKp8iuH
         Rod9zbCEWwU/LZaTV+QrF5vVSsJnPUzGe6KwuVGJCc28iwAuUbkOOvxben/Omev8njkl
         XRjposyVSqVEUYJlwKEhHLhQqMorCVKQnSAUHXWu6smbWiIKpXlh4AQK4EhrJWkp7Uv3
         EDrw==
X-Forwarded-Encrypted: i=1; AL+hErFRqoHMz990l2LJc2k2+hEASVpbV24gzpMIoAJ6nkhxCGDusoze8/OmbCdBJi+EH/5ktTt3xPn87ns=@vger.kernel.org
X-Gm-Message-State: APuU4Z+hiSqX1AiuWGTrsHzUZQRDjtwM9ONR4EfDkS1DTJqWKxvXp4Q8
	LM0nMtBvhl70+KFqy68RqZEGMhhtnUN0JzLZ9ND0iYlqT3p71ZHU8fVN
X-Gm-Gg: AYBFou3MPd/Iq75wpRXmjh0wy9bpg8L3mZg+wl1qpIS3BaT6OqytQSmj4XQsfMeT4BM
	GYzr8JCG9IRnr87R/u6UpewKjoyu2kiUVdwldUwCYakSK4GqQ4RZNWq1+vYwlPrEWniSuLC9YaE
	X/vUzTwDjaa+eVwuImYNfuEqXd/Ce751MW1HWqpjtDkFmxLcveuV6LydAbcO0rXL8hSF4x8jtI6
	Y4ed7OcbwapFMm5J2CwzFpR3oqK1jgVJaqRej9jAqq4vG5KuJZTZSM5UoZhGkCO1jP29vD8RITz
	AEyLLyV3yxCJ5wpyPJodITK9jO8WMX+38ppffQjqDQ4Gp6v1SnLPiknA4jLTLOkc614vZXMc3gm
	w0+anDPpMAYhJHkBmg3ItdlZ2EkkiO1GC9tTIHOzUfiIDDA4WKMAUdw1GaimegfxCfOJLKqx+aq
	EC7AbFHFHgKhRMrl07zorHxBqFOpBxU5Fxp0OOWn6HjUbcGiJNj8ZNH5pfShyKLHjKZF+rbJnjT
	qb/fDGlGelw2dsUPxAIwv99m/fCG+VApOaKaW+uJ2uY/gUHLd70JGCJ0v7MRtJULrdWt75IQRcP
	NhvQwE9eJ6ZeGFerqW6mGMlhbw==
X-Received: by 2002:a05:600c:a085:b0:4bb:85d9:156e with SMTP id 5b1f17b1804b1-4bb8880fe46mr21935945e9.11.1795125761923;
        Thu, 19 Nov 2026 14:02:41 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6b2052c8sm1735463f8f.41.2026.11.19.14.02.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2026 14:02:40 -0800 (PST)
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
 boundary=c2bf06ad23101c2dd736021b19ff33522859edba8be8e5bfafa93f393781;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Thu, 19 Nov 2026 23:02:37 +0100
Message-Id: <DMZIZ05H7MMB.1WYNR4X44BPGR@gmail.com>
Cc: "David Sterba" <dsterba@suse.com>, "Namjae Jeon"
 <linkinjeon@kernel.org>, "Sungjong Seo" <sj1557.seo@samsung.com>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner"
 <brauner@kernel.org>, "Trond Myklebust" <trondmy@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>, "Chuck Lever" <cel@kernel.org>, "Jeff Layton"
 <jlayton@kernel.org>, "Konstantin Komarov"
 <almaz.alexandrovich@paragon-software.com>, "Paulo Alcantara"
 <pc@manguebit.org>, "Chris Mason" <mason@kernel.org>, "Yuezhang Mo"
 <yuezhang.mo@sony.com>, "Jan Kara" <jack@suse.cz>, "NeilBrown"
 <neil@brown.name>, "Olga Kornievskaia" <okorniev@redhat.com>, "Dai Ngo"
 <Dai.Ngo@oracle.com>, "Tom Talpey" <tom@talpey.com>, "Ronnie Sahlberg"
 <ronniesahlberg@gmail.com>, "Shyam Prasad N" <sprasad@microsoft.com>,
 "Bharath SM" <bharathsm@microsoft.com>, "Sergey Senozhatsky"
 <senozhatsky@chromium.org>, "ChenXiaoSong" <chenxiaosong@chenxiaosong.com>,
 "Darrick J . Wong" <djwong@kernel.org>, "Sean Smith"
 <defendthedisabled@gmail.com>, "Andrey Albershteyn" <aalbersh@kernel.org>,
 "Pedro Falcato" <pfalcato@suse.de>, =?utf-8?q?Pali_Roh=C3=A1r?=
 <pali@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <exfat@lists.linux.dev>, <ntfs3@lists.linux.dev>,
 <linux-cifs@vger.kernel.org>, <linux-nfs@vger.kernel.org>,
 <linux-api@vger.kernel.org>, "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: [RFC PATCH v4 10/10] cifs: add provenance time (ptime) and map
 it to SMB's CreationTime
From: "koraynilay" <koray.fra@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "koraynilay"
 <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261115180343.576773-1-koray.fra@gmail.com>
 <20261115180343.576773-11-koray.fra@gmail.com>
 <CAOQ4uxg2gpC99ohuvKm-SgPzuffJy1fSvXorbuBnYZ=OFSxT3w@mail.gmail.com>
In-Reply-To: <CAOQ4uxg2gpC99ohuvKm-SgPzuffJy1fSvXorbuBnYZ=OFSxT3w@mail.gmail.com>

--c2bf06ad23101c2dd736021b19ff33522859edba8be8e5bfafa93f393781
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Thu Nov 19, 2026 at 7:32 PM CET, Amir Goldstein wrote:
> On Sun, Nov 15, 2026 at 7:04=E2=80=AFPM koraynilay <koray.fra@gmail.com> =
wrote:
>>
>> Implement provenance time (ptime) in cifs, as introduced in a
>> previous commit ("vfs: add provenance time (ptime)").
>>
>> Map it to SMB's CreationTime, making it settable from userspace and
>> propagating it to the SMB server via FILE_BASIC_INFO.
>>
>> Support reading ptime via statx(2) and fileattr_get() from the cached
>> CreationTime.
>>
>> Update cifs_fileattr_set() to check xflags instead of only legacy flags
>> and add the cifs_set_file_crtime() helper to wrap the RPC call to the
>> SMB server.
>>
>> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.7
>> Signed-off-by: koraynilay <koray.fra@gmail.com>
>> ---
>>  fs/smb/client/cifsfs.c |   8 +++
>>  fs/smb/client/inode.c  |   7 ++-
>>  fs/smb/client/ioctl.c  | 109 ++++++++++++++++++++++++++++++-----------
>>  3 files changed, 94 insertions(+), 30 deletions(-)
>>
>> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
>> index 8cff7857b450..c2f557e406d3 100644
>> --- a/fs/smb/client/cifsfs.c
>> +++ b/fs/smb/client/cifsfs.c
>> @@ -1307,6 +1307,14 @@ int cifs_fileattr_get(struct dentry *dentry, stru=
ct file_kattr *fa)
>>         if (READ_ONCE(CIFS_I(inode)->cifsAttrs) & ATTR_COMPRESSED)
>>                 fa->flags |=3D FS_COMPR_FL;
>>
>> +       /* Report provenance time (ptime) to userspace */
>> +       if (CIFS_I(inode)->createtime) {
>> +               fa->fsx_xflags |=3D FS_XFLAG_PTIME;
>> +               fa->fsx_xflags_mask |=3D FS_XFLAG_PTIME;
>> +               fa->fsx_ptime =3D
>> +                     cifs_NTtimeToUnix(cpu_to_le64(CIFS_I(inode)->creat=
etime));
>> +       }
>> +
>>         /*
>>          * FS_CASEFOLD_FL is defined by UAPI as a folder attribute,
>>          * and userspace tools (e.g., lsattr) display it only on
>> diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
>> index 2647785ec1e4..f0b20a72b9c2 100644
>> --- a/fs/smb/client/inode.c
>> +++ b/fs/smb/client/inode.c
>> @@ -222,6 +222,7 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs=
_fattr *fattr,
>>
>>         cifs_i->cifsAttrs =3D fattr->cf_cifsattrs;
>>         cifs_i->reparse_tag =3D fattr->cf_cifstag;
>> +       cifs_i->createtime =3D fattr->cf_createtime;
>>
>>         if (fattr->cf_flags & CIFS_FATTR_NEED_REVAL)
>>                 cifs_i->time =3D 0;
>> @@ -2958,7 +2959,8 @@ int cifs_getattr(const struct mnt_idmap *idmap, co=
nst struct path *path,
>>          * We need to be sure that all dirty pages are written and the s=
erver
>>          * has actual ctime, mtime and file length.
>>          */
>> -       if ((request_mask & (STATX_CTIME | STATX_MTIME | STATX_SIZE | ST=
ATX_BLOCKS)) &&
>> +       if ((request_mask & (STATX_CTIME | STATX_MTIME | STATX_PTIME
>> +                            | STATX_SIZE | STATX_BLOCKS)) &&
>>             !CIFS_CACHE_READ(CIFS_I(inode)) &&
>>             inode->i_mapping && inode->i_mapping->nrpages !=3D 0) {
>>                 rc =3D filemap_fdatawait(inode->i_mapping);
>> @@ -2992,6 +2994,9 @@ int cifs_getattr(const struct mnt_idmap *idmap, co=
nst struct path *path,
>>                 stat->result_mask |=3D STATX_BTIME;
>>                 stat->btime =3D
>>                       cifs_NTtimeToUnix(cpu_to_le64(CIFS_I(inode)->creat=
etime));
>> +               stat->result_mask |=3D STATX_PTIME;
>> +               stat->ptime =3D
>> +                     cifs_NTtimeToUnix(cpu_to_le64(CIFS_I(inode)->creat=
etime));
>>         }
>>
>>         stat->attributes_mask |=3D (STATX_ATTR_COMPRESSED | STATX_ATTR_E=
NCRYPTED);
>> diff --git a/fs/smb/client/ioctl.c b/fs/smb/client/ioctl.c
>> index bb8808289a46..19a9556d39b4 100644
>> --- a/fs/smb/client/ioctl.c
>> +++ b/fs/smb/client/ioctl.c
>> @@ -181,6 +181,41 @@ static int cifs_set_compression(unsigned int xid, s=
truct dentry *dentry,
>>                                             compression_state);
>>  }
>>
>> +static int cifs_set_file_crtime(unsigned int xid, struct dentry *dentry=
,
>> +                               struct cifs_tcon *tcon, u64 crtime)
>> +{
>> +       struct inode *inode =3D d_inode(dentry);
>> +       struct TCP_Server_Info *server =3D tcon->ses->server;
>> +       FILE_BASIC_INFO info_buf =3D {};
>> +       const char *full_path;
>> +       void *page;
>> +       int rc;
>> +
>> +       if (!server->ops->set_file_info)
>> +               return -EOPNOTSUPP;
>> +
>> +       info_buf.CreationTime =3D cpu_to_le64(crtime);
>> +
>> +       page =3D alloc_dentry_path();
>> +       full_path =3D build_path_from_dentry(dentry, page);
>> +       if (IS_ERR(full_path)) {
>> +               rc =3D PTR_ERR(full_path);
>> +               goto out;
>> +       }
>> +
>> +       rc =3D server->ops->set_file_info(inode, full_path, &info_buf, x=
id);
>> +       if (rc =3D=3D 0) {
>> +               CIFS_I(inode)->createtime =3D crtime;
>> +               CIFS_I(inode)->time =3D 0;
>> +               inode_set_ctime_current(inode);
>> +       }
>> +
>> +out:
>> +       free_dentry_path(page);
>> +       return rc;
>> +}
>> +
>> +#define CIFS_SUPPORTED_XFLAGS (FS_XFLAG_PTIME)
>>  int cifs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *den=
try,
>>                       struct file_kattr *fa)
>>  {
>> @@ -193,49 +228,65 @@ int cifs_fileattr_set(const struct mnt_idmap *idma=
p, struct dentry *dentry,
>>         bool enable_compression;
>>         struct cifs_tcon *tcon;
>>         unsigned int xid;
>> -       int rc;
>> +       int rc =3D 0;
>>
>> -       if (!fa->flags_valid)
>> +       if (fileattr_has_fsx_mask(fa, CIFS_SUPPORTED_XFLAGS))
>>                 return -EOPNOTSUPP;
>
> What is this supposed to check that is not already checked
> explicitly with fsx_xflags_mask below?

It should work for FS_IOC_FSSETXATTR, where mask is 0... but it's also
there because when I started writing the various filesystems code I
hadn't added _mask yet, so I'll need to take a little step back and
revisit.

>>
>> -       /*
>> -        * chattr writes back all flags returned by fileattr_get(). Acce=
pt
>> -        * FS_CASEFOLD_FL only when it reflects the share's casefold sta=
te.
>> -        */
>> -       if (fa->flags & FS_CASEFOLD_FL) {
>> -               rc =3D cifs_fileattr_get(dentry, &current_fa);
>> -               if (rc)
>> -                       return rc;
>> -               if (current_fa.flags & FS_CASEFOLD_FL)
>> -                       allowed |=3D FS_CASEFOLD_FL;
>> -       }
>> -       if (fa->flags & ~allowed)
>> +       if (fa->fsx_xflags_mask & ~CIFS_SUPPORTED_XFLAGS)
>>                 return -EOPNOTSUPP;
>>
>> -       enable_compression =3D fa->flags & FS_COMPR_FL;
>> -       compression_state =3D enable_compression ? COMPRESSION_FORMAT_DE=
FAULT :
>> -                                                COMPRESSION_FORMAT_NONE=
;
>> +       if (fa->flags_valid) {
>> +               /*
>> +                * chattr writes back all flags returned by fileattr_get=
(). Accept
>> +                * FS_CASEFOLD_FL only when it reflects the share's case=
fold state.
>> +                */
>> +               if (fa->flags & FS_CASEFOLD_FL) {
>> +                       rc =3D cifs_fileattr_get(dentry, &current_fa);
>> +                       if (rc)
>> +                               return rc;
>> +                       if (current_fa.flags & FS_CASEFOLD_FL)
>> +                               allowed |=3D FS_CASEFOLD_FL;
>> +               }
>> +               if (fa->flags & ~allowed)
>> +                       return -EOPNOTSUPP;
>
> This whole mess could be sorted out by switching the cifs
> implementation to the new API

("new API" you mean _mask right?)

> and implementing a generic vfs
> helper which does something like the above code to handle the
> old ioctls.
> FS_XFLAG_CASEFOLD would then be removed from
> FS_XFLAG_RDONLY_MASK and set explicitly in xflags_ro_mask
> by fs which don't allow to set if (e.g. nfs) and added to
> FS_COMMON_FL/FS_XFLAG_COMMON
>
> cifs would advertise FS_XFLAG_CASEFOLD in its ro_mask
> and then the generic helper would mask it and the new syscall
> will not allow it.
>
>> +       }
>> [...]
>> +               cifs_dbg(FYI, "set compress flag rc %d\n", rc);
>
> I think that the roadmap should be to slowly define all the old FS_*_FL
> flags as FS_XFLAGS_* and let the generic helpers deal with the conversion=
.

> But it is not so hard to convert one filesystem at a time in a way that
> fa->fsx_valid will have to be true, because, for example, here
> all the relevant flags would be supported by the new xflags API.

So, something like what fileattr_fill_{x,}flags() do now, but for
file_attr_to_fileattr()?

> No need to do that now, as part of this patch set which is complicated
> enough, just need to see the road ahead of us that we have a way
> forward out of this messy flags_valid/fsx_valid inside filesystem
> implementations.

I think it's probably better to clean up the API now, before introducing
new flags (like FS_XFLAG_BTIME/PTIME or the shared extent one in the
other thread) and as I'll say in that reply (I'll write it in a bit) I
think it's even better to first split the _mask changes into their own
RFC PATCH series, then have a separate one for ptime/btime.

> My understanding is that Miklos introduced those hints to reduce the
> work needed per filesystem for the initial implementation of the
> vfs methods.

Ah yeah that would make sense.

Thanks,
koraynilay

> Thanks,
> Amir.



--c2bf06ad23101c2dd736021b19ff33522859edba8be8e5bfafa93f393781
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCav9x/QAKCRDmj22qf5IG
XCsaAP90pDHkiG6FypqZoMEgsWt2zJhENiftUx4825vQrWbqSQEAv2tho2ttv5d3
4LEx3lAKlpln+AG5aT7npnHOlcow/AM=
=prrA
-----END PGP SIGNATURE-----

--c2bf06ad23101c2dd736021b19ff33522859edba8be8e5bfafa93f393781--
