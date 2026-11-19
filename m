Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795115996;
	b=Y81hoyBANmv3XzvbvlNeLp0s+wmxFSQItmFZm4y1wpbo5cZ3Gu605MtoZ1PjfRJGlIHZ
	 7jCzxnDKi2Rsgy+PHYR6s+H8kFoknMiMFZBrfrh1JUr4Fdssrrn6BaFCVK91vqJoS4eft
	 ZdKdALsr2rZn5um+kgFkKRBWR+D6cmmyXVBk9upWg/LOxX9rvUdGkV7qr/0ULFedEp+tC
	 1BrnlJp4UOLnty2ClN4N/gBHWjtO1sNuO3EkuBNRKkxgKh/Fb+MzQEt+BuIBoqTWelGTP
	 cJ20i/ImQ3PrQ8C8hz8LRPWPVbn8cGCY6buM9s0z3apj6mFv/VzgD/7AS4jwZvokvJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795115996;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=B3fPYwtnhJtRTzUId1FsxU5BbcK59iDRRgRTHG4g8TM=;
	b=D/MXtRNWfrmA2NvtBdrY6pmCx8T5ZQC9Tfg58b+nbAXpfBpKWTMCcyrD/ytEH65AlPrM
	 +vGR7zVI0/vGMUtkG3GBJ/vRBA7A4EF4Ih8mFh+njr18CKgto1Hmac8GBDJVObvFdCnKj
	 +hYuRGNFZRNl9+BsyhyZ6SHUpKqOkDgzXWfa/rSGQrb8GiHw8c1cgsoJ97amGI+e+eK+c
	 HXWc3eSQzD+OdIvWL0WJ2t7uHBL/Fug4Bzu6N+1HYcw/WpHwGS8o//MeMCyzWulLcDuTc
	 sMkIFQYVkHcDUUmccwxjW3bQCappi35QcHBwe+mdLb+AUGkgtz1+YOyRYcTn4tHf55g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--halg.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=e6cswkqt;
	arc=none smtp.remote-ip=209.85.218.70
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B11606A335
	for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 19:19:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91B11606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--halg.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=e6cswkqt
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c5095dd1514so12474366b.0
        for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 11:19:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795115995; x=1795720795; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=B3fPYwtnhJtRTzUId1FsxU5BbcK59iDRRgRTHG4g8TM=;
        b=e6cswkqtbr5gIXT7zPqwbxbqDazMSGSQh5brqg3woxMXmbrKcsjWeeblJDpIszQpxv
         TGd/0ALnpNpnRp60nZIXkRb+MGUi4YpzELfsgyKbr4pDwt9UXKuQxAM8wTMa71F87J3J
         YYQ7BIp9fnmNRMjQDqTpqrghxE77fiw7x7nGb+4Wy9iKCcQm8Xc//n2/a/t+2OZIFVuz
         vY5oy9BS16JZ7A7CoPwlDpw7vJHOvZMFy7JAayuM8duhreLgQWZdUtjMkjojacGMmAPo
         XWy8bVfUa3GEHukBLrYA+VA8kAgfdKRZvXiR9bpIv8Lbshi6/T1qWH0+rQhWll7dwZeB
         FMQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795115995; x=1795720795;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=B3fPYwtnhJtRTzUId1FsxU5BbcK59iDRRgRTHG4g8TM=;
        b=pnjn8EKVnXNrgzd4o3RyqkYa3qZo34G8tNXJydm1D6gKadH7/O/WW2jg3uQlewQlc5
         14mYHIil2jAGL6+F/K2QtoZz0IYhVBm1h8Tkpb9ijY8vA5WeTk4A75JZHa6KCTUS5RQY
         Wq5unaFn1v8dOV7Pkr2uXejnL6ubGsRoaj0QKlLH+/e7OMCQBq1Ec90s4PRiuOSPZSbg
         LSL7pg6mE+4oYx1hAMSwbM2R8ReYaMoBC+ubTA8JOlTwwrQhbjkR0X0bHNPLkcTXV0Bm
         ERZOEyLjR90P5ag6XDneoBmgap2m93R/Rq7jnjl3InmeLEhkTtOXzMoIkkrsSdODYj94
         X/QA==
X-Forwarded-Encrypted: i=1; AL+hErHFcpM2XvxGWwMoYs5WrmD7emKbZdSo2rY/D9gN2cXosJeyzgsBw5S9aZi9I8ap1MZElSQjfxlArYg=@vger.kernel.org
X-Gm-Message-State: APuU4Z8Mzvy8UKSYe856yIqQtGVYiVAqH1pGL746yL+Nr3YHKgs/lrUa
	tkmNX/NqowR0L5bh3K9mxRG7LwqILqw1oHVvMSZ/nLw8OCGd+C68oGm4zxnaymyvyPuJJSBFQQ=
	=
X-Received: from ejbgt15.prod.google.com ([2002:a17:906:f20f:b0:c2e:1bc5:6c6c])
 (user=halg job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:9fd0:b0:c50:a2f1:f200
 with SMTP id a640c23a62f3a-c513a5da8e7mr99034666b.16.1795115994327; Thu, 19
 Nov 2026 11:19:54 -0800 (PST)
Date: Thu, 19 Nov 2026 19:19:53 +0000
In-Reply-To: <av8QNiFcnGWocORy@kernel.org>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261119104208.782900-1-halg@google.com> <20261119104208.782900-2-halg@google.com>
 <av8QNiFcnGWocORy@kernel.org>
Message-ID: <av9L2ez51erKkQNo@google.com>
Subject: Re: [PATCH v2 1/4] userns: introduce capability bounding set for user namespaces
From: "Hallgrimur H. Gunnarsson" <halg@google.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, Serge Hallyn <sergeh@kernel.org>, 
	Andy Lutomirski <luto@kernel.org>, Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	David Howells <dhowells@redhat.com>, Kees Cook <kees@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	"=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?=" <mic@digikod.net>, Jonathan Calmels <jcalmels@3xx0.net>, Jann Horn <jannh@google.com>, 
	"=?utf-8?Q?G=C3=BCnther?= Noack" <gnoack@google.com>, KP Singh <kpsingh@kernel.org>, 
	Casey Schaufler <casey@schaufler-ca.com>, linux-fsdevel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, 
	containers@lists.linux.dev, keyrings@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Thu, Nov 19, 2026 at 05:05:26PM +0200, Jarkko Sakkinen wrote:
> On Thu, Nov 19, 2026 at 10:42:05AM +0000, Hallgrimur H. Gunnarsson wrote:
> >  static void set_cred_user_ns(struct cred *cred, struct user_namespace *user_ns)
> 
> I read the diff through but this led me to dead end. Cannot find this
> function from anywhere. I look the changes again once this is sorted
> out becaus this is interesting.
> 
> I wanted to look at the call site to understand how cap_bset gets set,
> which is not now possible but I do get the gist and agree with it.

Thanks for taking a look. The series is based on v7.4-rc1 and
set_cred_user_ns() lives in kernel/user_namespace.c, where it is called
from create_user_ns() and userns_install(). ns->cap_bset itself is
initialized in create_user_ns() right before calling set_cred_user_ns().

> I'd figure getting this relates to my rootns patches (perhas). One key
> mechanism for me resolving the unprivileged in my use case is
> MOVE_MOUNT_T_MNTNS [1], which is orthogonal but just pointing out
> the problem space.

From a quick look, they appear complementary. Being able to do more
setup operations from the outside generally aligns with bounding
capabilities inside the user namespace.

> I read through https://lwn.net/Articles/978846/ to understand the topic
> overall. Just mentionining as a possible addition to the cover letter
> (not a priority/necessity).

That LWN article is actually linked in the cover letter as [2].

> Hope these help and can be kept in the loop :-)

Will do, I'll keep you CC'd on future revisions.
