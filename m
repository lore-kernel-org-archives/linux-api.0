Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C4284A92E9
	for <linux-api@vger.kernel.org>; Wed, 14 Oct 2026 23:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792021932; cv=none; b=pK5uk+JQANWUWJE23LYeRFVC1weEV7q6yf+pjBVF4S/++Mq8AcQl0TWcciiFSh7J+ZzWlAuSSyIRvJoUcdToE2RhoUAzbjDoA6mBfvgRsFMzhxMr6Vv2nvuZuBcO9bUNbn8JIWiPhPIJfKQtIxYgyeNuZwWYhoJTTw+dJlf2Bfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792021932; c=relaxed/simple;
	bh=RRLqekvGZQ+53SYPIEm6C+hfQvOWKj/0/1Rnrc6/8sU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nOCNK1Wxx2wAGRLr7vg5pN0fqXF3elnKBJX87E3TKfafFAcY8r7OwOzhluYbDGK+6450UEXboojteXDSHZoUP3R6d0zUVPM4WpEBDDyMTyWb03glAJP2uiBiao3L9BiUOrHw7cE8bqZpBPDlBJpNi07um5l6KBl1Z6mSnCAMuCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OU4Q/Tr7; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OU4Q/Tr7"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-398a5aad413so703811a91.3
        for <linux-api@vger.kernel.org>; Wed, 14 Oct 2026 16:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792021931; x=1792626731; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=323vij1mo5h7hUHWqUpabgnpKBMGHxI36tWkLHAoZ2I=;
        b=OU4Q/Tr74rMH1Mw9h44mxxaEBwoJ4ha0yvl9MEMQsxIoBh8MYOouk3gvQn3pToYssq
         v/R/oPSt7/6ooj0Hg0Gooi6CkgAUZrlQiBvn3WlA2XyPbdoBb04uHwmWRmnPGtS8hcow
         QUh+ANlne3J/m5OWnntEBOJviOyDDbeWo5BcOFm7bbr3PMDNj7TRKoncoz2ddiisgwN5
         wbBNAPR6V3HPZEc3/GvnHnHXQaKf8vQeX7nWQFS65CU/HwFMfWNdK09AbUg507LTOg48
         udYuF5EHvThqksh/3JrOXPy547Mnyhw8q66aEZerijDlYRUHGDq6V3yFLVNj082AZeOl
         nJjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792021931; x=1792626731;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=323vij1mo5h7hUHWqUpabgnpKBMGHxI36tWkLHAoZ2I=;
        b=svshDuL6wG9E3n2stLNLSQBEOBuw+Qv2Hk8+34xhWaA17CAaCopp1I/OWMtR4zO/If
         pA+3roTY/c/GkQjsFxB9kCSvAmYO5UXdMSpMcwW00xEXBn2UBWYnZWa/JriihFM5+ORw
         Rjpst1Q1y2XZ9h4NM/8cwQO8hB9MeRkQWoIBpBc4d6+4aun68DAuCxo9S7C+7sA+U6r9
         yi2jGT1bAM3Egi9WdIW65d5mDX6jQeoQf/8crR4k0VZ9D0a37mIUpTzbsX3OLwJA/l5A
         6zyijX1k9aJ6IJJ05OUZ0cb54tpXEM8Mx+ng4vx1uekjTuPfZPsungMWkuLVt+kc1pa9
         AGyg==
X-Forwarded-Encrypted: i=1; AKwUvBwHFy+hFFDm3f/4sYXexz3zOtFn/nj6oiSja5tVUeset2zWdqNizlsBJh1gHW23wSbxHA6Ciocf8JE=@vger.kernel.org
X-Gm-Message-State: AFq9FYKSQ8QupgopXgh84D1RQygPguPTnhKOIOjWDA6YwiEUMcMRHb3a
	Yihj6ySqaL3lewSg9xmXtXDdPNmCUUVqSrshRoQvF4rkSnTcwQaWW7+kAj8ijw==
X-Gm-Gg: AYBFou3bg3eKt48rFOR1cw9sIy5tnw+5P2li0OBTnivGZY6WgX/3GT25ChlytH7XExB
	Xaothin0fdc9rD7G6JurlxUT9bh0IycSQwBDihFp/yRNzqnZ59duusC5aB428spCEsfGITc+py9
	9loQ9PcaODZOCEC034vSMPz4JCsusnKa+t7GOrdOYiYXCpUCGc3F+OT0I+br06mS3bEaJ/qXwfx
	VbZPWT2d3wAHrUTSS55BZl+rANqPode8ZjlGoepGkFkVtY4ahdp+WgJxTHaXZjNJgU4pN1J9APA
	7IGtCEIhQT7RaKtklprSjb3kE+XqFdU1C54ciHdcbvtaTbnXw0OULyxxokOsqttlekAejsiztWy
	m/KwbZC2HV9mz1x0qLaLCcHeUCQZ1s+596TRihh+EaZYV57+QeLqADxaWuvdmEpG0OMINuZ/fYD
	PJBg3rSwZvORv7sK/Umqv6HpZVLqSWtBab8ZLchHfl5tqmpKR6WTGCUBvq3D0iNA6GxMy+L+nZN
	4wIhFOg6v2ahR9ab4BZgCDlheucgvh/bjAfY2AbVyqErEEZVApEBe7CdOcOujZP+dEyhcxrNm2s
	sdIlJpb5ciPLKY/Xh9JmVxXBtIY=
X-Received: by 2002:a17:90a:d006:b0:3a8:6a04:80ef with SMTP id 98e67ed59e1d1-3ab3a2901c2mr12576549a91.6.1792021930548;
        Wed, 14 Oct 2026 16:52:10 -0700 (PDT)
Received: from localhost.localdomain ([183.96.175.225])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac943e755bsm1500440a91.2.2026.10.14.16.52.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 14 Oct 2026 16:52:09 -0700 (PDT)
From: Joonho Lee <mynameisjune111@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Takashi Iwai <tiwai@suse.com>,
	Jaroslav Kysela <perex@perex.cz>,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] ALSA: pcm: refresh capture pointers before drain
Date: Thu, 15 Oct 2026 08:52:03 +0900
Message-ID: <core-drain-helper-reply.0c1099dbd0ca4a37@gmail.com>
In-Reply-To: <87jynkcn60.wl-tiwai@suse.de>
References: <rfc-core-capture-drain-0.112c40f0e9284eaa@gmail.com> <rfc-core-capture-drain-2.112c40f0e9284eaa@gmail.com> <8733u8g0kh.wl-tiwai@suse.de> <87y0c0el29.wl-tiwai@suse.de> <core-drain-linked-lock-reply.cf2e307fcac34b6a@gmail.com> <87jynkcn60.wl-tiwai@suse.de>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Takashi,

Thanks, I've reworked the local version along those lines.

The helper takes snd_pcm_link_rwsem for reading and updates each running
member under its own stream lock. It uses snd_pcm_update_hw_ptr() for both
playback and capture. I call it after the existing pause-resume step so a
paused capture stream gets its final pointer update too. The pause and
drain-init actions remain outside the link rwsem.

A pointer error now follows the usual XRUN path and returns -EPIPE before
drain-init. This restores the group-wide error handling from v2 and removes
the "notify" boolean argument introduced in v3 proposal.

While checking this version, I also confirmed three problems in the first
patch: 
1) a reader already waiting for data could lose the capture tail
2) finishing a capture read could stop a linked playback stream
3) DELAYand SYNC_PTR(HWSYNC) rejected capture DRAINING. The local fixes preserve
the unread count when waking the reader, finish capture with
snd_pcm_drain_done(), and use the cached pointer for capture hwsync.

I reproduced all three failures with the helper plus the old first patch,
then checked the fixes in both atomic and nonatomic modes. The blocked
reader now receives all 64 final frames, capture EOF leaves linked playback
in DRAINING, and both position queries succeed without another pointer
callback. The 26 linked-stream checks, including paused drain and pointer
errors, and the 10 existing lifecycle/reset cases also passed under ARM64
QEMU with KASAN and lockdep, but physical real-world device testing is still pending in this time.

There is one concurrency point I'd like to check. The helper releases the
link rwsem before drain-init, and snd_pcm_link() allows another RUNNING
stream to join in that interval. The new member could enter drain-init
without being visited by the refresh loop.
My question is, should we handle concurrent linking across these two steps, or leave that outside this change's scope?

Thanks,
Joonho
