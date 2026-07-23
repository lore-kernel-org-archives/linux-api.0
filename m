Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6B6470438
	for <linux-api@vger.kernel.org>; Thu, 23 Jul 2026 13:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784814836; cv=pass; b=kAduNjmEQyWZK+Vf0dPDzQkYTsyFzVCBEcLPmSbgZO6v1VblH/PNLIr8frUzS1fXgN8IMvA5rjxv0M9FgkwxlHDjZ7yL/ZwNdAQ5Ikagi7XMU1jU/sgQYk1Qs6kEPTzVcSukLVP0TJDiVpTQz90q71pu23aAV48NR0qO5ch/1lI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784814836; c=relaxed/simple;
	bh=+2YHD0LYLDY85VIis/zdXqssptfCZG80ADhJvUZVeOo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Jhqxz1kg0On0Q8TP3NpwQZ+aNJlPjogKONHbsR1147OVc5ymDrfwRg0yodRL+Nt0pfVZLQCmj2c0QidAeaXuAYEOn/D5Jun4gmopsqw5lZOOWvfct6ssyjJ+DnQhdOQScPflYyPwbg9ro7mCZ9C6tY0jxgEOHj1gruI5lXcKNew=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b=TCOs5iNH; arc=pass smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b="TCOs5iNH"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-39dbe684115so3896241fa.1
        for <linux-api@vger.kernel.org>; Thu, 23 Jul 2026 06:53:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784814830; cv=none;
        d=google.com; s=arc-20260327;
        b=BprsOCeMwXQOn7pCIyGS6UouhqO++6en9fi1mB21iSBLG52BBBXeXxwEBjGMdLSdU8
         y42P/TVuU3URbp2iawgnNhva3tjTgFqUvIokmwsyGX/0vNSwRSGOcauDxdwfxhYJ3V55
         cVZIRE1lrvjA+Q9f110BcVNYzn5VIzu2BEjGWgsyYu9cZBGud7RFA+Qybm+wpW5wNZ2/
         2pVetaeKdQTHzmvC6CKe007OaTuxD4sWKER/oMu3JK79+qhyGEygd6I1xlwzS5bke+JJ
         vzKJKVkOCQIf0rkt3aSw/+BT2WWtthbQjIulDIPDpLuaWwVO8boO5+TUYIHGVatUgxlV
         bANg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/Qvp7W6WcD3MjP5gFX1gpVdJqvDJJ2Ad7xiF0QUVglM=;
        fh=HwWIAWB5QM6+IdhBONpSUC23SSfLcVDqhsgEMlGelEI=;
        b=Pbtu/n16aiHzOkqOsKzUDka7w+8CU0/IMEzZYurCG9/DIAS1rodcQqkv7DjpMFidmy
         ZVpySXtF7FlGBWzElWIR2DrPau+IOTv6WayBKleDgPkKfSnzOHMkt/OjWUEFkus8MyuL
         nptkwj6EKwsNG7vCoPP8Su2kx4Yp+wbK8ivkICsUlIKd1HO+PmbhvAYmYFOK527cqBht
         z9ZZ5LkNdqsRFCiGCjK+Bn2Rs9kz5SLqWl984m4lqgWyCcXtvrrPVKYGZ7w2mBrv76E0
         3zKZt6UKxje2bSmH3l5BVz68dL/fVGE4/5kJ3nAapa9f8014HVByJ5gSitbAzAWlpgW4
         ICaw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1784814830; x=1785419630; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/Qvp7W6WcD3MjP5gFX1gpVdJqvDJJ2Ad7xiF0QUVglM=;
        b=TCOs5iNHvbsl5X6Hfo62GvD27H13zYc3QJBzwYLSTICTXOBhF+lI6AkcUI2dFVsJXD
         g0aLU8WncvBsbZ62FIBlKUXFEO7Tu+S95BeppRX0MknJBoAQZQ3EwjArRLoPNqeaDypP
         9UwvodURNnpiXFe+1QTHM4jgX+8zxNyuCl/XE7AFiX7+VFHORmwYBps6ke0M/SuvlTYs
         bx5yPZU2am6Xoh0JYP4JqTaQIWPTfQOXgVtq/1WpN443Y28g6w32TJxwhfQLNjx3K6YP
         UGjcIy0Om5nIufS5anzRnOLL0rLP39PjNDn/093CvY21UINr6LQYaq/3YLQeeXZ78o8V
         DEmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784814830; x=1785419630;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/Qvp7W6WcD3MjP5gFX1gpVdJqvDJJ2Ad7xiF0QUVglM=;
        b=Zwik4O33DjU2LwDSAIoAKtpIYL/12omlNtBL4tcQbRy3lGa/BzWjNuQcSoIhxtYOte
         zJ8Yd5nW6UGTktRyWRp+dhC1+NN1pGlpMVINSiTlNpzQ7CqqylhjYChyuEBYO7oLN9dM
         zp6yc8kYaaSpBNXPzJgQ+W0T6qwfvF1Pp0OlhooVxpsGtFsmy/8wBnao0PwlTbRraypO
         Z0TKquJ0hphUPVlXwk+ls99Bgs2QSkA2zAYJ97Xy/2ChD31dVWaTZMx4RxEIrMB/HnL1
         85TD2bWVNpXth0J1kb6HKtbJ2OagyxC7SB6kN762lw6R7YvcAMfs/hQvrf9OhRs9W0yX
         o/Og==
X-Forwarded-Encrypted: i=1; AHgh+RoeOkJp9zG4EiQal5Uouu9DGwckesPzhE6qS4wsOjsEE4kf8keA4NcNVq9OPR9kLkUgTE95iu6rJZU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1sgFMouO6FTIxgiVu0w/m38feYED/tWqxpwgcord6nQe8XSZY
	GOwtWEJfO07Gr3bG5eIIdmc2mhQRBIQHhdFYuWkuszfnna4jzWf0Vbf2plQYbWcf93i6BJC5qcd
	heH9tdEJraNHKp2mR58cuj7yzMcbqvyX/OCb2eIpj
X-Gm-Gg: AR+sD100pVs/f5G0v4CHXPxFZU0xdtqlpZ6ri+uWOEYzixicZOvHwtnVtovcWWl/EJb
	NbmyAzDrvGfGuydJ3xaNnxWa7DowySJ+v/9jWg4NbCyDDvKsvo0xjs+uuQz0EjCSQE3n4gwC00y
	c2WgcMUGvEgPu62wRRj2g8Dk5IhILYoJGCBdU79jwk/B8F/lwHFAq2NsEr8nj25WPHgsfEvSSMc
	cdIB9zBc4rYMjTqhAZO8i8fCOjmXWcphKRFBnU5Sh3M0DbpzWjPsEco0WzEWQ==
X-Received: by 2002:a05:6512:ba9:b0:5ae:a9ed:35a6 with SMTP id
 2adb3069b0e04-5b2b33cde5emr603977e87.31.1784814830282; Thu, 23 Jul 2026
 06:53:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJfpegupwNTaVNZtdQTmvtz9x=ehH59hzsRT7D0=VbhOZvaqrQ@mail.gmail.com>
 <6C96C8A7-345E-4388-8EDC-D94E9463D214@amacapital.net> <CAJfpegteZbnPkiTSAPWXDqZbf5eALK0E_npBLtLTmJyZaHXdyg@mail.gmail.com>
In-Reply-To: <CAJfpegteZbnPkiTSAPWXDqZbf5eALK0E_npBLtLTmJyZaHXdyg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 23 Jul 2026 06:53:38 -0700
X-Gm-Features: AUfX_mwpGfNjVX76f8of_9AJftpdKTQtdZGp4l8jZIXndq3Duzeb778fccyzEFg
Message-ID: <CALCETrWCf67TTiRSikTjgBZ+jKc_HPptEp9BvO2G=1-C5D2F_w@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow opening overlayfs/erofs layers through O_ALT
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Christian Brauner <brauner@kernel.org>, Miklos Szeredi <mszeredi@redhat.com>, 
	Giuseppe Scrivano <gscrivan@redhat.com>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, Amir Goldstein <amir73il@gmail.com>, 
	Xiang Gao <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2026 at 2:19=E2=80=AFAM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Thu, 23 Jul 2026 at 11:01, Andy Lutomirski <luto@amacapital.net> wrote=
:
>
> > - O_XYZ flags to open() are all kinds of awful, for historical reasons =
that are not fundamental to the concept.
>
> I'm fine with limiting this to openat2().
>
> > - symlinks. If we have a new API where opening /proc/something/magic/bl=
ah can access something that ought to be inaccessible when accessed intenti=
onally and with privilege, a symlink pointing at /proc/something/=E2=80=A6 =
can cause the API to be used inadvertently.  Admittedly we have this proble=
m with basically all symlinks, so this isn=E2=80=99t exactly unique.
> >
> > - our nasty fs permission model. We gave a sort of gnarly mix of a bit =
of fd-based permission and mostly mode/ACL-based permissions for path trave=
rsal and opening, and mapping this nicely only new APIs (as opposed to actu=
al files and directories) can have unpleasant results.
>
> Pseudo filesystems don't usually do mode/acl based permission checks.
>  I don't see any issue with that.
>
> > Of course, I=E2=80=99m busy arguing (slowly and without a concrete prop=
osal) that we should have proper capability-like fds, and maybe that=E2=80=
=99s kind of an answer to this:
> >
> > What if we had an API to get an fd to the =E2=80=9Ccontrol filesystem=
=E2=80=9D for a superblock, like your O_ALT but as a real syscall or maybe =
only accessible via one of the newer and less janky open variants?  And wha=
t if the resulting fd and the filesystem tree it represented had a few prop=
erties that made it very different from normal directory fds:
> >
> > - You cannot mount anything on it or its subdirectories, nor can you op=
en_tree or otherwise mount it anywhere.  But you can open_tree the very spe=
cific things in it that point outside of the special API (e.g. the overlayf=
s layers).
>
> This patch provides exeactly those properties.
>
> > - Privilege is fully captured by the original call that gets you the fd=
.  current->cred is not checked when *using* it except to the extent that y=
ou might need privileges over your own namespaces to do operations that mig=
ht affect them.
>
> This is trivial to add to metafs: just store a ref to current->cred
> besides the path.

We have f_cred that might be good enough, although I'm not sure it
propagates through path lookup.

>
> Not sure how this security model would work, though.

If I have CAP_SYS_ADMIN and I open the metafs and then drop privilege,
then I would still be able to do all the metafs operations as if I had
CAP_SYS_ADMIN so long as I use the fd I opened to do those operations.

>
> >
> > - You can=E2=80=99t fchdir or (hypothetically) fchroot into it.  (Not s=
ure how important this is.)
>
> Not sure if there are internal mounts that have directories?  If not,
> we can just add a check to fchdir/chroot against mnt_ns being NULL.
>
> > - Maybe you can=E2=80=99t follow /proc/pid/fd/N links into it either?  =
Or maybe that would break CRIU too badly.
> >
> > The basic idea here is to try to treat it like an API that happens to u=
se the open machinery but not as part of the filesystem hierarchy.
>
> I'm not opposed to limiting this in various ways, though I don't
> really see the advantage.

I'll sleep on it.  Maybe it's all fine.
