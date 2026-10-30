Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793372065;
	b=P4cmxOEgvaUXRuqgkiPhK1f0VIupw7t2Het03LazZDOGH91bIRHi0/yGztRCjZ3/1MVG
	 Kcn4TJk44xKUv8Up3w8Jaz6eYaHA3X0Qq/7m/gKHNugi84XDx5+aiqPZ5C3E3ZI0OvJTO
	 40wEESB4crsd3z9slr6ucR6V9jKOxsWh0zN0KlK3E+SnLoh5YYUS/HNLpM/EJCgIHH64c
	 tPULGDeVqld3pDbRETuVXQEs8LyfkW0bkLBq7PXJ0qAAMlbQA4sQ92BfWrjagEsNIG+9h
	 8q0VpIt4YQCM7+LhzM+hdXkpPs57vc/YC9+EueEJStotEHc/p6NKrVL2wmbulXyOGnA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793372065;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=jMsUz0CmedXWqrdh2TheB4BjYFtAJcIsl6CPDLvVdyA=;
	b=EI+IuyQaQXEoQGxZwP2GWzmzhQdsnqaGJiM6dPB/ZTUTl0h8Xsrzkoeka1kAbsMMJVAP
	 AsFvmP8hHSBxeEnIDdg598l46Lg8LXngaM+09TmYo0VlcZmiCY8+rZqGh2Kfbv0epb6e/
	 fqzKDYNtg1AW9p6g3EhBLF8hG1AXp2tgwPuizAMF3z+9exi61toZk04OlQu8QBTe2OHfI
	 GXPyyOhpwZbw6d1SbYzKu5ULo3LxyExSPbiKl74kect4GGCicYwvKH1N7A48uLmaLkJBx
	 IN/Aq222jiPffj6mp7t1/p8C8Qrb7vfWsaU7i4tHGnvtY9a+WnjFS9K1xRW03tP2ljw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=amacapital.net;
	spf=pass smtp.mailfrom=amacapital.net;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=llSAjB83;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.53
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C43606A31C
	for <linux-api@vger.kernel.org>; Fri, 30 Oct 2026 14:54:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4C43606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=llSAjB83
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5bcb0f245e0so797744e87.3
        for <linux-api@vger.kernel.org>; Fri, 30 Oct 2026 07:54:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793372063; cv=none;
        d=google.com; s=arc-20260327;
        b=o4s0OlHz/iiTKfYSGLGNA2uCbbATMsK+vlTaCfJpu9M/nvLAk3XsCq8kQutgvRk6uA
         Agp5av9AdgH4bf3rwnEJa+L7DelwcCpkTdA5PaA3Ygla51PYHIbg5JliWCYgnXluBTRX
         OxTTWhrxs3z/qDg5mWv7Sm/F/sGw36ZXd6dJ//wifGygUR37y/9YSY+MAPRz2VndBYqW
         JFLUqCzFYjoHmiBJZBewOBKwGX3CurRsWNf10aBbCJdQ7qkLApyRtU3LsSzjOmJVw1Eo
         onmcihjpoDSQvb3l/C40ttJSJEFwXQnaoBxLgySEypKIgHW8Mpg8JzvMIzs0g0FawGrd
         Ihhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jMsUz0CmedXWqrdh2TheB4BjYFtAJcIsl6CPDLvVdyA=;
        fh=CRtDCB9f85XNfwBvmLiEc8nzUUQhresVDpA5y+EEAk0=;
        b=EWoE3aRbjVCHighU8vwdS9TtAxnaE7828bAqqru0tY3dVJ06N6d8Yh6jrheMbZ6c5/
         OkB5TJ1Q8Yt78c393ZnuMiN0QHLBhUjg2hrYHvcNxNA3PGxoQR44dgGj0t5jBlBzGbji
         cDhT6wZwlMHs7VjkBLw5LpH91gKoPlioCzOT1cvxrH6IfWYQkavJTutGkO3vN+0gsJYz
         lueKoLmmyrJC5xgpO1BLm06DiavpMoIXUKyN80UgLmUm6jtHLwigWY0XGNkPOWFli4tJ
         tiBQp3V4L31KY7dBOr3v4SW7h296WAoQ9fq9qIC+KiiMDtg9lXUTslIRn9pL/P4G9S/D
         heXw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20260707.gappssmtp.com; s=20260707; t=1793372063; x=1793976863; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jMsUz0CmedXWqrdh2TheB4BjYFtAJcIsl6CPDLvVdyA=;
        b=llSAjB8353GhiWJmW3lo0k47FpkVKUdOxkuIOEucyL686RRVtqlcVe+w6TaigBAncs
         RuBiEjJ5RrmdukHl9fbglfLqkd2Dg+gjSdyMfUNinYhI7lTg3SjhAWHlmdLd+D8lytl0
         M1Rn3HwniQdcK7QDZQC67l3ULytWecMDkddi/H2Av5rBgVEioLJ5lIUl6VdFcNi8F8Di
         ZlrBvbaHyHBGra4g6QxFHMA0e8cVrMPmfnPiJB8gTSMYPlzsJT2zqxQo9dExYOy/fmGw
         DBqyFbwKfTBpdLVueOJy00qtFaDWF4VRQSHd1hnmI3eyBv0v9uPa3/SYP6vznJSqPqAm
         FduA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793372063; x=1793976863;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jMsUz0CmedXWqrdh2TheB4BjYFtAJcIsl6CPDLvVdyA=;
        b=sS43/Csu6fhNK3vpBhSWXi9v84lc6P4GZHmsoEjZJKDjs+HbBB5nTnp40UgUXVEDHk
         ZK0GiARuhmLUrLESQNk/0PGg+Cdp5yksskvQCCQmvvVf5HeQc41FO96GkGlNl9/z7Je3
         IcmXaa6poKG0HCF9fbNqeTGIWCRlYnL5KxORvThzoj+tYfPnyetO/BaO7pH4JNzqc4+M
         KzD8Vxit3kxoQsPUDvlokbVkkmc8+/m4P8Rrh7kvYAwfD+fD0DkbIrQm7ctQQX9IqR91
         bezbiyVta9TlFEhWeIr4/G52SJJLJCLV+zAU+lpjqZD2wVQ8YpU+hjeH++pzyeRJNV6D
         QSkA==
X-Forwarded-Encrypted: i=1; AKwUvByx+X8u35Z7RsLmC1w/N+CMAZpGI0iEK1z6C+8/SOVyqOQN44etuslv7286h7hQFuFaCyHWOezVBy8=@vger.kernel.org
X-Gm-Message-State: AFq9FYIU1pclaj38nenzDnLQ2qbMbbs6j7XYpTiFY6ox7VxzPEWpINgE
	0iUbYYvrU6D/0THf1SAI0mMGAbDCog96OF5ixAadZxA6bgdS7DT46m0Co+PPzxxbR+flor7Po+m
	P6yQE10vdZwrHyd6wO/8yHTbk9Xkz4FyFh1f0FgAq
X-Gm-Gg: AYBFou2Yhds8xBf8Eon3fnlYemlfb2lkXjWfMjLwCSFF9CbGZ9Kf9wYAMikcD03cnsj
	H9mkSB4RVFQThKPJed0DAfF/vor9cQ2xV/xmUoMbd4vEGVgOSYC+Wd5i566ujL+rdTrF7T7Hw3V
	TViGgIevup7DzIjTHmIqeMImrO8KHxkgJrwum28SAYvZPMvSDzJxNgegEmhHLxsi+5+EW6pFApK
	NvdQnda6JBc3F40NWfXMWm0S5CtTTIOPiqJYcYSy5A1ry9si42CclkHl+6tXPRtXUetKzDlu18w
	AfyVaSjx/ieM2g9D0zr1h4vLDKpNqbYsws0W4aGB47648WfdkkkGU4ghAOfTEITBCwy8OiPcP+5
	xafxzasxix+EfYJNN81KohcQqy3wSnBvGsQ==
X-Received: by 2002:a05:6512:3402:b0:5bb:7b2a:5b2d with SMTP id
 2adb3069b0e04-5bfd9566d37mr824353e87.35.1793372062806; Fri, 30 Oct 2026
 07:54:22 -0700 (PDT)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261026220546.3114241-1-skhawaja@google.com> <CALCETrXNEWQNPjtuHnTfVFOafeJ7APXq288Cq16Q5adDNYx9+A@mail.gmail.com>
 <auEksxfAi9lHFXmT@google.com> <CALCETrXDY2e8x2kdr-FQvFLs-Y7FwNozXGDvqqM6yvVA7QLV3g@mail.gmail.com>
 <auPKfqh_YjRU9Ui3@google.com> <CALCETrUEyfvaEGxMHo=c0ia3CDgSxg-YW0_=Z7T31Ou+pvicuQ@mail.gmail.com>
 <CALCETrVpEP=HxVqdSP_AgA=U7ignwAgjz5Vi9+Z9dZsX5DXeLw@mail.gmail.com> <20261030121259.GC3889730@ziepe.ca>
In-Reply-To: <20261030121259.GC3889730@ziepe.ca>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 30 Oct 2026 07:54:08 -0700
X-Gm-Features: AclHuK8DrMlKsyKpQjiDV0_C05DMTWGTaa3ilPqU973TM9OhhHNjeL5jGLxSymM
Message-ID: <CALCETrW6RUgTGFuqx+cxV0c+Oq4d-P5C8AQ2ja0ESMP_8JGpxg@mail.gmail.com>
Subject: Re: [PATCH 0/2] mm/memfd: add F_SEAL_PUNCH_HOLE
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Samiullah Khawaja <skhawaja@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Jeff Layton <jlayton@kernel.org>, Chuck Lever <cel@kernel.org>, 
	Alexander Aring <alex.aring@gmail.com>, Shuah Khan <shuah@kernel.org>, 
	Gerd Hoffmann <kraxel@redhat.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	Jeff Xu <jeffxu@google.com>, David Matlack <dmatlack@google.com>, 
	Pasha Tatashin <tatashin@google.com>, linux-mm@kvack.org, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 30, 2026 at 5:13=E2=80=AFAM Jason Gunthorpe <jgg@ziepe.ca> wrot=
e:
>
> On Thu, Oct 29, 2026 at 07:11:25PM -0700, Andy Lutomirski wrote:
>
> > I can't shake the feeling that the problem here isn't so much that KHO
> > + iommofd doesn't like this but that the behavior in question is
> > nonsensical.
>
> It has been this way for ages, like David says if userspace shoot
> itself in the foot it should not be surprised by this illogical
> behavior..
>

I dunno, a couple weeks ago I tracked down a 20+-year-old bug, and now
it's fixed :)

> You can get the same nonsenscial thing with just mmap too, you don't
> even need a memfd.

I feel like there are multiple levels of footgun here.

mmap anonymous (or MAP_PRIVATE), pin the pages, munmap: okay, mmap
creates unnamed private memory, and munmapping is maybe like unlinking
a file -- if someone else is still accessing it, it's still there.  In
fact, you can mmap, fork, unmap, then mmap in the same location, and
your child process still sees the original memory.  It's not clear to
me that anything is wrong.

mmap anonymous, pin, MADV_DONTNEED: okay, this one is starting to be a
small footgun.  But at least it's pointed at *your own feet* (unless
you've forked, which in which case maybe it's pointed at a related
process' feet).  I would still argue that the kernel could notice that
it's false that I "DON'T NEED" the memory and fail or ignore the
request.  And the kernel's pages are still anonymous.

mmap a named file or memfd, pin, truncate or punch hole: who says the
footgun is even pointed at my own feet?  If I mmap a named file,
SCM_RIGHTS it to you, and you mmap it too, and then I punch a hole,
the rmap machinery had better invalidate your mapping along with mine
(and get the TLB flush right!), and it would be an unambiguous and
severe bug if this didn't happen correctly.  After all, what you have
done is to assign a *logical range* within the file an address in your
address space, and nothing I do should change that fact (except,
sadly, truncate, which can give you a SIGBUS, but your vma still
logically refers to the file).

So why is the kernel exempt from keeping its own mappings coherent the
way it keeps user mappings coherent?

What if that memfd (or tmpfs file or whatever) is shared between
multiple processes that don't trust each other?  One of them can cause
it to become incoherent from the perspective of the other one's use of
kernel APIs.



P.S. You can access the offending APIs from a VM guest using balloon
in typical implementations.  If the host userspace does not strictly
enforce that the guest doesn't balloon memory that is not ordinary
host memory *and that is absolutely not in use for any sort of
kernel-side pinned-folio IO*, then the guest may be able to cause the
host kernel's or hardware's view of its memory to become incoherent.
Heck, host userspace could literally use a memfd to share memory
between the guest and a separate host process that implements a
device.

P.P.S. It's possible for there to be a legitimate security boundary
between user or guest code and a future version of *the same*
userspace or guest, via DRTM.  Someone should build a guest that sets
up some form of host-kernel-pinned-folio IO (IOMMU or simply a
host-side emulated device that works this way), then
DONTNEED/REMOVE/hole-punch the memory, then do the DRTM dance and
attest to its state.

--Andy


--=20
Andy Lutomirski
AMA Capital Management, LLC
