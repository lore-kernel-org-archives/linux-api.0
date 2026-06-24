Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C84626159E
	for <linux-api@vger.kernel.org>; Wed, 24 Jun 2026 23:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782342428; cv=none; b=UxIts2qc7xZVvML3EcOElniIES0X0jkT+nzNpMQnRKvr9xJHp7XSkTYKZVCw4Js2ADPzCaqiECaHqLB6xLQRAFdCGN9HCaVbxu+JnNsXAjCxX+f3/CNs6Jye2fDtfjCqgwXmE/agoHUGCTYnC2rLpr7In2894eabJV9SvQiuD0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782342428; c=relaxed/simple;
	bh=dpDGPS+CbSXMjHrMq5m4eMoFsVU1+GvMNg12nCjgA6I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MRwvTbBkoI0NLv4E6xw+xJFQDfgMQFApF2lfg5FKPukzBJLSiXPP5fNzAuT80R++D8xowS6wqTMI7NDn/kVxGWYeUNtQ5RY2CR6CnnTD8Xl0ynRYhsltVJZ/5pYjFO7VhkoTZuI6tVwFMegROUkjNjOxG/kAd0LxYKe8dhTkqQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D+CioFwH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D+CioFwH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4091F0155D
	for <linux-api@vger.kernel.org>; Wed, 24 Jun 2026 23:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782342427;
	bh=Lqk0vUDZmRAN6Wkq/vMaSQtPAqbaSllRSJtlN1AeleM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=D+CioFwHNShCL36JNgds7zyG0Ct5oWjPbFP3i1u31776rBYS/pFEwQYZ5YXxJQU57
	 FftKbPxydVk/+5GHJvXVpnBLvr9iE+6B7h3U/few223Z/jT8//MsiewyJKNiswErSD
	 /DcUI4iEbFOZZd74jg/yrqP1QOEXCHEwruZkhRPbeW3TrJcmxPs12Syyc1+CLz9kSs
	 f2Xo6E29RLwXpKmScimBYkbh4axlU7M9LpagtpP+qowRXjCGgpnOMAOyRLH+7hjfvw
	 mm2/j9tA0/9BvislSRQCbY61xLbZslWeaphcsBLZu2z+8sz3RuECmr5XAyVXQmvn7Z
	 VcH5YDOT0P7vg==
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5aa5edf347eso1071599e87.3
        for <linux-api@vger.kernel.org>; Wed, 24 Jun 2026 16:07:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrEu0VckKLeoqpId7g+GVXzGmS54IwQbDqVVuU0ROo+N6+d3BCWijhXIh1jGuSoRq2u/vnZQtOTA8s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxd9nXq3T91406Me5Qgo36jz1ipmBC0iwF9WTMAW6ALS/m0zx2U
	JW+02mHeCdkrqVRvQZBW5q4Cf+kH/GoeJaMPwYUP5Chlh+9T/Syz/0uoAljOrqS3IbliEytQ07E
	cRJH1Ljg1TqosyDlTEI7L6cvtAm4ENK4kSSVUcIXi
X-Received: by 2002:a05:6512:258c:b0:5ad:3a58:1bd2 with SMTP id
 2adb3069b0e04-5aea1f40f8dmr19888e87.3.1782342425655; Wed, 24 Jun 2026
 16:07:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <a49ce818-f38d-41b0-bbf7-80b8aad998b1@app.fastmail.com>
In-Reply-To: <a49ce818-f38d-41b0-bbf7-80b8aad998b1@app.fastmail.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Wed, 24 Jun 2026 16:06:54 -0700
X-Gmail-Original-Message-ID: <CALCETrWhXNetw-BsAaoyT31suMmjYLdMh9MAuLB2Lvk2ac-31g@mail.gmail.com>
X-Gm-Features: AVVi8CdSDW0ba0Y4xuAHrcAmazhGgaHjA5VuAjrHJUgPlMDH6WiZlebtodOpUF8
Message-ID: <CALCETrWhXNetw-BsAaoyT31suMmjYLdMh9MAuLB2Lvk2ac-31g@mail.gmail.com>
Subject: Re: [RFC] Null Namespaces
To: John Ericson <mail@johnericson.me>
Cc: Li Chen <me@linux.beauty>, Cong Wang <cwang@multikernel.io>, 
	Christian Brauner <brauner@kernel.org>, linux-arch@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, 
	Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Kees Cook <kees@kernel.org>, Sergei Zimmerman <sergei@zimmerman.foo>, 
	Farid Zakaria <farid.m.zakaria@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 24, 2026 at 3:52=E2=80=AFPM John Ericson <mail@johnericson.me> =
wrote:
>
> Hello, I am hoping to discuss an idea I've had for a while, that I am
> calling "null namespaces" that has become more relevant with some recent
> other discussions. First I'll discuss null namespaces in general terms,
> and then I'll link those recent discussions and relate null namespaces
> to them.
>
> ### Null namespaces
>
> The essence of null namespaces is trying to give processes as little
> ambient authority as possible, so they are lighter weight and allowed to
> do even less than fully unshared processes today.
>
> Namespaces as they exist today are frequently described as an isolation
> mechanism, but I think this is the conflation of two different things.
> *Removing* a new process from its parent's namespaces unquestionably is
> increasing isolation --- no disagreement there. But putting the process
> in new namespaces is something else; I would call it supporting
> "delusions of grandeur" of that process. For example, namespaces allow a
> process to do mounts, have `CAP_SYS_ADMIN`, create network interfaces,
> look up other processes by PID, etc.
>
> Conceptually, to remove a process from one ambient authority scope (the
> very name "namespaces" indicates they are about ambient authority)
> should not require putting it in some ambient authority scope. Just
> because, for example, the process cannot see one mount tree, doesn't
> mean it needs to see another.

I think I like this, but some comments:

>
> Here's what I am thinking would happen concretely:
>
> First, the simpler cases:
>
> #### Null mount namespace
>
> - requires:
>
>   - null root file system: absolute paths don't work.
>
>   - null current working directory: relative paths with traditional,
>     non-`*at` system calls (and `*at` ones using `AT_FDCWD`) don't work.

It's perfectly valid to cd to a directory that does not belong to
one's namespace.  We have fchdir.  What's wrong with letting it
continue working?

Regardless of that, the current directory either needs to be a
directory or to be nothing at all, and if we support the latter, we
need to figure out what /proc will show.

> #### Null user namespace

A user namespace is kind of about how *non-current* uids and gids work
for the process and how it perceives its own uid and gid and not so
much about what uid and gid it has when accessing outside resources.
So...

>
> - Process has no user or group ids

What does that mean?  What does ps show?



Maybe the way to go is to implement the ones that have clearer
semantics and to defer the others.
