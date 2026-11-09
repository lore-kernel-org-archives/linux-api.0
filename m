Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794263699;
	b=OtrCYAaxPlMIy+JaQCqZOEDmJNYe5vFUtUJRt1AjODdj9KXErbueeBJULrhda18IbWwx
	 Q1XaZw/3HuNvnNvSajW59BNN9GFrIe+olE5XxpnFGtZoJTpfNkmhVK5w7KbU9PwZRiPLq
	 pHEcuaFmIKPYSoypuFmim2It3+OjVrhdXFkHYIRJC0WYFh3pdCaNwM5CjvlcXBhTAfGrw
	 2gdlACD2tT8khZIgR29QPTGUdEeq3LUOArIjKN+jGytKVy9fnyLWIDSKdUQ2eH+k/nG8i
	 TB0yFXYdEKivxnyrqM6s2RE2IOQ9tN+UxNVMaCWvq0fsaNHniZUuJ5ISQF5QT1aLNfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794263699;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=TbeRpiMQNiT5Jtn969Ppv6Yio3qCqfnpSKR/Mo7ZTMU=;
	b=1XNFUIgLpZuye2NIbKit7P+Xq4xMKg+JlpAdkJV8vdKAO66Wdie/n5YnGADQELpJsK1b
	 TWCN9U//iTkwUuPe+rHX/eFR6h6mHM6ZF9tgq106UMqUHiJLmFRd4BdiFWqK54cTgtthH
	 j1tdw5+m8URiGa/BL2F8xX7SXwF2M+5KwO/2gmXt0rxkRSJI1uYOn02qcUzDm/8TNjaKJ
	 vK9WkxT19E9gihywhwlIQmgUn4R+XsKWv7PILUQKXRNyeben8YN3EqLfUAoEYTGCA15iO
	 J+BxbN61Wbc20hvHMeRg0CcEBGLJjqlO2gCbGSj0xtb+/MmBbXQAsV++EA142hMEunA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZHEdAtMq;
	arc=none smtp.remote-ip=209.85.221.46
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CD960A2635
	for <linux-api@vger.kernel.org>; Mon,  9 Nov 2026 22:34:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79CD960A2635
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZHEdAtMq
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-4922523d1afso786657f8f.0
        for <linux-api@vger.kernel.org>; Mon, 09 Nov 2026 14:34:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794263698; x=1794868498; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=TbeRpiMQNiT5Jtn969Ppv6Yio3qCqfnpSKR/Mo7ZTMU=;
        b=ZHEdAtMqcMDVPooXMtdIyeTDcVwVMpn5P+qPV8DNIsSjjECv/mA8h7xZ/BTNyRPWEN
         fPu+3dkCNxIxyF93RZww+sqtps2TO41Ngas6LHgN6TDF9CnqgLxuFjy5V8vpvub17CTT
         XK2Efzjz+oYwe3gL8BeGmXe6hTbQtzGi5Mw1WDE8WNi3ztBLNCB3T2WqdD1jeQprFbH2
         JU5qnKgQp9Q4xkgW0Y6/Mj/3qdgPREXlkdeTrAiLOJyt2RtnUGCH/VYnT4yakgQ9aKpu
         fmZuXjx86sMiUNT7Sqb3/rAsvMdMnBggjoNJeHCZcVwzViYY95bGCkEomeypZ7Q5D3Qd
         AQaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794263698; x=1794868498;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=TbeRpiMQNiT5Jtn969Ppv6Yio3qCqfnpSKR/Mo7ZTMU=;
        b=lFcETjojSqD9ZlkETTyQrmM3/tHYAajlZuYqDrDMvpIKxQa+z18DLpGLNam3unNcoA
         ZrcPUaTFsJaVCsFf6Nw0NIOvjd16ZcHP4q+DBIELv6fSd3o1VMQ6E8EWcLUqevQ59REl
         UvjfYCKoWYQ5dLUuBwtwmH8F1cbdoestyOb9bykCqpe7k91RI7W7pCk063Tum9dj2gNV
         HRJEHxTsg187/6gHaABh5ZNw+BM5WPeaYJ4HcqaFJc3AthkkPSlUH5OlVK1wmwk1cH8k
         FdrKBm65C/vA72fHIIlBFGt5VCbo9MB4Y9BZW8yP+sdJD2eLsYaTadNsTO/QQg//+h/M
         STyA==
X-Forwarded-Encrypted: i=1; AL+hErE941dSFll9lLe7vAs9kjUxiEgUwGKNq5bckRNLjOmdGtqMqRVtD+Pmnlrb/Lgj6puu8zUPufPVF1Q=@vger.kernel.org
X-Gm-Message-State: APuU4Z8r3xCkH1WFUUiuGLaMzOQQSczkYCto6zB1wY0PN7f7zOer1xn3
	bptwoVmOXm0T8MLs6QEfrs2d7j6sEU0uRcgnI72O3EmodBWnSKbQ0Ae1
X-Gm-Gg: AYBFou3zWOCFS5YFKCAH+KOb0hvq1gdLb2NvaOeR6BjGjpuAOo8mkrs2XtJ2N/w3jyO
	sPNJeaaHvUoZyIKiE3Z27q2ieKABBw0oiiIIN0Buf7/+zW6zmz2tuaXQWi7bSeQ1WnLMl217DPx
	FEAcpCrp8wdaxEVuk0Cjuw2IVlXtNefyhtCgY47hWD7KjtzXRZZQ5PzPQtbNkYd9+YbqzvRmNSa
	31fkkaCP4VJsUrnkdYRsnyfZBymcVmAmPdvMSs+JPWM7229ipnsro8SyAzsNlfX0m9GCoSxCaUh
	WLhqkGZRmUokZsjejkcLqS/S0PX7ad61SfYZyR02S9N74mUOQ9mBAdNKQuM30LVRWfT7yIaQHD1
	tka0kjAdoLB6rO2CJYY3Nqj1e1Y9KJuQb9Ow+yHCsUgJA5L3iI3FIdzcgJ+m4/apLTjdicdWoFu
	Up9FzwQUd/+nz3K12JhYMDP8abRxzsUpGjMn97j0MDHrOHwMuXj1xvWJ8wmCSOJZVGyjVFDtL53
	Fr3/onU2KLxmkeGe2n10qjaxQTZDyx5liMaoTqUjwA4JMWXafNCFPDfN30+XixrhF01wyYb7jev
	JPnPXroZm5lwtFawO9ClvLZhxg==
X-Received: by 2002:a5d:5f47:0:b0:492:820d:1e with SMTP id ffacd0b85a97d-4982fb52472mr1381001f8f.11.1794263697601;
        Mon, 09 Nov 2026 14:34:57 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4983600bc8fsm1303661f8f.30.2026.11.09.14.34.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 14:34:55 -0800 (PST)
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
 boundary=1bc85eaa38fb06f5cb938135d83b598e0e2ac0da5a561a69ab953af6626c;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Mon, 09 Nov 2026 23:34:49 +0100
Message-Id: <DMR1E7XB3AT6.3UI3YHHBI8O9Z@gmail.com>
Cc: "David Sterba" <dsterba@suse.com>, "Alexander Viro"
 <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>,
 "Namjae Jeon" <linkinjeon@kernel.org>, "Sungjong Seo"
 <sj1557.seo@samsung.com>, "Konstantin Komarov"
 <almaz.alexandrovich@paragon-software.com>, "Chris Mason"
 <mason@kernel.org>, "Jan Kara" <jack@suse.cz>, "Yuezhang Mo"
 <yuezhang.mo@sony.com>, "Chuck Lever" <cel@kernel.org>, "Darrick J . Wong"
 <djwong@kernel.org>, "Sean Smith" <defendthedisabled@gmail.com>, "Andrey
 Albershteyn" <aalbersh@kernel.org>, "Pedro Falcato" <pfalcato@suse.de>,
 =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
 <linux-btrfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <exfat@lists.linux.dev>,
 <ntfs3@lists.linux.dev>, <linux-api@vger.kernel.org>, "Theodore Tso"
 <tytso@mit.edu>
Subject: Re: [RFC PATCH v3 1/5] vfs: add provenance time (ptime)
From: "koraynilay" <koray.fra@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "koraynilay"
 <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261101015551.786044-1-koray.fra@gmail.com>
 <20261101015551.786044-2-koray.fra@gmail.com>
 <CAOQ4uxiuJ=eZu28FZAUz3rpqPKqCimPxJucOnYYuBowvD09_Cw@mail.gmail.com>
 <DMP3UBB0QVOT.20HIXK7ZL6K6U@gmail.com>
 <CAOQ4uxgSVc8n1LbL_dcU-DpNN5BB-ap_vGdXEu7+d0Td7PK5Tw@mail.gmail.com>
 <DMP582BGB7DV.2U0SJLJL7A87K@gmail.com>
 <CAOQ4uxj82K4z+2OiY5W1g7NyWAFOFjqqWnZSS3prytW36j1LgA@mail.gmail.com>
In-Reply-To: <CAOQ4uxj82K4z+2OiY5W1g7NyWAFOFjqqWnZSS3prytW36j1LgA@mail.gmail.com>

--1bc85eaa38fb06f5cb938135d83b598e0e2ac0da5a561a69ab953af6626c
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Mon Nov 9, 2026 at 3:35 PM CET, Amir Goldstein wrote:
> On Sat, Nov 7, 2026 at 6:09=E2=80=AFPM koraynilay <koray.fra@gmail.com> w=
rote:
>>
>> On Sat Nov 7, 2026 at 5:48 PM CET, Amir Goldstein wrote:
>> > On Sat, Nov 7, 2026 at 5:04=E2=80=AFPM koraynilay <koray.fra@gmail.com=
> wrote:
>> >>
>> >> On Mon Nov 2, 2026 at 3:00 PM CET, Amir Goldstein wrote:
>> >> > On Sun, Nov 1, 2026 at 2:57=E2=80=AFAM koraynilay <koray.fra@gmail.=
com> wrote:
>> >> >>
>> >> >> Add provenance time (ptime), indicating the time when a file or
>> >> >> directory was created. This is user-settable via file_setattr() an=
d
>> >> >> retrievable via statx(2) (using STATX_PTIME) or file_getattr().
>> >> >>
>> >> >> The semantics of when to preserve this new timestamp are the same =
as
>> >> >> mtime, the idea being that there is a correspondence like this:
>> >> >>
>> >> >> ctime <-> btime
>> >> >> mtime <-> ptime
>> >> >>
>> >> >> so every operation (copying, moving, ...) that currently preserves=
 mtime
>> >> >> should also preserve ptime.
>> >> >>
>> >> >> Furthermore, in order to avoid the legacy FS_IOC_FSSETXATTR accept=
ing
>> >> >> FS_XFLAG_PTIME, add an FS_FILE_ATTR_XFLAGS_MASK mask to support ne=
w
>> >> >> xflags, and use it in fileattr_to_file_attr()/file_attr_to_fileatt=
r() to
>> >> >> allow ptime to be used with the file_setattr()/file_getattr() sysc=
alls.
>> >> >>
>> >> >> [ This is a re-implementation of the initial patch[1] by Sean Smit=
h
>> >> >>   <defendthedisabled@gmail.com>, following the advice[2] from Darr=
ick J.
>> >> >>   Wong <djwong@kernel.org> of using file_setattr() instead of upda=
ting
>> >> >>   utimensat() ]
>> >> >>
>> >> >> [1]: https://lore.kernel.org/20260405195007.1306-2-DefendTheDisabl=
ed@gmail.com
>> >> >> [2]: https://lore.kernel.org/20260407014129.GC6192@frogsfrogsfrogs
>> >> >>
>> >> >> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.4.7
>> >> >> Signed-off-by: koraynilay <koray.fra@gmail.com>
>> >> >> ---
>> >> >>  fs/file_attr.c            | 33 +++++++++++++++++++++++++++++++--
>> >> >>  fs/stat.c                 |  2 ++
>> >> >>  include/linux/fileattr.h  |  5 +++++
>> >> >>  include/linux/stat.h      |  1 +
>> >> >>  include/uapi/linux/fs.h   |  8 +++++++-
>> >> >>  include/uapi/linux/stat.h |  7 ++++++-
>> >> >>  6 files changed, 52 insertions(+), 4 deletions(-)
>> >> >>
>> >> >> diff --git a/fs/file_attr.c b/fs/file_attr.c
>> >> >> index 833e03810b24..c0645cb22bf3 100644
>> >> >> --- a/fs/file_attr.c
>> >> >> +++ b/fs/file_attr.c
>> >> >> @@ -102,7 +102,7 @@ EXPORT_SYMBOL(vfs_fileattr_get);
>> >> >>  static void fileattr_to_file_attr(const struct file_kattr *fa,
>> >> >>                                   struct file_attr *fattr)
>> >> >>  {
>> >> >> -       __u32 mask =3D FS_XFLAGS_MASK;
>> >> >> +       __u32 mask =3D FS_FILE_ATTR_XFLAGS_MASK;
>> >> >>
>> >> >>         memset(fattr, 0, sizeof(struct file_attr));
>> >> >>         fattr->fa_xflags =3D fa->fsx_xflags & mask;
>> >> >> @@ -110,6 +110,8 @@ static void fileattr_to_file_attr(const struct=
 file_kattr *fa,
>> >> >>         fattr->fa_nextents =3D fa->fsx_nextents;
>> >> >>         fattr->fa_projid =3D fa->fsx_projid;
>> >> >>         fattr->fa_cowextsize =3D fa->fsx_cowextsize;
>> >> >> +       fattr->fa_ptime_sec =3D fa->fsx_ptime.tv_sec;
>> >> >> +       fattr->fa_ptime_nsec =3D fa->fsx_ptime.tv_nsec;
>> >> >>  }
>> >> >>
>> >> >>  /**
>> >> >> @@ -141,15 +143,20 @@ EXPORT_SYMBOL(copy_fsxattr_to_user);
>> >> >>  static int file_attr_to_fileattr(const struct file_attr *fattr,
>> >> >>                                  struct file_kattr *fa)
>> >> >>  {
>> >> >> -       __u64 mask =3D FS_XFLAGS_MASK;
>> >> >> +       __u64 mask =3D FS_FILE_ATTR_XFLAGS_MASK;
>> >> >
>> >> > That is not the correct way to extend this API.
>> >> > This fixed mask was added as a placeholder for
>> >> > "We intend to add support for more xflags to selective filesystems"=
:
>> >> > https://lore.kernel.org/linux-fsdevel/20250329143312.1350603-2-amir=
73il@gmail.com/
>> >> >
>> >> > Please see this POC patch for filesystems to publish their supporte=
d
>> >> > xflags mask:
>> >> > https://lore.kernel.org/linux-fsdevel/20250329143312.1350603-3-amir=
73il@gmail.com/
>> >>
>
> Re-reading and answering your original questions:
>
>> >> Quick question, should _mask also be used for user-space -> VFS to ad=
vertise
>> >> what it wants to change?
>
> Yes absolutely.
>
>> >> This would be useful for on/off flags,
>
> Exactly.
>
> All the Windows filesystems that want ptime, would most likely want the s=
upport
> on/off HIDDEN/SYSTEM/ARCHIVE flags as well.

(But these should be deferred to other patches/to the FSs themselves
right?)

>> >> but for ptime both fa->xflags and
>> >> fa->xflags_mask would have the same meaning of "I want to change ptim=
e,
>> >> look at fa->ptime".
>
> There needs to be no FS_XLAG_PTIME in fa->xflags,
> just as there is no FS_XFLAG_PROJID in fa->xflags today.
>
> However, since btrfs does not support setting projid, when we introduce
> fa->xflags_mask, it would be elegant IMO to introduce the (new) flag
> FS_XFLAG_PROJID which would be valid in fa->xflags_mask.
>
> To be clear, currently upstream chattr (e2fsprogs) can set projid via
> FS_IOC_FSSETXATTR ioctl (no xflags_mask) and upstream
> xfs_io -c chattr (xfsprogs) can set projid via  file_setattr() syscall
> (no xflags_mask).
>
> But if either utils were to be modified to support setting ptime, then it
> would need to use file_setattr() syscall and set both FS_XLAG_PTIME
> and FS_XFLAG_PROJID in  xflags_mask when it wants to set a non-zero
> value to those fields.
>
> Specifically, the invocation of chattr -p <projid>, will no longer need t=
o do
> FS_IOC_FSGETXATTR to read all the unrelated flags for setting the projid.

Ah yes, this would be a good change I think.

>> >> Should we make _mask the only way to advertise what the user wants to
>> >> change,
>
> Yes, unless _mask is zero, which then means set all the legacy values
> which are frozen in the constant FS_XFLAGS_MASK.
>
>> >> ignore xflags | PTIME in user-space -> VFS and use it only in FS
>> >> -> VFS -> user-space to say "this fs supports PTIME for this file"
>
> Close, but not exactly.
>
> For GET, semantics are clear and follow statx precedents:
> xflags_mask always means "supported" (like stx_attributes_mask).
>
> For boolean flags, xflags is the value
> For integer fields, an xflags bit means "value provided" (like stx_mask).
>
> For SET, when xflags_mask!=3D0, a flag of 1 means "I want to set this val=
ue".
>
> For boolean flags, if the flag's bit in xflags_mask is 0, the flag is
> left untouched
> (e.g. a chattr -p that only sets the project ID doesn't touch IMMUTABLE).
>
> For integer fields, the meaning of xflags_mask 1 and xflags 0 would be
> "I want to unset the value" which is not the same as "I want to set the v=
alue
> to 0", because as you wrote, 0 is a valid value for ptime.
>
> The question of whether a specific field can be unset or not is up for th=
e
> filesystem to decide, not the VFS.
>
> For example, XFS already unset the value of cowextsize when flag
> FS_XFLAG_COWEXTSIZE is 0, although the same could be done
> with a 0 value to fa_cowextsize.
>
> VFS does enforce that xflags & ~xflags_mask is EINVAL.
>
>> >> (which will be always once support is added to an FS, so it would jus=
t
>> >> be "this FS supports PTIME")?
>
> It does not have to be an FS-wide property. some fs could have ptime
> (or another attribute) support only on some files types.

Right.

>> >>
>> >
>> > Sorry I was not able to parse your question.
>> >
>> > I think the mask should mean "this FS supports PTIME"
>> > regardless if the user asked to get/set it or not.
>>
>> Yeah sorry, I'm just a bit confused because of all the similar names and
>> concepts.
>
> Me too... I needed to re-read all the threads from Feb 2025...

I also had to go back to those threads, since at least those have more
parsable function names ahah.

>>
>> (assuming btrfs supports ptime and ext4 doesn't)
>>
>> * filesystem -> VFS -> user-space, while in fileattr_to_file_attr():
>>
>>   for btrfs, for all files[1]:
>>         fa->fa_xflags & FS_XFLAG_PTIME =3D=3D 1
>>         fa->fa_xflags_mask & FS_XFLAG_PTIME =3D=3D 1
>
> Yes.
>
>>
>>   for ext4, for all files:
>>         fa->fa_xflags & FS_XFLAG_PTIME =3D=3D 0
>>         fa->fa_xflags_mask & FS_XFLAG_PTIME =3D=3D 0
>
> Yes.
>
>>
>> * user-space -> VFS -> filesystem, while in file_attr_to_fileattr():
>>
>>         fattr->fa_xflags & FS_XFLAG_PTIME =3D=3D ignored
>
> This is debatable. IMO it should be 1 for value, 0 to unset existing valu=
e,
> similar to removexattr() if you want to look at it this way.

So in the case of ptime, fattr->fa_xflags & FS_XFLAG_PTIME should be
ignored, while for fattr->fa_xflags & FS_XFLAG_SOME_NEW_THING it will
need to be handled as

=3D=3D 1: set it taking the value from ->some_new_thing
=3D=3D 0: unset the value

>>         fattr->fa_xflags_mask & FS_XFLAG_PTIME =3D=3D 1 if user wants to=
 set it, otherwise 0
>
> Yes. but now the user has to set any legacy field it wants to set in
> fa_xflags_mask as well, because fa_xflags_mask is no longer zero.
> so we need to introduce flag constants for legacy fields that do not
> have xflags. I think that is only FS_XFLAG_PROJID.

Should this be a patch in this series, or a separate patch sent after?

>>
>> Would this be correct?
>>
>> Or would it be better to set FS_XFLAG_PTIME only in fa_xflags_mask, and
>> never touch fa_xflags with it, which would make the above become:
>>
>>
>> * filesystem -> VFS -> user-space, while in fileattr_to_file_attr():
>>
>>   for btrfs, for all files[1]:
>>         fa->fa_xflags_mask & FS_XFLAG_PTIME =3D=3D 1
>>
>>   for ext4, for all files:
>>         fa->fa_xflags_mask & FS_XFLAG_PTIME =3D=3D 0
>>
>>   (and always fa->fa_xflags & FS_XFLAG_PTIME =3D=3D 0)
>>
>> * user-space -> VFS -> filesystem, while in file_attr_to_fileattr():
>>
>>         (fattr->fa_xflags & FS_XFLAG_PTIME =3D=3D ignored)
>>         fattr->fa_xflags_mask & FS_XFLAG_PTIME =3D=3D 1 if user wants to=
 set it, otherwise 0
>>
>
> I prefer the former.
>
>> This would mean that fa_xflags_mask is used like stx_mask both by the fs
>> (to let the user know what it supports (a.k.a. what it's returning)) and
>> by the user (to let the fs know what it's trying to set),
>
> This is actually like stx_attributes_mask not stx_mask.

Ah ok.

>> and fa_xflags
>> is used only for ON/OFF flags (like immutable).
>
> Yes, on/off for flag values (like stx_attributes), but "value exists"
> for field values (like stx_mask).
>
>>
>> Let me know if it's clearer.
>>
>
> Same.

Yes, I think I get it know.

So, just to recap:

fa->xflags_mask =3D=3D 0 -> legacy behaviour before this series


fa->xflags_mask & FS_XFLAG_ABCD =3D=3D 1 -> "user wants to set/change abcd"
fa->xflags & FS_XFLAG_ABCD =3D=3D 1 -> "user wants kernel to take the value=
 from fa->abcd"
fa->xflags & FS_XFLAG_ABCD =3D=3D 0 -> "user wants kernel to unset abcd"

fa->xflags_mask & FS_XFLAG_ABCD =3D=3D 0 -> "don't touch abcd"


and in the case of ptime this means:


fa->xflags_mask & FS_XFLAG_PTIME =3D=3D 1 -> "user wants to set/change ptim=
e"
fa->xflags & FS_XFLAG_PTIME =3D=3D 0/1 -> "user wants kernel to take the va=
lue from fa->ptime" [1]

fa->xflags_mask & FS_XFLAG_PTIME =3D=3D 0 -> "don't touch ptime"


Correct?

Thanks,
koraynilay

[1]: so basically ignored, it doesn't matter if the user sets xflags | PTIM=
E
or not, but still recommended in documentation. Tho thinking more about
it, maybe it would be better to enforce it at the fs level with
-EOPNOTSUPP.


> Thanks,
> Amir.



--1bc85eaa38fb06f5cb938135d83b598e0e2ac0da5a561a69ab953af6626c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCavJKiQAKCRDmj22qf5IG
XFmvAQDJ5TYpkt4k3iU8vjC1XnupiucikMkdH55K6cVJ1gKQdwD/TAa5kJJuINtl
uD988n6vHMlyrWBlrjXaxWFBiVegWQQ=
=5ztk
-----END PGP SIGNATURE-----

--1bc85eaa38fb06f5cb938135d83b598e0e2ac0da5a561a69ab953af6626c--
