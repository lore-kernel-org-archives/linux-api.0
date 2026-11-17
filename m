Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.172
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794937497;
	b=MAir/eOsH6APnvTC8ciLJ/KnXson0e5rXcbrlOtjdSraNMEth+RzuV3Dp/ueFX3t9zox
	 iWmKdDX1+ZiQ9LerRh8cjFKEFNPPbWk9x4oi/8F8oPySOhA3+A0rMl4fBHdDuCYAk5VFu
	 ro/ur2GgzSB5QvXGJkqnwAgjwIXEtQXXh4I4ut/eS1H9FTAyUvTePbg6JaugV++lxZ4y0
	 SBBQVh2yVMdPFzp6lOFwLO/7utcH0mE1tLO9qplcbJVcEHwkM8ucCvKRqcPJ2skdgz8Wm
	 tATie8s8MMBv3wnWES21EtQJwQaRHevUpDEdJe3hwcZwtd4+M7WRMQB5hJIRjRKe03g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794937497;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=eNNOnQUc8HQHxzszI7I5Z5MCWmY2JGLCloKQuWJY2Z0=;
	b=Ar0/uar1+w/5TcxJlnjkgyYtCSYNPi2wWP6fCr+KqW2OlOWl8SA8P0kzmiNlNor+XKR1
	 cOCfXJxHGetpsn7L+7F1xKhphFiyitWG7yU8xAkTC1omVWHV9Slzj9DewqVQnRt6d627f
	 RVjw7nZKjNj1Kj6Q9zr1ZamDqaD4uQb3e2YaK8jP5c5gkcR5NTMQkgqya8Cpf31pNsdf8
	 kBlQmSFfTzIG8e9KqszvDhR5P+u2cCMQLocG8uOxkpzQvMfjtBWfXXHOHNSVzHH/YtrmP
	 ShTlZBNzgAbPqFf1uGs0F+dk+GRiORYGwIDd/o5PzR1mRCEC2Gc5BDicYjT978OPqmQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=amacapital.net;
	spf=pass smtp.mailfrom=amacapital.net;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=oAFIhfOA;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.172
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D9F606A331
	for <linux-api@vger.kernel.org>; Tue, 17 Nov 2026 17:44:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57D9F606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=oAFIhfOA
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-3ab3b29a298so1603871fa.3
        for <linux-api@vger.kernel.org>; Tue, 17 Nov 2026 09:44:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794937495; cv=none;
        d=google.com; s=arc-20260327;
        b=ePaxKAjjng/iFC+ffux7tpFYzqA5qRQS+nWpzfgqkTMhuqdmgMvTgWkqR2IHXBNBtB
         ObXbzBKlIxYZZpcGr6eR6GAXTBYNgfveA+19dEXsWvSn0MsCP1biKgSOStlHsEvfmRgD
         AE4awAxbLGbOwmVTktw7D/YUZFW4r3MjP0ptCmx7cCKy+3vgalNeTaK9GKL0CNe2O+yQ
         XSjbFCYd2OjyNsoYAtZOhnyOJF9McZWNwb0TP2KYkXIRLSBwGXvhWcgFHasZ+9Haiodx
         jAXnmjCopffE+NI/tU5V5KO7UlWoZC8jAsW+b0bqDSFSqJTku3DvafK/21C/SCDYNNju
         kwuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eNNOnQUc8HQHxzszI7I5Z5MCWmY2JGLCloKQuWJY2Z0=;
        fh=Hp75jenDBpLm3FSKiD33PnkZxlwuCi7g71yRJqTifr0=;
        b=OJDAnyv0byVVH7f2FWkVeIjoVEmq9IgAEc40dHL4ObyNP8oAeS/8JSvynNsE2tHgib
         ybxM/oOaYhU78f/G/GFFYKU6FZAq2HkfRE8P6nP3KKFWa4k88caGlzgdnBFMEcxXvk9E
         7hVszQUCATSHk3iuPRrRnqjgPt52OylMr7+QGxMHON29uFVhNkzQsYEVUb7pyRl8tlQN
         ks+6OcO3Q43kuET0ZwRyE2+JHxWdfYTzulEIVNibiZ23rmvcQnD8a8D9+Zjvg2xM1qbC
         +y1Uxl/zaeAvm5ix+OcpOoFfRIhqdcjRiO8+IYsrMeEzr6jDqcWyF5/VgM2zhgShubsv
         arXA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20260707.gappssmtp.com; s=20260707; t=1794937495; x=1795542295; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eNNOnQUc8HQHxzszI7I5Z5MCWmY2JGLCloKQuWJY2Z0=;
        b=oAFIhfOAkcB0Dg4mKVfkuis2uNtcfHHW1ME1slyaFUO4AI5iAHAmrY1Nw3LuN2VQnC
         6IGXyvAYklXrHuXDFIJP+OpIvCKpQXcsR6yhi7y7UMeoYZWd0Rkq8srCeIQr3Ut6yHo9
         s3QMrLw8d+7yQo0fv8lDR6N1UWY7BgFBjya/tZ7WAbd98chUjwhGKhZVz4B8CNKS2JVt
         s01yrFYXNsMtBbhpU0mHCjFVPEb/8RNf03yXDk0jC6t71dtVUAnUQlSNlv3yrv5kFy/Z
         7TcwXV5Nfa08sHn/NIrA4+u1dyH1Y1UL/1CiJgo3Ncba+UeXkhzzSc1rUH+9TFU6YyuR
         ZiXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794937495; x=1795542295;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eNNOnQUc8HQHxzszI7I5Z5MCWmY2JGLCloKQuWJY2Z0=;
        b=oC5bFghH2qU1EnldXQAcwamx2ZG2b024dHVJ5FZw4X4zCmHIKp/tVRr5UA/dZAcKMa
         pJ0IPlrGh5LC0XK69hLgOEfIgIkuoA7a/ps0Icc4ZumoM3doN7Le0vXczo7B6og2S8+t
         QxTJ32T93sZZ41NhpjEPHhhCnCx+/SWPjdusrY2z+0ydy9pH1Xlkmix9i7kUEvmSSk6u
         wT67tQSloqmKCcFNnBNJX2JYv5QCT+SZb7rqgeFdSXT2iB2jsNLyggIWaJijDd09+vMg
         v3sXuWkoJLCdyhqDIaD9PhDz4y+8kdTVdRENl/kOFhNQaxYMVG9kFIuBxjJq5zmJHYAU
         VvsQ==
X-Forwarded-Encrypted: i=1; AL+hErEg8H++aCJui45y4M7T7/WoX2fjPnskiRhKPXmMoivphs40lEH8C5JqA5tm8Wy0hfrwK1AJ1Yxw0Bg=@vger.kernel.org
X-Gm-Message-State: APuU4Z9sYPBvs2gU1ChzbBY9KHQXR8p9Tqkq5+RXSRIbcIc83LJ1cF7u
	XZolCHc7JH9bQqxz/TCG+QdNwYDOyNSsEQHbf37bm+vB4RYTYlG92tBfxshX2/QmLbE8ErRbgXj
	xivbf6SNtth8FEXR+H6OltgO8TwRiVgOTYbCxi/lB
X-Gm-Gg: AYBFou3jHAkQug3HtteMaEXC6I8AWiIVgJPY5vYiDVf1cu/lUOs0T2iZD2Jlv4Wf02m
	BdBb5OSFH54cNUHOUrl4QXwhkj/lV1Hd/83x5HKS2AcZkGgk16ZMBit3z6Zg4+yBmHyXvfBj7kc
	YFR0LMfIiLZqL9AkzFHB0qx4HTnYsuTJOh4EPEqdxEvj9sHYP8iPddykeSEa11IInlk2jafAOM1
	Ko7HuRn2446uS7T+PLaHVlogJzfea7BKxau2xpjutbNzOo7xem3IIilFpCFtJFlrsqJ7j2cE9u8
	OeJrZ/Izfkha6PIloyvsnljdbhVe8QVAM0KH/rH4Q4odIMVTZF+0V/r9cdAbnOP7hVM6ULGcenW
	lgB6KwceagzDGhLdmKZ7JUxqHHpybl7GMaPtH+euZlmHXeMb+sGHCErc=
X-Received: by 2002:ac2:51c6:0:b0:5bf:b945:4334 with SMTP id
 2adb3069b0e04-5c170a15b78mr6210350e87.67.1794937495491; Tue, 17 Nov 2026
 09:44:55 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261117050841.3289652-1-jarkko@kernel.org>
In-Reply-To: <20261117050841.3289652-1-jarkko@kernel.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 17 Nov 2026 09:44:43 -0800
X-Gm-Features: Aa3M54pzaE332pTi53D1YpA5VO7WahNUrZvzEHccu8lFNhASVJD5SKW-Zdzq05g
Message-ID: <CALCETrUBUnJVhiMkft6hTZZMe8nTpMBRTGY2v=9x5ETBSvmPZQ@mail.gmail.com>
Subject: Re: [RFC PATCH 00/13] Namespace for namespace roots
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, 
	Ben Segall <bsegall@google.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, David Howells <dhowells@redhat.com>, 
	Davidlohr Bueso <dave@stgolabs.net>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, 
	Juri Lelli <juri.lelli@redhat.com>, Kees Cook <kees@kernel.org>, 
	K Prateek Nayak <kprateek.nayak@amd.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Manfred Spraul <manfred@colorfullife.com>, Mel Gorman <mgorman@suse.de>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Neal Gompa <neal@gompa.dev>, 
	Paul Moore <paul@paul-moore.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, 
	Peter Zijlstra <peterz@infradead.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Serge Hallyn <sergeh@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Suren Baghdasaryan <surenb@google.com>, 
	Valentin Schneider <vschneid@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Vlastimil Babka <vbabka@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 16, 2026 at 9:08=E2=80=AFPM Jarkko Sakkinen <jarkko@kernel.org>=
 wrote:
>
> OVERVIEW
> =3D=3D=3D=3D=3D=3D=3D=3D
>
> The problem that root namespaces try to resolve is starting a container
> from a root mount tree that is pre-populated before any process is allowe=
d
> to run, without inheriting any host mount-tree ancestors.
>
> Work on this feature started originally in 2025 from David Howells'
> container object patch set [1], but I turned container objects into a
> namespace of namespace roots and built a new implementation around this
> premise.
>
> In early 2026, the patch set was left to gather dust in my kernel tree
> [2]. Then, the other day I saw [3] as was shocked by its over the top
> complexity and thus, here we are.
>
> Not doubling the number of container frameworks inside Linux kernel is at
> least a benefit over container object based solutions. Parallel plumbing =
is
> an inherent flaw of container objects, and it directly affects on
> development and maintenance cost of container runtimes.
>
> Also, thanks to better scoped implementation surface, verifying rootns
> correctness is factors easier than with container objects, and even my
> early kselftest is meaningful. We know what and where we are testing,
> which is always great.
>
> Finally, it is more compatible with pre-existing container tooling
> whereas container objects would have much higher cost.
>
> [1] https://lore.kernel.org/all/155059610368.17079.2220554006494174417.st=
git@warthog.procyon.org.uk/
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.gi=
t/log/?h=3Drootns
> [3] https://lore.kernel.org/linux-fsdevel/20261105-b4-cells-v3-0-bc909593=
7a84@toxicpanda.com/
>
> IMPLEMENTATION
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> rootns_create() allocates a rootns object backed by a pollable anonymous
> inode fd, pinning dedicated empty mount (CLONE_EMPTY_MNTNS) and PID
> namespaces along with any optional namespaces selected in flags.
>
> Before entry, a manager prepares the mount tree through the control fd:
> FSCONFIG_SET_ROOTNS binds a newly opened fs_context to the target rootns,
> and move_mount(..., MOVE_MOUNT_T_ROOTNS_ROOT) installs "/" onto the nullf=
s
> root once and attaches relative submounts beneath it.
>
> rootns_enter() forks a child directly into the rootns credentials,
> nsproxy, and root path without mutating the caller in place. The first
> entrant becomes PID 1; once it exits and zap_pid_ns_processes() reaps all
> members, poll() reports EPOLLHUP and rootns_wait() returns init's status
> and rusage. rootns_kill() walks pid_ns->idr under RCU to signal member
> thread groups.

Can you clarify what this new API actually does?  I've read this three
times, and the best understanding I've come up with is that you've
designed a way to create a group of namespaces identified by an fd and
you're adding an API to configure and enter them cleanly.  Which
sounds very sensible.  But I'm completely confused as to why a
namespace needs to be owned by a "rootns" or why that ownership
affects even newly created sub-namespaces.

--Andy
--=20
Andy Lutomirski
AMA Capital Management, LLC
