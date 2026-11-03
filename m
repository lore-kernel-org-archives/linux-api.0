Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793718638;
	b=ma6HSBhg61we32C1/aU+K9Zngt+QGktu1P9/+SKDRtdm/cnouBUY+2/g4o1Zs9qLpuGi
	 rZ+NiGUoG11CzaHCOXGCO3P1hDXe79UA7wxgh/YIRupbXu2UnpOlhlgSk2B6qZtJ1CWwJ
	 /AcJowjy6UbI6XYbnEGhpoLY4SuhYCXcUENL/KWNjmxwKNk/hp10tXMFYElMmRSAHXKqg
	 /1FXxFG156TNCOSr2zOMuTwGjtBNDOnRUJK8YA8T89if+2iydwcSB7YxoZW92My93n93N
	 vKtk07AXV22af3YvaoZlxA5pvtS38OvUqH3c597GNaZZZXVjLnfACD/08pooBq+xLTg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793718638;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=7sE4JPqE1qSE0dDJji3oRyNIsowmIbXefj05D9f9GTA=;
	b=dK8g2EaY9kDZxKfIpDuGdlaXswQ+XNUPSRzkI+F5qejQzuo/hGa+caXflYFyLG3dqhQ/
	 zc7Bc/caSmE7ttgyS3MbDG8sMb1s+ALuwJUws3cENOcUKKAl5WIVxpebQuEsJqkVmGJLB
	 vqBrLpRHwlDQRy5isxwKBg/AOX/W6n1Fq7QP94x3yuLlZvQXuqMrkLMaGz+4DOQ4GngwU
	 HzISaVqpR0YIKifZEIt9aAARuJNKqavuna2C9A28UcpsiCbFhEVl1e7TslTC+zg0BX46U
	 moOuNSyrpG9BtE/jaK1W/aUflUhleNPdQYxrkLDv8/Fgqt2D+B7Q62DEA2+JB30eDZw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IODVJv7c;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08B2606BA37
	for <linux-api@vger.kernel.org>; Tue,  3 Nov 2026 15:10:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E08B2606BA37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IODVJv7c
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6b1d8944cb0so7202089a12.3
        for <linux-api@vger.kernel.org>; Tue, 03 Nov 2026 07:10:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793718636; cv=none;
        d=google.com; s=arc-20260327;
        b=sWA9Y/a+Gk/vTzH7kr0XecneeRxU8JhjIh5PeCA0e1Y5PQZLq7tm5sJPY8lOOhCyHb
         7E6r9eE3nJ4rEDJmMH+/KHuFC7IFzESWpC9Ln1V+rr9dHLR9lY+TMWK2EqagfPP4aUYL
         DDzU1LIZOmx1uRbM33vtznJxVE56eUzbFo0/lQyuEACiV4XkZFXFf678cf+H7T6HGaZP
         PjitHRiHhvXGIpbws5MNIY0nnLCX+28gTADi7W0va8zHIl/4k5L5fQA2t5BaZXyCft3b
         zC6efXWP0b9VjA176YwjhMZB2X9uskTPkg49llnvTAaBeC5cErYnqS5ekkMIUspgSHaX
         dWfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7sE4JPqE1qSE0dDJji3oRyNIsowmIbXefj05D9f9GTA=;
        fh=ijXAZD/kJiggdGTv1FJ9brV1asKe/Hlg3rwGJsN5rkk=;
        b=hBKfxhOuydkpotl4qVibFdHhO+1lm9Exhnf31HelcyukBt3Ry0n/K1kYpD3Fx9L/pk
         zETKEFGY106UDwiSxAZQ6Hky9E+3Vem+ngGWtVdKxCYdX9UWLTHvRvqSEH1v6yip6dip
         UmqG4oty8D+8E7KLnN6ye8LtWOSQqXtAaJXuOV6DAzKDezcCNcYH9ky0efggq4ZIj+ha
         SuicQyrosoGNY7rb/6H06x9qOG7l1JCuvBJ7SIA5pG9JxCLZsZUgftjb7HufYA90rFVf
         EbEl9WWjpiOwJIXWVxX99pVF16dbHhApaf2dspZGgNszTeIshRjWVF5ufntCJt1QqBGn
         vO2A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793718636; x=1794323436; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7sE4JPqE1qSE0dDJji3oRyNIsowmIbXefj05D9f9GTA=;
        b=IODVJv7cdAiH0zI7EYwsSnOisU2I29QacRI48d3GrxZ/4ahTqZYjCqm3KezEodiSwY
         KCcB17frnQVJPSU30oNUQVd+nMk5pNZUdHRRHtexBAcVEnGW6qI/hr5KBmZoGKU9n1AA
         nX7CBFPWo7OCb7jC//Cb3RWTM+8h/yqeY6CfYOZwkZSo8jHXe8sSpor73NKW/nDvJZT9
         /jUg0RghHQEpHFi9UISuH2cBTU+qDXMt5uUjVJ4bcvsnUCsR9swJZWPjdvTg2aLnef7R
         K+UYBntvwOMC75a1sODBxaY3kTz0ODpxjGJ5O/lhjvZS7WbSzPyZEfQDeWHRhswBRXSP
         fOtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793718636; x=1794323436;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7sE4JPqE1qSE0dDJji3oRyNIsowmIbXefj05D9f9GTA=;
        b=PmF0WuPC1isJsmWGVAQC0fEdEvUcInrfNhtzRyOfIUiQYoz1LdYl9D8zIpwzasQmSr
         vyX61QtCvRfokVdcHDoyql7FeRu9IExtq/ZF5agQG/qyz7ceAs28T1mqjkCAfvLKGeiS
         X94nsu1IsB9qlAeKc3B1iz9z5WIqhWdLtAiH4ueMwvd/XeY3+lUxk7tSEVkGsvuTymm7
         xl4LQxeFkLMRuRew7eIwpRA6UxEiCw+BTxTeNzMYvFX95rUbJxu14/l8qFdUwlmpC5ba
         a8iWQgsLDjqxcVWohKB+3NFXjozytUQCcN/yUwFJas7kIKz9crKpg/CFpGjEZLGf59jD
         ey2g==
X-Forwarded-Encrypted: i=1; AKwUvBzGm2fRUUY1XovKlNTaJ7i6gzliyYqcVUS3TF8ZNyoHPAFzg0BUKTogx7VC+iiOe3+dDDRq40RhMlM=@vger.kernel.org
X-Gm-Message-State: APuU4Z8S02xJnTLDz3L6Pd8plUcH7hTJYYnY7iN10Ho86Iu7G3jEzvkK
	eT628wDF36z3h2u8eLDLjealZjnLIfLYFsYWxdsD3Va8+Cn2OF28TBTjqL9sOZGCgBFiVhChbYI
	HgcO2JpOyolkVxsitMSubYX8K/B5nz4c=
X-Gm-Gg: AYBFou2tfYjVCbuO2pSD6GOHJUCohl7SK3dxRu05hMNehcehQoNGnqrMVFl1ccY8Mmp
	4n+d0aQn+lzbI5n0RsT+OGSAE+BPSu3pMDeqhyG6oay6XHD8Xv5zpENKv+BtvxsLcLO4KgiSuY+
	sYQZaQVg19us1WEy0PyvJz2gLjOP3CFWhpWYKQDZVxj2x0yPhxXuHwC07IKoZO/YACCSq3YYJgn
	RJ4zdw1KXvddSqv/Di5cH3uLNNfD3i8YimlCOPuQKukhiOztPRQZSN/VSs90RjfuqbVK/BzPXcw
	qD/Nz0Mw5BIg27yvB7gTsmj2elsXLJrNQoug+tn+WaomVu2BTK378EqWhebjUzcp78H+2yVLian
	tM0qcu8+vIRqSEViIb3RR5bQgbI1wz+wQobeN9OZTshJHx1nH43ZVpdUzaXxaYsHZKidTEg==
X-Received: by 2002:a05:6402:1576:b0:6b4:2807:94db with SMTP id
 4fb4d7f45d1cf-6b4d63b89b4mr7276457a12.41.1793718635985; Tue, 03 Nov 2026
 07:10:35 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261101015551.786044-1-koray.fra@gmail.com> <20261101015551.786044-4-koray.fra@gmail.com>
 <20261102142452.d6jkitgdeuquy23i@pali> <CAOQ4uxhQ3uhq6s+4deEJAQV5iy8QZoucojR58_dUNYrnjt_yvA@mail.gmail.com>
 <20261102153845.d67wlorqcbe3c2w7@pali> <DD1A08F1-8F47-4612-A807-AEA39461AF9B@dilger.ca>
 <CAOQ4uxh8EDX5HzFFKWv10-mHYVcSC1zXN+BS2qCm5cTMq=GOCA@mail.gmail.com> <20261103094906.n55n5dhrpct5ykmw@pali>
In-Reply-To: <20261103094906.n55n5dhrpct5ykmw@pali>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 3 Nov 2026 16:10:24 +0100
X-Gm-Features: AclHuK-nvjo0FA1uWKxpxW2jM-UILx8XEkVUZkdQkJAo4Tb9oLsdcVumIEFmEyo
Message-ID: <CAOQ4uxizEdR-MauSMOTfVcdxnuSMkrEuPth3nm3MsZuhcN5vjA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 3/5] ntfs3: make crtime user-settable using ptime
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Andreas Dilger <adilger@dilger.ca>, koraynilay <koray.fra@gmail.com>, 
	David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Chris Mason <mason@kernel.org>, 
	Jan Kara <jack@suse.cz>, Yuezhang Mo <yuezhang.mo@sony.com>, Chuck Lever <cel@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Sean Smith <defendthedisabled@gmail.com>, 
	Andrey Albershteyn <aalbersh@kernel.org>, Pedro Falcato <pfalcato@suse.de>, linux-btrfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	exfat@lists.linux.dev, ntfs3@lists.linux.dev, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 3, 2026 at 10:49=E2=80=AFAM Pali Roh=C3=A1r <pali@kernel.org> w=
rote:
>
> On Tuesday 03 November 2026 09:23:32 Amir Goldstein wrote:
> > On Tue, Nov 3, 2026 at 2:19=E2=80=AFAM Andreas Dilger <adilger@dilger.c=
a> wrote:
> > >
> > > On Nov 2, 2026, at 09:38, Pali Roh=C3=A1r <pali@kernel.org> wrote:
> > > >
> > > > On Monday 02 November 2026 16:09:41 Amir Goldstein wrote:
> > > >> On Mon, Nov 2, 2026 at 3:24=E2=80=AFPM Pali Roh=C3=A1r <pali@kerne=
l.org> wrote:
> > > >>>
> > > >>> On Sunday 01 November 2026 02:55:49 koraynilay wrote:
> > > >>>> @@ -154,6 +158,11 @@ int ntfs_fileattr_set(const struct mnt_idma=
p *idmap, struct dentry *dentry,
> > > >>>>      if (flags & FS_APPEND_FL)
> > > >>>>              new_fl |=3D S_APPEND;
> > > >>>>
> > > >>>> +     if (fa->fsx_xflags & FS_XFLAG_PTIME) {
> > > >>>> +             ni->i_crtime.tv_sec =3D fa->fsx_ptime.tv_sec;
> > > >>>> +             ni->i_crtime.tv_nsec =3D fa->fsx_ptime.tv_nsec;
> > > >>>> +     }
> > > >>>> +
> > > >>>>      inode_set_flags(inode, new_fl, S_IMMUTABLE | S_APPEND);
> > > >>>>
> > > >>>>      /* Save nodump flag to return in ntfs_getattr. */
> > > >>>> @@ -275,8 +284,9 @@ int ntfs_getattr(const struct mnt_idmap *idm=
ap, const struct path *path,
> > > >>>>      if (unlikely(is_bad_ni(ni)))
> > > >>>>              return -EINVAL;
> > > >>>>
> > > >>>> -     stat->result_mask |=3D STATX_BTIME;
> > > >>>> +     stat->result_mask |=3D (STATX_BTIME | STATX_PTIME);
> > > >>>>      stat->btime =3D ni->i_crtime;
> > > >>>> +     stat->ptime =3D ni->i_crtime;
> > > >>>
> > > >>> For me this patch looks dangerous. Somehow I would expect that th=
e
> > > >>> "btime" will never change for existing inode.
> > > >>>
> > > >>> But because the ptime is mapped to i_crtime and ptime is settable=
 from
> > > >>> userspace, with this patch it is directly possible to change btim=
e.
> > > >>>
> > > >>>
> > > >>>
> > > >>> I was thinking more about it... Is not this just misunderstanding=
 of how
> > > >>> the security model around the times is working on different syste=
ms?
> > > >>> Because on NTFS there is stored just one field which says when th=
e file
> > > >>> was created. There are not two fields like "time set by user and =
time
> > > >>> set by system".
> > > >>>
> > > >>> Windows security model allows anybody with WRITE_ATTRIBUTES acces=
s to
> > > >>> change that create time. Linux security model does not allow to c=
hange it.
> > > >>>
> > > >>> NTFS in this view is just a filesystem like any other (ext4, btrf=
s, ...).
> > > >>> In my opinion if the ext4 or btrfs filesystem is correctly implem=
ented
> > > >>> on Windows systems, then Windows security model should handle it =
in the
> > > >>> same way like for NTFS or exFAT. So if something grants WRITE_ATT=
RIBUTES
> > > >>> access, then Windows should allow to change also btime on ext4 or=
 btrfs.
> > > >>>
> > > >>>
> > > >>>
> > > >>> On the other hand, I understand the use case to have two creation=
 times.
> > > >>> One time which would never be changed and could be used for any k=
ind of
> > > >>> atomic / synchronization by userspace application logic (this bti=
me).
> > > >>> And another time for human which can be changed at any time to an=
y value
> > > >>> which user wants (this ptime).
> > > >>>
> > > >>> In any case, I would suggest that filesystem driver would not rep=
ort to
> > > >>> userspace unsupported values and would not try to invent other va=
lues
> > > >>> and lying about them.
> > > >>
> > > >> But all those fs with mutable creation time already report it with=
 STATX_BTIME
> > > >> so what can we do about this?
> > > >
> > > > Well, what I wanted above to point out is that the "mutability" of
> > > > creation time is not feature of filesystem, but in my opinion rathe=
r
> > > > property of the security model on the running operating system.
> > > >
> > > > Maybe better question is: how ext4 btimes differs from the ntfs bti=
me?
> > > > In my opinion there is no much difference, both of them has meaning
> > > > "time when was the file created".
> > > >
> > > >> If userspace requests both STATX_BTIME|STATX_PTIME in mask arg,
> > > >> those fs could technically return only STATX_PTIME and it should n=
ot regress
> > > >> existing programs.
> > > >>
> > > >> But this is still a bit surprising behavior is it not?
> > > >>
> > > >> Thanks,
> > > >> Amir.
> > > >
> > > > I'm not sure what to do with it.
> > > >
> > > > If we allow to change btime of ntfs then for consistency we should =
also
> > > > allow to change btime of ext4.
> > > >
> > > > Maybe another idea... define new capability which would allow to ch=
ange
> > > > btime (on any filesystem)? This would at least make the consistency=
.
> >
> > Pali, I think this is a very bad idea.
>
> Ok, if the point is that ext4 btime must stay immutable then it is a bad =
idea.
>
> > This has nothing to do with capabilities.
> > The Windows and MacOS filesystems have allowed setting their
> > "creation time" forever
>
> FreeBSD for some fs allow it too (see below).
>
> > and for all the other Linux filesystems that had
> > "birth time" it was immutable, so let's not mix filesystem features
> > with capabilities.
>
> I think that it is important to first define behavior and invariants of
> these "btime" and "ptime" kernel properties.
>
> If we want to be consistent then there are two possible options:
>
> 1. If we choose that the STATX_BTIME is immutable then no kernel fs
>    driver should allow to change.
>
> 2. If we choose that the "NTFS create time" is reported via STATX_BTIME
>    then STATX_BTIME is not immutable at all.
>
> These two options cannot be chosen together because option 1 would
> implie that the modifiable "NTFS create time" cannot be reported over
> STATX_BTIME.
>
> We are have currently STATX_BTIME immutable and "NTFS create time"
> reported via STATX_BTIME.
>
> If we want to stay _consistent_ across fs drivers then adding API for
> changing "NTFS create time" would break one of those two things.
>
> In my opinion we should stay consistent across filesystem drivers and
> provide unified behavior of APIs independently of used filesystem.
> Otherwise userspace applications would have to write fs specific code
> for doing their use cases (and we can stay with fs-specific xattrs, no
> need to create unified APIs).
>
> Does it make sense? Or it is still a bad idea to think about it in this w=
ay?
>

My "bad idea" comment was only referring to capability.

w.r.t the STATX_BTIME ambiguity there is another option we may want to
consider: Don't publish STATX_PTIME via statx() at all.

One of the reasons that developers have pointed to fileattr as the right AP=
I
to host the creation time as well as the DOS attributes is that it has a hi=
story
of carrying filesystem specific attributes.

Not every attribute available in lsattr is also available in statx().
If projid is not available in statx() then the settable creation time
doesn't need to be in statx() either.

The file_[sg]etattr() syscalls provides a symmetric API to set/get it.

The same could be true to HIDDEN/ARCHIVE/SYSTEM flags if those
are added to fileattr.

Do we need to stop publishing NTFS creation time in STATX_BTIME?
I think it's too late for that and nobody is going to gain anything
from doing that.

Thanks,
Amir.
