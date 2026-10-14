Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97564524AE3
	for <linux-api@vger.kernel.org>; Wed, 14 Oct 2026 15:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791991486; cv=none; b=r5QPOhmJjHJADUvdYkLGV45lgdvgoZ4KLBB8/o/pLdzhQDeudER/gN5mD8xeo3x+2tXPVFcmdBCJioZ1qRcyeAVjrJOM9tAMnItf5Y3BSbkb4BrNZdISVMCgdKJai0OH/4GbLwTMiHMB6/BWmU4UzLJFYfJCubuUHD9wMJ/QUHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791991486; c=relaxed/simple;
	bh=BBI0XcpPkSK55EQflgt1Amfesy8fbmHDO9s7ArZKsO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ELTAT4P0NfoQGUWLPmJhVuXCbW7z9mXBRGE+ZVYDr0L6DSR14zjgWhxdLU7LvFNHASGGkiAR/rHra1ZzhT6f/z+j8QGwHSk+pKmzEC87FrA2DPASmfPGgxMnI9PMcD1a90kg4XQ+Oj0axcDtRRNINN5yOvhveiHi4SQBCp5d8ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V2EUGsof; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V2EUGsof"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3a4b3ac8fb7so2004277a91.0
        for <linux-api@vger.kernel.org>; Wed, 14 Oct 2026 08:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791991485; x=1792596285; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wmGqVNpq2PdWl+heL73MWMPJF6Ks87RHIfNcYC7eCSU=;
        b=V2EUGsofJlOKUuCaBTZZVQ6pMFFXY+ESh0ItzMX4oDsSGwamS9yKKTcv5/02/aNNYL
         kBTj7lWLr76YsPE209DQ63AhJYTWvyCSA3YJ3vWLlySoXqUgK5jRH8qMxIZRDgxopPSe
         jMh9KIcf7801SMuqEmzox6fjxuGGQSTENm3FsyzOwTFqbJsYgF5DDqMJTnvsRBcTOxqp
         VRCeMEHLed3koNrnt0Dk9XS8186rZY1wXHYi9Y3DNtK/AIX8Jt2ACCM3VPLImf/sDiWj
         2gl9TsG0ulZIkRv38UycVF1YzwrjV9iJB5ds+32jovYaih8c6Q3kqMjYJp6a3BQd7Etw
         2OZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791991485; x=1792596285;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wmGqVNpq2PdWl+heL73MWMPJF6Ks87RHIfNcYC7eCSU=;
        b=lsi6HYCPOkSYTY4OFqpe/2pJu9g8YjVcsN5As8uTTpokWSYUeZ7bjQxsD0mv2m1aG+
         /yw874pVZxX5bZiamoVcPVB/YqFUxpxLZmECCPtjCWIHWUSODNG8Q8HVa2Ae6UmlqWZ0
         qyRUUFOxBp2HleC6SdXVpCWH+5Dn8akMvbQkTLqr8OcvGCXruZUrJwZcqrDDAFGlkB2k
         VYCqj2klNiyDRleZeu+5a32J+A9ERhyU2t0NjGlO+hFWfmvqNtKcH2s1aKk1rVxhhzi9
         bobUDnUNlAUM5KSoObfz0KqnjJWO8SXjPkAXsZl7jbw3Vk/LiGvPFDxfPji1TLy4HPfA
         +FMg==
X-Forwarded-Encrypted: i=1; AKwUvBx8nh1psMkSBPagtTapvwhzLbZ7OTXVS6j5TKCJQ4MBCbXKqzefkEwSPsjFzojk7nanl/iYu2ybYpM=@vger.kernel.org
X-Gm-Message-State: AFq9FYKuUr89Xe5brMuhFA37xugufIT3P5Y4q8wCQcFX8L0GwLTEzasm
	OVV+6V6ZktgX614qG1fTaswmbgAntAnrtgVzXjvq+8NvndVi+SD1smY8
X-Gm-Gg: AYBFou2EXG2zANyqMr4o2J/QB7DLQR0YSTZHqoXqq/3XXdblkjFweMtNWrOT3CfI3i6
	QltWniytnbFxIIQoVdxtWfSH2ZZoDt3WDU/nSi0KcTTNMnCdo0d6cLo9FFWrxpwiimz3ZMitTWx
	M4H9ai1AcwBjSdYRRTNA+P70YvPeQ/Tw70ohRbQ+uY0hTCLyS+DHnrYUB6GgdBttdNnDmfZSR6I
	GTZxmuOBzOn6I561iJf961DOgVrgnLEv485Verpw+k6k8tbZ4Hnnn8DT18W4uBJM9zKwpJQXblQ
	2aa0elvvJx61XGiLYfRGFc3YgWNmoZDl0M+DRsfSaK4pVaDobYyDEVkDP+bX77iiphUAZ+7nt5v
	aNZkhyCVgRnX+6ffnEgknv10ZVD0Oe1+47spfK4MUHI0+dHYUesNBiQeT5Jr8vnNZOKWsH02HwQ
	qp+L9HwKuMcDa2MuBGywyg8zZu8RFHHxOWYUwHJazg2g1UVZdwLnKVR4QLARhgoRPNIPaVAPn/E
	RxaqIOnXZZHSj4Mm0+fMVGRc2vclrR2tMEDOQ7OrNKEdrg7z5tYxbL1BACxNC5f4yPFtHJEJ/4k
	p0o6hJaEDNeqM88=
X-Received: by 2002:a17:90b:3a48:b0:3ab:413:49b6 with SMTP id 98e67ed59e1d1-3ab3a79a2d8mr14082334a91.41.1791991484697;
        Wed, 14 Oct 2026 08:24:44 -0700 (PDT)
Received: from localhost.localdomain ([180.182.24.11])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac5f27d573sm5151816a91.11.2026.10.14.08.24.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 14 Oct 2026 08:24:42 -0700 (PDT)
From: Joonho Lee <mynameisjune111@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Takashi Iwai <tiwai@suse.com>,
	Jaroslav Kysela <perex@perex.cz>,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org
Subject: [RFC PATCH v3 2/2] ALSA: pcm: refresh capture pointers in the drain action
Date: Thu, 15 Oct 2026 00:24:39 +0900
Message-ID: <rfc-v3-core-capture-drain-2.cf2e307fcac34b6a@gmail.com>
In-Reply-To: <rfc-v3-core-capture-drain-0.cf2e307fcac34b6a@gmail.com>
References: <rfc-core-capture-drain-0.112c40f0e9284eaa@gmail.com> <rfc-core-capture-drain-2.112c40f0e9284eaa@gmail.com> <8733u8g0kh.wl-tiwai@suse.de> <87y0c0el29.wl-tiwai@suse.de> <core-drain-linked-lock-reply.cf2e307fcac34b6a@gmail.com> <rfc-v3-core-capture-drain-0.cf2e307fcac34b6a@gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Capture drain decides whether to retain unread data from the cached
hardware pointer. A final subperiod can be omitted if the driver has
advanced without a period notification or another pointer query.

Refresh each running capture pointer in snd_pcm_do_drain_init(), with
the normal drain action holding the stream and linked-group locks.
Allow pointer accounting to return an error without issuing a nested
XRUN or drain-complete action. Guard both the driver XRUN sentinel and
the stop-threshold path; otherwise a linked drain can recursively enter
the group stop action while its member locks are held.

Let drain init own the stop: an update error ends that member in SETUP,
while a successful update retains available capture frames in DRAINING.
Ordinary pointer queries and period notifications retain their existing
XRUN and drain-completion actions.

Suggested-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/all/8733u8g0kh.wl-tiwai@suse.de/
Link: https://lore.kernel.org/all/87y0c0el29.wl-tiwai@suse.de/
Assisted-by: LLM
Signed-off-by: Joonho Lee <mynameisjune111@gmail.com>
---
 sound/core/pcm_lib.c    | 34 ++++++++++++++++++++++++----------
 sound/core/pcm_local.h  |  2 ++
 sound/core/pcm_native.c | 10 ++++++++--
 3 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index de952f639d3b..2bb24d7dd2a1 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -206,8 +206,9 @@ void __snd_pcm_xrun(struct snd_pcm_substream *substream)
 
 #endif
 
-int snd_pcm_update_state(struct snd_pcm_substream *substream,
-			 struct snd_pcm_runtime *runtime)
+static int do_pcm_update_state(struct snd_pcm_substream *substream,
+			       struct snd_pcm_runtime *runtime,
+			       bool notify)
 {
 	snd_pcm_uframes_t avail;
 
@@ -216,12 +217,14 @@ int snd_pcm_update_state(struct snd_pcm_substream *substream,
 		runtime->avail_max = avail;
 	if (runtime->state == SNDRV_PCM_STATE_DRAINING) {
 		if (avail >= runtime->buffer_size) {
-			snd_pcm_drain_done(substream);
+			if (notify)
+				snd_pcm_drain_done(substream);
 			return -EPIPE;
 		}
 	} else {
 		if (avail >= runtime->stop_threshold) {
-			__snd_pcm_xrun(substream);
+			if (notify)
+				__snd_pcm_xrun(substream);
 			return -EPIPE;
 		}
 	}
@@ -233,6 +236,12 @@ int snd_pcm_update_state(struct snd_pcm_substream *substream,
 	return 0;
 }
 
+int snd_pcm_update_state(struct snd_pcm_substream *substream,
+			 struct snd_pcm_runtime *runtime)
+{
+	return do_pcm_update_state(substream, runtime, true);
+}
+
 static void update_audio_tstamp(struct snd_pcm_substream *substream,
 				struct timespec64 *curr_tstamp,
 				struct timespec64 *audio_tstamp)
@@ -283,8 +292,12 @@ static void update_audio_tstamp(struct snd_pcm_substream *substream,
 	runtime->driver_tstamp = driver_tstamp;
 }
 
-static int snd_pcm_update_hw_ptr0(struct snd_pcm_substream *substream,
-				  unsigned int in_interrupt)
+/*
+ * Call with the stream lock held.  With notify=false the caller handles
+ * stopping the stream, so pointer errors must not start a nested action.
+ */
+int snd_pcm_update_hw_ptr0(struct snd_pcm_substream *substream,
+			   bool in_interrupt, bool notify)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	snd_pcm_uframes_t pos;
@@ -322,7 +335,8 @@ static int snd_pcm_update_hw_ptr0(struct snd_pcm_substream *substream,
 	}
 
 	if (pos == SNDRV_PCM_POS_XRUN) {
-		__snd_pcm_xrun(substream);
+		if (notify)
+			__snd_pcm_xrun(substream);
 		return -EPIPE;
 	}
 	if (pos >= runtime->buffer_size) {
@@ -490,13 +504,13 @@ static int snd_pcm_update_hw_ptr0(struct snd_pcm_substream *substream,
 
 	update_audio_tstamp(substream, &curr_tstamp, &audio_tstamp);
 
-	return snd_pcm_update_state(substream, runtime);
+	return do_pcm_update_state(substream, runtime, notify);
 }
 
 /* CAUTION: call it with irq disabled */
 int snd_pcm_update_hw_ptr(struct snd_pcm_substream *substream)
 {
-	return snd_pcm_update_hw_ptr0(substream, 0);
+	return snd_pcm_update_hw_ptr0(substream, false, true);
 }
 
 /**
@@ -1906,7 +1920,7 @@ void snd_pcm_period_elapsed_under_stream_lock(struct snd_pcm_substream *substrea
 	runtime = substream->runtime;
 
 	if (!snd_pcm_running(substream) ||
-	    snd_pcm_update_hw_ptr0(substream, 1) < 0)
+	    snd_pcm_update_hw_ptr0(substream, true, true) < 0)
 		goto _end;
 
 #ifdef CONFIG_SND_PCM_TIMER
diff --git a/sound/core/pcm_local.h b/sound/core/pcm_local.h
index ecb21697ae3a..12bb6e75329a 100644
--- a/sound/core/pcm_local.h
+++ b/sound/core/pcm_local.h
@@ -28,6 +28,8 @@ int pcm_lib_apply_appl_ptr(struct snd_pcm_substream *substream,
 int snd_pcm_update_state(struct snd_pcm_substream *substream,
 			 struct snd_pcm_runtime *runtime);
 int snd_pcm_update_hw_ptr(struct snd_pcm_substream *substream);
+int snd_pcm_update_hw_ptr0(struct snd_pcm_substream *substream,
+			   bool in_interrupt, bool notify);
 
 void snd_pcm_playback_silence(struct snd_pcm_substream *substream,
 			      snd_pcm_uframes_t new_hw_ptr);
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index defbb2977efe..91ae46de3521 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -2094,6 +2094,8 @@ static int snd_pcm_do_drain_init(struct snd_pcm_substream *substream,
 				 snd_pcm_state_t state)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
+	int err;
+
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
 		switch (runtime->state) {
 		case SNDRV_PCM_STATE_PREPARED:
@@ -2119,8 +2121,12 @@ static int snd_pcm_do_drain_init(struct snd_pcm_substream *substream,
 		if (runtime->state == SNDRV_PCM_STATE_RUNNING) {
 			snd_pcm_state_t new_state;
 
-			new_state = snd_pcm_capture_avail(runtime) > 0 ?
-				SNDRV_PCM_STATE_DRAINING : SNDRV_PCM_STATE_SETUP;
+			err = snd_pcm_update_hw_ptr0(substream, false, false);
+			if (err < 0)
+				new_state = SNDRV_PCM_STATE_SETUP;
+			else
+				new_state = snd_pcm_capture_avail(runtime) > 0 ?
+					SNDRV_PCM_STATE_DRAINING : SNDRV_PCM_STATE_SETUP;
 			snd_pcm_do_stop(substream, new_state);
 			snd_pcm_post_stop(substream, new_state);
 		}
-- 
2.54.0 (Apple Git-157)
