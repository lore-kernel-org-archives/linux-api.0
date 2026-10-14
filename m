Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0705486E7E
	for <linux-api@vger.kernel.org>; Wed, 14 Oct 2026 08:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791965752; cv=none; b=I8pg3VCEeO8riuE4AZnYIYKZNab5ckDTsjXEJkUl1zsoDndPgbCSZHk74ek1IUyjy0Ptx1PjdBhfEda+mNAHdezGk6zbSAe9a6jPkdJaUk5xS9CYjTxNeJqj0gmNuV/YTpIfCLr2KbUdS27XB8uY+cqZ40e3+WmcqTbuiPqaPGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791965752; c=relaxed/simple;
	bh=wSZ3zwnVBwhfAGt5ifjj+oFVu2p72JS9QMJwu71vpk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r7NDFLkxu2Ptm7Ir+pf2Sk2L7of4cAw6dXGI2HdQn6YxwUNjr/qtRbDz8jPRLYJuhvbptxd3E03LTqxNkfjc4mrDvySqSacU3DLSBU86URTkEwlitu8ubCU5MKno+lyVxh12Sstx067kUGnZGhhZ1+TMI0mJXLI2ok7I7rSpBHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DhOGTsII; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DhOGTsII"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3ab9268d90eso1916544a91.3
        for <linux-api@vger.kernel.org>; Wed, 14 Oct 2026 01:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791965748; x=1792570548; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=t7IRL6SEiSa3rzeqlbvDCyLB5N7LUmPGMrQiBUcualE=;
        b=DhOGTsIIoYoFoB3HtfXJWqtn7l1e+BYak3aD2IASvJXXb0az5D4s31qAwUTcZTI6xH
         STxLs0yiX2k9EqUmxhJhc+TBis73InrMRrjzjA5anO4QivtSWElt8BoXSUrRooMclyhL
         yW8Nrkp7Fv/86wRPB28BTLAJS7oVOaHmW5I/bttvUUAT0Akq+NbHIa1mqy7F8fH+E1qG
         zXDtMChb6ojZ6Qu8gTRLos3gWfMqHYji6g+uqLXbPtUtou33y3ioHUDrr04lU17oDm1l
         a/6koldbij1XRjW1kbpTl1MqWdJuN9S0d3SWuZeT/GbYLJzFyrcmnrJGrIWE1evdhEhb
         XzjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791965748; x=1792570548;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t7IRL6SEiSa3rzeqlbvDCyLB5N7LUmPGMrQiBUcualE=;
        b=iBSx5BLuLEPkvh3TOPq5lNb3gP9ZMlqeGaL6XMs/ZoIQP64MnZ2p6GtqU21yO7FRgL
         SQyKjYXXypWSFdIsf4X7wShGmzqApNvoBRBEWFHU/VHz+/rkO4Xzxtezfpb3IDXRc6Lk
         e+jy6cX1PJhAy+OWOXybY1JuOAzgYsLX61UEBjk38IMR0BLxon6wCGOHD/X3vzedVMOy
         gDE+DCdxeCo0sck+pUelc7c2zZaP6FtsldImeoNqemIa6H8ZDCGYQ7SUjPplgvnd3w4V
         nQQcudZHTUMVUWFlHqceP9owPP4kzJdddTn3ZeKEgRHJXgYiDLKCrbizTmkL2P0WFiQK
         znPA==
X-Forwarded-Encrypted: i=1; AKwUvBy3i8F9R8piFF3c2+9910dQOkqZlf/a3wfsw89Tqfwh9PGtZoeZefckDKpenOAulix4AY5UEtqyC+k=@vger.kernel.org
X-Gm-Message-State: AFq9FYKlCHG5RYR0Lz0I+C5+de+XczJDHN8cA9mrLw6GQ4tde9O7QC7w
	dbSgAaTDtX7X5deXHixu2Lft4SXWb7EodZwS5GI5IZmlqXf1SPzbr0k3
X-Gm-Gg: AYBFou2m/pXMbcEobQTjlmrvZgmLb7ooHdV8WJqylNdfXZpRiMgk9zhHfvABKdP5Bp/
	x7yrCzjP+2cHrSSj8OMXAhv8XuJYTtCtSsMrQSZA7X5a3bL35bHDvElc4JI2oZUMiCmvrOVz7PA
	a4uA+IL/w+LOGKAD7CaohO9SrESJMiK/zd8AdVxBr9nH7C7XJeFCuglka3taJSrT2VPriGOgJTl
	UY2NyZ1Cn1BMLfS9Pvb3R1caqo1bRWmXFAcanGX/s9Ktw6TXW1RFxaqC2QgxgeZVxIzBzL1YAVE
	7gvbzXVNTs/dFt/FfGzGKZoTUuLBiEv3yTvOfo3m1jcj5GRq59VO6UZSUEBjOEWAunU6kUO7b4x
	RjAApU/2jlW0aPdm680pmtssyPQhwDWd0T967E9rQNOxK1NpUzNkiuNSLHtnb8hfXiEBNv0edS6
	8vQFt2WQKcatk0yAK5qRms0Y0Adv7VPykzlTJa+XYAlXOdaH8f/7XWzd0ApJeNDaE3jwh2c4OBi
	4e0miQw0BD6JfLX7q6WLhHD3OGZJhyLChsHQZYeLHt6uus+5/Hwu3WLIintPeipVKOYTm6hOj9P
	HrH4j1PUM6m+fEDk7hVkVkmGPw==
X-Received: by 2002:a17:90b:51cf:b0:3ab:c370:3684 with SMTP id 98e67ed59e1d1-3abc370392emr7678451a91.30.1791965747930;
        Wed, 14 Oct 2026 01:15:47 -0700 (PDT)
Received: from localhost.localdomain ([121.137.86.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac5f24b757sm3569229a91.10.2026.10.14.01.15.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 14 Oct 2026 01:15:47 -0700 (PDT)
From: Joonho Lee <mynameisjune111@gmail.com>
To: Takashi Iwai <tiwai@suse.com>,
	Jaroslav Kysela <perex@perex.cz>
Cc: linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org
Subject: [RFC PATCH v2 1/2] ALSA: pcm: allow capture reads while draining
Date: Wed, 14 Oct 2026 17:15:43 +0900
Message-ID: <rfc-v2-core-capture-drain-1.2eddd58a796e497f@gmail.com>
In-Reply-To: <rfc-v2-core-capture-drain-0.2eddd58a796e497f@gmail.com>
References: <rfc-v2-core-capture-drain-0.2eddd58a796e497f@gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Allow capture transfer calls in DRAINING so already captured tail frames
remain readable until drain completes.

Assisted-by: LLM
Signed-off-by: Joonho Lee <mynameisjune111@gmail.com>
---
 sound/core/pcm_lib.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index 4d665b4148d7..de952f639d3b 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
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
 
@@ -2388,7 +2392,7 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(struct snd_pcm_substream *substream,
 		atomic_dec(&runtime->buffer_accessing);
 		if (err < 0)
 			goto _end_unlock;
-		err = pcm_accessible_state(runtime);
+		err = pcm_accessible_state(substream);
 		if (err < 0)
 			goto _end_unlock;
 		appl_ptr += frames;
