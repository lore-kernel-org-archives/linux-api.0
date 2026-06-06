Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014F5262FF8
	for <linux-api@vger.kernel.org>; Sat,  6 Jun 2026 06:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780726264; cv=none; b=s+4YO/7j6wnKvld63opQZTLUY0oHxr5Fy8D4al6zHspi9If8Ov4iapcS3A2WiIQ/41xw6hudul+aht8MQymMCp8GZ1aPyeUH1XVfRtxEL3efoQzfA89X3IlINbJUIA3cIt+UzfyGEw0Nh7VG2Zy48oniqcAWwOC4S+uGZVfzgew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780726264; c=relaxed/simple;
	bh=ve8FNUDJ+bfAlTYt1tyGpBHY0ZFpeP48sjRpO5hIorA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KXD9Gd7tPpJEDZ9kn8ljAx6ALAEZVlSiKTM+Qp6nl1B911Z4Fre4oZQOAsJCu0eY6b7/cVJHMN6nd3iocsQ72ntMbbPevXQ/2WaAIwBSqVshnyo2IgNT2K3w5qjgWVRopfxCp5QgMZmeHWKDxD96xeD0ZZvKmrS9RAEi+Sv761Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lZLnIKMI; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lZLnIKMI"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-45ee5cdbd28so2201348f8f.1
        for <linux-api@vger.kernel.org>; Fri, 05 Jun 2026 23:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780726261; x=1781331061; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8r8X8oylGshLaIHIAK1kgCpu4mjI5I9eQ7pptBpGukw=;
        b=lZLnIKMIF3d3ixq8CA9qHpI6c4K1GVAPpUE7R5cbmfuod843qux2ApzyxWcN9P1y0i
         oMecdiFiZIMP/MgPqXZhVctyIRv7uFpA4tSLsF3uUJZwyQ4hA5iuZwQl9QFwGcd3gvGC
         Hcdw9UucXPzWiaheQKM/ZZ/cvZbpBP7P1jAehUaNMz2+Lff0BSjM41b4lfirrrSchqdp
         iipJrLwv6jAPAnpwodIcFsI9u55Gs6HqDYvjkk8XKoNqROoyb8jh13EJ828FZ0KvWiVZ
         v7PCF9Eqn8mX4bx+AOr4+fAN6ce4raMku673pCYv0adx8D6N/lH1pEiyXmvfHU9o9LQR
         FfZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780726261; x=1781331061;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8r8X8oylGshLaIHIAK1kgCpu4mjI5I9eQ7pptBpGukw=;
        b=J5nTJS8s7x8ZwcDfCSFqiV0YgVPXu8M5DUOSF8U09KQndlI+R+X/z+jQf5lw/4nXP1
         Q6MRl4K30pQDmkSTP7gwm/xY+wqiEfOYr4rNnUkb1/Bit21Dh+Bw0dhTW9sA5vpqSuTR
         te8xNe7t68/cACwkpgjg3cYUOa15dJCmoyKFkZMdf/ej64B8LnHPy/ijVNmqOGJHG6Gu
         C6n0JH/3OLYp/0pHfa3rZozIzL/2/hmTKnTABT6i2cqf9hED9NV8Z6/Oyr5oT3MbVj/7
         ZBnuyiuUyaZ12OtQ2eZvo4niPAV2mLak2XaEfJW2q3Qd0KgX1Tvbd7ksK0GBY5S6wXAC
         s71g==
X-Forwarded-Encrypted: i=1; AFNElJ/RxMNpQt84C/EU3XMq9DV7YF6pDqn1l+fXghW6qyePycZZzVdTv5Hou4TUCSykF/U2yc5B4jsA75w=@vger.kernel.org
X-Gm-Message-State: AOJu0YxfQWixXzbIRp6qNWGWJT+11iGe5j61wy5P1lD945v8eoCdbEKp
	l678HhRKTh5eFvuq8faohP/1iT6ZmSxLA5mfkDptcVTu/kuTCLXnWjXr
X-Gm-Gg: Acq92OHiE4VrI973YnyLmvYog6+KyiOGVo5Z5irL7iZ5IfVzjdp1V1q0BZ+1tk5ZZyi
	BDYli5PQvWi4rEpIg9BZQt2Wnh2R9Ws9KEHkf5/IdAsVij8kxuAn0w7b5FKKSLUbmkjTsiGwhT7
	FyCv/Bm1DPoDlBUAgrCdl22GOe5Xa8YcvP3Q64Ot/X031x3yyRe4EhJ1buerPbZpufLTUBnHVyH
	j+3Qw6iuwC/Zdf2HcwTCVnrINPgGiY+QDfOyIX0u4CoAMfxutfzMjfAA7EqqdU39y6AkcsWF1EF
	rTt1AkdmWDrg+Ocj+eZobmwwpC1UjUZhyjRMB5xc3t/zVTMXn08WSB/cQP44Z5R9n8+nv5lOoFl
	/YEuRz234WYQDTGfQOtivPVfM0PutvbajMugkOWK7MZ+shGGf/G95/bw5bX9Dc6l+N6pDXE17rS
	MAG++NcbBvvmrm1UoGTfzgG58hZO0iSQ==
X-Received: by 2002:a05:6000:41c4:b0:45e:f5b5:885 with SMTP id ffacd0b85a97d-46032b610d1mr8361361f8f.2.1780726261254;
        Fri, 05 Jun 2026 23:11:01 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4601f360bd6sm34254711f8f.36.2026.06.05.23.10.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2026 23:11:00 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-api@vger.kernel.org,
	netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	ltp@lists.linux.it,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>,
	David Howells <dhowells@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andy Lutomirski <luto@amacapital.net>,
	Collin Funk <collin.funk1@gmail.com>,
	David Laight <david.laight.linux@gmail.com>,
	Stefan Metzmacher <metze@samba.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	The 8472 <kernel@infinite-source.de>,
	Willy Tarreau <w@1wt.eu>,
	Joanne Koong <joannelkoong@gmail.com>,
	patches@lists.linux.dev
Subject: [PATCH 0/5] vmsplice: fix some problems in my previous vmsplice patchset
Date: Sat,  6 Jun 2026 06:10:26 +0000
Message-ID: <20260606061031.3744880-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset is for VFS. Of course, it depends on my previous vmsplice
patchset.

I fix some problems in my previous patchset.

1. Fix problem with CLASS(fd, f)(fd). See first patch for details.
This is probably not so important, but I fix it anyway.

2. Change "unsigned long" back to "int". See second patch for details.
Again, this is probably not important, but I want to fix this anyway.

3. Fix that LTP vmsplice01 bug.

See patches for details.

Please, run that LTP vmsplice01 test again.

Notes:

- I want to repeat: I change behavior around SPLICE_F_NONBLOCK.
Previously, vmsplice ignored whether pipe itself was opened as
non-blocking file. Now it is not ignored. And in my opinion
new behavior is better.
- vmsplice(2) now is in fs/read_write.c . It is very similar to
preadv2 and pwritev2 now, so I think it belongs to fs/read_write.c now.

Please, review this patchset carefully. I'm still new contributor.
In particular, please, review that do-while loop, I'm not sure I did
everything right.

Tested in Qemu.

Askar Safin (5):
  vmsplice: open-code do_writev and do_readv
  vmsplice: change argument type back to "int"
  splice: turn wait_for_space flags argument into bool
  pipe: move wait_for_space to fs/pipe.c and rename it
  vmsplice: make sure we don't wait after writing some data

 fs/pipe.c                 | 17 +++++++++++
 fs/read_write.c           | 61 ++++++++++++++++++++++++++++++++++-----
 fs/splice.c               | 19 +-----------
 include/linux/pipe_fs_i.h |  2 ++
 include/linux/syscalls.h  |  2 +-
 5 files changed, 75 insertions(+), 26 deletions(-)


base-commit: 8d86fcfc2857d64af85f5c87c193c25655c970af (vfs-7.2.vmsplice)
-- 
2.47.3

