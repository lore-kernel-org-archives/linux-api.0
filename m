Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.167.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1794077276;
	b=LjHCcoRXPwS/JBKAuM1QRjf+YbPCUYqO9mlFq35OhqLrvGcj4/xY8SA68rCGJnK/MYMc
	 39ahvRkAa6lPGyY379iFQaSuHdfoMnQH84wyqHJroYdrTfVCX0QTSU1d3JQKRIOWnHstV
	 IvrxfExnWox29hO7aAosksLoIhKFZLbJjL5LaqA84Pz4BC9FsmV93ElZWAB0kU6x5AtvY
	 XZJ1K6GqCkm0L6GJp9LzDOJpmFBmkBoLV9YkuaiA6W5/BvW5aU9oqQaUc+SDVZSXOJIGw
	 T1/Q+DHP8OOm96pUZp2uPDEUVQgBajPz7ukuVMPTX8ng9DunWj7Nm7w8+xlE7hyZ36w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794077276;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=DWojXY4nDMT9rtwg6h/b477SwUuLPC3ITyeb/WPBYqc=;
	b=BDIzdEolQjStyJDNWhJtNabw0i7bi/8wjw3MewJQtShCRYtJSzDW9dOk0xPDvIcbcCzX
	 gaYCIoI4KXqFVltoFiZKsi5eSjHL+/zpY5Bd+HNjImNjoF/wZXdq8LADW7+2VlzKjYoY4
	 QxspfhL74jKqZQAIel4Mv0d8slq1a/22piparOLPzPlnx5L2qTaktqsgtIaEtPm8nDrVs
	 IT6xZ/eSHwe09+uNPZbgAMYlN7lskz4t1u4oWfufpgtYUY+9rPyPdDc/Xomczrsvvdnk6
	 1PURdiEGdIgbJ5NZ+CEUaaX3KhzNqOLz8jh2AqoEbFj9BzwjPJFVRhWbz/oFqY8nOtw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=amacapital.net;
	spf=pass smtp.mailfrom=amacapital.net;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=jDsWkgNe;
	arc=fail smtp.remote-ip=209.85.167.44
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC54D606A32D
	for <linux-api@vger.kernel.org>; Sat,  7 Nov 2026 18:47:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC54D606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=jDsWkgNe
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5bfa65c8617so923628e87.0
        for <linux-api@vger.kernel.org>; Sat, 07 Nov 2026 10:47:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794077274; cv=none;
        d=google.com; s=arc-20260327;
        b=WR2rUG+EeGNFrjpspdj6rYpr7bmHB927b0EtK2+ZW3meOdWEzl0vWEEm3d6J3VRI7q
         X69JuY2XKxrnk6WoxVBRY/z0UCbRHLqsYZYBVdSszYlIWwkr2Sz4+pDCtLmbxphQ8CaU
         CMZnDRYvSw7/f5kVranVzZwDeWDcyufARJB/x2qQDOLFj+cSY5BPtQkEopWPf7vg1ZXP
         6GBfKrN54Dxi4Ja8qrofw/Vb5jyoPX7aF3qouzXSC0zjN80e/RHgvE9Gyw6IwOHx2G0U
         lFUb+JJh8xoj14mp6KK0PNP0HUvzzqlDgg8gbXps6v49AQxCAN0JYuR7KpllEWA92Xkk
         mF/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DWojXY4nDMT9rtwg6h/b477SwUuLPC3ITyeb/WPBYqc=;
        fh=8UWrfl5mvCzYzvJYyTQsdF0tEyu30yoRufY3VJMQ54U=;
        b=qtTiMaE1fhvPWyuZKkSvI1PD8RD8bFIWxZP4mkjRN1e8sKDj9AfLJUGxlK4SZ150qX
         0tuygND2dQjF4ilPcR/xVXJRejOm8qe0uv1em06tPAMYm316YiiuM2LfU86AViRIcdxG
         EEbpmUkA47moRc/z0kH3aGylriuRwMZgU3/u8cXJzrMI8WW6WkPbTWcmDxPhicScotJo
         C2KavqnVnv1CtUq0fTc2ChnA64zo9276zJgF77RkZVddKuCNqWKVkkGCLbYUvKXVDV5U
         oaMGbOuVNmPeNGt7u/JVgr+wfYHcrQweoy0ujSybwvf4YcR9tpNmBjeeGo8j4AQ0YcC4
         Ecaw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20260707.gappssmtp.com; s=20260707; t=1794077274; x=1794682074; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DWojXY4nDMT9rtwg6h/b477SwUuLPC3ITyeb/WPBYqc=;
        b=jDsWkgNeFsbdQ7qKqbpHSGOmDkfyI4OzDS2pJc6+Irn0QHpBxG9wPbmRTDmNnDdzS5
         db8t7KSVAGcHE/QtRbNhFDCWnX4uqUr1mEeZuLglr9YUDK4k94+gZZ0e2v5XDqaLBMAu
         GF2mKtLq3tPj9IBZGN3w1gGTAF0jFrsZMFCKcXAmKrirJiOIjEcuysNg1l24IqICP4gV
         r2UQCTmuYiVAi+q/1GU8UDVYE1+IZodom/D3RIz9GtMMMdasHTqHTXmlylMP0IcXnVJO
         5lWPTzglrmuISOXtwRoPqefa1QyXnIQk56sGTTb2Rf1nGsDNJzcZ5BPRF2XDpKcZZ3TD
         g2UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794077274; x=1794682074;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DWojXY4nDMT9rtwg6h/b477SwUuLPC3ITyeb/WPBYqc=;
        b=B9ql+p2NEJ1mxqCDEjyitaZPb/DtGb18CAhJ59QOAlXihPQ8iINqqIcvHZ8oQ7jG4h
         44UZI3bCwQHyuE57gI5mIIhMJnFaeGcIH8pHzVcs5IDvdMu2IjRugAwJMJ2m9ebx2nHu
         OpISDZRDWEzPfyBIH2Ce06P6DTTauS6dUbqJROxN90roHUk8mTMmToIayB5meZh+sijN
         IKbSKZy2tDm064LJu2VZI+9Cuzkz37TgGfFT5oRwrSb/5TjWbLIXAsrQeOmJ+pr3FJcB
         cdUXLft1bl9zAfjIt8B/M4fykrqsE8XhfeShcVfD4olwKed/nGTxk3+BXGoF/NQ2jAip
         qrSQ==
X-Forwarded-Encrypted: i=1; AL+hErGf3YY4hNInCr/yMYAqUgFP/Y4DRhMUVbuCeZeKynie7fOZh7I7JdQuDTnPxG8YibkyWLFWsweCt/w=@vger.kernel.org
X-Gm-Message-State: APuU4Z+KjV86z5l8YNg2vXO9ufkoMz5oPS7HyvX2GGCclQg91FzUEuQ1
	4bVMz+0OLlx1dYaFCk6jIaUuAiyQOwPsZJu0Hy2EESx6Jrsmfkd7GcWvZB2VI8JZlJkzjBDaSgD
	XhFAURFLhZImweqPpSZDuvtP90QAYsUfOegKfr68Y
X-Gm-Gg: AYBFou0ZNWMtH0GLUvc4uMfVK8x5illh9zG0Tuw446grbUlSz9mW4EU98FOKHAHUUnh
	lGj8B4F7Spxq4f4H8SE+IDhJfLgSQqKGYIhAaHNycN29zgsKV7C7v/eYxr/p2U0jANBjh0CWm/Y
	zwRqTJlsCEppcKum72pl9folxjBUdDyh03w3OltEQJLHrdbaBvgVkW/qR221iQCM9isDveoMW6K
	+cj3fm4MhYhpSgdsRLXh3w2ZkRqXCLgc59tP72FPtHx0HL/IaqdRmZHjUkWPQ0SWkvb3de0j0Sn
	VdKt72FwLgKcn2fTzl+Up/sYThdt+deOgEPe2Kznl3Qs0YkpsrxZ7sFdBT0GC1zOs3NCxa9OOz2
	QX0O6NhjAw310tbaFc0StwqHFZnfuBneBfQ==
X-Received: by 2002:a05:6512:291a:b0:5c0:ca1:9dd7 with SMTP id
 2adb3069b0e04-5c00ca19f2bmr594320e87.35.1794077274068; Sat, 07 Nov 2026
 10:47:54 -0800 (PST)
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
 <20261106-befreien-addieren-eislauf-e09212803534@brauner>
In-Reply-To: <20261106-befreien-addieren-eislauf-e09212803534@brauner>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 7 Nov 2026 10:47:41 -0800
X-Gm-Features: AclHuK9s0dgg3FDVqp4WbjYQnA0hebDpEpxOAgz_VjLjRP_HfRjeTpRH9DX274k
Message-ID: <CALCETrWa1SBLcb5oWjqjgzZvKvCoHjmYFk=Lf5ytEM9uqm5jYA@mail.gmail.com>
Subject: Re: [PATCH 0/8] userns: per-namespace capability bounding set and
 opt-in netns loopback
To: Christian Brauner <brauner@kernel.org>
Cc: "Hallgrimur H. Gunnarsson" <halg@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
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

On Fri, Nov 6, 2026 at 5:13=E2=80=AFAM Christian Brauner <brauner@kernel.or=
g> wrote:
>
> On Wed, Oct 28, 2026 at 03:56:11PM -0700, Andy Lutomirski wrote:
> > The whole unshare/clone flag situation is getting out of hand, IMO.
> > And this new thing makes logical sense but is really about reducing
> > exposure.
> >
> > Perhaps we should instead have a small list associated with a userns
> > (extensible in the future) of things that the ns's admin (i.e. whoever
> > has CAP_SYS_ADMIN relative to the ns) may do.  That list could
> > include:
> >
> > - Create loopback with sensible defaults for ipv4 and/or ipv6 (i see
> > no obvious reason to separate them)
> > - Create tun/tap interfaces in that ns (and attach them, etc)
> >
> > And add a very simple new API to do these things.  Actually, the
>
> We've had this idea in the past and I think it is reasonable. I had
> always thought that we should expose a system call to create empty
> namespaces ot any type. Usually I'd be excited about that but I think
> that point is a bit moot and I'd really like see whether we can turn
> cells (or whatever other name) into a first class api.
>
> The problem I have with the patchset as written is that adds a lot of
> moving parts. And yes, I find the CLONE_* and UNSHARE_* flags plus
> sysctl to be suboptimal as well.
>
> So the TL;DR is that CAP_NET_ADMIN + userns =3D
> CAP_NET_PRIVILEGE_ESCALATION 10+ years later. And this patchset wants to
> put it back on a leash.
>
> So why isn't an aggressively stupid solution to this problem to split a
> new capability out of CAP_NET_ADMIN so it covers the absolute minimal
> set of things that should be allowed instead of doing effectively the
> same thing but split over multiple apis?

Because we don't actually have a clean way to make a list of
privileges that are, in theory, harmless but are hazardous from an
attack surface perspective and assign them only to tasks that ought to
have them.

But maybe we should invent such a thing.  It would be very, very nice.

Other than that, I agree with you.

>
> Anything that is reasonably advanced should not be the kernel's
> responsibility to delegate. I really think the old privilege model where
> the kernel grants control over a whole subsystem is inherently flawed
> and is much better replaced if you have the means to let userspace
> services grant and delegate resources.



--=20
Andy Lutomirski
AMA Capital Management, LLC
