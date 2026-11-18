Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795038587;
	b=PxX4QuobiOxMf/K5iA3FI/ttA6tXxlcgCEVa5OJK091oPG/2c65Zj8HUZh+Gqi1p17LA
	 pdnPz9H0W3wAdMC/8krbbpkRUhu+EIa/vQPBaM1xa+KR7a4F4JKHt7fAv+1uWiw+Oa3wN
	 ACXYAyI4lCxdO6GLlPsEBhkq93Px1xBezpotbKtFQh7tMxjECoyybGiwl6npFpOLqKNry
	 wZLtmA4c+dkHsLnC3aPo8WADXxMbFClRiuoOVOF+lWXSt94Q6P3dYN8sW4VU+ZHQvyIrX
	 nb8R+V95iEuI5RvQwMIr8EjU/fTkIBilrRd+zNGEocIwmwx12ntOo53INn0j4q0m5eg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038587;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=CZPHqjEKi2vg5bpASOGDI+kJVhoG5JNXko8FEV4Oxfg=;
	b=fVpPaqhM4gJTuXXCT6bkK6lUyHDblEPtN9D1L/ZSqhhF3jMI9ZQhgM7HFSOfs5ZtVlzb
	 bcZ8TH39/g1adURGYJ4dO55pSYm551D3tBs0uhzaNcH6I1LnrAvgOCuqyp4GuHCw1QgEl
	 kkDzWx6G+cT4SdWuV+vVlgBIBXqxnG+SsZ1sqrC6n3azDEqqoelwa4iWOOtHss4cPVneJ
	 l59CppGoumLWzA6w+UqjoD5U1SpOG2tWwTG0oKjzO03dLQYKIE/zTdd/RkCycxkwzweTf
	 ln4o5MZsvTrgqY4I/KdAVJXV7UnHvF2k/ObjuHAGn0SjDzhieSKUc/+Sa7007n+XX2g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=amacapital.net;
	spf=pass smtp.mailfrom=amacapital.net;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=KaciEEIF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.46
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC7B606A334
	for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 21:49:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9DC7B606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=KaciEEIF
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5c14f3dab66so286220e87.0
        for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 13:49:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795038585; cv=none;
        d=google.com; s=arc-20260327;
        b=ZxBq6/AnsdBbLAMWDLIm4xK1tmapbpKIA+J+wezi0WNjKJ/TpUkstCTLmieKlVRR8e
         L283f+zkyJ7ZMsn6zYt65wrE+gxlC/80iRGOiKebq9g7RVQ5mFrC/hyh/Yq9UK9ppv3u
         VICkqxIyAWGgZvYouYqYtwXH/pI5byQHbUQgPPgq/doO3tr6fqdgI5PlEewHgcKpwrUC
         YS8DE2zGLoEzS4L894zjWKIh30C1y2cS8bo9gX5cD0RyIdzIVJBSveDEsptOeEeRDwWw
         NAJfBZqNbpFQ4KkgnvD1Up72GxxAH5XVDKitVdAiYDKGbd9MXybezBHuo8C9qSONSvsX
         24Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CZPHqjEKi2vg5bpASOGDI+kJVhoG5JNXko8FEV4Oxfg=;
        fh=j9Yz8qKHxzkZrRaENkDLfnK+ZFPJxbUyhILBSCDAgmY=;
        b=UshRBYYtuyB0kks0IV4SNvcVedbPgLJUUaYoP4e4hUduyU62CK9gQIy3r1HupVey/Y
         OhB1mzlxlcSV/gVqcLDtHU7OvQVFvteccceGT/3IfyI/wlNcp3YmQlVMbElAphy8ZdOL
         GMvXi6EXc9WnnCSRKz6NJvsMKBLbGb3DpcTx+VNjsuz4p0wlHvNI3EuHPrVyH6ucBvrZ
         BmUJzUauXMmD7WUeTrOQAF8tEujOD87fX3m4YDaJZTvcFMQ585RKfC4VMzVuHIFwtaHf
         6RRP1CU+DkuAXgmfj+wJm4aqhkkFgdTGYXMvFuO1C8fA04dX7VmJtGnZQQyzlt5hEEWg
         DqKA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20260707.gappssmtp.com; s=20260707; t=1795038585; x=1795643385; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CZPHqjEKi2vg5bpASOGDI+kJVhoG5JNXko8FEV4Oxfg=;
        b=KaciEEIFbL/YwiIDScNJOJE/ZISkK9Hm5quErzyii+lNT1WfC7kXZg/3FpRZhArF36
         Ad6xuGX4OWHMMcj6Uv+Z0P3xjYKr4xdoCcBZYBSZ40V+hyh+sFba/6f/Byhy6/IHBYV0
         /krtJ2/zrzEeNc29BPoEzTEoutLnweqJEraHWGz4Xdqq1myp231uUNQJfdNikDffJxU0
         OhrtcSpB956rNGC7WaELPyoRadGtF0ROnUwsxD71d4jKhm42p47rbfwAaCyy31Ekzp8c
         eLl8tZDuFmJ51rjZGikkRD11SztUd+7xg3bdsx6y/sDvmlwM86hcs70DaEGgQFzFJe8W
         wh1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795038585; x=1795643385;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CZPHqjEKi2vg5bpASOGDI+kJVhoG5JNXko8FEV4Oxfg=;
        b=sdXNEF6RF71aAJpU9W1bmqbut3Yxi42iOgR3YifuKXMa9gQbzUiZsp9HjUAzGvlkQJ
         5XAUbxmhMNKnYL05y5oARBFWQy1sZICIu8pFLysSvrlMowjJxDUVdjiq+0XxcLB1rty2
         YeY0Ysi+w7xRnpM5ApxoVJWK7vtlub4I+Vw0UYIBOjzFC1dfL+FEBwpnoCMCueBgAeUV
         +huywlTlTVm2lISh4FL1oDlkAE7LTumwWn3JtkkKhMIMP8j0AEwg7KfcGbDwnl8rqX0S
         i/JDP8fLukjf068D83UYsSTP8zMBRF4nhRaAa7Pt51G2OzcLfHWDkxEvwhTfXbuC8PSA
         ILAw==
X-Forwarded-Encrypted: i=1; AL+hErH7YkGwa3MA1x/VkBhEzlYAmbV0ptXW1W/DGDSh3MIABJTIzmjdHCop0QtifFgMiloc5uQ4GPd5aYU=@vger.kernel.org
X-Gm-Message-State: APuU4Z9Iup/TypwMhDAS1vOyE6tpicIwMZC5bepi+TI+ULZWLHLslrdc
	aXPgcUkZw2wX20N2V1ya8LuYLMCt33pTMkG+OddC5oXffrrFt1L4O3s7kFA49mot8LWlsHo9UCP
	qTLbgJVOIOnn1SzdOSqRYHF5yuhtrwEw+2hrDOq3l
X-Gm-Gg: AYBFou0iLB5N0gWCpyGnNgCIHQrQtM+LUxlR8Mcw1n4B+3/uJIKoiLyCHeLtdJAVS+q
	I8lHyAqw53JSjz5IIsiNOGmhqB6VVmyV3h0oo8UDGbsyVZmuTtOF6HOdnZLnZkMrC4xtAASeM3W
	AsFKR+JHfpILj9sKNSQvMiU608aLNBVyR8loLDbnDSdQZjjP1vdiqR+LBL/RALAOljrvhOzgNJd
	/CPQMgkeHNZR0qRAVN2OIRY8gsONMKKsydHU+bfZZtfPyfVsnLLxF2Do5Z+0FmKhYm2bPerwMmE
	zZ+qkQPRpVzmDwJlYcrlz/7UN+AqZtBZmNg6jV+SJ3JVYZI7ZEY6HyJz7bOOGkt5jiGzfw4mShh
	5UnWWeX9zPKga27RgkUeQzceBjmkr5J70tw==
X-Received: by 2002:a05:6512:3c8e:b0:5c1:ac5f:e596 with SMTP id
 2adb3069b0e04-5c1b40e9b72mr9362e87.23.1795038584801; Wed, 18 Nov 2026
 13:49:44 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261106-befreien-addieren-eislauf-e09212803534@brauner>
 <CALCETrWa1SBLcb5oWjqjgzZvKvCoHjmYFk=Lf5ytEM9uqm5jYA@mail.gmail.com>
 <avM41a80aig2de-R@google.com> <20261111-behagen-faktisch-entgegen-e2e714373895@brauner>
 <CALCETrUjW=kXxyggDUvEN+Pxc-pE98eVbdW8XBU8JzfqXj_voA@mail.gmail.com>
 <20261117-rational-ohnehin-unbeugsam-e5c04759a156@brauner>
 <CALCETrWhuOnBy0N0KznmczD4S2XEK0fbr0C=1KFQqTnoTJbQbg@mail.gmail.com>
 <20261118-stapeln-eckpunkte-lesbar-ee73537f474d@brauner> <20261118-zufahrt-baubeginn-gutsbetrieb-c09004227e8f@brauner>
 <CALCETrUMNr=32ENT6VBKPzoyJDfaX6nzZsjMVxuz9O3z+6LRhw@mail.gmail.com> <20261118-professionell-kondition-kerzen-5dd23c1ee490@brauner>
In-Reply-To: <20261118-professionell-kondition-kerzen-5dd23c1ee490@brauner>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 18 Nov 2026 13:49:32 -0800
X-Gm-Features: Aa3M54rEY9J5hVHcO1DPxjhsi7Vv-UveBjN-XrYjaJlUs9gt6QOZEnzJ-89YhLo
Message-ID: <CALCETrXAGpb=OZyGQ2=VfKmA6xeizAsusGZ_HmRtp_s99RpRJA@mail.gmail.com>
Subject: Re: [PATCH 0/8] userns: per-namespace capability bounding set and
 opt-in netns loopback
To: Christian Brauner <brauner@kernel.org>
Cc: lennart@poettering.net, Jann Horn <jannh@google.com>, 
	"Hallgrimur H. Gunnarsson" <halg@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, Kees Cook <kees@kernel.org>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Jan Kara <jack@suse.cz>, 
	James Morris <jmorris@namei.org>, Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	=?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>, 
	KP Singh <kpsingh@kernel.org>, Jonathan Calmels <jcalmels@3xx0.net>, 
	Casey Schaufler <casey@schaufler-ca.com>, linux-fsdevel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, 
	containers@lists.linux.dev, netdev@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 18, 2026 at 1:37=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Wed, Nov 18, 2026 at 01:12:45PM -0800, Andy Lutomirski wrote:

> > > > * deny privilege gain on exec in the initial user namespace and all=
ow it
> > > >   in nested ones. I mused about this in
> > > >   https://github.com/uapi-group/kernel-features/pull/38
> > > >
> > > > Also, since v7.1 there's CLONE_NNP to spawn a child without no_new_=
privs
> > > > set.
> > >
> > > Forgot:
> > >
> > > https://www.thkukuk.de/blog/no_new_privs/
> > >
> > > has an overview of where we're currently at.
> >
> > Nice!
> >
> > I commented in the uapi-group issue:
> >
> > I think there may be a rather more direct solution to this problem. I
> > seem to recall advocating for clearing no_new_privs when entering a
> > userns way back when, and IIRC I dropped this as part of the extensive
> > negotiation to get NNP into the kernel in the first place. (I think
> > dropping it was probably the right decision to keep the final patch
> > simple.)
> >
> > But I think I would still advocate for an option to let clone, unshare
> > and setns callers turn no_new_privs off. The logic is that, if you own
> > a userns, you already have all capabilities in it. If you enter it,
> > you get to keep those by having them raised in cap_permitted. Being
> > able to clear NNP and thus drop and subsequently regain them does not
> > let you do anything you couldn=E2=80=99t already do.
> >
> > An LSM hook for this would be needed because this argument does not
> > apply to non-namespace-scoped LSM-based privileges. But the LSM hook
> > would just be a "may this caller enter this userns and clear
> > no_new_privs while doing so" query. In the absence of LSMs, the
> > operation would be allowed.
> >
> > This would allow a fully no_new_privs host to run an ordinary
> > container that runs, in the ordinary way, without no_new_privs, and
> > without hitting any new LSM calls after it's started.
> >
> > The API could be as simple as a CLONE_CLEAR_NNP bit.
>
> I think that sounds ok. I worry a little it since it would somewhat
> alter the promise that NNP gives. What model do you envision?
> It seems that CLONE_CLEAR_NNP would only be allowed with CLONE_NEWUSER.
> I _think_ this safe even for privileged users that create a user
> namespace and map uid 0 to uid 0. So I think this could work.

Whoops.  I thought that and didn't type that.  Yes, I think you should
only be able to clear NNP with CLONE_NEWUSER.

(And if something like cells ever lands, presumably a task with NNP
set should be allowed to create a cell without NNP in the init task as
long as the same LSM hook says it's okay.)
