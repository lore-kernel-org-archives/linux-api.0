Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F3536A374
	for <linux-api@vger.kernel.org>; Mon,  8 Jun 2026 11:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780918827; cv=none; b=ewRo5EMwybkmDGXP0IeHj6AOHp6Pyvk//msTbLjRxmB/RosdtTWa9oONHNpNs8Uu9eG8jVZyMriNm/Rn1Lmkvow+m0dJYkwuWd+1yRDT7dmucs+cWbMu0fuFcRGHUi2YmxMrGmKYGhQnjn7RxdDEe36JAiMAyYnU2Vi+fDzLYT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780918827; c=relaxed/simple;
	bh=gt817j5d2FZcQYx9aiRFtGll+41qpg8M37eW3rPlaLM=;
	h=Message-ID:From:To:Cc:In-Reply-To:Subject:Content-Type:Date; b=uDLueJ+ZP06Ix9sRTNJ1CBHcSQGSeXzkk41wNoE0VJV/7FaRRYX370zCOsKzp09nbS6WbLI+BQw4f3O1P98I0MaEXH0Rc996RT6pnOjUxMksNF29thNqd36wvpkQ01WGvgjkLahgmIBiOgyttfObKmr05e+l9vZTr4h1Ur31a6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CU33JHhO; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CU33JHhO"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-45ef1629ff4so2764862f8f.0
        for <linux-api@vger.kernel.org>; Mon, 08 Jun 2026 04:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780918824; x=1781523624; darn=vger.kernel.org;
        h=date:content-transfer-encoding:subject:in-reply-to:cc:to:from
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=gt817j5d2FZcQYx9aiRFtGll+41qpg8M37eW3rPlaLM=;
        b=CU33JHhOJJpl7G85SmXd37aYDGyPNc1hcQU4q+6OJ/2MUTacmuThcIoEtwOpdud9nR
         9/HdLyCw/h6jDB7VnA4vDU8ICEQRvuBVcEz/L4CdSZ0GzGJTb1aL4wu6Dgvgw5vBRNyp
         wA1tJLT+bol7dh3VO+K7B7YxZKMLkw9lCpk52epadCuzaKdyARU4lmYukD8IxlpERS+Q
         uLUFqKLdIRuOCNN/e1LLwxwOPeJ+e6pVjjQj+injFQHEgDxYRUWWeBaAvQB9sgS8mKbz
         +8ARhmnOYxUGm2JN95dC+P7KudilAnUI00WGu1vcxdbCtJnLchqiBwacxAHLp3mnBJUR
         fq9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780918824; x=1781523624;
        h=date:content-transfer-encoding:subject:in-reply-to:cc:to:from
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gt817j5d2FZcQYx9aiRFtGll+41qpg8M37eW3rPlaLM=;
        b=EQXs95cn8kU6E8xm6RhaOsvxVEH4tg4gFXWcbyyxlVeyyX3nB+VdcPsF6k4M8iYgJm
         6XNdds6vGDaZNR3cIHKWB/jie2LMjmCMHeR/LrSsRnJ1MTZT5Jwt4o0/ERHNBO87xDK3
         DmaPGmDUB8IurFu96hCXIh5f64b0R3pFqx3uw1rTrTXO9NLnV7eD2S4y2gCjQuGWRhFx
         5nyv+cr1TnKq+NKdwMCLsUhYgg+aJAuO69VtExJGX6Hx0jXpp7txqTwfAcJawBSjdmPs
         X1/TqXLEW1r+jTV0wuaKp8orUNGYO3dvzS02BqHD69eVBvORHOfJ9HpcsX9yBJYaIsay
         LRiw==
X-Forwarded-Encrypted: i=1; AFNElJ87grXJccAYzTdIDAp49YCQ6rX3t0bD1m0qBVKfInB5H+Me4iJvl8XPfQiwQfMokiho04R5woa/L3M=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpIecXq+MOYFBvYZw1bZi55l/xLLks6bpCDMcRtDnbuTXhRgKj
	rw1nJPBv+2psMrIA4v4EYiVac6iX9/tlagmKukTGYGpfc8shTbyPW8zv0UX4tUTZ2fI=
X-Gm-Gg: Acq92OF8pfrshmepV/p7rIp8AfWqaOfd3arCbJzNpSGmnzDY0qqpkjQBayNMzy6K/Ez
	MQ3QXO+uod/BW0O8YII9M8hHeVq9z3vh0WSfVja6qghUYRzxtu/PB9R1VB6Gj5n65HBvII7KVyN
	9NC53izfTlv4PKqMTJ1PNgb5ew1dDEGMBo0usJ9AkKtB8T+Qdb13jXNXZGWtL1hFKrbI2NoPEQb
	ct8Lh3rre168VFf+BkM/TdgdTt9XPeHHKBE0xZkL0JCrjXXmlDpjF6FbIyjYjaStPrgxCuNvWux
	OxLC/6lcoeiRH+mLSElQ4wzKr7jLNaOIzLSSHSdrim+Km4HnD1wV2Ka+hSIkz8TfLPVAAFoG0FB
	KqITstcC5TGFv98LADuj6G8MvbBYJrXCcIhK4aM46esl6dp23K0ge8GyMjiwto1p6QHp7xyuG/e
	pHxTxGr71ENd9KskpBm/I9nlRZD9pgGZYR8uKfeXYmqD65Mmdg7viRTTYY4MB97hFWqTRxBCt9d
	1Vwtvx9ohVI5Vfb6M5UJ2vTMpXeLMpQBMz7yj8VLZReYg==
X-Received: by 2002:a05:6000:46cd:b0:460:1492:4f0d with SMTP id ffacd0b85a97d-4603063c591mr15377117f8f.34.1780918824402;
        Mon, 08 Jun 2026 04:40:24 -0700 (PDT)
Received: from localhost.localdomain (p200300ef2f13eb00c11aebd17f9598f1.dip0.t-ipconnect.de. [2003:ef:2f13:eb00:c11a:ebd1:7f95:98f1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2f2710sm40821903f8f.14.2026.06.08.04.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 04:40:24 -0700 (PDT)
Message-ID: <6a26aa28.283787d8.1f1282.ba36@mx.google.com>
From: "Andrea Cervesato" <andrea.cervesato@suse.com>
To: "Askar Safin" <safinaskar@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, "Christian Brauner" <brauner@kernel.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Jan Kara" <jack@suse.cz>, "The 8472" <kernel@infinite-source.de>, patches@lists.linux.dev, "David
 Howells" <dhowells@redhat.com>, linux-mm@kvack.org, "Collin Funk" <collin.funk1@gmail.com>, "Joanne
 Koong" <joannelkoong@gmail.com>, "Miklos Szeredi" <miklos@szeredi.hu>, "David
 Laight" <david.laight.linux@gmail.com>, "Matthew Wilcox" <willy@infradead.org>, "Christoph
 Hellwig" <hch@infradead.org>, "Steven Rostedt" <rostedt@goodmis.org>, fuse-devel@lists.linux.dev, "David
 Hildenbrand" <david@kernel.org>, "Pedro Falcato" <pfalcato@suse.de>, ltp@lists.linux.it, "Jens
 Axboe" <axboe@kernel.dk>, "Stefan Metzmacher" <metze@samba.org>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, "Andy
 Lutomirski" <luto@amacapital.net>, linux-api@vger.kernel.org, "Andrew
 Morton" <akpm@linux-foundation.org>, "Linus Torvalds" <torvalds@linux-foundation.org>, "Willy
 Tarreau" <w@1wt.eu>
In-Reply-To: <20260606061031.3744880-1-safinaskar@gmail.com>
Subject: Re: [LTP] [PATCH 0/5] vmsplice: fix some problems in my previous
 vmsplice patchset
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 08 Jun 2026 11:40:22 +0000
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>

Hi Askar,

the patch-set doesn't apply:

error: fs/read_write.c: does not exist in index
hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch
hint: When you have resolved this problem, run "git am --continue".
hint: If you prefer to skip this patch, run "git am --skip" instead.
hint: To restore the original branch and stop patching, run "git am --abort=
".
hint: Disable this message with "git config set advice.mergeConflict false"
Applying: vmsplice: open-code do_writev and do_readv
Patch failed at 0001 vmsplice: open-code do_writev and do_readv

https://github.com/linux-test-project/ltp-agent/actions/runs/27129052434/jo=
b/80065058557#step:8:21

Please update it to a new version after rebasing with the upstream master
branch.

Regards,
--
Andrea Cervesato
SUSE QE Automation Engineer Linux
andrea.cervesato@suse.com
