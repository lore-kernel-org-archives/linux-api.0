Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795168135;
	b=OggpGKgaiReWl63ZhjrrJTXzX8vzpMpNbafTBmrXppEe4ln8nrwODoCBBx4MzgehCvdg
	 duLh1Qcy37jGxOxWUnvW/Ii5wJYRUyqau1ZV+wL2DY7cbHNJCWp7Lisn0GYUIUqipDc6E
	 R0fHQ9sCh7ZoX0CxnzWKDuaCoIfszxOuXqzCzRFBTCPE55ckrdkwrzqDEfhcVKdC6EO6a
	 lNp53nkXPtCkYowQI5810i5tylaZ3SuQ9CXSxttN9nM1tXNgMVjcYAqFLnCvDcZI4GmPw
	 +1QB9WZIooO0ZRIn/QSXeQQ3mkiJ3qHwB13/X+rKs4rcvBM4dFp8nePg09AgWbFyIkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795168135;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:
	 X-Forwarded-Encrypted:X-Received:Received:Mime-Version:From:X-Mailer:
	 References:In-Reply-To:Date:X-Gmail-Original-Message-ID:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=E/BqrsiNEe7N9X/6LzAE99VV6mdYgIQRyh/LOdMxu5o=;
	b=ElWhPw1fdn564H0ncoEyIIKp9+BGEYEUeZ36gnNyWk1VxegokVwJL/rj0LvyRozD/7OK
	 7nPPqlCd6SIkltcQHUwUxO6aJwC5rXYHZS1yyqnZO/wXcfhIkVM6nodFJmUEn96DP7hop
	 +4a6MTK8eLBjhZSkV4/6OTolzJFwmjgmnO/KujeKQvh17J3GufAYq7bu9iaLffmX9enRK
	 55XjBm3GEBuYAasjZ8SuTpRO85ypLU3ltOA+ORu6UPVm5GpzeZfyQvBHJPua4x7nB6j5Q
	 RxDkYgBI0IgsjBx47PyhV66xzZFwvrv4bgD15ou8kS5MasMetmvToFttNGWtR09il+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=black-desk.cn;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.167.41
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BCE606A326
	for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 09:48:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 44BCE606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=black-desk.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5be47aa555cso788098e87.3
        for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 01:48:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795168133; x=1795772933;
        h=content-type:cc:to:subject:message-id:date:in-reply-to:references
         :from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=E/BqrsiNEe7N9X/6LzAE99VV6mdYgIQRyh/LOdMxu5o=;
        b=p1Mf8CuQzUvKyb/Uf/bmTOULj7i0tLJNrTsfKoiNilTaZK7/9vyMwYQIyCLfJxx4QO
         cF5idpXbjqapGXF0ZksrZdlykSZC3UqR3ydYV3CZsrcBK52zc2kwuNQFyu5VE6ZD8QU2
         03UfyJ0sYKb2+EkTos4XsmPahKDeYlU8uDsqVPYMc3wtcNg8UtPt1/lW/4jt+5bkB103
         6ZLs4cXY43O8EGMwl/1H+srlUBwD+5MlMVHJzPDeX51d4XY8Ydduik2uDzT/tPjxNmjU
         l1iuP/K+DKCpFb4aMiEWtWTaP03o2r1alT3KVIwcseyMYeefIWPCBZV4n71v/lzOyghp
         OrWg==
X-Forwarded-Encrypted: i=1; AL+hErHE7Iv+X7SZeI3mzHi3FqzW1ShKdfdQR1ZlJP3/f04CzR7rL0t9pq9u8ZB175q+O62ipk3K9mThAqw=@vger.kernel.org
X-Gm-Message-State: APuU4Z86//6tEytQCSW3Kea8P69YdxkUpgtIG7FTsHukdbaL0csSlMGG
	k95sIMWfcVe+hBttHqPQOSuGMJYcoQV3y2qdhFUzya+9XuhWQkyLoYk4hBpSdKrCICw=
X-Gm-Gg: AZFdTZfneQ08257ENZxGPg8+/Tq5RxDymxLkdyn/RccNInCPa+9f9OLHmOh2BZ3YDlo
	ukxtR087eI14L5Ubaxp2hp3+f2ZOhPzJwQRvRTcQXrEyidqSdwgfm8P/yVZYqML7NxmktpDjlsP
	zTpg5eBcJSlDccF8YNIjKbEr6EPahmUzptPPCkQ0PGZcbuuxMIpfG70ZXgYUsHzZUzpLNpf/W7M
	D/KRMO5+UAJCeMtDBubg2eChpqZLx/RmMdVZukuZisW1WVnMKcmGcFemOR1iVHaNzkaBqXvzof+
	KgYzA5twL8ToQ8uKOrb9hosCHr2MT7w9oE+C2FpikM5W/BG/jc2vWCgX1ldyzX+isiuk9c4tZB7
	pUpAM/TJapC45e9O5kxyAqVgHxz6B6U0G7e+5I0v0s1vAczLXfEBreXuvUN9uf+ZbHmSJFDtht8
	SKm7jWgSqys4lybJwu1uqsW/0N7jXAVHlOBIQBTTV0idFRUUDG1WLeGxBCEAbBnFzwtcOmTSrar
	/Gu6IwAh3YZbC2l91UnSP4YOADJyUkwU+L/27LzieugoMusRB2FnodV3J8hqwW526qlWHGgnMzD
	r3RNKSwH62H7YwZJeVe2/AG3ap72dlavnq8qr/N+8d8CGMi708kTAsZ+aX1dtaKv/EpYtdYYbj8
	6QmypymubUTceA01tmuopcMQgU6DmBlWXCYv65L0=
X-Received: by 2002:a05:6512:2348:b0:5c1:4d49:cd74 with SMTP id 2adb3069b0e04-5c1bc7bcd31mr870620e87.17.1795168133170;
        Fri, 20 Nov 2026 01:48:53 -0800 (PST)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5c1bd043387sm450701e87.49.2026.11.20.01.48.52
        for <linux-api@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2026 01:48:52 -0800 (PST)
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5be3ed646a5so843157e87.1
        for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 01:48:52 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGJqbOAJ0r0bCMAqT9YO8r+OOMQtYXPm/w1zvCAYWXic3XmB7pi8Hxxzx8r00vrBPrQwdOTZtDR6Ec=@vger.kernel.org
X-Received: by 2002:a05:6512:104d:b0:5bc:b659:2e15 with SMTP id
 2adb3069b0e04-5c1bc7f36d7mr678438e87.36.1795168131847; Fri, 20 Nov 2026
 01:48:51 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 20 Nov 2026 01:48:51 -0800
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
From: Chen Linxuan <me@black-desk.cn>
X-Mailer: aerc 0.22.0
References: <3e4103cbcf7b76535e2f957762174515ef00f08d.camel@amutable.com> <20261119135452.990-1-arpe1618@gmail.com>
In-Reply-To: <20261119135452.990-1-arpe1618@gmail.com>
Date: Fri, 20 Nov 2026 01:48:51 -0800
X-Gmail-Original-Message-ID: <CAC1kPDOSS=w6mU6ruk0f5=V4NNdyr0NfUCA3npNdKPVGx+JVZQ@mail.gmail.com>
X-Gm-Features: Aa3M54ogGYoYwMNHk57gHJJnlwKfTwwkirw9b7KG6c57d-KoNPXDISSoVm4_K7g
Message-ID: <CAC1kPDOSS=w6mU6ruk0f5=V4NNdyr0NfUCA3npNdKPVGx+JVZQ@mail.gmail.com>
Subject: Re: [PATCH] pidfd: restrict pidfd_getfd() to the caller's pid namespace
To: Jiwoo Kim <arpe1618@gmail.com>, Alexander Mikhalitsyn <alex@amutable.com>
Cc: Christian Brauner <brauner@kernel.org>, Sargun Dhillon <sargun@sargun.me>, Arnd Bergmann <arnd@arndb.de>, 
	Jann Horn <jannh@google.com>, Chen Linxuan <me@black-desk.cn>, linux-fsdevel@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu Nov 19, 2026 at 9:54 PM CST, Jiwoo Kim wrote:
> On Thu, 2026-11-19 at 14:42 +0100, Alexander Mikhalitsyn wrote:
>> It it an interesting point, because pid namespace itself it not a
>> security boundary. While user namespace and capabilities are mechanisms
>> to manage permissions.
>
> Hi Alex,
>
> thanks for looking at this.
>
> Agreed, and the patch does not try to make it one. I followed the rule
> Christian suggested in [1], requiring pid_vnr(pid) != 0 for operations
> that grant access to additional resources of the target, which
> ee8323fdc827 then applied to the namespace ioctls. pidfd_getfd() hands
> out one of the target's open files, so it looked like it belongs to the
> same group.
>
>> Currently, you can do something like this on your machine:
> [...]
>> and this will actually print hello in the Terminal 0, while the process
>> doing that lives in nested pid namespace. But this is not a problem
>> because this guy is a root:
>
> Right. As far as I can see this also works for an unprivileged task of
> the same uid, as long as it can reach the outer task through a procfs
> instance of the outer pid namespace. So pidfd_getfd() currently behaves
> like procfs here, and the patch would make it stricter than procfs, in
> line with the pidfd ioctls and PIDFD_GET_INFO instead.
>
> The case I had in mind is the one Jann described in [2]: a task in a
> child pid namespace that gets a pidfd for an outer task over a socket.
> When it has no procfs view of the outer task, as in a container with its
> own procfs, that pidfd is its only handle to it. There, the ioctls refuse
> the pidfd with -EREMOTE, while pidfd_getfd() returns the target's file.
>
>> So please understand me right, I'm not saying that your point is not
>> valid, but I'm not sure what was the intention behind pid_getfd() API
>> in the first place and we might want to have semantics and model close
>> to the one procfs has.
>
> Understood. If pidfd_getfd() should keep following the procfs model, I'm
> fine with dropping this patch; the inconsistency would then be on the
> ioctl side. I'll leave that to Christian.
>
>> To conclude, it looks like we have a little bit of inconsistencies
>> around here :-) [ But please, don't go and change anything in procfs as
>> we might break some tricky use-cases like CRIU and SCM_RIGHTS users. ]
>
> No plans to touch procfs.
>
> [1] https://lore.kernel.org/all/20260925-gewischt-auftrag-tierzucht-c153cb3f9f74@brauner/
> [2] https://lore.kernel.org/all/CAG48ez1T5-tUHVK_iHsgUtWa-inVdrZxA3E-ZCW0iENJvasKfg@mail.gmail.com/
>
> Thanks,
> Jiwoo Kim

pidfds provide process access without requiring procfs to be mounted, but that
does not mean they must expose every capability that procfs may expose in a
particular mount configuration. It is reasonable for pidfd operations to apply
stricter checks.

The existing handling of the pidfd namespace ioctls follows this principle. Even
when procfs may be able to access a target, PIDFD_GET_INFO and the namespace
ioctls require the target to be visible in the caller's active pid namespace.
This does not treat pid namespaces as independent security boundaries. It is a
conservative restriction to ensure that pidfd interfaces do not gain additional
access merely by bypassing procfs.

The original pidfd_getfd() commit, 8649c322f75c, used the following rationale:

> This syscall allows for the retrieval of file descriptors from other
> processes, based on their pidfd. This is possible using ptrace, and injection
> of parasitic code to inject code which leverages SCM_RIGHTS to move file
> descriptors between a tracee and a tracer.

The syscall documentation in the same commit says:

> This syscall gets a copy of a file descriptor from another process based on
> the pidfd, and file descriptor number. It requires that the calling process
> has the ability to ptrace the process represented by the pidfd.

That rationale assumes that the caller can actually ptrace the target, rather
than merely pass ptrace_may_access() for a task referenced by a pidfd. If the
target is outside the caller's pid namespace, the caller generally cannot
address and ptrace it through the ordinary pid-based interface. Allowing
pidfd_getfd() solely because a pidfd was transferred through SCM_RIGHTS,
SO_PASSPIDFD, SO_PEERPIDFD, or fd inheritance would therefore give pidfd an
operation beyond the ptrace-based justification in the original commit.
