Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793228185;
	b=Qx8qEk49NRVU5GRKclys8ZL+2lu35h7vcaVCq1eDcFPTGyRugk9y/ZmRS920fHrBBjQU
	 YB6vAUit3H95C8vlQgOh3OjO29IUv3ER+deLeSZts+LDSFLwhuODyARqCPqfC3csD4hH5
	 9PcxbOWzV4J82+e7gTgdc+RzCMWYBgo/0buGJt1B23aMpN3z0CUSK4B8SZFaOJeO5Uns2
	 8VKY1IMSfE1oIPrCTXPrmPs4BlhHv3NkVfuhU+q9ffiprf64Xv4qs1QTAPKf8BekXpFuE
	 bfCGbJYFurDWO98PYSX8qEINHTFSoNaLFXyJI2AsS3s6nzOFA28wc6ngOsDGfGMF4KA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793228185;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=V0MpBzACJCm623um40rfrBkC0GCIrNAzwGLFIF9vVVM=;
	b=q2cFdfhDbpJv7biLVmep+YE2duawC8GVaDCQTb9bKqvqTNLq0mv3ss6LNwrkYD90R9xV
	 xERwYTxkai3yrLyn1gvvQugk9nSz0tFkx/VSRT/QJRbsXQdX9PYZUahM17uHrCnfSAZzY
	 3uVCLnZEBYli/fLjdnzyBv0lLm10+Az+MemwXZXJmMNjVRtrjqAwac/pZCvt/dOJEKo+G
	 3iKtJC1Jc2h0VoegHnkqpLVMHtZrIx4ObwC+2WC5LGRaIJf3Y9EEAKw6SnLMMZZ2LNMUJ
	 +2sml/EKagkn6ao24U5ktXi/ocB5KKOhu9dQ8nS94k+MTFivLBpSf+vx0/gps4poRmg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=amacapital.net;
	spf=pass smtp.mailfrom=amacapital.net;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=bZOSlVJG;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.49
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3E4606A31C
	for <linux-api@vger.kernel.org>; Wed, 28 Oct 2026 22:56:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC3E4606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=bZOSlVJG
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5bccecba199so1646594e87.1
        for <linux-api@vger.kernel.org>; Wed, 28 Oct 2026 15:56:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793228183; cv=none;
        d=google.com; s=arc-20260327;
        b=CyuDcT4FzHXPYeoOrlr4JdzsMAbuzW7Ud+XIgQGbxlrHLSZ7wXjwSpp3dbedJ/nNeZ
         wdFzPlv+TovVzo5Jcl0IareOs0A4qEhAMBQcZ0YK8p+clERnRY+gzOEsD4qvBkwh4rto
         AaZpcuQmFr0YjCeNJSAwVVFpSy9Ltc2UcuVRtsJvOGBd2iWvDdLvi/1FLei3SDRIX+u1
         3dfSvYj53mAf2UlJHq8CyurNaX5e3VgenUiu8f58gqMl4rzKG0TvEPNGdr5zPWVrLzd2
         lORrrxBozCBaTcswgzNBUc+9R5McbRwpsv4hr7lxC3cO26/CFqfykekhPUJeUIVNaGYo
         kneA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=V0MpBzACJCm623um40rfrBkC0GCIrNAzwGLFIF9vVVM=;
        fh=zS+k27+q9cb9Axe2pc23SUp6mMygtGXFDNZHMxhgWgY=;
        b=OYeqreDuy52RvxLAbyzshVz/N7zVME/1aNR4LaPjThgzxpJVHyErZHpcIi7zc+XLZv
         2QtPJeJEiGMbVPCyltz0S6B8gjSdf3hrToeT1z7MqEdfI7k6n5embTfwLYLcnDPWIcOw
         f9Go2E//UvaFjXHpKhSf0wzUm6ZAdFotI5s0JHRyh8VP0WJtCM4du32V2Qr4sJIVFGlf
         Q+YSfx6dnItFrE/HKxnLn4QW97ttiSCcu6yrlEoxXUxQcLdTHgASEUC6xRYHTJATwdQ7
         JYBZx5N6Fl18Vk2LRzasJm6NtZ6tnQURCHADwo4MsA0j6zz91HQF7ODIAb/QPzxIoWIV
         wutw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20260707.gappssmtp.com; s=20260707; t=1793228183; x=1793832983; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=V0MpBzACJCm623um40rfrBkC0GCIrNAzwGLFIF9vVVM=;
        b=bZOSlVJGtHEYwYd8P/JXTJGc0heKbmZ4zF6gCQsfAWUdj+V8lveZo37a35kI44zsZG
         8r9p4GP3JXlJVRf/lRQCeD7DpNu+EpwjtNRy8B/mAQWg4VrhYeyQL+tDoFWr1hQ8Js/1
         WmBu61FcofxUa9iC2o9+OqMJhIY2ZxGCvswPzn8Prxv7xx3PhcvCqjngxpEz26C3Zh5+
         QCDR/cnpyszjYnYa+NJ3GR//R0d+Eo5+XTYFDLb2ivFHUdLHCDDXia/PshsMR6SOBMAE
         M4o+rVXHudqK4Y3GjiNjn4cOkyeetgJTVfYAYDZGmr6blu+DiQE+KChOyTySu65qfvrn
         wIcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793228183; x=1793832983;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=V0MpBzACJCm623um40rfrBkC0GCIrNAzwGLFIF9vVVM=;
        b=H6qJli4syxBpS2lbMEHVgfOYh6MpPi7skYoiejFDWCH5TO/SQKOwcj09CWp2r4lj78
         S9fR+amo/J7MtktRWAX14XftrGcKzOUf1qli23+p4b51oxljQQVJAIvSB3Q5jMEJ9Ck3
         Cng7jKf37oQSR2gEfF+VpyzLCjvaIp+axIN7iYg84ogY+EbYw8HwJcJiZmL+asOSfmNU
         DftGlJyqkq9Lo/0t4o3JM+eFfGhF+fbx9Uz2BXto38TQmDa0BIt1Th5yGU1/4vHDvHmm
         zyXu9ZOXrhjp9UgV48LUaxAdvvXGHaQmdc7WKEjpmeMU0IXel3IrBRCAkmIruo08HsXW
         nq+g==
X-Forwarded-Encrypted: i=1; AKwUvBylWrA0TfY6qzlQTfrQcWfnw1rvx+kzTjqTs+fVe4xob85KNFQmyfV4YVWJWHrTRnj7/QMZXqOlgZw=@vger.kernel.org
X-Gm-Message-State: AFq9FYJACZ+P+BicR9ChlIuiRvx0KJWoqG1szQZZZyuWMVuLGnTlea4v
	lgGxn2kBffHcNpGXwY3/jVN0PFlkxbrzuBTnX6ThP2An1+HHDIsKFib6Ep8s9waBBH9fMtobZfu
	UPnQ3fu77ttH+gpSLWC5I/dqlo7/ovytxVw3TPMM7
X-Gm-Gg: AYBFou33zZY0IpFR4Fasv+QIjIeSefkSXY6BrkjDdcWpU4+zp9JI4g2IqFHk9khw0/F
	e4WI9BB3gKFc7LA1cTP1kIbrIjJIdFrBYVK47lv8gD0SJxVyaSEJRLV1lBrwOcyDbD3PBBiMovl
	GfUTAs3LZQ7DB1xPevko4oG+9gQ7H/m4cXyi5KCtK0tpONF1wu95/w0MmkP0iFAJU9wKc7u8GMl
	/OB6znYDR8RgRvsChtTCEivCOOE7aa1LQVamHKik0KGUn85NZBoxyYqpm2AuXs9ygR6xy+Jt0pI
	oaNTWAvSMt2Crv0kCOh37L9RKt1mc9ddcbQBXY+aMgXc04EXlieLLyZn9XkMRgAUtgwCJ7nGO0C
	WSfBh8p2Gjd1QsA5LUPmk3EtqBSC4IHQE5LznrA==
X-Received: by 2002:a05:6512:3e19:b0:5bf:c239:71ad with SMTP id
 2adb3069b0e04-5bfcad69127mr1282221e87.38.1793228183136; Wed, 28 Oct 2026
 15:56:23 -0700 (PDT)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028221705.3915340-1-halg@google.com>
In-Reply-To: <20261028221705.3915340-1-halg@google.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 28 Oct 2026 15:56:11 -0700
X-Gm-Features: AclHuK_P2NrO86m_OPGwNSCuxqmiVp7fbTt4tlVfFApQPbneLnvcqCjpUTpk6N8
Message-ID: <CALCETrW9ygriu54gxiHFLEd5+hJminQo0r8Jwd63wR69Dj4W7w@mail.gmail.com>
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

On Wed, Oct 28, 2026 at 3:18=E2=80=AFPM Hallgrimur H. Gunnarsson
<halg@google.com> wrote:
>
> When an unprivileged process creates a new user namespace, it is granted
> a full set of capabilities (CAP_FULL_SET) scoped to that namespace.
> While these capabilities are isolated to the namespace, they allow
> unprivileged local users to reach deep kernel subsystems (most notably
> networking configuration and raw sockets via CAP_NET_ADMIN and
> CAP_NET_RAW) that historically assumed a trusted caller and have
> accounted for a large share of local privilege escalation
> vulnerabilities.
>
> Many workloads and sandboxes use unprivileged user namespaces strictly
> for basic UID/GID, mount, PID, or network isolation and never need
> high-risk capabilities like CAP_NET_ADMIN or CAP_NET_RAW. Likewise,
> system administrators often want a host-wide policy ceiling restricting
> which capabilities unprivileged user namespaces may acquire, without
> disabling unprivileged user namespaces altogether.
>
> Prior work by Jonathan Calmels [1] proposed addressing this via a sixth
> per-thread capability set (cap_userns) alongside a global sysctl mask.
> During that discussion [1, 2], feedback (e.g. from Casey Schaufler)
> suggested that rather than adding another per-thread capability set and
> prctl() interface, capability restrictions could be integrated directly
> into struct user_namespace and configured via clone3(). At the same
> time, as noted in [1], a clone3() flag alone is not sufficient for
> administrators who need to enforce a host-wide ceiling on unprivileged
> user namespaces without modifying every userspace callsite.
>
> This series combines both pieces of feedback: it embeds a capability
> bounding set (cap_bset) directly into struct user_namespace, reusing
> the existing task cap_bset, cap_permitted, and cap_effective sets on
> namespace entry, and provides both a system-wide sysctl ceiling for
> unprivileged user namespaces and a CLONE_NEWUSER_BSET flag for
> voluntary per-namespace restriction via clone3().

Why should the task's cap masks affect this?  *Maybe* cap_bset makes
sense, but I'm struggling a bit to see why cap_permitted and
cap_effective should matter.

Also, I think that Docker in non-userns mode restricts cap_bset, and
the purpose of that restriction is rather at odds with interpreting it
as a restriction on newly created user namespaces for purposes of
vulnerability mitigation.

>
> In addition, because restricting CAP_NET_ADMIN at user namespace
> creation time prevents userspace from bringing up the loopback
> interface in new network namespaces, the series first introduces
> an opt-in flag to automatically enable loopback on network namespace
> creation:
>
> 1. Opt-in loopback activation on netns creation (Patch 1)
>
>   New network namespaces start with the loopback interface (lo) DOWN by
>   default, requiring CAP_NET_ADMIN over the owning user namespace to
>   bring it up. To block external network access while preserving
>   localhost networking, sandboxes commonly create an isolated network
>   namespace with only the loopback interface enabled.
>

The whole unshare/clone flag situation is getting out of hand, IMO.
And this new thing makes logical sense but is really about reducing
exposure.

Perhaps we should instead have a small list associated with a userns
(extensible in the future) of things that the ns's admin (i.e. whoever
has CAP_SYS_ADMIN relative to the ns) may do.  That list could
include:

- Create loopback with sensible defaults for ipv4 and/or ipv6 (i see
no obvious reason to separate them)
- Create tun/tap interfaces in that ns (and attach them, etc)

And add a very simple new API to do these things.  Actually, the
tun/tap could just use the normal mechanism.

Thoughts?

--=20
Andy Lutomirski
AMA Capital Management, LLC
