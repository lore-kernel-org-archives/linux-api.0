Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794234915;
	b=bOdK0Gd4t/fvloowWX2WoRAy9ptQm67DWROQ+yP44bO0dF0/QEcO1PcL3D4NRep8bnwn
	 2pI5CiQdKm9ki49vz1+3pX+veXFqgc3K1iksRah3ovRgkoAbyjhvEP0Bw0pJ+WNhygHyW
	 +43HQIdlG8qunKR2z4aubsJXgVPAOqOhenwsbg+NBpRN96GauhsoTtejWM04rSKCUBOW/
	 QzR/6T30T2vw6qPE8mY6kr1dg1LqBjAUYKqY2DdNAQeJHQaobqz3VzRyujR0PAWXid/aN
	 Wy2iJbxoYbVve2TGhp6OGRKVctf0vkR8ecvZaYtgLolOehi+VgWjzvW1cL5KhSMUudA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794234915;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=0DP2yyIupbH6DsaD6N2BQPQTWSxBg8RNCtcYu23tXoo=;
	b=NuyFWbTO5eAvCU3CG1ZWV/OjnGlRhDlgZ0anYQbj93ap5SlEeh8H9SSz2xh+GHKkggxh
	 FXNOY5YWSKD/EXA0FtrDnSkOBs1NLQ3QkDB0PDBENQDyI07YS0FIgJSgBamvqTpKT6Cro
	 iguExx+p/a3OpGHlcXArMJnHAXgqVzgIGZbAy3Ul3P65yLIxUDnI55ZuPza+LMeUMnmc6
	 NZzXPp7EtjEzkVfRcNEMisNlaFy/x3JGZLuFP0SQMIk6kgd+K3YdtYR1lG9E7N4ebXsbH
	 TATnxOG4P63ml5myiBeaQ7/hChQQyURXPsXBIma+RJ8ZupDgE0yt+x5M6uUqcFa/aow==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FcRBLneC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061A5606D803
	for <linux-api@vger.kernel.org>; Mon,  9 Nov 2026 14:35:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 061A5606D803
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FcRBLneC
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b6e8b6d424so1341193a12.0
        for <linux-api@vger.kernel.org>; Mon, 09 Nov 2026 06:35:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794234913; cv=none;
        d=google.com; s=arc-20260327;
        b=cJEAaDFiWD6GysxR5VrcexI2l8umPzJjxWPq8W3EMkcKEvh70C0IervTe6kDh1Kq9E
         rGr5He5Cou8bAjedb+BmtoY/Hq9N6QV1LNkJA1ckyF12IQayCm6lp7ecijLnl7ijwXfo
         nYVYsTMfv9rpTxeR2SW4KlLo6nA/EtOVCHkpzrWzTpGSDkVDcIX4kRqVUzcInNU3A1Ft
         J0J8wjYTCkIFQNlPP/ZK/dlSc7/xr5LSAwV0GmM4Qjg8AUBxWpN6evgjeBDBVb0nEHq+
         3hjddOByPmwZtETwR3NAkHHjK0Q99W90HD1JJIMmChK3OgfS55CCBoXMCSlD3E29wbxw
         NyZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0DP2yyIupbH6DsaD6N2BQPQTWSxBg8RNCtcYu23tXoo=;
        fh=WVoTcwd8lmlFvTUwT5tuldapDKOtspzmdDj7H1QbXxY=;
        b=NHrboJi4DKI6eMtolCCWDNxdaH2jb4plQz+yTZd36aj+G6UPKiZEE/hqaLQD+FHwLo
         ZtpsS/afDhHZh3OPmLYyhI/j4zQOaiHKXxd5NlbsKYuhrS8uP/HEsxinNp15RL4dlVTG
         1ALRbvhT++bY55e19VLnWLVjAvl1T99BVPgbqi/CJ6MD1CDk+h7XdwAAFeDnKxnOT0mu
         asRkK4RETWgqrqi6vB/RsZW08ODPx95yqzyzG8lG5auJfu6Eh8MdNJAnp9IyTHmKDxep
         scXi9pVOVM/JILqoMxn0+3wqUvUl164Y7iFYlriNquXshM8nVsGgwsabj9O2YT7I1GZ6
         1ddA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794234913; x=1794839713; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0DP2yyIupbH6DsaD6N2BQPQTWSxBg8RNCtcYu23tXoo=;
        b=FcRBLneChJ3iVAtYKXY2VEwYNzesOapHOFksvKPhX8sUFzqbpdbVJSRohKdAqKIJGx
         X7sRc/w9F2cJdZMa33dL+1NGs6t8XyM9vT5C4r6r0S6IBHFnTO6k3UMqLzLG/5hxkwh8
         WJzumXQT9LoGeh3I/lQ/bNC3vjjbNqzah27nTcEw9PPPblAH16VkFfAh3FoN/BVVEAzr
         h9u5SbcgtTUS+w9ZgDc242PytiA/SV9kkYzMVj5OcgOY17/pVJcFEGi31YCnIxd8paPF
         s0mXAS1ScJyM74V96vt/80mXa0+3SR4y/KhT3XqDxzYkpbJs7lYvT8D+GRO0NbPKUopk
         nhNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794234913; x=1794839713;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0DP2yyIupbH6DsaD6N2BQPQTWSxBg8RNCtcYu23tXoo=;
        b=KV2gaKWxvV2uFPqijfNJwrd9JSLe6Tr5R1yRUb3Oaua9FCw5zaWW8zWthKDgvRyYnB
         6nl6GCCAULrl4beXhy++9l0LztiTXZpUXe6KDwGfiQczj1XrdIqeyLDPB1ZOUMiymKCt
         N+H5Y6qLx0xmrEuvyiUFc8K+OI6xdYPi56Pl52oT9LvVeocGCRtvmJOS5LDAQESg72M0
         2R69yOA/2/vwMoJUhPQV4Z8OfQcSxfVahZXz9y4erM9FBbOqrlMiBh0UoZjjzWcqPkx4
         msDG5urs9Uh3qffZtIe2HMv9T9VUyofnHKka/B2iLQ3OyX5U3FtVMblJI03CWkwjK8d0
         /KcA==
X-Forwarded-Encrypted: i=1; AL+hErHtsyUgPZKrIv1CSd9UFtQfuhzJEzI+cJfdc62JSHiY+sH5dscKTq7wdDEkFbm7ib1YdwY30ARP4UY=@vger.kernel.org
X-Gm-Message-State: APuU4Z9fFGKFTOqekX6xPzVdihXBYgs3syJC5Qu86QYmli2zMDdffH4x
	kBkOnGJirq6SdNgicUoy/3A9bEVBL15oteO6SRW4Lws0JYHeuInOv0DZ1ViKxxRES6XpUAx+9LJ
	FQqmI1Riq+grIyHVe4YwYemCI4BDJKFU=
X-Gm-Gg: AYBFou0E9Myq+HkoLUbKZ/kyVf3Jjn3Y1+Wa1JRh5gB0ECmHHCjfHiQTx0WAmE+iGe3
	5TaQfVaJCLSyOPgvVlr9HeC6ETebCHCqFZ/+8hNG04KqQBU2rdvOoHptGF9VbRGPiDzzLUtLxDI
	HGsKW2xGaQsqlrfprpy06/JWVZ1aUlfF2LEUvRA1uRisD5IzUXUgtnroP7jCyqTKfEZri+sDkS5
	FejkCze/eMQj8/JoS7NHyFBxj6Bmhkzi63Bn7JSI0Sg7oKSoNJCSiX9MjPpoqpRO19vopPs+stn
	caxoa2H3d0nt4IKmzm2Y6pPrMzk6E+TowXO70hvdpJxYa2+vHPh9rjPwhBSwnDDfhT7Y49ob9JP
	B0iDK7Mfr1eLKpVGY/cUWDHrfRimh/G+a15w1uQl0R/IxJvErtwf0jPmIl+AD+iDovjPOI405gV
	Ua6YjgINp8nFHFcAA=
X-Received: by 2002:a05:6402:241d:b0:6b5:4f5c:cb2 with SMTP id
 4fb4d7f45d1cf-6b722464790mr2827746a12.34.1794234913074; Mon, 09 Nov 2026
 06:35:13 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261101015551.786044-1-koray.fra@gmail.com> <20261101015551.786044-2-koray.fra@gmail.com>
 <CAOQ4uxiuJ=eZu28FZAUz3rpqPKqCimPxJucOnYYuBowvD09_Cw@mail.gmail.com>
 <DMP3UBB0QVOT.20HIXK7ZL6K6U@gmail.com> <CAOQ4uxgSVc8n1LbL_dcU-DpNN5BB-ap_vGdXEu7+d0Td7PK5Tw@mail.gmail.com>
 <DMP582BGB7DV.2U0SJLJL7A87K@gmail.com>
In-Reply-To: <DMP582BGB7DV.2U0SJLJL7A87K@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 9 Nov 2026 15:35:01 +0100
X-Gm-Features: AclHuK-FL8zlFzv2gx7YoWgAsxkxAy656VIACQ9wLKYKc-RbZwxWRFIcIAczMqI
Message-ID: <CAOQ4uxj82K4z+2OiY5W1g7NyWAFOFjqqWnZSS3prytW36j1LgA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 1/5] vfs: add provenance time (ptime)
To: koraynilay <koray.fra@gmail.com>
Cc: David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Chris Mason <mason@kernel.org>, 
	Jan Kara <jack@suse.cz>, Yuezhang Mo <yuezhang.mo@sony.com>, Chuck Lever <cel@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Sean Smith <defendthedisabled@gmail.com>, 
	Andrey Albershteyn <aalbersh@kernel.org>, Pedro Falcato <pfalcato@suse.de>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, exfat@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-api@vger.kernel.org, Theodore Tso <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 7, 2026 at 6:09=E2=80=AFPM koraynilay <koray.fra@gmail.com> wro=
te:
>
> On Sat Nov 7, 2026 at 5:48 PM CET, Amir Goldstein wrote:
> > On Sat, Nov 7, 2026 at 5:04=E2=80=AFPM koraynilay <koray.fra@gmail.com>=
 wrote:
> >>
> >> On Mon Nov 2, 2026 at 3:00 PM CET, Amir Goldstein wrote:
> >> > On Sun, Nov 1, 2026 at 2:57=E2=80=AFAM koraynilay <koray.fra@gmail.c=
om> wrote:
> >> >>
> >> >> Add provenance time (ptime), indicating the time when a file or
> >> >> directory was created. This is user-settable via file_setattr() and
> >> >> retrievable via statx(2) (using STATX_PTIME) or file_getattr().
> >> >>
> >> >> The semantics of when to preserve this new timestamp are the same a=
s
> >> >> mtime, the idea being that there is a correspondence like this:
> >> >>
> >> >> ctime <-> btime
> >> >> mtime <-> ptime
> >> >>
> >> >> so every operation (copying, moving, ...) that currently preserves =
mtime
> >> >> should also preserve ptime.
> >> >>
> >> >> Furthermore, in order to avoid the legacy FS_IOC_FSSETXATTR accepti=
ng
> >> >> FS_XFLAG_PTIME, add an FS_FILE_ATTR_XFLAGS_MASK mask to support new
> >> >> xflags, and use it in fileattr_to_file_attr()/file_attr_to_fileattr=
() to
> >> >> allow ptime to be used with the file_setattr()/file_getattr() sysca=
lls.
> >> >>
> >> >> [ This is a re-implementation of the initial patch[1] by Sean Smith
> >> >>   <defendthedisabled@gmail.com>, following the advice[2] from Darri=
ck J.
> >> >>   Wong <djwong@kernel.org> of using file_setattr() instead of updat=
ing
> >> >>   utimensat() ]
> >> >>
> >> >> [1]: https://lore.kernel.org/20260405195007.1306-2-DefendTheDisable=
d@gmail.com
> >> >> [2]: https://lore.kernel.org/20260407014129.GC6192@frogsfrogsfrogs
> >> >>
> >> >> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.4.7
> >> >> Signed-off-by: koraynilay <koray.fra@gmail.com>
> >> >> ---
> >> >>  fs/file_attr.c            | 33 +++++++++++++++++++++++++++++++--
> >> >>  fs/stat.c                 |  2 ++
> >> >>  include/linux/fileattr.h  |  5 +++++
> >> >>  include/linux/stat.h      |  1 +
> >> >>  include/uapi/linux/fs.h   |  8 +++++++-
> >> >>  include/uapi/linux/stat.h |  7 ++++++-
> >> >>  6 files changed, 52 insertions(+), 4 deletions(-)
> >> >>
> >> >> diff --git a/fs/file_attr.c b/fs/file_attr.c
> >> >> index 833e03810b24..c0645cb22bf3 100644
> >> >> --- a/fs/file_attr.c
> >> >> +++ b/fs/file_attr.c
> >> >> @@ -102,7 +102,7 @@ EXPORT_SYMBOL(vfs_fileattr_get);
> >> >>  static void fileattr_to_file_attr(const struct file_kattr *fa,
> >> >>                                   struct file_attr *fattr)
> >> >>  {
> >> >> -       __u32 mask =3D FS_XFLAGS_MASK;
> >> >> +       __u32 mask =3D FS_FILE_ATTR_XFLAGS_MASK;
> >> >>
> >> >>         memset(fattr, 0, sizeof(struct file_attr));
> >> >>         fattr->fa_xflags =3D fa->fsx_xflags & mask;
> >> >> @@ -110,6 +110,8 @@ static void fileattr_to_file_attr(const struct =
file_kattr *fa,
> >> >>         fattr->fa_nextents =3D fa->fsx_nextents;
> >> >>         fattr->fa_projid =3D fa->fsx_projid;
> >> >>         fattr->fa_cowextsize =3D fa->fsx_cowextsize;
> >> >> +       fattr->fa_ptime_sec =3D fa->fsx_ptime.tv_sec;
> >> >> +       fattr->fa_ptime_nsec =3D fa->fsx_ptime.tv_nsec;
> >> >>  }
> >> >>
> >> >>  /**
> >> >> @@ -141,15 +143,20 @@ EXPORT_SYMBOL(copy_fsxattr_to_user);
> >> >>  static int file_attr_to_fileattr(const struct file_attr *fattr,
> >> >>                                  struct file_kattr *fa)
> >> >>  {
> >> >> -       __u64 mask =3D FS_XFLAGS_MASK;
> >> >> +       __u64 mask =3D FS_FILE_ATTR_XFLAGS_MASK;
> >> >
> >> > That is not the correct way to extend this API.
> >> > This fixed mask was added as a placeholder for
> >> > "We intend to add support for more xflags to selective filesystems":
> >> > https://lore.kernel.org/linux-fsdevel/20250329143312.1350603-2-amir7=
3il@gmail.com/
> >> >
> >> > Please see this POC patch for filesystems to publish their supported
> >> > xflags mask:
> >> > https://lore.kernel.org/linux-fsdevel/20250329143312.1350603-3-amir7=
3il@gmail.com/
> >>

Re-reading and answering your original questions:

> >> Quick question, should _mask also be used for user-space -> VFS to adv=
ertise
> >> what it wants to change?

Yes absolutely.

> >> This would be useful for on/off flags,

Exactly.

All the Windows filesystems that want ptime, would most likely want the sup=
port
on/off HIDDEN/SYSTEM/ARCHIVE flags as well.

> >> but for ptime both fa->xflags and
> >> fa->xflags_mask would have the same meaning of "I want to change ptime=
,
> >> look at fa->ptime".

There needs to be no FS_XLAG_PTIME in fa->xflags,
just as there is no FS_XFLAG_PROJID in fa->xflags today.

However, since btrfs does not support setting projid, when we introduce
fa->xflags_mask, it would be elegant IMO to introduce the (new) flag
FS_XFLAG_PROJID which would be valid in fa->xflags_mask.

To be clear, currently upstream chattr (e2fsprogs) can set projid via
FS_IOC_FSSETXATTR ioctl (no xflags_mask) and upstream
xfs_io -c chattr (xfsprogs) can set projid via  file_setattr() syscall
(no xflags_mask).

But if either utils were to be modified to support setting ptime, then it
would need to use file_setattr() syscall and set both FS_XLAG_PTIME
and FS_XFLAG_PROJID in  xflags_mask when it wants to set a non-zero
value to those fields.

Specifically, the invocation of chattr -p <projid>, will no longer need to =
do
FS_IOC_FSGETXATTR to read all the unrelated flags for setting the projid.

> >> Should we make _mask the only way to advertise what the user wants to
> >> change,

Yes, unless _mask is zero, which then means set all the legacy values
which are frozen in the constant FS_XFLAGS_MASK.

> >> ignore xflags | PTIME in user-space -> VFS and use it only in FS
> >> -> VFS -> user-space to say "this fs supports PTIME for this file"

Close, but not exactly.

For GET, semantics are clear and follow statx precedents:
xflags_mask always means "supported" (like stx_attributes_mask).

For boolean flags, xflags is the value
For integer fields, an xflags bit means "value provided" (like stx_mask).

For SET, when xflags_mask!=3D0, a flag of 1 means "I want to set this value=
".

For boolean flags, if the flag's bit in xflags_mask is 0, the flag is
left untouched
(e.g. a chattr -p that only sets the project ID doesn't touch IMMUTABLE).

For integer fields, the meaning of xflags_mask 1 and xflags 0 would be
"I want to unset the value" which is not the same as "I want to set the val=
ue
to 0", because as you wrote, 0 is a valid value for ptime.

The question of whether a specific field can be unset or not is up for the
filesystem to decide, not the VFS.

For example, XFS already unset the value of cowextsize when flag
FS_XFLAG_COWEXTSIZE is 0, although the same could be done
with a 0 value to fa_cowextsize.

VFS does enforce that xflags & ~xflags_mask is EINVAL.

> >> (which will be always once support is added to an FS, so it would just
> >> be "this FS supports PTIME")?

It does not have to be an FS-wide property. some fs could have ptime
(or another attribute) support only on some files types.

> >>
> >
> > Sorry I was not able to parse your question.
> >
> > I think the mask should mean "this FS supports PTIME"
> > regardless if the user asked to get/set it or not.
>
> Yeah sorry, I'm just a bit confused because of all the similar names and
> concepts.

Me too... I needed to re-read all the threads from Feb 2025...

>
> (assuming btrfs supports ptime and ext4 doesn't)
>
> * filesystem -> VFS -> user-space, while in fileattr_to_file_attr():
>
>   for btrfs, for all files[1]:
>         fa->fa_xflags & FS_XFLAG_PTIME =3D=3D 1
>         fa->fa_xflags_mask & FS_XFLAG_PTIME =3D=3D 1

Yes.

>
>   for ext4, for all files:
>         fa->fa_xflags & FS_XFLAG_PTIME =3D=3D 0
>         fa->fa_xflags_mask & FS_XFLAG_PTIME =3D=3D 0

Yes.

>
> * user-space -> VFS -> filesystem, while in file_attr_to_fileattr():
>
>         fattr->fa_xflags & FS_XFLAG_PTIME =3D=3D ignored

This is debatable. IMO it should be 1 for value, 0 to unset existing value,
similar to removexattr() if you want to look at it this way.

>         fattr->fa_xflags_mask & FS_XFLAG_PTIME =3D=3D 1 if user wants to =
set it, otherwise 0

Yes. but now the user has to set any legacy field it wants to set in
fa_xflags_mask as well, because fa_xflags_mask is no longer zero.
so we need to introduce flag constants for legacy fields that do not
have xflags. I think that is only FS_XFLAG_PROJID.

>
> Would this be correct?
>
> Or would it be better to set FS_XFLAG_PTIME only in fa_xflags_mask, and
> never touch fa_xflags with it, which would make the above become:
>
>
> * filesystem -> VFS -> user-space, while in fileattr_to_file_attr():
>
>   for btrfs, for all files[1]:
>         fa->fa_xflags_mask & FS_XFLAG_PTIME =3D=3D 1
>
>   for ext4, for all files:
>         fa->fa_xflags_mask & FS_XFLAG_PTIME =3D=3D 0
>
>   (and always fa->fa_xflags & FS_XFLAG_PTIME =3D=3D 0)
>
> * user-space -> VFS -> filesystem, while in file_attr_to_fileattr():
>
>         (fattr->fa_xflags & FS_XFLAG_PTIME =3D=3D ignored)
>         fattr->fa_xflags_mask & FS_XFLAG_PTIME =3D=3D 1 if user wants to =
set it, otherwise 0
>

I prefer the former.

> This would mean that fa_xflags_mask is used like stx_mask both by the fs
> (to let the user know what it supports (a.k.a. what it's returning)) and
> by the user (to let the fs know what it's trying to set),

This is actually like stx_attributes_mask not stx_mask.

> and fa_xflags
> is used only for ON/OFF flags (like immutable).

Yes, on/off for flag values (like stx_attributes), but "value exists"
for field values (like stx_mask).

>
> Let me know if it's clearer.
>

Same.

Thanks,
Amir.
