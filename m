Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5123B2F7F05
	for <linux-api@vger.kernel.org>; Thu, 15 Oct 2026 23:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792108091; cv=none; b=eh2KCUITdI3FsB3nuNeahXgGAUBY49gqwLNij/Z0opNf5bKPk3lAhkj57YA3QlhD9LVy7/GJ7Jfw6TxVEyKiyFvvguGnqMdHYtW6JWA53QtAwW/cOhF+OzuMfASeKULl/LiaHkMUr33vLz29YYk96p0w03AvEsVptuaDDUfiM0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792108091; c=relaxed/simple;
	bh=FxNvXGumU/2fsM36onSYdlMMUXPemM3oxSTy+CpTOSE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RbstkxCE560j1tGlbQZv61ikSQmYT60N6LFC+Q7g03yZC6NQn1vmSvcf5/hRdkXo1bwi7/r3aWZlaK5XCncz2BHZPZnaRUYThs4vc1Kc8BVQcWPiGiAeJyCPk3U31Jz3csb/2ls7VcND45ssNoLTOIQ2e4+Zfnsda6brAAxtALA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ejDscta8; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ejDscta8"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cd60c5da24cso2988539a12.0
        for <linux-api@vger.kernel.org>; Thu, 15 Oct 2026 16:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792108089; x=1792712889; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QHMtTPJd5CGkNnfuYvZleiw12hUo1dI+m+gbvcH1A2g=;
        b=ejDscta8rIUZKYGD5l2Zr2l4tBwcjKPAk4KgzKbmLLcAT89iR8oFOuXcmQJOj/aWR3
         zEcMOVLxsvPF98JRRO+nHofMmsxpd+kYSjiiO9M8l5p2hYIBzNL9OOAm6XyvX75prpdI
         wqC13WbAOV+GAZ4d1BP3A+CyGDUeoV8CpEaQS9/P16TRQ5cDvsz/5Phj6r8D1/ytZVky
         FisEZQr3VYLJI8bBz5FldwOEbDFCFXc5wsu+SHbqsFFI7loa9l4i0XuZ0mCkUGvebUDX
         fpmQ6Ogdy1XAeH5fZcUW6fNjOtggFdMahdfIKsK6sUCenthsVoQJD2wBRngyRT8SCt2g
         P/Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792108089; x=1792712889;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QHMtTPJd5CGkNnfuYvZleiw12hUo1dI+m+gbvcH1A2g=;
        b=ie6wq9JmoN7DnR6j17NS0+VGGvaVLfAEPlhgkB8GxC9h3PAPI92QU/hJ2+Gzxlvx3l
         H7G8kOQg9zOjGSUe/NijZX96X6tqi+/2do84gCtO78yfQFUVMwmf54Qz+bwc6A8uiEdA
         ZMyEIXEeYfUfbLpU9xgb8PE4V0oMgTTbAuTle7oPZ1vXA5JEc4Y0uulYdNCOblFQPJzv
         v4wDT9WcToaMM+A+BEtu6404QAefvAWnAB15GaQMdhYsB++MsmqmmL/71bIZvgePnkzg
         l4ri06IQYDGyB9DG1ftuWHj1UXpQEzibeh6njbnAnV/74ThI7PhGBobGIzGGUt63XUPZ
         ml0A==
X-Forwarded-Encrypted: i=1; AKwUvBzPEauSZxzzZwOxm7b+cOobkkhpOB+vowA1SlLIG9ziU/5M6+O9scboXVkxOqa+3GqNI/hf39GIga0=@vger.kernel.org
X-Gm-Message-State: AFq9FYJE2dgO54xSD8yHESMZmkPPj5Ft9ok36sAFWwqvSMKuMUvHj3zk
	RUpGCqTWFVOm5qMjRYNZ/lpBgZUa9rJUtUa7vi8gvYbLC8NzXooRrZlo
X-Gm-Gg: AYBFou0OW9X4Mg4XwPPR3WUycvI/sxi7ipAX1lfzOOUoNj6aCx7kSC86FxxPIUcHGXw
	KF3UjClLj/EaZshzOzZSBAtjrNlOwUuzOenq8pIBYBa/NiKxNjTWY2Cef/mSC4kArIsoTfICrDq
	ANTZfOFoYucJDY5xR8fP4DBSYcs068Fi4M8z4EkW1OQxlYT2ocDiUwrGHbuq+tlClH3ngcTMT5g
	tGZ39ZEjTHbJ7N9GA7/1F/eTjk2Qz0NTgJwok1nC6Z2/qNfU8W/DFuYzh9p2iSH1zbgPLmkZzLB
	mjrrQcRrKfLFvRRSFeabmsJmd8f+M8s4aychO0FcIkbzgp7CT+AdqM4/XKbfyWdxLxpxmqZYqZp
	yYPV9i5DSBBxwKmNwadKsQ6zeqJnwtzUACyrX3hl5wEibEhAYOzRhqxwfclwSPsCGG9prkh5Gsv
	EYhION5Xlm/z5T5njz8xiAIO0zbff6meNZnYgfIMnOe9NE+S8Qf4UpPt2Es6OOkgRt9XSDiaVHJ
	7ltRFM4n8cgpHrpocnHLyqN5RdjZeBHCM9YQ5ihIO0H38RKIvelCpN37luswzzn9yPrm0JBVjlK
	Mx8d/oMkt4nhR+nf
X-Received: by 2002:a17:90a:d44d:b0:3ab:2737:3395 with SMTP id 98e67ed59e1d1-3ab3a8d0e98mr17335574a91.42.1792108089426;
        Thu, 15 Oct 2026 16:48:09 -0700 (PDT)
Received: from localhost.localdomain ([183.96.175.225])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acc46ee27fsm1213468a91.5.2026.10.15.16.48.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 15 Oct 2026 16:48:08 -0700 (PDT)
From: Joonho Lee <mynameisjune111@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Takashi Iwai <tiwai@suse.com>,
	Jaroslav Kysela <perex@perex.cz>,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org
Subject: [PATCH v5 0/2] ALSA: pcm: preserve capture tail during drain
Date: Fri, 16 Oct 2026 08:48:03 +0900
Message-ID: <v5-core-capture-drain-0.e9b40d3bc08c4162@gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Capture drain can leave final frames buffered after the device stops.
This series lets userspace read those frames and refreshes the linked
streams' hardware pointers before drain-init.

Patch 1 allows capture reads in DRAINING, preserves the unread count when
waking a blocked reader, and finishes capture with snd_pcm_drain_done()
so linked playback can continue draining. DELAY and SYNC_PTR(HWSYNC) use
the cached final capture pointer after capture stops.

Patch 2 refreshes each running member under its stream lock while holding
snd_pcm_link_rwsem for reading. It updates both playback and capture,
after the existing pause-resume step. The pause and drain-init actions
remain outside the link rwsem. Pointer errors follow the normal XRUN
path and return -EPIPE before drain-init.

Changes since RFC v4:
- Submit as a non-RFC series following Takashi's response.
- No changes to either patch body, including the commit message, diff,
  and existing trailers. This cover and the mail headers are updated.

Takashi said both patches look OK and that he can try merging a non-RFC
series:
https://lore.kernel.org/all/87ld7z6jsk.wl-tiwai@suse.de/
Previous RFC v4:
https://lore.kernel.org/all/rfc-v4-core-capture-drain-0.b56779f7976d4657@gmail.com/
Implementation and test discussion:
https://lore.kernel.org/all/core-drain-helper-reply.0c1099dbd0ca4a37@gmail.com/

The five-patch virtio-snd lifetime v3 series is unchanged:
https://lore.kernel.org/all/cover.1791881787.git.mynameisjune111@gmail.com/
The base and prerequisite IDs below preserve the tested integration:
apply the five lifetime patches, then these two core patches. Replace
both earlier core patches when testing this revision. Core has no
dependency on the generic control-wait or VZ compatibility RFC. This
submission does not revise either companion series.

The following validation is from RFC v4's unchanged source; no new
runtime tests were run for this mail-only revision.

Validation used ARM64 QEMU with KASAN and lockdep:
- 26 linked-stream checks passed across atomic and nonatomic modes,
  including paused drain, first/later member pointer errors, normal XRUN
  handling, tail reads, and unlink/prepare/reopen recovery.
- The three patch-1 failures were reproduced with the helper and the old
  first patch in both locking modes. All six corresponding fixed cases
  passed: a blocked reader received all 64 final frames, capture EOF
  left linked playback in DRAINING, and both position queries succeeded
  without another pointer callback.
- Four additional blocked-reader runs compared baseline and fixed modules
  in both modes with a stronger gate: thread sleep and a pointer callback
  after START. They confirmed the baseline loss and fixed 64-frame read.
- The 10 existing lifecycle and timeout/reset scenarios passed, including
  held STOP/RELEASE, SIGKILL, reset, and subsequent I/O recovery.
- No KASAN, lockdep, or panic diagnostics appeared in the 54 selected
  logs, which include the baseline behavioral-failure comparisons.

The full Image and modules were first built with the new helper and the
old first patch. After fixing the three tail issues, sound/core was
rebuilt with W=1 against that same configuration and symbol versions,
and the corrected PCM module was used for the runs above. The module
build had no warnings or errors. The full build had 517 existing
-Woverride-init warnings in arch/arm64 outside sound/. The exported v5
core source matches the tested source byte for byte.

These tests use synthetic drivers and modified fault/reset backends.

LLM assistance was used for implementation, reproducer development,
analysis, and documentation. I reviewed the changes and test evidence.
Assisted-by: LLM

Joonho Lee (2):
  ALSA: pcm: allow capture reads while draining
  ALSA: pcm: refresh linked pointers before draining

 sound/core/pcm_lib.c    | 16 ++++++++++------
 sound/core/pcm_native.c | 27 ++++++++++++++++++++++++++-
 2 files changed, 36 insertions(+), 7 deletions(-)

base-commit: 8d70e364e866bdfca81eee24d0688fac9472cfb9
prerequisite-patch-id: 39fb327a004c966ab90f66a34a64bbdbb3ffb475
prerequisite-patch-id: 7c6bc344656fd839ae0d697ba18d66ac0b47827a
prerequisite-patch-id: 9dd290ac3147fa7b49a475d7df8a6172778f2860
prerequisite-patch-id: f4c24a5e441343a690f4ac2437f181c815bc23d0
prerequisite-patch-id: ab4a5b770247a65272ab7af18a75a147daf81287
