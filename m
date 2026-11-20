Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795204425;
	b=qtvZDjz/qZFirz09qwtIxNcEdRuSl+mY7SmsrM0uiC/tNVAD/bKRaMzi2pVkK0Mk3xUP
	 k02G44K7pOeMhxYKKM080hRvUD2b9p8gRd/JAUjRJxVG10WbSJ91GcDw+6pLGSasEnuia
	 0xwHgs6a+LhTr3zRclHKyB/bU9Z0RcqD21XQrjK4/GgNhy7WPkUVtQ/0e3fkIBh3hHbgS
	 Nfeh1hL1SsPj/+6VanHPjbNYmf02TSn0gL7sv78wI5tph7lA4pmCqYu0f4HL0vFiGjhER
	 lPPMoMT7AZPxef6lkNV/DCOxlGjvBmyJegBZSdy2VTiQV1ZoWskcVRl24WlONwUljdg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795204425;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=Y76CwwbIFFZSLzT6VqrJeNVAmGacmUJL5O9mQNR1EcY=;
	b=gKyGwUCn3hMXIMFa+7J61FALhN6PSlNTwutQfjjpXuB3opIxfr2tjErKycv0lFgQZHm6
	 aONixILusTYblPpFYrKcq3bzjzVm7jjG5vXpiQ3V+8vMz3pjLsr2xm4B3scT5gfzJ1YES
	 3GVT4J7VJszbrex2pZ8r92OTx1eFE4dJVxsK+esCTzbYjpKJJDzJoen/9OBxJnjqex+hK
	 83WIjC/H74JSHHPCk6EgFUxe2c0JGMhVx/81fp19eDKrqdZ5hZ4q7hCN7WHOd02l860F/
	 BBxFHOiM8m7X9YpV895ZdT3SqG8jN+C0l16CZ9V/jCnIS3sidMP8kLifgJ1GfT0WZPQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=amacapital.net;
	spf=pass smtp.mailfrom=amacapital.net;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=OIzOhE5i;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.41
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4AC9606A33A
	for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 19:53:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4AC9606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=OIzOhE5i
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5c15ccd7fb5so744139e87.2
        for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 11:53:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795204423; cv=none;
        d=google.com; s=arc-20260327;
        b=PIwj3RZ90Iz0qnLqwbXpHZ+muqHPd6WBT2FL6GPCZow2Tsp75C9PnIDQhiqsz1OHlD
         4Fi38KDtWlUJg5OUzNymgJJh7oe5NASOy+89f6ZwdwDbylZ5UBDKk1fSqYeitxZeGXty
         GtrHNwrpIzvdIknoKTdnkS0hw5/h/TStUwyyvUVmxf/akU+8nG/wAJamCBjS5gu7xBAx
         wwtAJ9u0wBZ22XROHQJ/5nKUrhusIdz2HRB3SBJZY7haFeoFGNfhHYqUg66xkrRH0j/V
         52fqweNvpZuItAPCTIRNRmuNcZBOAkwM1AGWX8bmcy01+6Z0WdIBoe+Bh8PVWh6UeuVN
         Qb7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Y76CwwbIFFZSLzT6VqrJeNVAmGacmUJL5O9mQNR1EcY=;
        fh=pBqFf/knOJWmU6DmsMaeDsQyLcZf/s/jnhDreK8wBPo=;
        b=eBzxt0sHmVRjzVff3G8KGtrnYbZ3/2GcUh0W6GMBlLrTw0mTjYchNl5QrHrnMw+U8H
         jl/Bd0TlAbBlEScni03ixgClT/u1cNv9mt7/uVciIk7TcvHAJL+/59jiT+B8x7CeMwxw
         wZd6QQa/XTlienzJVd4t0+IOBeXIRS3PvvXrEkpzfE6q4czgl1l2iyKdAZs0GcvSH1o8
         1DPkWgvG8XsAYBSijXzV8kHLKDyANBpCEUhJiAFSC8yWbB8D3xXmzJKtMcqnqUWk02H8
         vXBltSohLj38Zv5UwJuI8b5Y98eCb2SiUgiXRq9Qk8AEkRzn8n8n1BGWOoTD6UE6IwXJ
         ybhw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20260707.gappssmtp.com; s=20260707; t=1795204423; x=1795809223; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Y76CwwbIFFZSLzT6VqrJeNVAmGacmUJL5O9mQNR1EcY=;
        b=OIzOhE5iObSc8vEouH0agFHpvADyEkxMoLtQygTw3RAog7Wv+L7LAKHBfx6tywTWla
         XUmS9LeJ7PnxVQ8l/3h5q4xOUl+0sR1Yhl89cyUVCQFQ6WCNIJ01mU32NChKR7y23gEJ
         n6jCSfPaTpMmvNA7KdBLfnQPGXRT46ttzJgAvgufnJa4wXOuJ17zrS9bXry+tvzH4oPw
         y8KH2mJUm+Io56eSd80lF5wNq2JRo3v7s3MN3hIShmIFHlUZKroZclqXKbLIjGE9o4oI
         gDJi5i5Hy/If+d9CSXWm+OtWA52rz2oh8TdXKQlysnEYYdN/92oAHLZ0UJRgGJo4WwVZ
         xk2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795204423; x=1795809223;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y76CwwbIFFZSLzT6VqrJeNVAmGacmUJL5O9mQNR1EcY=;
        b=dSw38Kre9Pvtj/JNKJNT+3I97yX7Jt8ZlCyCLKdblWno5r0u4nvdtRmrXNrUYozGPE
         9RnsVR9puQI2ftikjJe4HVNUkNxYEnyeOl7Ll8LgDHN4vN1BcDTjop2FfoQ21zgO7sfd
         mMH2I64Zx6d4DAE++WroZOAQgN3c1j4iQXlMiqQnx0Odxl+kNm7oco4B1NKlAWTRI8ym
         0tLG50dZsOzo6l3z/0icHnlwwbtSyDM2meI/aJ5y8rH2+NJApa/N7USxkud1r/3b8FYv
         WLAOwc6DSTEiw1vVRlgU8cVKD0UWw9adqVBJNouyYBVBaNHvCG9Vg7XX7ST09Qhj0R9f
         YuwA==
X-Forwarded-Encrypted: i=1; AL+hErHePsn8znksdmWth1V0dWVT7EH89RCoVSKGQbtIu4PM6lkspbo4K1qtpKJuiQNnpG2IKqh/oBQSqeg=@vger.kernel.org
X-Gm-Message-State: APuU4Z/twF7MG19i3036DMlam/fPvHnMYdPfq7PLjY7tZVRNLjugq1dZ
	gg1QZro5V8y0Ixp2267mrDrlL2FQDSt32GhqNNAQo5W08LyJrB2ilXWEpd1V7X7ogYdZ/gROlkV
	hoNeuQSJSS0/rIYMgwu0bmJBt1T1bE5cCKdGldQZO
X-Gm-Gg: AZFdTZd8qXIPAnVrpBbrXm//lC95186yAoWRQxswbs4gZn94SxaBojml45lSvgKtaEI
	PUX54QjoIUEo4RX/MdvVnOqk7d/ZEqwHUWzH5R/SpSuUlh3Rp31pf+GtbKbBQPjONWctMoqNYGX
	l4XVVAza2gaxb7QUqmBYu00gc53yyOgbaQBd5hpeRD0gw2OSVmd8FgVkjPBYn+L4pQNsexEYakk
	totP0XBf0v5yVkIbPmOlWe2JinC+aQToEVB4IXFjVGoY7+pr8UM665Md52meE/t1Tx5NaoQgfYr
	0rzOAnQRYZHokeXyH8FMiHKVq3Jvgm2dmC3314pEn2XYDlPn+s3dlMyeFrT5GMoVByVnM9Ywkxx
	FAp759QWQJenMFlw6FD7v+6qqQReFLbs00Q==
X-Received: by 2002:a05:6512:1046:b0:5c1:acec:260e with SMTP id
 2adb3069b0e04-5c1bc8432bamr1303866e87.55.1795204422738; Fri, 20 Nov 2026
 11:53:42 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <av3bkDnwmjunTleX@kernel.org> <CALCETrXPLeUgxyhjP4XuWS46FKB0TUHF5PcMkdMf+qeEXbyXRA@mail.gmail.com>
 <9463a969d35a7d5ec5a56aeb67644b94.josef@toxicpanda.com> <CALCETrXt-Do28BHDpbrA98kEy-tQuorxD8c2XsW24Tt8Vspdtg@mail.gmail.com>
 <CALCETrUbe8rBoxrC+Q66AMsrJ8Fow7xt5KJKRAmobtXBvHWdqg@mail.gmail.com>
 <c301fff20a4920fcd3baa31dda2e31ad99c93436.camel@amutable.com>
 <awBHZO2VwWyJzvBN@kernel.org> <1f12636403bb7af3759cd933b2612d8a5d7317a2.camel@amutable.com>
 <awBRyKgOQlaEqpWX@kernel.org> <awCg5VYXKJvex9vy@kernel.org> <awCkANwNDox_99SR@kernel.org>
In-Reply-To: <awCkANwNDox_99SR@kernel.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 20 Nov 2026 11:53:30 -0800
X-Gm-Features: Aa3M54pKxDm6eU_2Sjm44hIEowicdxL9W6xw2PHKnbweFLV6y91fuj5aPjITmFQ
Message-ID: <CALCETrUnQjrWmSzL-FOqFF+_enxVsEM0On7orydXLCO-L2f23w@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/13] Namespace for namespace roots
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Alexander Mikhalitsyn <alex@amutable.com>, Josef Bacik <josef@toxicpanda.com>, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>, Serge Hallyn <sergeh@kernel.org>, 
	Kees Cook <kees@kernel.org>, Paul Moore <paul@paul-moore.com>, linux-fsdevel@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2026 at 11:48=E2=80=AFAM Jarkko Sakkinen <jarkko@kernel.org=
> wrote:
>
> On Fri, Nov 20, 2026 at 09:35:06PM +0200, Jarkko Sakkinen wrote:
> > On Fri, Nov 20, 2026 at 03:57:32PM +0200, Jarkko Sakkinen wrote:
> > > On Fri, Nov 20, 2026 at 02:24:57PM +0100, Alexander Mikhalitsyn wrote=
:
> > > > Yeah, detached mounts API solves a security issue here, but it does=
 not
> > > > fully enable the use-case Andy describes (if I understood it
> > > > correctly). My interpretation here is that to fully cover it we nee=
d
> > > > some well-isolated communication channel between container and
> > > > container manager (vsock for containers? :-D). And some well-define=
d
> > > > agreement of how PID 1 inside the container can get an information
> > > > about a hotplugg-ed stuff. [ But it could be that I completely
> > > > misunderstood and Andy meant something much more simple here. ]
> >
> > The sequence for hotplug (Andy's use case) breaks down like this and is
> > doable:
> >
> > 1. Host creates rootns(ROOTNS_SEAL_MNTNS).
> > 2. Host sets uid/gid maps with NS_USERNS_SET_IDMAP.
> > 3. Host populates "/" with MOVE_MOUNT_T_MNTNS, optionally combined with
> >    MOVE_MOUNT_CLONE for bind mounts.
> > 4. Host spawns PID 1 with clone3(CLONE_INTO_ROOTNS) (optionally passing
> >    an AF_UNIX socketpair fd for communication).
> > 5. PID 1 watches /proc/self/ns/mnt via fanotify(FAN_REPORT_MNT |
> >    FAN_MARK_MNTNS, FAN_MNT_ATTACH) or polls /proc/self/mountinfo.
> > 6. On hotplug, host mounts the filesystem via fsopen()/fsmount() (plus
> >    optional MOUNT_ATTR_IDMAP).
> > 7. Host creates the mountpoint with openat2(RESOLVE_IN_ROOT) + mkdirat(=
)
> >    and attaches the mount with MOVE_MOUNT_T_MNTNS.
> > 8. PID 1 receives FAN_MNT_ATTACH and queries the new mount via
> >    statmount().
> >
> > ROOTNS_SEAL_MNTS, NS_USERNS_SET_IDMAP and MOVE_MOUNT_CLONE new features
> > that are yet to be submitted but they were not tedious to ramp up.
> >
> > I'll include them to v5 of the patch set. Thanks for underlining this
> > part because that led to having those.
> >
> > Architecture scales to this even if my choices to address these details
> > would need some adjustment.
> >
> > The clear two-phase (build/live) progress with rootns sort of just give=
s
> > room to address stuff like this, and I have hard time to believe that i=
t
> > would get much better than this.
>
> A completely new feature is NS_USERNS_SET_IDMAP:
>
>     nsfs: Support NS_USERNS_SET_IDMAP ioctl
>
>     Configuring UID, GID, and project ID mappings or disabling setgroups(=
2)
>     for a user namespace currently requires writing to /proc/<pid>/uid_ma=
p,
>     gid_map, projid_map, and setgroups, forcing container managers to spa=
wn a
>     live process before populating a filesystem owned by that user namesp=
ace.
>
>     Add the extensible NS_USERNS_SET_IDMAP ioctl on CLONE_NEWUSER nsfs fi=
le
>     descriptors to atomically configure setgroups policy and UID, GID, an=
d
>     project ID mappings before any process enters the namespace. Enforce =
the
>     same single-write and capability invariants against both current_cred=
()
>     and filp->f_cred under userns_state_mutex.
>
>     Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
>

I'm highly in favor of this.  But maybe not as an ioctl.

If you have an nsfd for a userns and that nsfd is the "control" fd
(however anyone decides this is formulated), why does f_cred matter?
It should be possible to create a userns without privilege and
SCM_RIGHTS the fd to a privileged uidmapd.  (I fixed the rather
screwed up workflow for this in newuidmap/newgidmap a few weeks ago --
this is remarkably easy to screw up.  It'll make it to a distro near
you some day.  It's supposed to *work* even without CAP_SYS_ADMIN in
the picture, and it did not.)

--Andy



--=20
Andy Lutomirski
AMA Capital Management, LLC
