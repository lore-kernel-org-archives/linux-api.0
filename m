Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429A537C927
	for <linux-api@vger.kernel.org>; Thu, 15 Oct 2026 23:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792108098; cv=none; b=GGjIzjsTGBEm38O0bNZxyjcbGgRcaanXtBrbtFSYGdmo1SMyWnHy7YUuI0o42Y9i31aRPWXs30D/KyEjwXKZ1kU8+jYzx0kEUBhF8H9yrSkuzvBj4oNAgVHYtzTSpFTOPyvpQ6ftvyNIYmh+eGLuC/8cvQoVHXzUDCIUV3Mlbi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792108098; c=relaxed/simple;
	bh=PT9ArUjUozHhUUTYiMZwczp/mL27AYQ8/pAM0UOxD9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=itvBwaIyler+5WkCUv4nwu350OWy1PKxBdlgxLI3qbu0FpGTB694idMYdhuNeggRLvU8HbgjAQ6qV1011ZQJdJDyEaoalrMzpiu5pT8rwuW6ryacH8CqamkF4fgRJzk49dVDele15jfJcLMoMMMM7w8vzXmo6V8At8EiH5OAYi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GJUKCMq7; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GJUKCMq7"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-88834d30002so3023067b3a.1
        for <linux-api@vger.kernel.org>; Thu, 15 Oct 2026 16:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792108096; x=1792712896; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cQYVQp3cNq+IO9sRvJYpEZ43wUtWXqrA+QLO7PX+bJk=;
        b=GJUKCMq7HqiLpUZqJ3nmU+5QQlETGSwHnIjsII6TifYaG5bi8R+80P23RGYsaTlOpZ
         W+1uEbT0RQ37P+/JafAuTLSAw5qbVGuLMXfjmA322G7lmtld/3WmUWswOibK5pRHiJ39
         2tcK/1xe4N579C6WIbEJ9yKUxnH9sGCVuF5ebaSrJzTKDoQYaTeun3mnXweBv0rMwHun
         5twv9TFH/q23HqjVj/O9TO8VTj8bO2sKdRhfIt96GQ07EKa/nLFoWnqQxyqGxojOuQq3
         a3ptxrL7DbBLwpFWEbLHR+VmrHWO04qZvIFuES1HuLuO/vG3h4kjivBgJK1BXAsy6kdM
         msXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792108096; x=1792712896;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cQYVQp3cNq+IO9sRvJYpEZ43wUtWXqrA+QLO7PX+bJk=;
        b=LtarFaBuBAQOhID5FbJxDXY673AXeUMnzpt3leCRM54ClR0PJvC2J1P8vTKed9vAZK
         bjRROXd/2i4SKXDxNOLAHhB8THA1fQR5fjzZgFBQr9N2cX/Bp98DtKy7h0NVikDkPNcK
         sX88lJHWsKYqAJu83O34CB5jlLuMN7IcC270ys2B5+/6+2dTzwR2olDz0TIMGpqE6z20
         Zqj0+RKbrxImYOiInpa68hM9faQBlMv4FMGCteEyxT33hMw8xd6M3wC/FZk4Q5Y50UuR
         vnvq5JtVWQiZ6LI7pUpL869QIKY6lbrqtUAJ0SxqgoRal0vOZAzPHRvmXUqMxn366F/i
         kgXg==
X-Forwarded-Encrypted: i=1; AKwUvByFGwWaifK4fIy7JbZbiijttJhORcZTiqIbycZ+S4YTSrTCPX3XC065Wyh5rnZlCqxUSjCiQS5ClbM=@vger.kernel.org
X-Gm-Message-State: AFq9FYLsr8+zllfW8tyhFEaZGeOxzdnY9rpw4HVRmUI1OkoDM6hZSnvW
	Fb4u4zTr9S2vEE/8IAKtcFAuwdCCQ3qRmFTx/osvP6dXzOicHK9kMsh/
X-Gm-Gg: AYBFou0Gzz4WOOTKTC6SalpQzxmcFovh424FziSWvxW5pRmme+bxZmvn6+HOODVU2aM
	rMoCtEkBCJIN03BwVSCtW7ddVvX5LKZvV07TuOqz4DJAwFKD15Lz0OqwVX5EtBFD06E4tRVzigQ
	I0/YQcWkefXVTLuJ/Cl9yeRW7bBawXsUoUxwhERNV51UzVe2Pq0X0JKOp+K0eK6eF4R/OXE4sJg
	SpJDD0UhGBl0GA9Ma0XR8AMORVMRNifYZ6KndUHTyRl5b7EEmct8uVccmKOdheYXLoGjIy7udkI
	O9DjvXd6+X3zexAXN/P2HrgZSEcXcW6e/ga6up/2yd8m9O9qX/RvWOzGWhmXvivly1RNAJXbDbz
	NCwb5kx5TccLelg6yYEanVOLyOkKOYt/7bb05V8NNhmPA/6YJK5F/9pHkvLToe4aDbPYR2E0Ydy
	IpFrm7a3GmJwZAU3Ax6ZpUNAdglKzHYfZAlKwlOKyTFdQbKX3lmKF8pX1bPXne2wpZNmfcnLEYs
	XeBEEWVWNZP5+BJkGYxlSFwSw8KyDrUJG1AgbXATWhxd9KLmRZ5pIeAMeRugkJCcGWX+N86UTgK
	dXq41Ac8a/onANO6Ow==
X-Received: by 2002:a05:6a20:e212:b0:3de:5435:3419 with SMTP id adf61e73a8af0-3e16beb2275mr17738963637.51.1792108096484;
        Thu, 15 Oct 2026 16:48:16 -0700 (PDT)
Received: from localhost.localdomain ([183.96.175.225])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89f58208cc3sm255708b3a.52.2026.10.15.16.48.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 15 Oct 2026 16:48:14 -0700 (PDT)
From: Joonho Lee <mynameisjune111@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Takashi Iwai <tiwai@suse.com>,
	Jaroslav Kysela <perex@perex.cz>,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org
Subject: [PATCH v5 1/2] ALSA: pcm: allow capture reads while draining
Date: Fri, 16 Oct 2026 08:48:09 +0900
Message-ID: <v5-core-capture-drain-1.e9b40d3bc08c4162@gmail.com>
In-Reply-To: <v5-core-capture-drain-0.e9b40d3bc08c4162@gmail.com>
References: <v5-core-capture-drain-0.e9b40d3bc08c4162@gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Capture drain can leave buffered samples in DRAINING, but the transfer
state check rejects reads in that state. Allow capture reads to consume
the remaining frames while preserving the playback state check.

When drain wakes a blocked capture reader, return the actual available
frame count from wait_for_avail(). A zero count would make the transfer
loop discard a nonempty tail. Finish capture EOF with snd_pcm_drain_done()
so the state transition applies to that substream and leaves a linked
playback stream draining its queued data.

Allow capture hwsync to use the cached final pointer in DRAINING. Capture
has already stopped, so DELAY and SYNC_PTR(HWSYNC) can report its remaining
frames without another driver pointer callback. Playback retains its
existing pointer update.

Synthetic atomic and nonatomic tests reproduce dropped tail frames,
linked playback stopping at capture EOF, and rejected position queries.
With this change, a blocked read gets all 64 tail frames, playback stays
DRAINING at capture EOF, and the queries succeed with no extra callback.

Assisted-by: LLM
Signed-off-by: Joonho Lee <mynameisjune111@gmail.com>
---
 sound/core/pcm_lib.c    | 16 ++++++++++------
 sound/core/pcm_native.c |  2 +-
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index 4d665b4148d7..e8f6a9da4a4c 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -2009,8 +2009,8 @@ static int wait_for_avail(struct snd_pcm_substream *substream,
 		case SNDRV_PCM_STATE_DRAINING:
 			if (is_playback)
 				err = -EPIPE;
-			else 
-				avail = 0; /* indicate draining */
+			else
+				avail = snd_pcm_avail(substream);
 			goto _endloop;
 		case SNDRV_PCM_STATE_OPEN:
 		case SNDRV_PCM_STATE_SETUP:
@@ -2208,13 +2208,17 @@ static int pcm_sanity_check(struct snd_pcm_substream *substream)
 	return 0;
 }
 
-static int pcm_accessible_state(struct snd_pcm_runtime *runtime)
+static int pcm_accessible_state(struct snd_pcm_substream *substream)
 {
+	struct snd_pcm_runtime *runtime = substream->runtime;
+
 	switch (runtime->state) {
 	case SNDRV_PCM_STATE_PREPARED:
 	case SNDRV_PCM_STATE_RUNNING:
 	case SNDRV_PCM_STATE_PAUSED:
 		return 0;
+	case SNDRV_PCM_STATE_DRAINING:
+		return substream->stream == SNDRV_PCM_STREAM_CAPTURE ? 0 : -EBADFD;
 	case SNDRV_PCM_STATE_XRUN:
 		return -EPIPE;
 	case SNDRV_PCM_STATE_SUSPENDED:
@@ -2320,7 +2324,7 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(struct snd_pcm_substream *substream,
 	nonblock = !!(substream->f_flags & O_NONBLOCK);
 
 	snd_pcm_stream_lock_irq(substream);
-	err = pcm_accessible_state(runtime);
+	err = pcm_accessible_state(substream);
 	if (err < 0)
 		goto _end_unlock;
 
@@ -2348,7 +2352,7 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(struct snd_pcm_substream *substream,
 		if (!avail) {
 			if (!is_playback &&
 			    runtime->state == SNDRV_PCM_STATE_DRAINING) {
-				snd_pcm_stop(substream, SNDRV_PCM_STATE_SETUP);
+				snd_pcm_drain_done(substream);
 				goto _end_unlock;
 			}
 			if (nonblock) {
@@ -2388,7 +2392,7 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(struct snd_pcm_substream *substream,
 		atomic_dec(&runtime->buffer_accessing);
 		if (err < 0)
 			goto _end_unlock;
-		err = pcm_accessible_state(runtime);
+		err = pcm_accessible_state(substream);
 		if (err < 0)
 			goto _end_unlock;
 		appl_ptr += frames;
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index defbb2977efe..657e77d33b21 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3014,7 +3014,7 @@ static int do_pcm_hwsync(struct snd_pcm_substream *substream)
 	switch (substream->runtime->state) {
 	case SNDRV_PCM_STATE_DRAINING:
 		if (substream->stream == SNDRV_PCM_STREAM_CAPTURE)
-			return -EBADFD;
+			return 0;
 		fallthrough;
 	case SNDRV_PCM_STATE_RUNNING:
 		return snd_pcm_update_hw_ptr(substream);
