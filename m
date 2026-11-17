Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794948842;
	b=sgRWpDO+RVzo1kXynAfGMqfWuEVtFQHEE94EIQRymIm3ZQld19qxvxj3b9BiDcBIPB2l
	 LQ7H8LPBEVecL3MBQljalXiMJopliGIwm0d9XEWL2gIjJAEUQwrrkws58mxs9wM/WFT7g
	 S3DYeVQVk0RcZK5DUQ+XojB5w7meFh1gGr5JYgtXFGgraFil26CWE4UxayeiffgrqLYzf
	 JvnWoHJWSZ4IfTSz5bTel8QICvpmSXkTt2sNozHxFTvLQcILpDsaS5aZuWsjkWJAT3pY3
	 sGhqd0ws7ByZShNKxJd65KTQKbadpxjkI6wxCd5zI+KNF4iqOMlY1Ex/WSdX6PgfYuw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794948842;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=lxMCjoGZWG4QAWp+HpCFavF1sxg7OOCbkVFjQuSNzhA=;
	b=YD8Hkmsz9KLeLO19gyVwAGclRskLRWYDig5uHFZ5zqnDYp4Yase5CB9R4Fk7W++qPrgS
	 1IrxGTpSgG3TcIlqdiYF/pc1SKV6GfHyd6KwHiK77gQ4zMrax6tJLFo3F5Vm1S/zKJKkO
	 mVgLGyRC1X59iKVTKbcghj58irTbvCJAZi3cmZ/rkuHXd0awMuyevM5RJLm1B6JGhxZH+
	 YB+mlEOmq8eo0tAV7r1W+M8Q1wyjHyp+qnlLMm+vEVWGrQrJXBIo1h+zbVqHAfnHQMjnj
	 ClO2ALCqPYl6a4LpqzOd7qH7xxbfa72jQWttO4JEDNgnURYWgRXnFt8Ym78KOvsRPhA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=amacapital.net;
	spf=pass smtp.mailfrom=amacapital.net;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=LslQjUmg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.45
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56FC9606A32C
	for <linux-api@vger.kernel.org>; Tue, 17 Nov 2026 20:54:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 56FC9606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=LslQjUmg
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5be4fea434bso1244821e87.1
        for <linux-api@vger.kernel.org>; Tue, 17 Nov 2026 12:54:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794948840; cv=none;
        d=google.com; s=arc-20260327;
        b=GIT3oH5Nl+WjncZj4u54QBbr/y822YvWhp1vTIHUkudJB408W3tdfRaZXnlqAUE6dT
         zdQTsfS8Gb+Yq7ZdAtBG9CzS82/l+/W0ryAidUk4HbBE4sqTa2XkG11vsj3y49kyc7XE
         QocvdXbImORofv7fgJ9IVVQ6EPlV3odl4cWAUYXLwYUzH3Gc9wPoNSFb5LTq3czlG8wJ
         +NQrAUVUpMMow8Le4ZrNlw4wWWyqmFR/m3i8IuVybaRrcECDsuVDOppMgNeIhhRXbi/U
         MCL0jzB+j/8o/jeCrY892Heqwimt2ds3+o1xJijWvmSuNVdD8ogYIwaWaOanRYB5Rjsb
         9cNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lxMCjoGZWG4QAWp+HpCFavF1sxg7OOCbkVFjQuSNzhA=;
        fh=zmdBslda1c8hE3K8tbQw95FvXjxRYB9dEhhDxkY7xyo=;
        b=WwXv0u8lYS8/+xWDJVbF9XNbDoK5CA1TZQqvY3FwuYs1ocg8COQ3IW/iKzHJ3M6W70
         Q4nAHBOxNw4141AhdVCaMG4pVoXIc3r6WtEgxrecbDw/v3/HQqdiJvHKGRrN6HVBaguB
         FUyUCkzOk9+5ESDB2mi3lG/bvSPTEG02E0K5WhYeTeapULn88WB5X48Mnz5SkwADtcT5
         jKQU/p98jm2m/YV58sxMinqm0nEsTOxs30EEZ8cSqYP3iHWFLRybEiPej/6wlkheg4mO
         3UsiMdxHtuxHcyG3rckZCRwKHt2l+dzh7YZxAgjsiE8sd5LzoMlp3MXLWU/8s7CbYOQQ
         q9QQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20260707.gappssmtp.com; s=20260707; t=1794948840; x=1795553640; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lxMCjoGZWG4QAWp+HpCFavF1sxg7OOCbkVFjQuSNzhA=;
        b=LslQjUmgXp7ppoB5z9C6lIh34ojfvcQ8nzfZ/Bus0FFDGG0DUi+QbKakM0fZFVIykq
         5mE0e/s/CpUqdx5hmSPPf4ZqfdbbG/4eR1cdypM9sQ7xLq3NiWuooniPj3c+oOnP/Gs/
         9eulqTIqNDLgU092uHWrXSQFQOUQ0Ybq8I+KARDSFo99l3A76mmdMOP5EIWjKF4SsU8k
         CLRnBvH95KDC8joQwrmPsfza+TxJts5K4ekF1BkXcERhq9o5i5YAd+8YKoGtExZnN7ex
         +BuNP6j+NU8hBGd6crUPCUF5Rx+iT4Q8fvcxMfppbSleGXT6F0Sca+oO5jRTOaHafzSk
         UZPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794948840; x=1795553640;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lxMCjoGZWG4QAWp+HpCFavF1sxg7OOCbkVFjQuSNzhA=;
        b=lpHEL4+ReAgZi+C15Vnq0kB5UC87zCewLbxFks1fognoxMkeirST4Lgpmo9xrA3wVM
         Waxeu5c/1lPl1UF8KCydlXL62naRLh10D3zULRdA39lUdMEzzHoLUUQiOwT3KVgk94cZ
         MDN9T1X7KVgOU8F/bEb/F2X5OexekbPmvNv8XaLvlVAOfl7K7zIDqJ3g9olJ2iZfqJFF
         VKAMMHCBaV+KSsg3Ql3P8wON7Z3Xs9Hiv2A44H2yWzVkzWANvCyUgd1x2TtHj/e7t+Tr
         m5kTvRhC1m0/hh3nBbd4ULcDdGvlS5Ul5pgIz8NMaB/mtuIaCX/TlgdcX2Mz1Ix87Q77
         4BJg==
X-Forwarded-Encrypted: i=1; AL+hErHOFVqAK5uhdJeGJj2H20dFH0FSKqh7eamWutDAcQo+yaLSy5f5EtLlmAay12KzvsQQNSI9/h8tA7s=@vger.kernel.org
X-Gm-Message-State: APuU4Z8z5NquZGJr4hhwfOKE9QskHJQkv35hk1uELD57pQOd+vNBwcsI
	lD4YUfxcMjXZnwQOFvbInFzTsfAQgFPaMT9HNSvkdlu5+FicNDB71KEKeY244uhCOUxVfDvtkER
	zhKJkAI9MR2Xq3KPZCRAx6sB38MQ7fnvmr7C0JAPm
X-Gm-Gg: AYBFou2TTE8+jxPbzesJsfqj1vmIyDJ751I2JVyFy/GVASbn3/VWC69b9HYWl0A8h1s
	Utu4BvKtHBJA8JheH8xtI08I86oe18QKnI+N4I/QZt7EYRJqb83b9MCyNVM5YuWQn/aA8dcXnV4
	LYZK/mZYx70bBWdXie5jtSXJMaBh+CxXffpjr5qmAhReSmOxKU7dBVXPF9Xyyi7x3TanB4gsSni
	z9qfDOFBpJXuukbfhNOcyIYuq9EoNheydmkmpYNwEHZvpbJhziNf1+juOVSEm7b5QGvc7cq7ynL
	sXo16jkWOQkj0WGWr39kNCml2YpkzSJRSeXN7RURPTT0fEkTiOeSYajoL6aaK3RY8dUqJIR90YA
	4v9AWQrliU+xLPY1VkiHMDTw1xIBav9YNgg==
X-Received: by 2002:a05:6512:224e:b0:5bf:b96b:89f4 with SMTP id
 2adb3069b0e04-5c1a0f1b8e2mr1319677e87.19.1794948840370; Tue, 17 Nov 2026
 12:54:00 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261117050841.3289652-1-jarkko@kernel.org> <20261117050841.3289652-8-jarkko@kernel.org>
 <CALCETrWtbUFQGDOCHkxAN9O4i29ixfL5KKF1Cqw2-CjxKwC6gQ@mail.gmail.com> <avyzFnKQrNOid25y@kernel.org>
In-Reply-To: <avyzFnKQrNOid25y@kernel.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 17 Nov 2026 12:53:48 -0800
X-Gm-Features: Aa3M54qx88-je4c1jdCxPXUBmX_p3qTxglmaltFgKplV78kiTxOHsj4XFF6xQaI
Message-ID: <CALCETrWHxjrQvRC66d1fvkZw1e8_+38BdzmjSYHmqRjXZnD8nw@mail.gmail.com>
Subject: Re: [RFC PATCH 07/13] rootns: Add rootns_enter() system call
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

On Tue, Nov 17, 2026 at 12:03=E2=80=AFPM Jarkko Sakkinen <jarkko@kernel.org=
> wrote:
>
> On Tue, Nov 17, 2026 at 09:42:26AM -0800, Andy Lutomirski wrote:
> > On Mon, Nov 16, 2026 at 9:09=E2=80=AFPM Jarkko Sakkinen <jarkko@kernel.=
org> wrote:
> > >
> > > Multithreaded userspace daemons cannot call setns(CLONE_NEWUSER) or
> > > safely mutate process-wide filesystem state in place before spawning =
a
> > > child into a target namespace set.
> > >
> > > Add the rootns_enter() system call to fork a child process directly i=
nto
> > > a rootns whose root mount has been installed. Transition the rootns f=
rom
> > > ROOTNS_READY through ROOTNS_FORKING to ROOTNS_RUNNING for the first
> > > process so it becomes PID 1, serialize concurrent entrants on waitq
> > > until bootstrap resolves, and admit subsequent callers into the runni=
ng
> > > PID namespace until teardown begins.
> > >
> > > Require CAP_SYS_ADMIN in the target user namespace, forbid credential=
 or
> > > PR_SET_NO_NEW_PRIVS privilege escalation
> >
> > Why are you disallowing this if no_new_privs?
>
> For no any good reason at all apparently: no_new_privs is inherited by
> the child and only restricts privilege gain across execve(), whereas
> user_namespace transitions are allowed under it.
>
> So yeah, it's a spurious check, and thus I'll drop it.
>
> > This isn't necessarily a showstopper, but fork() is really quite slow
> > in many cases.  It would be nice to have a more spawn-like API
> > available.  I assume it's possible to open a file in the target's
> > mountns by some sane API even without entering that mountns, as a side
> > effect of how the fsopen / move_mount mechanism works.
>
>
> If the caller retains the O_PATH fd returned by fsmount() for "/", it is
> able to open files inside the target mount tree via openat2(...,
> RESOLVE_IN_ROOT) w/o entering the mount namespace, and pass the
> resulting fd to execveat().
>
> For avoiding full fork(), there are (at least) two options:
>
> 1. A rootns flag in clone3() (e.g., CLONE_INTO_ROOTNS) and a rootns fd
>    in struct clone_args (disallowing incompatible CLONE_NEW*, CLONE_FS,
>    CLONE_THREAD, ...), and callers can pair it with CLONE_VM | CLONE_VFOR=
K.
> 2. A flags parameter in rootns_enter() (e.g., ROOTNS_ENTER_VFORK), which
>    would map directly to CLONE_VM | CLONE_VFORK.

There's also been some work on using a pidfd-like object to build and
spawn a subprocess.  Supporting that would make sense, but I don't
know to what extent these projects should block each other.

--=20
Andy Lutomirski
AMA Capital Management, LLC
