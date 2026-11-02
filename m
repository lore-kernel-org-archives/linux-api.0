Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793605460;
	b=OpMc2/iBS1M1PGnD3+cY245a051mL4AtOCCoV6qu+T9t5xmPoQzgHqWfGKN0eakDzn4a
	 33GZCUwcIaOkedfAERDG3r1GxF/C49qb5R3c+HCRXqvEYkF4AGthJe8zPPHpaT6blafil
	 d/oFCPoe4l/fkfp11Q+oFw15zLw72lyaquCXK9mvuuowAn/BvVBTBJb6Fn95nSpFECie0
	 rno44n2aVJag/H0HS1LcXLOGZpejnVXP+Bw5YD9xLoKmQp2FOTP846u7+P1u8duxG0jOK
	 TW8tkPmAkariFxw0Fktc4+JG1xeNBK3R1CJsXOijSwSqH31cUfkka1lbj+E8guaIWsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793605460;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=GMp9mcTTKC9DHoWvLxRWF3MR+m0EkCxt9LMLL8huxSQ=;
	b=ozBnHrVD115jlANeeG/7A+5nVt05TElf4Jb9kxSResfQyt1IGRoWVf5SKiLBX9pZO3mP
	 i+KTemjyRhuVuxphSAc6GMs2HX2YXC7JoRLWHO339rIdtWnVpICEGfOY1IkuU1QwUjFJG
	 c3mKE1aRsZ6okmZOj6rkwb5t6IaD2VP3mL8iigxXcuDpjqUtHAqhAWrMNPS1QuhcWZ/fr
	 zBviPOBpwkW0IsLtzsS5faMlpiIg7rRwfT/D+T47DALRinZb03OTbOmgLwejB6YJcKB/F
	 7ZrXjabi/ScKBeeltUbHSemUFc9FRP4FD79BvJn+Ek+CQpoUMudaFPUZXo2TT9mQunw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OYjCNJ4Y;
	arc=none smtp.remote-ip=209.85.221.46
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61BAE606A329
	for <linux-api@vger.kernel.org>; Mon,  2 Nov 2026 07:44:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 61BAE606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OYjCNJ4Y
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48dfdd0678dso1806622f8f.0
        for <linux-api@vger.kernel.org>; Sun, 01 Nov 2026 23:44:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793605458; x=1794210258; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GMp9mcTTKC9DHoWvLxRWF3MR+m0EkCxt9LMLL8huxSQ=;
        b=OYjCNJ4YGN418aOh4vtw14+7AbwL7A3Ew1CDtb+YSuxsqDbyN3W3NuNSwtJa2wrcK+
         /0DbK6/gccivSLcebaEXKX+PuviBnQdEZl5rWvIUJE0+unubt6dYmDsFeZl5JUyTPfJA
         eb5cfsbZTdDxFpV9Z2S2YwoHdgZgDyswjQ9g1w13yyKdN9fbW7JBUGkDsTW8DY8T4vrO
         vxyyS3wp/hibMOyq4jZ+uN+QFFFQYYKjWb/9TtDlU0VZ5kIriHuMnnVNtNup9Q+7OoJQ
         uGL5ABBYMspVQzy6ukvZB69Smvf1uU8UokxPfb3jSB6aTAWGnHCzZPdyzW+aWE7smNI9
         qv4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793605458; x=1794210258;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GMp9mcTTKC9DHoWvLxRWF3MR+m0EkCxt9LMLL8huxSQ=;
        b=1LW2JC4rgE/WXPW1syMC4o17e6BLiOQJ49pl+qkDuHtQJrWbyfg4dQBQo+gNJe+3Gg
         hoSBHasNPtrB8L5IQqetaAzsGJUdJSYsKHI8x5fPFdiJ5royZgW02KHQPiftE69gMZFD
         JHIhjtByQ1ksP6SzTXZAPkedc0WV8pi9XUVflQvIaDzibL1edSrJU7sKPCf5a0U7FqLg
         dGdfwh6nLO3Lb4QglZ5cagZ27TeC47swcwnLettagVrq6XHp5pAiEROBIZGROfiVMrRr
         eYzN4xTVJW2gg7/PG/Jt0lFz2yHRS539aR8ihHU2nB9w36SPpnYnA0ij+XKlBtmuUY/g
         1yIQ==
X-Forwarded-Encrypted: i=1; AKwUvBxZirpV8uWCw7HpZXk/h/z2KnB6NL8QY5bEik0IjIJ5ceBoeykJLlpJ/JAKnALpFL8kD0k0wZvNv/8=@vger.kernel.org
X-Gm-Message-State: APuU4Z8CF54KDi1x+GZ3A58r4xmnNZoRswk/4QZFDkklpnw3kKZeGQk1
	vcbEcVPJ5Ppm8H1l95y10Yuc9cxWm2+3LWWABbKaPZcS/0RM68ndiwwb
X-Gm-Gg: AYBFou1h9hfopZkCBUCz3z91gD4ikaSA1gSqiPyB9ti0HBcQkX4MkJm9ZiHOhMcERDK
	Thnhj+EI95/f8R1+1ydiMY33czn6hYwF60kz3FnhrKtUAqmQgWJXj/8bnFp7/xE6XBX3ThrKpaI
	ls28AlaH2yhawP+WrQjGXv0DIXS8cwOHRCB6aUpOTvJubYRBC54Q/y59O65NwsV7WiaTHkOkAND
	xt1Zp+bPlMT1F0nIsh0NHo6Kk8OZbV9RNBxLmAJjK33KQcinujgS+isML2szLhe0QDUeBWfXbsg
	m0Z2n9NhvbL1cG/+C+Wt93yK74x77eAKa5uSnOwueASIuW2zYtWak5AzcCCPJ0x9CXfBxSRhWZU
	M8H2Baa0vLKrcFraMHmxZp/0L0nwpKr9FK/e3JLHuVkK/1ZDSf54g0m9YtetrqrxHVeaLtH2hpK
	WLT1rwmdq9Xfpe/Othwp3pDMeIF0+spLKze6RSkOQvsOdSa2ARl2a9KtUy9homWxXWqj9jT4vWI
	0iCO1tF6nKQOciDz5G9Iq0p3HIeXTunrnnBC67H13hGpHhgSWR2YjXeB7uBtti9uJ56VJAVI8Wy
	sQC6GSKbMbUGnA==
X-Received: by 2002:a05:6000:2387:b0:48e:20f9:8d75 with SMTP id ffacd0b85a97d-48e6e50b79cmr21195080f8f.48.1793605457581;
        Sun, 01 Nov 2026 23:44:17 -0800 (PST)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b81c74sm18050374f8f.36.2026.11.01.23.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 23:44:16 -0800 (PST)
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	ts930@dgu.ac.kr,
	alx@kernel.org,
	linux-api@vger.kernel.org,
	linux-man@vger.kernel.org,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: [PATCH RESEND 0/3] mm/mlock: make zero length requests a no-op and reject wrapping ranges
Date: Mon,  2 Nov 2026 08:43:58 +0100
Message-ID: <20261102074412.189554-1-azpijr@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No changes, rebased on mm-new, Cc fixed.

Follow-up to Park Tae-sun's patch [1], which was dropped. David asked
which of the cases it raised can actually be triggered, and for selftests
that show them. Two can.

Patch 1 makes a zero length mlock()/munlock() a no-op before the address
is rounded. Today mlock(addr + 5, 0) locks a page and munlock(addr + 5, 0)
unlocks one.

Patch 2 rejects ranges where start + len overflows, or where the end
overflows when rounded to a page. Today these get a silent success, act
on a single page, or get -ENOMEM/-EINVAL depending on CAP_IPC_LOCK.

Patch 3 adds both cases to mlock2-tests.

I could not find the commit that introduced either behaviour in the git
history. Both are already present in the earliest history I could find,
so they may predate the imported git history. There is therefore no
commit to use for a Fixes tag. I have not added Cc: stable since these
changes intentionally alter UAPI-visible behaviour.

The mlock-random-test failure CI reported on [1] came from that patch,
not the test: it assigned 0 to do_mlock()'s error, which has to stay
-ENOMEM for the over-limit case, so mlock() over RLIMIT_MEMLOCK without
CAP_IPC_LOCK returned 0 without locking anything. With [1] applied the
test fails 40 runs out of 40; with error set back to -ENOMEM after the
check_mlock_range() call it passes all 40, as it does with this series.

Tested on x86_64 (KASAN, lockdep) in QEMU: mlock2-tests 31/31 as root and
as nobody, 24/31 and 23/31 on mm-unstable; mlock-random-test and
on-fault-limit pass.

[1] https://lore.kernel.org/all/179066531783.50175.13377521828379196177@dgu.ac.kr/

Jose A. Perez de Azpillaga (3):
  mm/mlock: make a zero length request a no-op whatever the alignment
  mm/mlock: reject ranges that cannot be represented
  selftests/mm: test mlock() and munlock() range normalisation

 mm/mlock.c                                |  29 +++-
 tools/testing/selftests/mm/mlock2-tests.c | 191 +++++++++++++++++++++-
 2 files changed, 215 insertions(+), 5 deletions(-)


base-commit: afb4eea28037fa55c4560313ecbd8a1e1da8369a
-- 
2.56.0

