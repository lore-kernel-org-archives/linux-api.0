Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.167.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793897971;
	b=SVxRqLKCsFttZkxotlFYgApnG+35jbqi67Mcepa/dngdbNJkAU1rNo4BU6LcXAdGJeVZ
	 173eq0WJdhi8sV9JN8uChyxsD3JQmbGVedbCXT55q+Ibu1B3b8ox4pfXoijS7+eoCIU9F
	 fkdZ6dlW1DsnVSjerPKFHSATkatLulOS1C6RCHp7hzV2jRuALEI8XgOrEkSRwVLfDhq/3
	 U9PtSoUr73M1r4ma2Ve4aCFveiiQfbrAsNMkR29x/ggKqsaJt8yu4vywK4l78JSCL+4Lv
	 i8hVssdcI0+vz5djRmqK0Nn7Mpi3xm9/8+OuEOqvtZNiNU2T83/5D58l3sf1NqMs9eQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793897971;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ENTWrgdqNOnhBXm7Ydoc9z3n/Zlmn8Dt6MNiq3/7nzs=;
	b=cKQhF/6CKWlXRkpS2EsBr0apA/Whm3jKor2TglILjRfhTREnPi9iIwQ9L5epIZvKLfEb
	 XXVOHkMFBMTyNWmUDSVx/7kkqAXutgpScT28jiRAAXdiS0GzQq8EisiQJywaHFwqZBQAY
	 tZtWiQtU58o8y2pzSMsr1TxLr1ectRhTaVHHnDdyMgRxtFBfUxl9wf0z5nN0rwk+lWhse
	 JnZEoIofYEhSZQ/W0o/aJYlSkMgejkTreMBBx4VVlgHP9LnPJ7yxLBPR9AWdoseB0DwJZ
	 2S6d9PUmM1YjpL0AfLVBwYCELPQI+C6JTqDK5KRjRfGOQPecsUU+Z3FG8yctQFHUy7g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=amacapital.net;
	spf=pass smtp.mailfrom=amacapital.net;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=M4rBHBr6;
	arc=fail smtp.remote-ip=209.85.167.46
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E22606A32E
	for <linux-api@vger.kernel.org>; Thu,  5 Nov 2026 16:59:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 62E22606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=M4rBHBr6
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5bfbc67991cso1334382e87.0
        for <linux-api@vger.kernel.org>; Thu, 05 Nov 2026 08:59:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793897969; cv=none;
        d=google.com; s=arc-20260327;
        b=XKiN3f15/A+P2aqlGRxc6qGIWZMV9TbjiaX2PL+KAoDYcwJtkKHQ+F3I8hsM1nb6Zk
         7LvHNpIjkmzhJKpfceZlYOALXyqy99e9dCccEnQGh7cakAsdK5ycJ9NoAIxpc8Zja9JD
         T/JahC25K4EMrLsYX2OuhQBspdV4jh/T+z6eESmNCtvV9GsRhrf8e9y/AQTP6xgCEg9V
         w9j+QEzrcoLf+TXPPHOOPDNv0LPnHcbNeZLrCdFnG0CqzWZEcMvsTCKfSpf3Rvo/k+ic
         NdOtsURKg7LLmFlxULHqidsFpBT/l4dZ1DTez0PigZ7W0gNcxtsGSlA02we6JfRjBeRJ
         ISQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ENTWrgdqNOnhBXm7Ydoc9z3n/Zlmn8Dt6MNiq3/7nzs=;
        fh=qoW5KdseMdaCyBP1NYYCwO7degAphqQcLdwetq6IVZk=;
        b=dCeEXVH+I8o6nc4kqwAt7y4aLvBWsUNGkpmnyJXCk2yN157eAqE/CiC1Vb7Gz/+x4P
         Kneh9jq/068loAhcPQOisvCAHmS+BwjxDOoocxZSS64sJZ2FCtXv+PhniqILk30o3s0A
         fjOSU9ppHR3sdvAlgrgb6Pd7c5YUjztGCWa4GNar16N2Zarc2DKRC/Ap/Mg+ZVirzs+l
         HzXkt08FoXF+S2Esdf7hyM1gTvBQ8/XoBqcc9x8rpCsA++GE0uxkTj+FHYid4FQnzv2R
         j7Hycxubu/U0fvdYtCwVFNA3WzXrgoDtzc+xyiZcm90ENrAJxfRredWJYuCS6IYycQye
         nRtg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20260707.gappssmtp.com; s=20260707; t=1793897969; x=1794502769; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ENTWrgdqNOnhBXm7Ydoc9z3n/Zlmn8Dt6MNiq3/7nzs=;
        b=M4rBHBr63W/SAVwNNbCQfErkFQNKWB1qkv3HtqteP54rOiV/HHnDMbtUKJCArIzFu4
         mYj0S1RcIb0q9pNYYwzfkrgcW/4hpcfT9cokBuN88bZN0gEMLrtAd9p4+/Q1wKWLERCs
         DrW00xbJ3OukwQpHPe/em0QG+3GlYH+g3IYsga7TvOEBXsyzoIivcIrFXjcPfBtQMsJx
         dhhKFMCZQePt2r/MCoc/hvcGaP1eaY7HE+KfNY0jNPytwrHw0Re5wyWLV4CIYYEeqBaz
         M8PdhqQP2K58xdjOL5tlAIrLEOG/UBLGLNET3to0NrS8A3suRDOPofJdLYHDtzflD6hB
         0Dzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793897969; x=1794502769;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ENTWrgdqNOnhBXm7Ydoc9z3n/Zlmn8Dt6MNiq3/7nzs=;
        b=pQ26ol0j68y8iCKL+UuDJmxdvtVKq0X+G8nWnoAs5sugqBPUPsdbgiskhOZfjdmiCF
         X7WVIfRM3/J5mme+eV5u6xnL3XLteNmWh0UhbDVcqqEFdIHF6pxzI+10ulFlLo1tNRSb
         4icYW68+LE0m5wtTJt+jiEnL7ed2LyReVsMwc6gsAeoQa2FlIC35O+rZg8XERr7agQuT
         t6kTq5ai4QqsLZVElsZBzsyAiI+RUPHkGEo9FP3/d/vQjbjr/3HbzERfNT1nXNgRX8N3
         qJXeuEYRIo1obZ8vvQH9BrNZGgMo2Pwu0TIrJxxo+tx7HITaAk3vEjvHDg+XMS3/FSOJ
         v6ew==
X-Forwarded-Encrypted: i=1; AKwUvBwj2iNo66ZpqeW9Fz5aAbjxkPC7bGhd9ScDzZUDiiqN5pU80HmUcHcNZMGg8eQCQ9LGdexDzMIDkac=@vger.kernel.org
X-Gm-Message-State: APuU4Z8rAnkzxFbzJHvRWV+hwxxePwfhNsvhhLwp4Ap5T3xIhNDAKvFx
	HDGNAMivCoAXTY0GZTF9OYx83CFRrX4oiF3QWANWWl/aVnkQj6bxXxKxPMObN6xt3VZNKOEaB7T
	molnF4G6tDYZir9m96guDs3D51Vd9O8YAA8/ksEYt4dVoRx7aQ/w=
X-Gm-Gg: AYBFou1JQZqU3irqSrcWD0vKeIT7xIIiqaX3kqSsW5gY6MDvTwwO5Cckn/qVWR9YKvB
	JP2HONf+erqtutDn3PxwbeglDwWDOFhE3cH4Si71d3RZRKwbGTiqIb82u88Qu1oIS6/oU5CCPBB
	7W3tpY1iaMEDWUQVbJCSsvDm9vJyVGL3pPxwh7XRxCxvuZKmTaafAwwfmXOm9rIow7GsuTiHk1e
	jr2MukvFNuYf4PQQmkiCP5GkYbbM3vFFV5gs8n79FMmdlAu31dFdSfE6ZFJMf+/kYB8m0x2TGDl
	1EYQ8+QUpouZOgkmtFk2hptx3EOjhqn3YgcxlZISD7egs0tyVmC/L+3+YHu+VQV56PeviZRE7SH
	i69T5Nu3T44gujSdnfpyUJHsL1buwj1sfNQ==
X-Received: by 2002:a05:6512:3e1c:b0:5b8:f97f:7a22 with SMTP id
 2adb3069b0e04-5bfd957683fmr6945728e87.54.1793897969539; Thu, 05 Nov 2026
 08:59:29 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028221705.3915340-1-halg@google.com> <aunVmg42/S2uUDWR@hallyn.com>
 <auyink594bxptAPN@google.com>
In-Reply-To: <auyink594bxptAPN@google.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 5 Nov 2026 08:59:17 -0800
X-Gm-Features: AclHuK99RUxjga4Yt7Cih1iKUoXn780fqABuH5tRHwVrGa5--KTUob_Z762ltig
Message-ID: <CALCETrWaFf-X-mD0moxqaqEDWOV+85geK2B2Rs3ArixKd=Ntfw@mail.gmail.com>
Subject: Re: [PATCH 0/8] userns: per-namespace capability bounding set and
 opt-in netns loopback
To: "Hallgrimur H. Gunnarsson" <halg@google.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Paul Moore <paul@paul-moore.com>, 
	Serge Hallyn <sergeh@kernel.org>, Kees Cook <kees@kernel.org>, 
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

On Thu, Nov 5, 2026 at 7:48=E2=80=AFAM Hallgrimur H. Gunnarsson <halg@googl=
e.com> wrote:
>
> On Tue, Nov 03, 2026 at 06:37:46AM -0600, Serge E. Hallyn wrote:
> > Generally, if I, or some users I support, need to use unprivileged cont=
ainers
> > or user namespaces, then when an 0day comes along, I can hopefully trus=
t them
> > not to exploit it.  The biggest danger comes from the fact that, right =
now, if
> > they can use them, anyone can.  So if someone can trigger some other co=
de running
> > as user nginx or something, that can become a root vector.
> >
> > So what if we had a built-in feature or LSM which implemented a credent=
ial based
> > whitelist, entered at firstboot?  Something like
> >
> > ```
> > # Default deny
> > uid =3D=3D 1000  # approved
> > 1005 < uid < 1010  # approved
> > gid =3D=3D 1005
> > security_label =3D lxc_user_t  # Not sure how far we want to go with th=
is
> > tty # must have a session
> > ```
> >
> > Now, if you want to use user namespaces for generic sandboxes for all
> > users, e.g. to confine browser activity or nginx modules, then this mod=
el
> > may not fit.  Or rather, it might need a few tweaks.
>
> Thanks for taking a look and sharing the credential-based allowlist.
>
> The latter scenario (generic sandboxes for all users) is actually the
> primary use case that I'm targeting. I want to allow unprivileged users t=
o
> create user namespaces, e.g. for sandboxing, but without granting them
> security-sensitive network capabilities (CAP_NET_ADMIN/CAP_NET_RAW) when
> they are not strictly needed, given the historically high risk of local
> privilege escalation associated with them.
>
> The two approaches target complementary layers of the problem. A credenti=
al
> allowlist at creation time controls who can create a user namespace, whil=
e
> this patch series controls what capabilities are available inside that
> namespace (and its descendants) once it is created.
>
> Gating creation works well when there is a clear boundary between trusted
> and untrusted users. However, in a multi-tenant environment (like a large
> container fleet), we generally treat workloads as untrusted by default.
> Because we still want to allow these untrusted workloads to use unprivile=
ged
> user namespaces for sandboxing, it is essential to keep the attack surfac=
e
> small and follow the principle of least privilege whenever possible.
>
> More specifically, this patch series enables that model of safe sandboxin=
g
> across three key use cases:
>
> 1. Configurable capability stripping: Administrators can enable unprivile=
ged
>    user namespaces for all users to support sandboxing, but configure the
>    system to strip CAP_NET_ADMIN and CAP_NET_RAW by default in new user
>    namespaces created by unprivileged users. Basic sandboxing rarely need=
s
>    these (except to bring up loopback, which Patch 1 addresses via
>    CLONE_NEWNET_LOOPBACK).
>
>    The per-namespace bounding set can enforce this either globally via th=
e
>    sysctl, or explicitly via clone3() at the container manager level. Thi=
s
>    restriction is monotonic and persists down the namespace hierarchy.
>
> 2. Selectively granting CAP_NET_ADMIN: Some containerized workloads
>    legitimately need CAP_NET_ADMIN to configure advanced networking for
>    sub-containers. Because an unprivileged creator's child namespace is
>    bounded by:
>
>      parent_bset & (sysctl_ceiling | creator_effective)

Right after sending my last email, I had the following thought of a
variant of the model.  Permission to gain CAP_NET_ADMIN via creating a
userns is kind of like a capability itself, right?  We could get
pretty close to nice semantics if we allocated a capability bit for
this (CAP_USERNS_NET_ADMIN perhaps?) and, by default, giving it to all
users.  Unfortunately, the latter part is tricky because even sticking
it in the ambient set won't keep it from being dropped by setuid.

Perhaps we could have an extra capability mask that is for default-on
capabilities.

The intuition for this is that permission to gain capabilities in a
userns is a mess if it's a sysctl (as sysctls are global and there is
no clean way to say that a particular unprivileged task may
nonetheless create namespaces with CAP_NET_ADMIN) and it's a mess if
it's a securebit (still has the latter problem), but it's much tidier
if it's tied to a task.
