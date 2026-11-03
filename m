Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.208.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793718777;
	b=KK3zHnjiA1vDeBmNBfu6Cx2RaB926Fea3RVag8m0vlYAMGbBZ/Psq6cV/lmfhOLJuAIQ
	 J7mrZBOXLc0MRXPu3bKrQiSd1AMaVaYDV/OGFOKmOh2EIXG6XOID0cYGwL3k8gQ6n5jMN
	 BjTj5IchLe2p2R8JGTHDGJuO6SamE6rTbu5ra+sdUhdrU0gshvA8hYzulwS/Y8MZBQz+3
	 ds8GtPc2bUqK6G8rpmEyjn35QNBLfcmt2F70iTVm7RGdJBRNsYsJebXxdh3g7XpX2r+l+
	 OHK0cILdUc7cHglz6SB8haJWpJhm/6BZ0LvIQtNtDwSnmTi7pzZjSma6poFB+Lk1Eaw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793718777;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=7cMnatEM3HIlL4UaH1i3lvKdnRzKCLctOQy2OXRyT4U=;
	b=MPgv3FuidCH3lfqiTsqziLtaNtr2LOhDTQ/GgSBXrlg8Kh3P8OlypkBy6ZTMwzraL1Wj
	 zlojDZiQURNC+ojo1yAWFbqydLZ2x80H60g+hHsZ3/1NMZ7GOHj6mm3otNZ8BO3aoJsLX
	 8cVNPzOwBLH5244VkuejFMt6rNIXodlzZD+toe2YBSum49JP8vE1R7evAgKMB0xhDf98X
	 8kzyT6CuIJTve0OHcw0b6j1PUWXj/Dj0XrdtUOY4IAuKCsDWS13D2cky/UskhyUtj00r0
	 HIgXIRzaEWshaHztuNXQbhU+SnRIDCf4JNDEiwLxs2IlVZFnyFmNQwj1lF03gaGdKEA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OvFvtKic;
	arc=fail smtp.remote-ip=209.85.208.42
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94FFB606B259
	for <linux-api@vger.kernel.org>; Tue,  3 Nov 2026 15:12:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 94FFB606B259
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OvFvtKic
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6b1f31c63ebso1165429a12.0
        for <linux-api@vger.kernel.org>; Tue, 03 Nov 2026 07:12:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793718775; cv=none;
        d=google.com; s=arc-20260327;
        b=YEugOhvzQG083Yzr2DPaxnaXHAQ5N0yweTBmJt8f+LgD3e7vlG56T9Sd4aipc7QbOc
         rGxj6QHjZd/CbbzBvlK0gqlj6dFaxDE+2EEZM/z2zOAKPmV55E4oRxTWRddYYbnG2XQa
         /Yat68TTIHRAvgcB8MqZ1Px7mRS//nJwFt0Fa2SOFCHH6wirLqtJY57GPj+yLvx8BzIi
         b7wOmb0Jcyf+DVAD2HrIhWTuB8NC908rmkfVxdjBJPddHIWdSwvmXOW6Wi54vqojOnWn
         NDWtAfG4ZfNkSub3A9Um7vWdxaFkXBy0OuHxTqTxfdMTErdn0oIUQFbT4YYY+91GVwjO
         aDGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7cMnatEM3HIlL4UaH1i3lvKdnRzKCLctOQy2OXRyT4U=;
        fh=Lu8JJcLuilm6LU2dAyDwK0yQumJT4p/SBkNJ1vZ8juU=;
        b=kG9aiXLHbJo7xAgS3bhaovIP9jGxKOVpqU4ncV6/jObc0UdQLTe1W/S+48L4Uvdh3M
         VZK0ecSV83EeiqORLidW5g9xE+zaf6HbAqM1ldTL1vvj3Y0+5Xu63dz8HxBKCZNVK+7t
         64Xjo2tt9KXxDjOldg6NC4NESjjANfy4ieosjwmgCUJ8dXSN8TKMLeP3NeKEZj4s/DsM
         6s1BaDA3TW9kohwDz/Ql+B4Z96GjD28P+r4AaKXfpewM/qm//LXdY0Ld3apEUhD9Ajce
         CfZUW8m60jQUe24IBUe+84FVdrEPeMUX3JWGMDrqkVNyhg+TAujVLNYOBYep5L0s4Q4h
         PfRw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793718775; x=1794323575; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7cMnatEM3HIlL4UaH1i3lvKdnRzKCLctOQy2OXRyT4U=;
        b=OvFvtKic68lKCYq5u4vqHczl3baTPtF15hOIez1MaJdBuzdCpImLq5Qv7L32t95reC
         ew8jluUvcc+N3iPd5ONhE6VQMsevXPTcnFcQMaMAXtydoe1Hvu4ufW8rct43NHU52g5v
         X6kQhB503r+JeDBVm2lVapqlL+7T5XwUc4QW0kNnCmhuVPRXuTmuIrietp2CZoQSDa/Z
         4jg55kmTR2BGZX5663w+3TGaH1OHMO4OEHB3ShEet7gRgN/NDGqdS+XvhVI8/KoYJeGO
         ZH8EsfNHZpQ1Z4aUgHGqr2/pfzFkq3nT8y24hz069Du181ff3kyUHLwqV6RHhY7o6PLP
         P4eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793718775; x=1794323575;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7cMnatEM3HIlL4UaH1i3lvKdnRzKCLctOQy2OXRyT4U=;
        b=xF20Lt4eUg8ekLepBTD68HF+v1cY/oCpgoAj/1myuf5c2Ni7gas9GUHlvttBm85cEF
         SS59M6XLUJ8aPBWim5zMJJUFgbA06a4sk1onh4pt5ZdIN55YDkJCFlc187Ytoe+ZOsOz
         OVe0a6PwMza8HYnBAHuGvvWsC6uS2bvkMk1zbsgAJkgYRqO80qXivd8f2IYMELMJxr7g
         hvNMjRLgTLMPnZcbEf7ZnnsxCPKH56M9Y0vXbzBm2s9K0tLw30a9KKg5N4lZwp7G1cHv
         Dqh+qp2EAPtlC+0oA3OG2Fjf2j77hJaZrOSZWZNoLh2/3JHAoFRE+Hd1JXdT5uYcW8A4
         s03A==
X-Forwarded-Encrypted: i=1; AKwUvBwuBPFEcSuFCkWFTsu1oza8COJJbez48M2aEXdyyfSIio08er0UoI4wjzxg96X5G0pkJLwogte/3NA=@vger.kernel.org
X-Gm-Message-State: APuU4Z/BaSfWPP6+/G8qtoJiGTQEiFG7xUjGzuE9jPFYxSDr129u+IYZ
	5EFJfEtof07KVRkmpP01fmhQxI3k7lA/yLNjx9QvW+IuZ/eJukJCtBdYjNiWGjzFk7NEytLlSAC
	0GXX5YMLne08xFwyo88l3SaSgkW//5gA=
X-Gm-Gg: AYBFou0Kwl/Xjm2NgHJwa6eI0K+Ycy+KZSwXOj36udKoK9lESDa2Gft5xgE/iAypHWo
	cm2GRZRYT9XPSmV9CoH78w4MrIwtJIOnUuh+COVQzmvzFJCm6qINAEHABh4lgkN9R+kEzXNu7L1
	v3mZvcv5jvHELOx6khi+WCJb6SkEODvRnY2igrZkl7C9M03/9KC87vT/TCl6HQNxVP8KjsDF7lm
	H0SHkCsORsHww92WLOMSlGBhBDPCfzb77nqD8rZMcRUDFHMpmNVxHDSDPA72RReICi3xlkye9w1
	PAs6cJNjwJw9nNuZ9DdZgtI1g+RvjQEws6navI7H/ZtExMeM3Zwl0AjvbiVo6pZeOvNtP1vWvdQ
	FUuq/xj4363pIai5VThLCFhUrJl5+th1vNqt4Z9O9bNuCty2TD6BOMpaj474GnSugwo3Ct7E=
X-Received: by 2002:aa7:c716:0:b0:6b1:c521:ebda with SMTP id
 4fb4d7f45d1cf-6b4d5ee6c50mr6756533a12.14.1793718774731; Tue, 03 Nov 2026
 07:12:54 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261101015551.786044-1-koray.fra@gmail.com> <CAOQ4uxjkG=1j1z==Mv4wzkF042rXstodokKnBfMFBf2e-Eztmw@mail.gmail.com>
 <DMLJE2Z57AD9.1W22LSE7V9HH2@gmail.com>
In-Reply-To: <DMLJE2Z57AD9.1W22LSE7V9HH2@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 3 Nov 2026 16:12:42 +0100
X-Gm-Features: AclHuK8QI8V9NvEKNRSnDchTL0FslmV7Uh3t35Xsoq4Akwwc8XamtLwVFdORxbE
Message-ID: <CAOQ4uxiMLDgMXuij99-43UfCqfZN2a=CTet560o_RzU2m_Y4SA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/5] add provenance time (ptime)
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
	linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 3, 2026 at 12:25=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> On Mon Nov 2, 2026 at 3:54 PM CET, Amir Goldstein wrote:
> > On Sun, Nov 1, 2026 at 2:57=E2=80=AFAM koraynilay <koray.fra@gmail.com>=
 wrote:
> >>
> >> This is an initial implementation of a new timestamp to indicate the
> >> time when a file/directory was initially created.
> >>
> >> This patch series takes inspiration from the one by Sean Smith
> >> <defendthedisabled@gmail.com> [1], but using
> >> file_setattr()/file_getattr() as suggested by Darrick J. Wong
> >> <djwong@kernel.org> in [2].
> >>
> >> The semantics of this new timestamp should be at least these:
> >> - it should be the same as btime on a newly created file
> >> - it's user-settable, so it can be preserved for backups, filesystem
> >>   conversions, archives and any similar operation
> >> - it should be preserved every time mtime gets preserved
> >>
> >> and the correspondence with the other timestamps is as follows:
> >>
> >> ctime <-> btime
> >> mtime <-> ptime
> >>
> >> Examples:
> >> 1) a .zsh_history file created in 2019, then after a few years the use=
r
> >>    decides to switch to another filesystem, copying the .zsh_history t=
o
> >>    the new home, in that case btime would have the timestamp of the co=
py
> >>    and ptime would have the 2019 timestamp (just like mtime would have
> >>    been preserved)
> >> 2) a symlink created in 2020 from the home directory to a /path going
> >>    through the same process as the .zsh_history, in this case it would
> >>    also make sense to sync the ptime to the 2020 timestamp instead of
> >>    keeping only the btime (so the inode creation time).
> >>
> >> The proof-of-concept code (for testing) for stat(1) and cp(1) is
> >> available at https://github.com/koraynilay/coreutils (master branch)
> >> (Note: these coreutils code changes are a prototype and won't be
> >> submitted upstream as-is, but they work as expected in simple stat and
> >> cp -a/--preserve=3Dptime tests)
> >>
> >> Lastly, the name "provenance" and "ptime" are not final, I personally
> >> don't have a strong opinion on any name, but while testing with stat(1=
)
> >> I noticed that "Provenance" is definitely too long for the normal
> >> output, so another option which would fit well is "Origin time",
> >> abbreviated as "ntime" (OrigiN time) and not as "otime", as that would
> >> conflict with btrfs' internal naming and create confusion.
> >
> > FWIW, I agree that given the existing uses of btime and crtime in the
> > kernel and various XXXprogs, using 'ptime' for kernel code is probably
> > the lesser evil.
>
> What do you think about the origiN time (ntime) (Origin: in stat)?
> It would also coincidentally be alphabetically (ntime <-> mtime, n -> m)
> the same as btime <-> ctime (b -> c) ahah.
>

Honestly I don't know.
My new idea is don't publish it in statx() at all.

Thanks,
Amir.
