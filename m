Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9B74A2A66
	for <linux-api@vger.kernel.org>; Wed, 14 Oct 2026 08:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791965748; cv=none; b=AbtYbYZCOJgJ1jQK8K2PWFMDlC20RlcLT/+Lx2LQAkBfk0iqujFIOEV+LZouVx/300LYzyk0W38jq834d0HwCIJFKlrxPA6GiXeCyPUTZympQz/OPiwTQnRKh9pUikKk+oQ+NscR0MRB/kTdqcqIXY8QPe2cIFLnLKZAwfOnZ+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791965748; c=relaxed/simple;
	bh=NfRbfyqv4MISWvfFB6YrL+5/YWMuOqeIK2SxP9SAFo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r/qq0XkuB5F22ppX9CIB3tEVwK2fKWhtg+8FmsGHB6CMFE45d30RqQwWsfrzvjiLgUeBDfhxJfqLpL1VKhfmfmukjYqMH02Ee4nmaLoBtCLp6ddfK7dQjhh3wYO5Ojj58NW++KUMcQ/7icAyOTBDuRCIZA/Hog6NV/S/ohBzqk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RmkAmbBm; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RmkAmbBm"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-89a595332c7so2024815b3a.0
        for <linux-api@vger.kernel.org>; Wed, 14 Oct 2026 01:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791965743; x=1792570543; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CCQEOhtmFz7cT7CBUEXeFEMa04vdTqpWMOvtYLUe+QE=;
        b=RmkAmbBm+kVYQAOBQyaXZDz1KvffjwKtbU7Y/k/HBcLTPyXeTQGnWjUOZZ+D0KPTox
         rrQTUFVqmK567FTiWa2VSnqtRmLFh7yfrliT1Oqi8gCZxor76IfxAFB3DskrIyEv2kFB
         bTdA75knQDC88/v5MG/qosdyag/ork1wtWE2JvMKgTLDFX7I6Gbw+7Oh5O2wUsxDPSwQ
         wY/5qrVUsVT5O5r5xIy/pD7seXf5/ud5iIhC606MfA28wixUDkXv45553z1E1tMSxieU
         6T20QWRm29YLgNrBUF3FkQyQ8tUvYRjf5NWAZDDj0dmoEokZZsp9bsbZzxyq50Fx5bTw
         X+Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791965743; x=1792570543;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CCQEOhtmFz7cT7CBUEXeFEMa04vdTqpWMOvtYLUe+QE=;
        b=bRYXzeeMZV+fKcm6QY2hsJK8xbR3Hz18Js8A1iCCJZUCNbKEBFGqzVbPw2Ewy6Y3P1
         rdUh54QYQn+ap4DyJhY2ZUKED/bG9rqV2EH3/e/fgcMbugMmWhPnXZEnw4Km+QBZ0jFm
         dSqU5XNjc5b+ngoVE0gpA2gHK+ElOGiNVdzv//26rePmZpX0NUK30L0VOoAdAZ4/S+r9
         zcMf0OFnwAbGcQXCuLJ6dSJipcQliSFvGf9r1md0S6YocJtOsm/vj3kKTmw5CI/AJCKT
         x9MDCVCoueXArZqTQbdS4kMUNOrcrjm4xyaQTMdm4O/tGZaLSLisexocu2btYE/ZdeO9
         z0Ng==
X-Forwarded-Encrypted: i=1; AKwUvByUUp91DcUudpbXgwnMZLQZJC2NwES9wcAXOLLPUccOECY5qebq31UTCrIl2lqG1YsEKrWsoVgkLWg=@vger.kernel.org
X-Gm-Message-State: AFq9FYKt3K0oluNxnDLZNJcCYMLK7+4yRfNYzik8qSaiAlXNXD252ydx
	GVGpd+izB8ibrfSUFkV4iARND3Q8NGZ228fYcCTRSvouOfA3GbY97oeA
X-Gm-Gg: AYBFou106QA7pGGW0mPOl0EHO3rvlsA9uDFJ3WbEMNJPVl4KSEuf4Nu323GE3Y29hWm
	Tp01QaTaLY93NiA2hdMMjmxG4qeFJPQS7ZkMJ9npZVDi/xu5bC50KsZ8NP1pf/rm5yNtD108pz9
	8HOcPD8WFkyO7YhFWoC97efDcjA1ejUaC97+iazMFSQwe8FvX7P0AY4DxsQ1UDjAj6S3tPS+51/
	+1G86FI/dtq1Dpm4WncUhryIKs5aUBUE0sOkBZEsw721E4+doRCUzlSJqsw6wtEDIdcdNwUk12j
	XWvy24XHuvS+gPlBKYZvBkOtjmBjCS5TOSEdIaPgekasCOj42qNu+rfEXgvIqs+qMbhavi9kwke
	SmaE8B4nErSSi6fQD9cv8Q23IHEvAxWKNsU+VINwUXmVEPSdGT4oLIEqYLvhbakTuWoIqF1jHF3
	Zs3eZvozTDxWPjWWnixOLoquK4LakTGkNSFj5P0oDb5L/iZbouyqXKVYvPTxHL3LaF1RUkS1/5Q
	OEdBpMgKuxYWBh0BJuyty7bCl4+KVoSIjPJE6B9nvU1Bo3q4bxzB531nRzpB90ZaKtveh8zzZLp
	UzP/1T9j2OnFCWlH4+SvB742YA==
X-Received: by 2002:a05:6a21:a345:b0:3dd:a197:cf31 with SMTP id adf61e73a8af0-3e16bf67ae8mr11898673637.85.1791965743197;
        Wed, 14 Oct 2026 01:15:43 -0700 (PDT)
Received: from localhost.localdomain ([121.137.86.182])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd3d9d4fc36sm6523770a12.1.2026.10.14.01.15.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 14 Oct 2026 01:15:42 -0700 (PDT)
From: Joonho Lee <mynameisjune111@gmail.com>
To: Takashi Iwai <tiwai@suse.com>,
	Jaroslav Kysela <perex@perex.cz>
Cc: linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org
Subject: [RFC PATCH v2 0/2] ALSA: pcm: preserve capture tail during drain
Date: Wed, 14 Oct 2026 17:15:38 +0900
Message-ID: <rfc-v2-core-capture-drain-0.2eddd58a796e497f@gmail.com>
In-Reply-To: <rfc-core-capture-drain-0.112c40f0e9284eaa@gmail.com>
References: <rfc-core-capture-drain-0.112c40f0e9284eaa@gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Changes since RFC v1

Patch 1 is unchanged. Patch 2 replaces scoped guards with explicit lock
and unlock pairs because include/linux/cleanup.h prohibits mixing cleanup
helpers and goto within one function. This addresses the Sashiko review.
We did not establish an existing double unlock or skipped unlock: the old
gotos were outside the scoped blocks. The link-lock scope, per-member
pointer refresh, error path and playback wait loop are preserved.
The build and regression results below are from the revised candidate.

The public base and ordered prerequisite patch IDs appear below. The local
v3 tip d58a3ac9b1719fdf8ce9d286be606128aeebf1aa is reconstructed by applying
the five v3 patches to that public base; it is not an upstream commit.

This is v2 of this follow-up RFC, not v4 of the five-patch virtio-snd
lifetime series. The v3 prerequisite thread is:
https://lore.kernel.org/all/cover.1791881787.git.mynameisjune111@gmail.com/
The submitted v3 fixes ACK error propagation, failed START recovery, and
message/buffer lifetime through completion and reset. It does not add the
VZ capture profile or the ALSA core drain handling in these companion RFCs.

This series proposes two changes to capture drain handling:

1. Permit capture transfer calls while the runtime is DRAINING, so buffered
   tail frames remain readable instead of returning -EBADFD at the state
   check. Playback access rules remain unchanged.
2. Refresh active capture hardware pointers before the linked group enters
   DRAINING, so a final subperiod tail is accounted. Hold the link read lock
   across the initial operation and take each member's stream lock for its
   pointer refresh. Propagate pointer errors before the drain transition.

These are ALSA core changes, not VZ quirks. They apply with all VZ options
disabled and can affect other capture drivers, including linked-stream drain
ordering. No new ioctl is added, but applications can observe buffered data
where the previous state check rejected a read. The appropriate core drain
semantics and locking scope need review independently of VZ support.

Dependencies

Apply these two patches in order on v3. They do not depend on the companion
STOP/RELEASE wait patch. The VZ capture RFC requires all three prerequisites.
The base is pinned for reproducibility; this is not a claim that the core
changes are inherently dependent on virtio-snd lifetime fixes.

Validation and limits

The complete local candidate (v3 plus all four RFC patches, including the
revised core locking) was freshly built on 2026-10-14 as an ARM64 Image and
full module set with W=1, KASAN, PROVE_LOCKING, LOCKDEP and
DEBUG_ATOMIC_SLEEP, release 7.3.0-rc6-snd-rfc-cleanup-lockdep.
There were no build errors or warnings in the changed sound paths; 517
-Woverride-init warnings remain in two unchanged ARM64 base files.
This is a rebuild of the pinned candidate, not a rebase to a newer upstream
or sound maintainer tree.

With this kernel under ordinary TCG, no-query short-tail drain returns
1023 frames (FNV-1a64 20d61b4edef6d535) and 2047 frames
(af2de207e4d27535); drop returns zero. Each run also passes a following
capture with fatal-overrun checking, playback drain guard and teardown.
The linked-stream fixture was also rebuilt against this kernel's config
and Module.symvers. Normal unlinked/linked drain passed. An injected
pointer XRUN in the later member visited both pointers and returned EPIPE
with both streams in XRUN. Unlink/prepare, close/reopen, capture/playback
recovery and teardown passed with lockdep enabled. This is a synthetic
ALSA fixture, not a physical-device test.

The QEMU 11.1.2 fixture includes backend reset cleanup changes as well as
fault injection. These are integrated candidate results, not standalone
v3 or isolated-patch proof, and not stock-QEMU, VZ or hardware acceptance.
Earlier runs failed follow-on capture with ring saturation and overruns;
those logs remain retained. Final passes do not establish a permanent fix
for load or clock/scheduling sensitivity.

Physical ALSA devices and the full range of linked capture/playback groups
remain untested. Historical AirPods capture does not isolate core drain
semantics. Playback access rules remain unchanged, but the shared drain
entry locking/order changes also need review for playback-led groups.

All ten ordinary-TCG regression scenarios passed with the fresh candidate,
as did the additional linked-stream error/recovery fixture and 24 Python
harness tests. Successful runtime logs contained no KASAN, lockdep, WARNING,
BUG, Oops or panic diagnostics. Initial harness/CPU-configuration failures
are retained as invalid attempts, not counted as kernel passes.
No new real-microphone or VZ runtime test was performed for this revision.

Reproducer

The previously published source package remains at this pinned commit:
https://github.com/whatisyourname0/virtio-snd-reproducer/tree/7a9876738bdc70ce669f02ec31fe8968eb0ee4fc/rfc/vz-capture-20261014
It contains the original RFC snapshots, kernel builder, QEMU fixture and
ten runtime commands. It does not contain the revised core locking or the
newly rebuilt linked-stream fixture. Do not treat it as the exact source
of the new results above. Existing v3 patches in it are build prerequisites,
not patches being resubmitted.

The revised source stack, four signed implementation patches, exact kernel
config and portable linked-stream fixture are published at this commit:
https://github.com/whatisyourname0/virtio-snd-reproducer/tree/64fa85f3260b45e7dbb85c4eee68a5b4a8b064e1/rfc/vz-capture-20261014/sashiko-followup
The public source recipe reconstructs all eight changed files byte-for-byte
against the tested candidate. The packaged linked fixture also passed with
freshly compiled probes, a new Alpine rootfs and a rebuilt test module on
the same KASAN/lockdep kernel. The public archive was downloaded and checked
against the local source package. See README.md and RESULTS.txt at that URL.
This supplements the earlier bundle; use its corrected core 2/2 patch
rather than the earlier core 2/2 snapshot.

Questions for review

- Is reading buffered capture data in DRAINING the intended ALSA contract,
  or should the driver expose that tail through a different transition?
- Is drain entry the correct place to refresh capture pointers, including
  when draining a paused stream or a linked capture/playback group?
- Is the proposed link-lock/member-lock scope appropriate when a pointer
  error can stop the group? Which other driver or linked-stream cases
  should be required before treating this as a general core fix?

Joonho Lee (2):
  ALSA: pcm: allow capture reads while draining
  ALSA: pcm: refresh capture pointers before drain

 sound/core/pcm_lib.c    | 10 +++++++---
 sound/core/pcm_native.c | 26 ++++++++++++++++++++++----
 2 files changed, 29 insertions(+), 7 deletions(-)

base-commit: 8d70e364e866bdfca81eee24d0688fac9472cfb9
prerequisite-patch-id: 39fb327a004c966ab90f66a34a64bbdbb3ffb475
prerequisite-patch-id: 7c6bc344656fd839ae0d697ba18d66ac0b47827a
prerequisite-patch-id: 9dd290ac3147fa7b49a475d7df8a6172778f2860
prerequisite-patch-id: f4c24a5e441343a690f4ac2437f181c815bc23d0
prerequisite-patch-id: ab4a5b770247a65272ab7af18a75a147daf81287
