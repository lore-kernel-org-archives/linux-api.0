Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D75C412C06
	for <linux-api@vger.kernel.org>; Thu, 23 Jul 2026 09:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784797270; cv=none; b=CvPZql0bbwIiZ9kHOnKatHwnT9uNZzVzP3JMaSJEMSfRG0SoZy3/ulyLdID7Y0JJqAsIlYDmxIWbRqWsuGRHEnpzZ6AkQDiZtiVq6ii5IFysNaLzj7GNadGS6/wp6unNi3Z+t4KCTsShoNBynIQzwmPTeCNYO1HIs2uh9KhYvnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784797270; c=relaxed/simple;
	bh=3jTlyr0xcFOTLx1mQk6C+Pf7U8xQRYKxC6jxUP2Vklc=;
	h=Content-Type:From:Mime-Version:Subject:Date:Message-Id:References:
	 Cc:In-Reply-To:To; b=pbPsbBeUZQfVqtUah/tfUSZ3i4MFBl5lw0U3vbI6WzHrAYnP091mzymlI0U8oAIxNuFV8clqloOsPDmY6t50wwGvVdLtIc1NULktGcbvs6+h7jcsEBhnHz1NIMa8xuB01m9FJtp6iSBm+TIYkzsPCJLhLi7pzEpkzyMm0v0cOhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b=mdm0v8UI; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b="mdm0v8UI"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7eb34c17b96so250798a34.2
        for <linux-api@vger.kernel.org>; Thu, 23 Jul 2026 02:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1784797267; x=1785402067; darn=vger.kernel.org;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:content-type:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/tPr3qdcawiWwA2VysdP5ZIB8M9hpvOF1iQApSBfOK4=;
        b=mdm0v8UIGCx1vSluyV40Ba5KwLm/vSIUh7PtS5hwq1lABkZctBbiCDxkig6IRreP15
         RUxRGZKw9E0F8MppfaStaicI1ZaIitcK5/HKftPyAuj1Es3++TP/Ep+yJx91UoncJjsl
         YWB7wHWHjYJZ9sOXur/9Likz20caCIQMDnkMYIq56i51IJqtzvXzIUSSH501Shw8xG6H
         C75VDHbeWItoENF+nML/z0VBEiVItthdzjeFB9tJ3FIpRHc3CoLqD5Vbpkza6qp029nP
         8BqfQ1n3JE38dnJPKKktfWNB7e19Wor8zWiDrIzegop8mE7HtjaSe7uHGD5YcFQvHVDd
         1fxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784797267; x=1785402067;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/tPr3qdcawiWwA2VysdP5ZIB8M9hpvOF1iQApSBfOK4=;
        b=VFAEmqzxFq89s9t1EphheoxSchM8Sn+3L+NvmLo+1t0jGkbrzbx5/l/GtZhBSgSu0Z
         kaWCfF4AoJII3qxMUKAzouO+18GDunpAAkQT3/D6sCLEZnbZ+VptlalsN408jrVGkUN3
         3AfU8vSeHvZeRegRgOWn6wnE1rD2j2663TJcM1rVv3po0IfVN/a3OCjh8V6v7UM3pEP4
         MMaNeuImzb4qyQjdA+tCDCaQmfjOzgFdHCqy4pUat3+lYaisqxjiDWstpe9ns0Pzjt0n
         qIB89EZStNXRyYTwHqm+HeMgWbgMY/mo2drlQCDtUG1kcSnN+8e+5f+oCskXzHKQLS7h
         zxpg==
X-Forwarded-Encrypted: i=1; AHgh+RpKB18sVuFI+jpejqEekkvSoekY+S4EmDy5gCwsVBOIDLbxF7ke6YXsZCKhElGmGtegcgNZUpXRKvQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHmsGk+fL3d/tc3Jlo9iGZ19Wam8+lUgXlxEs6HFlmNZeYxvzg
	D4K14uV5fDjnNIxC5OU4i7rkWDR4caS74CiwM1QAfkI2W2KSx+6ZiAx0Hk5cXpqW9Q==
X-Gm-Gg: AR+sD13OYrNgkyjKNo/MjPtM//ZemXAx9DCce819ch63lRHcrTtClERieXOjrd/5B+U
	kCybbw3IesbCJCAIxJifCn075JkBvRDzG5/PVWZlqj6XJMEALCbaaUbsFbI8ZZPA/P1XZo30PMO
	efY5mAcTA/J8P6KNhB7dwwbCkneTDNgTW4hIfK9Cp37VTF41LBgSwaE8qcNksX/wM7DlZwPKSVc
	KxWOkzWv4kbjV9S3MfvnzB/PQ3qkRBtnDzkDnnkAIlXY0lUVisS6gOMzYC5Jk5Wp/Z8gE6IrGcN
	jJyx8D697UCVdczD+8Gi4gOFEig/X1q1RzHD4iZqFx7znYwGI2KCZcvr5JVKnQ868Ge4YoEj2sw
	+z3Z9/O9OK6HeML01eNCilBFooz51kfnrI3lLPxDIwCY6k9+mvhnveBbQDMPM7Cbaakx8TpPHHG
	guC0l0VGFOXzyDyZv8Oh1pHO11Dm3muo4=
X-Received: by 2002:a05:6830:3692:b0:7e7:5e4:ee11 with SMTP id 46e09a7af769-7ee4417fc9fmr1388710a34.16.1784797267490;
        Thu, 23 Jul 2026 02:01:07 -0700 (PDT)
Received: from smtpclient.apple ([172.58.164.213])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ee2a03c856sm3082411a34.13.2026.07.23.02.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 02:01:06 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Andy Lutomirski <luto@amacapital.net>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC PATCH] fs: allow opening overlayfs/erofs layers through O_ALT
Date: Thu, 23 Jul 2026 11:00:53 +0200
Message-Id: <6C96C8A7-345E-4388-8EDC-D94E9463D214@amacapital.net>
References: <CAJfpegupwNTaVNZtdQTmvtz9x=ehH59hzsRT7D0=VbhOZvaqrQ@mail.gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
 Miklos Szeredi <mszeredi@redhat.com>,
 Giuseppe Scrivano <gscrivan@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-unionfs@vger.kernel.org, linux-api@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, Amir Goldstein <amir73il@gmail.com>,
 Xiang Gao <hsiangkao@linux.alibaba.com>
In-Reply-To: <CAJfpegupwNTaVNZtdQTmvtz9x=ehH59hzsRT7D0=VbhOZvaqrQ@mail.gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
X-Mailer: iPhone Mail (23F77)



> On Jul 23, 2026, at 10:22=E2=80=AFAM, Miklos Szeredi <miklos@szeredi.hu> w=
rote:
>=20
> =EF=BB=BFOn Wed, 22 Jul 2026 at 18:36, Andy Lutomirski <luto@amacapital.ne=
t> wrote:
>=20
>> Other than that question, I think I generally agree with you.  The
>> interesting operations here (getting an fd to something that was
>> previously inaccessible) are different enough from normal path lookups
>> that I think they deserve to be explicit syscalls or syscall modes,
>> not magic links.
>=20
> This is a super specialized use case.
>=20
> I sort of agree that doing statmount() as a syscall was not a bad
> idea.   But new syscall for getting a backing layer, that makes sense
> on just a couple of filesystems?
>=20
> And that leaves us with ioctl.   And ioclt() returning an open fd has
> it's own problems, besides ioctl being a generally bad interface.
>=20
> And we have all these powerful concepts and interfaces for
> filesystems, why the big resistance to actually using them?.
>=20
> Sure, it's easy to misuse, but I don't yet see why this particular
> case would be a misuse.  Enlighten me please.
>=20

I think there are are a couple of complications involved with open, openat, e=
tc that aren=E2=80=99t present with explicit for-the-purpose syscalls:

- O_XYZ flags to open() are all kinds of awful, for historical reasons that a=
re not fundamental to the concept.

- symlinks. If we have a new API where opening /proc/something/magic/blah ca=
n access something that ought to be inaccessible when accessed intentionally=
 and with privilege, a symlink pointing at /proc/something/=E2=80=A6 can cau=
se the API to be used inadvertently.  Admittedly we have this problem with b=
asically all symlinks, so this isn=E2=80=99t exactly unique.

- our nasty fs permission model. We gave a sort of gnarly mix of a bit of fd=
-based permission and mostly mode/ACL-based permissions for path traversal a=
nd opening, and mapping this nicely only new APIs (as opposed to actual file=
s and directories) can have unpleasant results.

Of course, I=E2=80=99m busy arguing (slowly and without a concrete proposal)=
 that we should have proper capability-like fds, and maybe that=E2=80=99s ki=
nd of an answer to this:

What if we had an API to get an fd to the =E2=80=9Ccontrol filesystem=E2=80=9D=
 for a superblock, like your O_ALT but as a real syscall or maybe only acces=
sible via one of the newer and less janky open variants?  And what if the re=
sulting fd and the filesystem tree it represented had a few properties that m=
ade it very different from normal directory fds:

- You cannot mount anything on it or its subdirectories, nor can you open_tr=
ee or otherwise mount it anywhere.  But you can open_tree the very specific t=
hings in it that point outside of the special API (e.g. the overlayfs layers=
).

- Privilege is fully captured by the original call that gets you the fd.  cu=
rrent->cred is not checked when *using* it except to the extent that you mig=
ht need privileges over your own namespaces to do operations that might affe=
ct them.

- You can=E2=80=99t fchdir or (hypothetically) fchroot into it.  (Not sure h=
ow important this is.)

- Maybe you can=E2=80=99t follow /proc/pid/fd/N links into it either?  Or ma=
ybe that would break CRIU too badly.

The basic idea here is to try to treat it like an API that happens to use th=
e open machinery but not as part of the filesystem hierarchy.

One could go even farther and try to remove a bunch of the parts that make i=
mplementing it tedious.  For example, if this hierarchy had =E2=80=9C/layers=
/1/options=E2=80=9D, there is really no reason to over open an fd to layers o=
r layers/1, and if we had a readfile syscall there wouldn=E2=80=99t be a rea=
son to open an fd to options either.  But maybe this is a silly direction to=
 move in.

> Thanks,
> Miklos
