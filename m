Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.167.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793731088;
	b=QayWHM+DRvLHJKouM4VOkWwS/94zFxsT2WYgXhHXhpeZlQyWZ7F1rqdA0C7xZ57E11Yl
	 qvta1cxLfBmxuFLaxssL+pn3j4pZ9b+CLzPVaBklTi3dQ5WrtPE1oQFDeTVj1G+G/ddGp
	 WDighY5cxOmHP03AezedRk6sLdcv30K4sGTR3fsxXDEB9no4d6Owh5/TNQKUZJTYLYpRF
	 srWvtQ5ihO9ZLbUCsaXVgzsHst4yiOf37Etgs8UVJjraRA5OLAbimStrcDvlrE0oBvdW1
	 rnwYMj4sQamgJtuHFMlilGpuDNbShWGZFMo8j5A8lT0rtJmDAuH23OBNKJfJVpDlS+w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793731088;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=fviwjroG//qntBAn39plNVA6JSIngXI7akYS02td+eA=;
	b=b/I6rz+jndHzjQkhA8L2xvnKqL/PVMLyp0CamrtDHt0luAlQeC/0LyTlLdUiZAsMVhFt
	 RUhRbLparhYxRdv9ThdchXijovBQa1RnbqQn8j5bBAb1YSOgWeABpv2QinBtWUPvdzKhp
	 X8VmHun5O6CDPz1hrfPASom1xcoDr2EnGjfxgxFK53QjJiu7sgvE7j5bL58mkcJJox16v
	 zmJUNjg2qYe3xqb01LAAVyu854A8fhNFZgDaJasJpe3pb/77PUqmr6jVR6mXiw2f46sMc
	 9m1O9cV+QJbQn6hZOjMHuMYh9dy5SKTVE4iwzCCjA1UyyIabLQk3WrCIY9YnwroeoPQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=amacapital.net;
	spf=pass smtp.mailfrom=amacapital.net;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=nVCsNw0y;
	arc=fail smtp.remote-ip=209.85.167.42
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1817606A329
	for <linux-api@vger.kernel.org>; Tue,  3 Nov 2026 18:38:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1817606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=nVCsNw0y
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5bfa65c8617so2716940e87.0
        for <linux-api@vger.kernel.org>; Tue, 03 Nov 2026 10:38:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793731081; cv=none;
        d=google.com; s=arc-20260327;
        b=YZMno1jT5X4KzIw594HeYSmMKiAj23s1ATzbh6dWpmVjxNCn5sHjtYByU56WDdyzTP
         VlbJu2qFOYHKVRM4hv4mIpnzTO6kFUlLnuijDXlnde4btusVy2Px9s/Q0egPSA+eu93s
         73K7B0JefLCw/ex89XubI4Sa8voMu5URD3JLI9Y/VttX2pU/1PtQ2eblIUHqRprOAyoP
         ZwTkTiaDfcZEORhgkgpj2md12fFjZ7veuX+Wpawk9Csq+Z93LQ66AMTGBndxS1XHjQ2y
         GqXtrbzIlHd2xgxt3lRUwNkLq+P+06q9cY+rR5KywpnVTfFKXOFX9NFvSfTBlt4L+28+
         XzDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fviwjroG//qntBAn39plNVA6JSIngXI7akYS02td+eA=;
        fh=4LBoDrXqV7pmhj2Kui5GI+C+1fZLBun0zmyV53NEwUM=;
        b=AYYvRV5SJ82BpieS2SYv79UNPSMFesxpzKtaSMuniS1VG0SFlYGGDdEWerRjbGSswI
         gzsPQCsvZuTwBDVRs380LzhpEmf6S7ZQmk7YNZmpVZlUm1e0/58SwxQ2ZMcovP3jszdy
         77nP8Xvm+zatKhziGWpUTzTVF7GvZV+dJIs8j6YVtCsWsBaNwhgYUd+7OhlzzE3WmIpN
         /Ur/W4Ntx6aqLUWmYzGt6G7KcMeY4N0vbaVqEpxY5dP9nQlgmDKptUzvbdtr+jmYCYks
         0HPAfKH3tq+Pci+oOBKt+LfIyGbdNzAoHOTx2oCaNJvdsbzDpVfBImV1qhgedollH3KL
         p/Cw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20260707.gappssmtp.com; s=20260707; t=1793731081; x=1794335881; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fviwjroG//qntBAn39plNVA6JSIngXI7akYS02td+eA=;
        b=nVCsNw0y6hskrENSBv8EU3amWuYztT8dLT5p7AwDRfBEJgh5KCH4wcnDy1+4F8oz26
         mugE2B8LWKKCR0Y9k2Z98xSLZ5eNvcfR272i+te/45lnsb9AWyAtGJcy3D9bL7ir+f71
         qQpNmsSv7T5esoFkU7QTr7zF74lmigXGg9dzQbwmAGy2M5yd+bQ/6ZIx3r0WugxBJ5RO
         hJm/oKDuQExrJP3FUtAD2VCpRZdYySsqRCW8MbRDOe9JChKA+5WjiMn7EutjmI1dtjC9
         TX6PAuZUUq43suQ5ErDcrLsoaFbkM/WfFXDhbG1erayEtyXYdgmMQ2TL7MALbarBBDH6
         21vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793731081; x=1794335881;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fviwjroG//qntBAn39plNVA6JSIngXI7akYS02td+eA=;
        b=A8yl/uxOdO6dtl3yeKqfbAazHFXyzp9Ejec8uudJzgnn2dlR2siTul4c0XwBscuBjB
         dzSf5W2zx/6FmFFzddhovS8pgcfy1bO9+FFUZRfCoU11BYMxOvhMGdG11qmW4RdmjWxz
         QZTmIbG3P19P0Tp7uEtDcljyA9WI4rrJqD8JyOpdYLvojT4Ug4zcn6we+KiQRurMlumO
         C+snstTqIpyI3G3faXC0stcH3ZND/vEEWvG/4us0ieLi5uvL3cyD0plyG+To46lRrDzk
         6awA5SzBNS8ZUfqJp0XadCE+04qoFKRzk6NKK/la9LepjyJhtRifUzqs8DkiOfWD/wMM
         8hMQ==
X-Forwarded-Encrypted: i=1; AKwUvBxiMGzb3c7NoS10iZRvT8qSwnrT6tAEelU5Oc6qkw6u9Tmd7UniAyb+xZLed+91OHqMrPjGB6iA6bo=@vger.kernel.org
X-Gm-Message-State: APuU4Z/wahO3rDJOXTNaE0COZuNjaQszihMaFHoEp5agSQpgWW9lv7H0
	FxwAzauEtDj1mRUA8uTu+HqqEfHnkDclw1FVp1o1V7M9sHT26o1G6hXdyFRnwLh7fUc295Orqml
	FpZ4GXNGLB9NfJv1Syxtf8firjt3WoR6WjJasVARe
X-Gm-Gg: AYBFou2oKxCdbgRNOZ1kpoo+DXIz2SSbyGwomYVODua7GZ5xRGI4vj0JIhG0cy5RMok
	gG/VSsU4Trbk+hoRX6rYJpLvJLhrt9x3z/8w4GXwC3yGAOgnDvhfW+Vkg9Kyew66wcP418BzPtp
	A6HVOHwl4QSJL0/yMNFyFVNH4GOSqviPkLb01GYk92fr1Elb1o3EQkr4XP6I1bTcnUb/0ggFAV+
	maDvuRDniwNtSxEtHxw00HFxnGC1bTleHBePVk2wcw8ScdTE3In4dqfP9GEKOCaxbkpU3oiTb3C
	LdZaV3TBvu1S1bGXP4StsYR5vK5Uw9PxzyQ0oyOvOODS1LB0feOEnlWPjBKb4R/fbat375sePsF
	m/7SlfxyhIWrRNHpevoY7kICHIHGthElDeA==
X-Received: by 2002:a05:6512:3ca7:b0:5bc:e8b0:5652 with SMTP id
 2adb3069b0e04-5bfd9589099mr5147409e87.63.1793731080985; Tue, 03 Nov 2026
 10:38:00 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028221705.3915340-1-halg@google.com> <CALCETrW9ygriu54gxiHFLEd5+hJminQo0r8Jwd63wR69Dj4W7w@mail.gmail.com>
 <auM32mOlBLu6ZUlt@google.com>
In-Reply-To: <auM32mOlBLu6ZUlt@google.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 3 Nov 2026 10:37:48 -0800
X-Gm-Features: AclHuK_sfbKF658HbwyCTsOToNn9cXs0qzXn8uaPUG4vxi_nXA5hXmjvbt4jwHQ
Message-ID: <CALCETrUD4vh_iSHV7G0bprUFU8=c+ECo701-tXcbQ3UXBWC1ig@mail.gmail.com>
Subject: Re: [PATCH 0/8] userns: per-namespace capability bounding set and
 opt-in netns loopback
To: "Hallgrimur H. Gunnarsson" <halg@google.com>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, Kees Cook <kees@kernel.org>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Jan Kara <jack@suse.cz>, 
	James Morris <jmorris@namei.org>, Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Jann Horn <jannh@google.com>, =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>, 
	KP Singh <kpsingh@kernel.org>, Jonathan Calmels <jcalmels@3xx0.net>, 
	Casey Schaufler <casey@schaufler-ca.com>, linux-fsdevel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, 
	containers@lists.linux.dev, netdev@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 29, 2026 at 5:11=E2=80=AFAM Hallgrimur H. Gunnarsson
<halg@google.com> wrote:
>
> On Wed, Oct 28, 2026 at 03:56:11PM -0700, Andy Lutomirski wrote:

> >
> > Why should the task's cap masks affect this?  *Maybe* cap_bset makes
> > sense, but I'm struggling a bit to see why cap_permitted and
> > cap_effective should matter.
>
> Sorry, the phrasing here may have been misleading. Just to clarify:
> none of the creating task's capability sets (cap_bset, cap_permitted
> or cap_effective) are used to restrict the new user namespace.
>
> When I wrote "reusing the existing task cap_bset, cap_permitted and
> cap_effective sets on namespace entry", I was contrasting this with
> the prior series from 2024 [1], which proposed adding a 6th per-thread
> capability set to struct cred.
>
> In this series, when a task creates or enters a user namespace, we
> simply initialize its new cred->cap_{bset,permitted,effective} in
> that namespace to user_ns->cap_bset instead of CAP_FULL_SET.
>

Okay, this makes *more* sense, but I think it's too weak.

I have a sort-of goal of having the creation of unprivileged
namespaces be allowed in most contexts by default, *even in Docker*
(which would involve the Docker team changing their default seccomp
rules, but that bridge can be crossed later).  (In furtherance of this
goal, I fixed an ancient bug in newuidmap that gets us quite a bit
closer a couple weeks ago.)

But tying this mitigation to a parent userns means that it's
completely unusable in the single-deep case.

I do have a question about this whole scheme, though: are we talking
*just* about CAP_NET_ADMIN?  That is, is there any other bit that has
anywhere near enough security relevance to make this kind of thing
worthwhile?  Because if it's really just a single bit control, maybe
we can come up with a nicer scheme.

--=20
Andy Lutomirski
AMA Capital Management, LLC
