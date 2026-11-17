Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.175
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794937360;
	b=iGp94yYSHQ4VgCiMK0PwRMew3IpiYzO2k5P4LxuGCpy0apFARGVZOI/BuL6kZXEHZyg7
	 rbt6ufNSqjVi96d5TUQA4c9sBegwViybMxnrI554VGL+OJxFLIxUtfHwrwc4bj8Q6Sqvu
	 uMtNhjpOSTvw8cMn4mybrAzl/MaHGii0+qALZvy8/rBg/act3nLuZ5ndsR746uyvhrGTd
	 MuGgqcuGRm/DfehJY07AYjdUMt2KbUehCUtBU+BuCljQcID+S0di5fE2P9Erip32omDGB
	 TxuGDogMviZ2NMf2yJD47iv4hxsSvgjxxiy5N7EHF/fyGVUTEk9TsjjnLVLEPdId4sw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794937360;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=C0Br6uNbCeSZG/D0SaMC7uBQz4y4PQvjObMC5HHmvxw=;
	b=MjGd0YvyQ9ZGhRoiN9P1LvE3aXqPXZhwDsSWs/w1ZxMhirDYs0UyyBQMAg8IHdNAM/eH
	 zNsEoxDnz3jFCoo7Zfb44fHFlxpzb+wgpztkuM0TNbXBLAUgG30wwLQ4ixuVje1nXFHG5
	 gosijv/azNS4nwMARfruYrVQBSxKBaoPQnJz7hK4FQLchGkfTqKvLiwEgQrkLaYqRbhlW
	 y8ITPUg39XbvUFS5FAdqJytgkEc4sRsmKUWbncalvrd6p+I+U1CIZV3JSVWSkYX2JIy/6
	 znUGxda86pghrVEerP3+3hVbRqJQv1jnZgqIuVKwlf77ymWVPWVA88WHL9BHiREYcEQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=amacapital.net;
	spf=pass smtp.mailfrom=amacapital.net;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=EEvWGAFb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.175
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924CA606A330
	for <linux-api@vger.kernel.org>; Tue, 17 Nov 2026 17:42:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 924CA606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=EEvWGAFb
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-3acef9307c7so1276541fa.2
        for <linux-api@vger.kernel.org>; Tue, 17 Nov 2026 09:42:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794937359; cv=none;
        d=google.com; s=arc-20260327;
        b=EsYTBgXDCtbXE/cQXxQS0uSpCHwOsbvdJjg7c4Et14Osm6E7E9IVMTl7dRDjCuW1fI
         5yGTuIVY5zZYwLaBM9A5fC6RbhRQVLzMQE90E3us4ecrxlOhcqAzuu8csba9CvJGYN1e
         dp66wjTkFCYludwuI311RVdUXGOupiBkm+4Nx66xkraWTH7EGlEB+DNEZpK72TMgDEKa
         4LWpZIFKwb6MtbwpxzqFH+GvSFgn9xfaDurFtCUmpBUEyE4VzUPkXfFhwDRzKI78lAgh
         zXUfKDnpXz8b4NMWDxL9L4i8zl3XkJs/EhYCtHdugfbTJjRiamdO0B35zX8mxPQWViJd
         1yMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=C0Br6uNbCeSZG/D0SaMC7uBQz4y4PQvjObMC5HHmvxw=;
        fh=wfJ3p1GMBSmmWXgNnofUis/jjqUSBXDlmBRUPnTLqTY=;
        b=RpihpXG7orvL4rgmCLrPqlmbCmpuUzohC+JiOLjepMXkr0QC9fXFy6FbgOEhtm6MBj
         muRwhz8vwW6dg9E1/6ZQc8X380nn7z41w921iRWU0UZb613KoS8cqPEpZ6aU6kkt0VfK
         3jxa753ct8Ap1KV1ZdmvadO8yOhGPR3CABiTDAD9BbYXvEnV/+n+ACCHohA29+bND3Rh
         vcn9cShqZlh/RsH08H7wXJ3F7zICAli8qhYHzW8qBbj8lamUDePDQsn5ZPO01v1hTtn2
         z042Xp4JUUcFx6H4Yh0NRWVqtuWdFR3JB2y2KW+pvxeYzpdDGUVIlMsa1C+IgXztzTmw
         EbTw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20260707.gappssmtp.com; s=20260707; t=1794937359; x=1795542159; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=C0Br6uNbCeSZG/D0SaMC7uBQz4y4PQvjObMC5HHmvxw=;
        b=EEvWGAFbOmPz0e1bruaOl0rjybH0s4KDHt1ZdsIprIDdOYSYYFkdgv0P5ZbqLm9wOt
         QUKZ38KmXI7yBp+GV0/eyJrlR0x9jaOEr3Ii55nnjpnVrQIiwkaoActJokk0nmQSZd7G
         61WKKrB70e3ufmKjp4oHO9TAABVl1efKkOpBvtOYK6RF6gVHy0E+rjZz0xIx57DanHDh
         1TInlFBGPv/IJYMg1cTj312Sc7q2gHY8Ugtu6+Jpk/LKIOoiULHPpgJvsVB0ghEN1g8q
         2dPQMdyQdgbZ8hjQrp+yJxxt3I0107KE+viwJ2hHYYVk4FGOG+dWGVAy9wgHIHfa0LWA
         TeLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794937359; x=1795542159;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C0Br6uNbCeSZG/D0SaMC7uBQz4y4PQvjObMC5HHmvxw=;
        b=V7dSQbYUXFk2bQMrb+VmrWgsT4VsjR0ijppvIdR9EVl8RLpekI+/qkGC7Ka3jL/ixn
         chpSLzUJgA+9P0rcbsCk5ay4ZQalMKlFlduZ8rFGxO1NemQfm1yoJjaflv3AAWR1Wbb5
         kL7X6bVkbV52psWcDhjLmtIowHJAuLDIUBkDk3h+LzmioT7SasF0d+l5UOcL/ba2ElEn
         IoKtETZx6shv6rS9n0p6+XF+yEYHEaHM218OhowQTKNlga3GIcblBGxUZXRRBUArOj2H
         QDsMDP3pXsoBPuRrmwdWeB24MYAWIf9dTsHkIHn3AMMYbY5udJhadleA2JPu40/9fDFt
         feIQ==
X-Forwarded-Encrypted: i=1; AL+hErG9UsNtmUAloZD9wFnMRF3+bbRtdmaIDhpKJo3kXwlee405J1VnfHVut21oi7pr4C8ii6KeeRrBx7k=@vger.kernel.org
X-Gm-Message-State: APuU4Z9wA3HKh5Yt8mp32ViM4c3bYV/oq+zaxGtEbDaWRCmTPRdozOQ3
	Llsnf+wAfkusxHzd2NVvMJFT2/hhi1TKp/uj8+ZNFmHUSTqgQjMcSvRJVP+gjKD8drUgECOieKJ
	zUkIWnW8HNT2cdaNpypTmjgzwFXLb4RFif+AD2jK7
X-Gm-Gg: AYBFou2EVVDrE5O2UWDiErWLsEKH55XlgvEfpgnCUARKr6wKV/zFfHSyxPr4iAmh/kN
	KFZ4qRM9ZhcYvjk4eaQqENNYgYGz247pO0+taW+jN5hSfudlh9mXhltCTVK8T344LUdVdJ5Asxg
	0QRfzpl09uOUckhd4gBjTtnv2CvKjTbzMHbHbH2pe75/axw9v8nu/ESx3X9CUg6O3TGvLV8viaA
	Z24KuVz/Tmxq3F6eR5w/swhJeBek/BBWMiSy8tq4IGY8a2cfsltmmV8f8FxWA66+qFGOJZvLDVz
	Ep53aElNLm5ypCYCOAqVtXZtQKLFc3XPs9+qtGHp0b7vHiac0XFCt+rgZNcDPXsB8McWWpSgJPB
	ClLdWFGV98i2CN3SfI51af+zjSMrgHsvXVg==
X-Received: by 2002:ac2:4bc9:0:b0:5c1:4ccf:f0b8 with SMTP id
 2adb3069b0e04-5c170a0bb3cmr7252657e87.16.1794937358574; Tue, 17 Nov 2026
 09:42:38 -0800 (PST)
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
In-Reply-To: <20261117050841.3289652-8-jarkko@kernel.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 17 Nov 2026 09:42:26 -0800
X-Gm-Features: Aa3M54o6AJsup2EB_D5C3UIkkriS8wK22wW9apyv8KKATx5_DoWBh2HrH9mfDyU
Message-ID: <CALCETrWtbUFQGDOCHkxAN9O4i29ixfL5KKF1Cqw2-CjxKwC6gQ@mail.gmail.com>
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

On Mon, Nov 16, 2026 at 9:09=E2=80=AFPM Jarkko Sakkinen <jarkko@kernel.org>=
 wrote:
>
> Multithreaded userspace daemons cannot call setns(CLONE_NEWUSER) or
> safely mutate process-wide filesystem state in place before spawning a
> child into a target namespace set.
>
> Add the rootns_enter() system call to fork a child process directly into
> a rootns whose root mount has been installed. Transition the rootns from
> ROOTNS_READY through ROOTNS_FORKING to ROOTNS_RUNNING for the first
> process so it becomes PID 1, serialize concurrent entrants on waitq
> until bootstrap resolves, and admit subsequent callers into the running
> PID namespace until teardown begins.
>
> Require CAP_SYS_ADMIN in the target user namespace, forbid credential or
> PR_SET_NO_NEW_PRIVS privilege escalation

Why are you disallowing this if no_new_privs?

This isn't necessarily a showstopper, but fork() is really quite slow
in many cases.  It would be nice to have a more spawn-like API
available.  I assume it's possible to open a file in the target's
mountns by some sane API even without entering that mountns, as a side
effect of how the fsopen / move_mount mechanism works.

--Andy
