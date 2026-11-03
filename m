Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713053;
	b=GD3nDZf4N0xb+gEuF+cl8ZRoMbaIxef+nfYm/SSRRn+n6kY3cKa1mdtRpim/SlQEABii
	 Pbj4HhgRJRzZBY5uLNx3zSheEET988E6vP5177bLz+7wgR3PLA57dC5u4X3VWztIsVl21
	 Br0yfcQgLNEYcz/LifKsH8w2TMt14aB121PdwIbQ23Sx8xvwykXdfOKYqjd8L1DA3jozt
	 oJuBdcL44kIrvw1GTigL/UsPDlll5qOCW0zilgo3NllP+l0H6Ice03QMHn9++B+4/BwF1
	 VB3ooFPQhWjEX+uCoHMkXee/4+JPM/zf03K616R4FCXVkjfpFSoCA4UWf1IlWO9xqDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713053;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=z8I4fwdpHZEHxjsoI7j2kaC5QiNqCfLlTB8//I16Q20=;
	b=dnNUWsXZdb9iXrDXlUdEPQpZkJKQxovG/axGlpPIs8gZCJxxalYsLGAqfulYI998LYbN
	 2pAT3Bhm9YpBixTutfXjryapnzylNQk/b/qBXk/qYU+l7y5rHk4PEw+WAQZg3IwUtZpi4
	 q6T+d9Aokn/KMqAdj62RtCoQeWUgDGtfiU0q4mCcSEy5sHTQqrCkpf9/GJQlQLB5RCCTJ
	 AbcqTkUgPT+Q/KRIpR4VlpBs6o7sFV7kUsBMQoa7mgZgXq24m1NGIni0JJ9OuvF4SU9XA
	 +9aglQKknqRXLnNQyrlwvlFG+c8Na7bONu+2ab/Ypj+x+q9DAs8BrT3HinoJHq8qZhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZuOeHSCa;
	arc=none smtp.remote-ip=209.85.218.48
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8822C606A331
	for <linux-api@vger.kernel.org>; Tue,  3 Nov 2026 13:37:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8822C606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZuOeHSCa
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c46bd7a7345so143549466b.0
        for <linux-api@vger.kernel.org>; Tue, 03 Nov 2026 05:37:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793713051; x=1794317851; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=z8I4fwdpHZEHxjsoI7j2kaC5QiNqCfLlTB8//I16Q20=;
        b=ZuOeHSCalGGW/kf+LdsGX3X/V+G76kaicuZZtepch9j2N9yf3BoqQuUO7uIAjscwar
         fNR823LiPdamg1xyvEX05Xbdx/+mykhO0rtfldD9xtRNHGMkuQYKxl/m1oGmUZYFTMAl
         FSUFJhDLPsvIEaJfrDyrjpF76kQoK8TqJR0kU2+U79yvV92155XDJKPgv9gxgaydqkWy
         ATTkxhXKOM0DsIgIeFsGBL8CWIckSL3Fd6EfB5QFpi9KwFU8HkeexHFzOhzajM7L5ZoS
         8cigLmr81NyK7nZ6bVnrqCeDoTadNnThZQGJdqP5MxBn7Ju0kpOzVynprDWNxViacffI
         6KqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793713051; x=1794317851;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=z8I4fwdpHZEHxjsoI7j2kaC5QiNqCfLlTB8//I16Q20=;
        b=P/WbbvLijFupH2j5m+drSohl4gSKGaD8knXjFuuX13LzCV0Chw0Btp8raYoJ/55H2h
         crJ2k4R256kZkjZ1Hg24btzNnZmqlYiwlbvgUKHr3PABRmR/OLojTtUTF4Vk9gbOveA+
         us3JK97gAqL6jgj5TKqXr/Fazk5W7qlC+B3HTkJZ7UvDRjwZ/uar3wj7DEKfrAjMriS1
         XIEgB0BNmMfiGpkiRqJ58pWSh8v85SDfcMtqSadQAVuFdEHNJ8zJMgFx+nAR0gyfeJ/v
         /7DBELuwZ+fjJZEJ9wOsBsaxmnUlg1LNqpTEH6iklwq6JmYPwnRlhx6gLSsedW6P9HqR
         Zt8Q==
X-Forwarded-Encrypted: i=1; AKwUvBze3/SUCKLMN/1Q/gdVAML7B9M7PkARiozhTuF0u8AVOk9+z6qY6W7yEK2Wj1wt7CW3tEp3IL5KGD4=@vger.kernel.org
X-Gm-Message-State: APuU4Z8aKe9U8B5i/DiYGqeDYoqjmK/tY73TvG9eCqhykiCcdZrovbPx
	hNoHiwRDwpZe5hKwc456QGD6rW5DukIVsun5oqPF4BslbCctD/sbyudS
X-Gm-Gg: AYBFou02awSultI7lWWZSKBzTsewIxaEZkCg42WKD+wL8Im79onz8iISs4Fq1SWSVBf
	RHuX74/zcbOa6dcPQHQ9ZzABNuKb+EkbEfbzCN+7EeBRq0X5A5VBN3h7dhzlpeKKy6F8TGD61b2
	fDTEEtc0uGBLfaTmHuVavpG7pueV5/aSxNtlPq8k6EKWBffj0lbynMpJEtfWgE7QKtarLEpcv6T
	GmcX4+J3rWI05Cq6FMpcrlCRCFrxhiu5nQ4eJM+g9n/AxaVCGd/Qm192/VJfxrsMLvZjWKutSNb
	UV5qo2WsbD2XeCLBrJtuWsHluDWPNYJhGrgXaBZeBq+zZ1LpjGXGLUo0ybxsDoaH18WFQ+25Srx
	O7lMeXz/GXOKyqyeoI3JBlgQUtGz4Bcd47ZtrrdB3WDLEzmqS0yjsASAep8Xm9s9weEXewutgEk
	ana65Ekh12H7zso4Ha2zuTOLNg5obYa/97mdWk3EDldHpLUcJzt+xCf37G7IuXvKH1VuI05G00L
	Ml6tmlxmfWBk1ZDGlvFLNjDEXJdAb7R8nAr1pPQsWq1dY5c7hd+dg6rWgNEeEKfIgU2HQT/SFdM
	jAmQftOvq4rh7fO/AQ7ZeqXiV4FWgQVBT0Kxk73GNCccaOHn
X-Received: by 2002:a17:906:7093:b0:c4c:b683:363a with SMTP id a640c23a62f3a-c4cb6833696mr550318166b.20.1793713050430;
        Tue, 03 Nov 2026 05:37:30 -0800 (PST)
Received: from localhost ([130.192.98.149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71a4d3e9sm28064453f8f.6.2026.11.03.05.37.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 05:37:29 -0800 (PST)
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
 boundary=b8a5d7c24979484bc010700948d777a4b3d3da4f8cc6b6d0af825f593776;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Tue, 03 Nov 2026 14:37:18 +0100
Message-Id: <DMLM7E5X17UG.AOHJCH4UYMLZ@gmail.com>
Cc: "Amir Goldstein" <amir73il@gmail.com>, "Andreas Dilger"
 <adilger@dilger.ca>, "David Sterba" <dsterba@suse.com>, "Alexander Viro"
 <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>,
 "Namjae Jeon" <linkinjeon@kernel.org>, "Sungjong Seo"
 <sj1557.seo@samsung.com>, "Konstantin Komarov"
 <almaz.alexandrovich@paragon-software.com>, "Chris Mason"
 <mason@kernel.org>, "Jan Kara" <jack@suse.cz>, "Yuezhang Mo"
 <yuezhang.mo@sony.com>, "Chuck Lever" <cel@kernel.org>, "Darrick J . Wong"
 <djwong@kernel.org>, "Sean Smith" <defendthedisabled@gmail.com>, "Andrey
 Albershteyn" <aalbersh@kernel.org>, "Pedro Falcato" <pfalcato@suse.de>,
 <linux-btrfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <exfat@lists.linux.dev>,
 <ntfs3@lists.linux.dev>, <linux-api@vger.kernel.org>
Subject: Re: [RFC PATCH v3 3/5] ntfs3: make crtime user-settable using ptime
From: "koraynilay" <koray.fra@gmail.com>
To: =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>, "koraynilay"
 <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261101015551.786044-4-koray.fra@gmail.com>
 <20261102142452.d6jkitgdeuquy23i@pali>
 <CAOQ4uxhQ3uhq6s+4deEJAQV5iy8QZoucojR58_dUNYrnjt_yvA@mail.gmail.com>
 <20261102153845.d67wlorqcbe3c2w7@pali>
 <DD1A08F1-8F47-4612-A807-AEA39461AF9B@dilger.ca>
 <CAOQ4uxh8EDX5HzFFKWv10-mHYVcSC1zXN+BS2qCm5cTMq=GOCA@mail.gmail.com>
 <20261103094906.n55n5dhrpct5ykmw@pali>
 <DMLIYIKP2CN8.3VGUCOLTMZC5J@gmail.com>
 <20261103113835.7kndzvvegrkwjlsd@pali>
 <DMLKDOZWVDTU.GLUJUDOZES2V@gmail.com>
 <20261103124816.m27zk5c75lzee272@pali>
In-Reply-To: <20261103124816.m27zk5c75lzee272@pali>

--b8a5d7c24979484bc010700948d777a4b3d3da4f8cc6b6d0af825f593776
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Tue Nov 3, 2026 at 1:48 PM CET, Pali Roh=C3=A1r wrote:
> On Tuesday 03 November 2026 13:11:30 koraynilay wrote:
>> On Tue Nov 3, 2026 at 12:38 PM CET, Pali Roh=C3=A1r wrote:
>> > On Tuesday 03 November 2026 12:04:39 koraynilay wrote:
>> >> Hi and sorry for the late reply,
>> >>=20
>> >> On Tue Nov 3, 2026 at 10:49 AM CET, Pali Roh=C3=A1r wrote:
>> >> > On Tuesday 03 November 2026 09:23:32 Amir Goldstein wrote:
>> >> >> On Tue, Nov 3, 2026 at 2:19=E2=80=AFAM Andreas Dilger <adilger@dil=
ger.ca> wrote:
>> >> >> >
>> >> >> > On Nov 2, 2026, at 09:38, Pali Roh=C3=A1r <pali@kernel.org> wrot=
e:
>> >> >> > >
>> >> >> > > On Monday 02 November 2026 16:09:41 Amir Goldstein wrote:
>> >> >> > >> On Mon, Nov 2, 2026 at 3:24=E2=80=AFPM Pali Roh=C3=A1r <pali@=
kernel.org> wrote:
>> >> >> > >>>
>> >> >> > >>> On Sunday 01 November 2026 02:55:49 koraynilay wrote:
>> >> >> > >>>> @@ -154,6 +158,11 @@ int ntfs_fileattr_set(const struct mnt=
_idmap *idmap, struct dentry *dentry,
>> >> >> > >>>>      if (flags & FS_APPEND_FL)
>> >> >> > >>>>              new_fl |=3D S_APPEND;
>> >> >> > >>>>
>> >> >> > >>>> +     if (fa->fsx_xflags & FS_XFLAG_PTIME) {
>> >> >> > >>>> +             ni->i_crtime.tv_sec =3D fa->fsx_ptime.tv_sec;
>> >> >> > >>>> +             ni->i_crtime.tv_nsec =3D fa->fsx_ptime.tv_nse=
c;
>> >> >> > >>>> +     }
>> >> >> > >>>> +
>> >> >> > >>>>      inode_set_flags(inode, new_fl, S_IMMUTABLE | S_APPEND)=
;
>> >> >> > >>>>
>> >> >> > >>>>      /* Save nodump flag to return in ntfs_getattr. */
>> >> >> > >>>> @@ -275,8 +284,9 @@ int ntfs_getattr(const struct mnt_idmap=
 *idmap, const struct path *path,
>> >> >> > >>>>      if (unlikely(is_bad_ni(ni)))
>> >> >> > >>>>              return -EINVAL;
>> >> >> > >>>>
>> >> >> > >>>> -     stat->result_mask |=3D STATX_BTIME;
>> >> >> > >>>> +     stat->result_mask |=3D (STATX_BTIME | STATX_PTIME);
>> >> >> > >>>>      stat->btime =3D ni->i_crtime;
>> >> >> > >>>> +     stat->ptime =3D ni->i_crtime;
>> >> >> > >>>
>> >> >> > >>> For me this patch looks dangerous. Somehow I would expect th=
at the
>> >> >> > >>> "btime" will never change for existing inode.
>> >> >> > >>>
>> >> >> > >>> But because the ptime is mapped to i_crtime and ptime is set=
table from
>> >> >> > >>> userspace, with this patch it is directly possible to change=
 btime.
>> >> >> > >>>
>> >> >> > >>>
>> >> >> > >>>
>> >> >> > >>> I was thinking more about it... Is not this just misundersta=
nding of how
>> >> >> > >>> the security model around the times is working on different =
systems?
>> >> >> > >>> Because on NTFS there is stored just one field which says wh=
en the file
>> >> >> > >>> was created. There are not two fields like "time set by user=
 and time
>> >> >> > >>> set by system".
>> >> >> > >>>
>> >> >> > >>> Windows security model allows anybody with WRITE_ATTRIBUTES =
access to
>> >> >> > >>> change that create time. Linux security model does not allow=
 to change it.
>> >> >> > >>>
>> >> >> > >>> NTFS in this view is just a filesystem like any other (ext4,=
 btrfs, ...).
>> >> >> > >>> In my opinion if the ext4 or btrfs filesystem is correctly i=
mplemented
>> >> >> > >>> on Windows systems, then Windows security model should handl=
e it in the
>> >> >> > >>> same way like for NTFS or exFAT. So if something grants WRIT=
E_ATTRIBUTES
>> >> >> > >>> access, then Windows should allow to change also btime on ex=
t4 or btrfs.
>> >> >> > >>>
>> >> >> > >>>
>> >> >> > >>>
>> >> >> > >>> On the other hand, I understand the use case to have two cre=
ation times.
>> >> >> > >>> One time which would never be changed and could be used for =
any kind of
>> >> >> > >>> atomic / synchronization by userspace application logic (thi=
s btime).
>> >> >> > >>> And another time for human which can be changed at any time =
to any value
>> >> >> > >>> which user wants (this ptime).
>> >> >> > >>>
>> >> >> > >>> In any case, I would suggest that filesystem driver would no=
t report to
>> >> >> > >>> userspace unsupported values and would not try to invent oth=
er values
>> >> >> > >>> and lying about them.
>> >> >> > >>
>> >> >> > >> But all those fs with mutable creation time already report it=
 with STATX_BTIME
>> >> >> > >> so what can we do about this?
>> >> >> > >
>> >> >> > > Well, what I wanted above to point out is that the "mutability=
" of
>> >> >> > > creation time is not feature of filesystem, but in my opinion =
rather
>> >> >> > > property of the security model on the running operating system=
.
>> >> >> > >
>> >> >> > > Maybe better question is: how ext4 btimes differs from the ntf=
s btime?
>> >> >> > > In my opinion there is no much difference, both of them has me=
aning
>> >> >> > > "time when was the file created".
>> >> >> > >
>> >> >> > >> If userspace requests both STATX_BTIME|STATX_PTIME in mask ar=
g,
>> >> >> > >> those fs could technically return only STATX_PTIME and it sho=
uld not regress
>> >> >> > >> existing programs.
>> >> >> > >>
>> >> >> > >> But this is still a bit surprising behavior is it not?
>> >> >> > >>
>> >> >> > >> Thanks,
>> >> >> > >> Amir.
>> >> >> > >
>> >> >> > > I'm not sure what to do with it.
>> >> >> > >
>> >> >> > > If we allow to change btime of ntfs then for consistency we sh=
ould also
>> >> >> > > allow to change btime of ext4.
>> >> >> > >
>> >> >> > > Maybe another idea... define new capability which would allow =
to change
>> >> >> > > btime (on any filesystem)? This would at least make the consis=
tency.
>> >> >>=20
>> >> >> Pali, I think this is a very bad idea.
>> >> >
>> >> > Ok, if the point is that ext4 btime must stay immutable then it is =
a bad idea.
>> >> >
>> >> >> This has nothing to do with capabilities.
>> >> >> The Windows and MacOS filesystems have allowed setting their
>> >> >> "creation time" forever
>> >> >
>> >> > FreeBSD for some fs allow it too (see below).
>> >> >
>> >> >> and for all the other Linux filesystems that had
>> >> >> "birth time" it was immutable, so let's not mix filesystem feature=
s
>> >> >> with capabilities.
>> >> >
>> >> > I think that it is important to first define behavior and invariant=
s of
>> >> > these "btime" and "ptime" kernel properties.
>> >> >
>> >> > If we want to be consistent then there are two possible options:
>> >> >
>> >> > 1. If we choose that the STATX_BTIME is immutable then no kernel fs
>> >> >    driver should allow to change.
>> >> >
>> >> > 2. If we choose that the "NTFS create time" is reported via STATX_B=
TIME
>> >> >    then STATX_BTIME is not immutable at all.
>> >> >
>> >> > These two options cannot be chosen together because option 1 would
>> >> > implie that the modifiable "NTFS create time" cannot be reported ov=
er
>> >> > STATX_BTIME.
>> >> >
>> >> > We are have currently STATX_BTIME immutable and "NTFS create time"
>> >> > reported via STATX_BTIME.
>> >> >
>> >> > If we want to stay _consistent_ across fs drivers then adding API f=
or
>> >> > changing "NTFS create time" would break one of those two things.
>> >> >
>> >> > In my opinion we should stay consistent across filesystem drivers a=
nd
>> >> > provide unified behavior of APIs independently of used filesystem.
>> >> > Otherwise userspace applications would have to write fs specific co=
de
>> >> > for doing their use cases (and we can stay with fs-specific xattrs,=
 no
>> >> > need to create unified APIs).
>> >> >
>> >> > Does it make sense? Or it is still a bad idea to think about it in =
this way?
>> >>=20
>> >> Personally I think in this discussion we should separate linux
>> >> filesystems vs non-linux filesystems, as linux filesystems are "ours"
>> >> and are the ones we can change as we want, while non-linux filesystem=
s
>> >> are not made by "us" and cannot be easily changed (like NFS I would s=
ay)
>> >> or cannot changed at all (e.g. NTFS (well, unless we make ntfs
>> >> incompatible with windows lol)).
>> >>=20
>> >> But I understand why it would be better to keep a unified API across =
all
>> >> filesystems, even "non-official" ones, so I can think of 2 options
>> >> (well, with ntfs/exfat in mind, as I don't know much about NFS/smb):
>> >
>> > SMB for timestamps has exactly same meaning and storage format as NTFS=
.
>> > So it should be pretty straightforward what to do with it.
>> > NFS3 does not have btime at all. And NFS4 has FATTR4_TIME_CREATE attr
>> > which I described in previous email (there is no more info). So based =
on
>> > the decision of 1 or 2, that NFS4 attr would either map to btime or pt=
ime.
>>=20
>> Ah ok, thanks.
>>=20
>> >>=20
>> >> 1) keep btime aliased to ptime, which means that (to userspace) btime
>> >>    would be mutable for ntfs/exfat/vfat/etc
>> >>=20
>> >> 2) move ntfs/exfat/vfat/etc's cr_time from btime to ptime, effectivel=
y
>> >>    "removing" btime from those FSs and "keeping" only ptime; in this =
case
>> >>    stat would show "-" for Birth:, but would show the correct timesta=
mp for
>> >>    Origin:/Create:/Provenance:/...
>> >>=20
>> >> I prefer 1) because it probably breaks less scripts, but 2) would be
>> >> more correct semantically.
>> >
>> > My personal opinion is 2) because the btime stay immutable also in
>> > userspace and is also more correct semantically.
>> >
>> > Another argument why 2) should be less breaking change: Userspace
>> > applications have to already expect that the btime is not filled at al=
l
>> > (e.g. when filesystem does not support it or when application is runni=
ng
>> > on older kernel version without such support).
>>=20
>> Right, I didn't think of that.
>>=20
>> > My opinion is that if the _new_ API provides two different timestamps
>> > based on the filesystem then we should report it as is, so userspace c=
an
>> > decide how to want to process them. For example full 1:1 clone backup
>> > application would want to preserve both btime and ptime and correctly
>> > indicate if one of them is not available (e.g. because underlying fs
>> > support only one of those times, like NTFS). And such full 1:1 clone
>> > backup application do not want to "invent" some unavailable values.
>> > Option 1) would not allow to do that for such applications.
>>=20
>> Ok yes I agree, I'll update the ntfs/exfat patches to switch btime for
>> ptime then.
>
> Well, what I wrote is my personal opinion, not the decision from this lis=
t.

Right, I don't have a strong personal preference either way, so I'll
wait for more feedback (so there's also less diff between v3 and v4).

>> >> And both break at least 1 existing script anyway (as per https://xkcd=
.com/1172/).
>> >
>> > Yes. And that is because we want a new feature which allows changing
>> > something which was immutable. So we need to handle it somehow.
>> >
>> >> >> >
>> >> >> > I think the ext4 and xfs maintainers have repeatedly said that b=
time/crtime
>> >> >> > attribute should not be modified by users.  There was a long dis=
cussion on
>> >> >> > this from Ted as well, and the reality is that "creation" time i=
s not worth
>> >> >> > the bits that it is written on,
>> >> >>=20
>> >> >> This is an opinion of individual people, who did not lay out techn=
ical
>> >> >> arguments.
>> >> >> I have concrete technical arguments in favor of first class creati=
on time for
>> >> >> ext4/xfs from my experience with production systems that need it a=
nd use xattr
>> >> >> to store it (by smbd), but I am not going to list them here becaus=
e
>> >> >> this is not a
>> >> >> thread about implementing mutable creation time for ext4/xfs.
>> >>=20
>> >> For my (backups, preservation) use case, making btime mutable would a=
lso
>> >> be fine, but I can see the value of having a "ctime" for creation, he=
nce
>> >> this RFC.
>> >>=20
>> >> >>=20
>> >> >> > since it is not preserved by any tools, has
>> >> >>=20
>> >> >> Facts check:
>> >> >>=20
>> >> >> # NEWS for rsync 3.2.3 (6 Aug 2020)
>> >> >>=20
>> >> >> ## Changes in this version:
>> >> >> ...
>> >> >>  - Added [`--crtimes`](rsync.1#opt) (`-N`) option for preserving t=
he file's
>> >> >>    create time (I believe that this is macOS only at the moment).
>> >> >>=20
>> >> >> Incidentally, I have an implementation for --crtimes for cifs [1],=
 but this
>> >> >> is not extendable to support all the filsystems which support sett=
able crtime.
>> >> >
>> >> > Another two facts check:
>> >> >
>> >> > FreeBSD has also API for changing "birth (creation) times".
>> >> > It is documented in utimes(2) manpage:
>> >> > https://man.freebsd.org/cgi/man.cgi?query=3Dutimes&sektion=3D2
>> >> >
>> >> > So I guess that there has to be some tool which is using this API a=
nd
>> >> > therefore these "birth (creation) times" are preserved.
>> >> >
>> >> >
>> >> > NFS4 has time_create attribute (FATTR4_TIME_CREATE=3D50) which is
>> >> > per-fs-object read-write attribute and defined (in RFC8881 5.8.2.40=
.) as:
>> >> >   The time of creation of the object. This attribute does not have =
any
>> >> >   relation to the traditional UNIX file attribute "ctime" or "chang=
e time".
>> >> > Since NFSv4.1 it can be even specified during creating a new file/d=
ir
>> >> > which seems to be for backup-restore. And permissions (RFC8881 6.2.=
1.3.1.):
>> >> >   ACE4_WRITE_ATTRIBUTES
>> >> >   Operation(s) affected: SETATTR of time_access_set, time_backup,
>> >> >     time_create, time_modify_set, mimetype, hidden, system
>> >> >   Discussion: Permission to change the times associated with a file=
 or
>> >> >     directory to an arbitrary value. Also permission to change the
>> >> >     mimetype, hidden, and system attributes. A user having ACE4_WRI=
TE_DATA
>> >> >     or ACE4_WRITE_ATTRIBUTES will be allowed to set the times assoc=
iated
>> >> >     with a file to the current server time.
>> >> >
>> >> > I'm not sure if there is some backup/restore tool which do it over =
NFS4
>> >> > but the NFS4 description seems to be very clear that the network pr=
otocol
>> >> > itself is already prepared for these use cases. And permissions mos=
tly
>> >> > matches the SMB / NTFS / Windows security model.
>> >> >
>> >> >> > a "vague" meaning (is it when the *file* was created, when the *=
content* was
>> >> >> > created, do edits update it, is it preserved across filesystems,=
 archives,
>> >> >> > etc.) and adding it into the filesystem is misplaced effort.
>> >> >>=20
>> >> >> Sorry now you are talking nonsense. Meaning has nothing to do with=
 it.
>> >> >> This is a property of filesystems (plural) which have documented A=
PIs
>> >> >> and documented network protocols - it is what it is.
>> >> >>=20
>> >> >> If you are looking for a meaning, it is the first publication date=
, whether
>> >> >> it means something to you is irrelevant - what's relevant is that =
customers
>> >> >> use it and want to preserve it in backups, whatever its meaning is=
.
>> >> >
>> >> > I agree here. I also heard lot of times that users (customers) want=
 to
>> >> > preserve create time in backups and be able to restore it. And that
>> >> > Windows is already able to do it, Linux not yet.
>> >>=20
>> >> Hi I'm one of those users, I still can't believe no-one has implement=
ed
>> >> something like this yet since POSIX came out way back when (*cry*).
>> >>=20
>> >> > Maybe what is a "vague" here is where that "create time" is stored =
and
>> >> > from which (API) source is GUI (or CLI) application showing it to u=
ser.
>> >> >
>> >> >> >
>> >> >> > Storing it as an xattr has some reasonable chance of being prese=
rved across
>> >> >> > tar/cp/filesystems, and doesn't introduce a herculean effort of =
changing
>> >> >> > all of the system calls and on-disk formats for every filesystem=
.
>> >> >> >
>> >> >
>> >> > I think the part "being preserved across tar/cp/filesystems" is
>> >> > relevant. If a completely new API is introduced into Linux then it =
means
>> >> > that every existing backup tool would not be able to preserve this
>> >> > property and also would not be able to restore it.
>> >> >
>> >> > I'm not sure if we can do anything with this issue, but it is impor=
tant
>> >> > to know about this limitation.
>> >>=20
>> >> My thinking for this RFC would be to then submit relevant patches als=
o
>> >> to at least the main tools I use like tar, cp, rsync and vim, which w=
ill
>> >> hopefully make it gain momentum and be supported also in other less
>> >> well-known tools (I would also love for it to be supported by HTTP li=
ke
>> >> mtime is, but that will likely be a lot more difficult to get accepte=
d
>> >> and implemented).
>> >
>> > If having two btime and ptime fields would be the direction then we ca=
n
>> > propose an extension for NFS4 protocol with a new attribute (as NFS4 h=
as
>> > currently only one). There are already some NFS4 extensions which come=
s
>> > from Linux or was inspired, e.g. umask or xattr support.
>>=20
>> Yes that would be nice, so when making the patch for nfs (in v4 or v5),
>> should I treat FATTR4_TIME_CREATE as ptime and maybe try to add the
>> needed code for a new btime?
>
> That is good question and I do not have any definite answer how should
> Linux handle it.
>
> The reason is very simple. If you look at the FATTR4_TIME_CREATE in
> specification (basically I have copied everything about it in previous
> emails) it is short and does not say which one it should be.
>
> I was implementing commercial NFS+SMB server with a hard requirement on
> compliance with both protocols at the same time and also interop between
> them. So from this my perspective by reading NFS4 spec with knowledge of
> how SMB server should behave and how are designed Windows/SMB attributes
> and permissions into NFS4, if I was asked to which of "ptime" or "btime"
> I should map the FATTR4_TIME_CREATE then I would say it is "ptime".
> Reasons: all those time attributes are R/W (like in SMB/Windows),
> all of them require WRITE_ATTRIBUTES acl permission (like in SMB/Windows)
> and we somehow agreed that Windows "create time" matches the "ptime",
> and also because the request from from SMB to change create time would
> not result in changing the linux "immutable btime". Basically in that
> NFS4 spec I see a connection between FATTR4_TIME_CREATE and SMB create ti=
me.
>
> But please this my analysis not from the Linux perspective, but rather
> from the FS server perspective with respect to the NFS4 and SMB protocols=
.
> I'm just giving inputs here.

I also agree that FATTR4_TIME_CREATE should map to ptime, mainly because
in the spec you posted it says it's user-settable with the right
permissions, while btime wouldn't be (and semantically it wouldn't make
sense to be able to, considering btime means "inode creation time").

Best,
koraynilay

>> Thanks,
>> koraynilay
>>=20
>> >> > About the part "introduce a herculean effort of changing all of the
>> >> > system calls and on-disk formats for every filesystem.". In my opin=
ion
>> >> > it is better to do that cleanup (maybe even in all stat-related
>> >> > syscalls) if it makes things easier and prevents another technical
>> >> > issues.
>> >> >
>> >> >>=20
>> >> >> As I said I can provide data for why the xattr approach taken by s=
mbd is
>> >> >> limited and inferior, but this is not the place to get into it (th=
ere are hints
>> >> >> in the rsync commit message below).
>> >> >>=20
>> >> >> Thanks,
>> >> >> Amir.
>> >> >>=20
>> >> >> [1] https://github.com/amir73il/rsync/commits/cifs-crtimes/
>> >> >
>> >> > I would say that xattr does not solve this issue too.
>> >>=20
>> >> I would also like to note again that xattrs aren't available to symli=
nks
>> >> (or other special files), which would break at least my backup/preser=
vation
>> >> use case.
>> >>=20
>> >> Best,
>> >> koraynilay



--b8a5d7c24979484bc010700948d777a4b3d3da4f8cc6b6d0af825f593776
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRJ2XvJtXGwULYEerQ0bnTtJTDoOAUCaunjjgAKCRA0bnTtJTDo
OBCMAQDUp2CJtyRW7WbFqkhgGVQxt6/K0KLBxryACyOPZaLaXwEA3qYj7EV55tWu
W7Yc1QH/pjeFNiRY0kJ/xtLxJAL6TA4=
=Szox
-----END PGP SIGNATURE-----

--b8a5d7c24979484bc010700948d777a4b3d3da4f8cc6b6d0af825f593776--
