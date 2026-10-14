Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279004A207B;
	Wed, 14 Oct 2026 08:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791965737; cv=none; b=G5rYebwBUdW+crszd0tzBpFwTH627rlNCiyIwSba5P7ozQ1E4L3zKXNN/m7zyJs9Q25dAJ5KaXuXSW+0mKTaP2+w8jJWXEeI1OpSkydqVZ0eImRNUBfjz7EI2fMkdjhkt5NnAy3FSem2G1HqP8a6O6NkpEqg8sNN433KYymKbpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791965737; c=relaxed/simple;
	bh=RNcC7loXwQAbS2fy2cUOJMcPavpqddm35TtWbLZ2Dv0=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DXlTDZQJfsQIhB9zSNWLneiWR+10RHMzmPZlaMdo7p3ftrPiOvNNr19LTkP4BdDW0miHI3iQzy3u5mUwZ4AroAeZZyyCQcBjTOgPxsRyaTnxzSf4U8zXVvQhYYPB0rYLlngf1pkPLgVmOY6Gk9GL3SEjowaUqkIYTSJ4Zn5lOEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kiv4Aib/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=74Z2j57f; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kiv4Aib/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=74Z2j57f; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kiv4Aib/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="74Z2j57f";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kiv4Aib/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="74Z2j57f"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BF9091F7C5;
	Wed, 14 Oct 2026 08:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791965727; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Fo0GdmgfeO4+EkZHg2pz27AKahy6RCBiDvsUFo84pMI=;
	b=kiv4Aib/vjXZIzZWX6rVaXuX5JmZiC2rj3pjSaZpz5gHg44Ry9eLVvy0kpGw13Y/oPVXL6
	+ztgxbMO3zclgdffBa5UjSyFhxR9PrEz1EUeqkL8iVYkbPfT7EK2fCrZpGTg3VZxunteYk
	7G/8CJFRPRn2UcL8p2ZmtVIQf2z+Tgk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791965727;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Fo0GdmgfeO4+EkZHg2pz27AKahy6RCBiDvsUFo84pMI=;
	b=74Z2j57fJaz/eMUq797K1Xcqr/CHchW2lVqcH/w6MPCn1oXHehCkiRJdNgYdC+2lWeok56
	8no736kz/HnD0tAQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="kiv4Aib/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=74Z2j57f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791965727; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Fo0GdmgfeO4+EkZHg2pz27AKahy6RCBiDvsUFo84pMI=;
	b=kiv4Aib/vjXZIzZWX6rVaXuX5JmZiC2rj3pjSaZpz5gHg44Ry9eLVvy0kpGw13Y/oPVXL6
	+ztgxbMO3zclgdffBa5UjSyFhxR9PrEz1EUeqkL8iVYkbPfT7EK2fCrZpGTg3VZxunteYk
	7G/8CJFRPRn2UcL8p2ZmtVIQf2z+Tgk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791965727;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Fo0GdmgfeO4+EkZHg2pz27AKahy6RCBiDvsUFo84pMI=;
	b=74Z2j57fJaz/eMUq797K1Xcqr/CHchW2lVqcH/w6MPCn1oXHehCkiRJdNgYdC+2lWeok56
	8no736kz/HnD0tAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0C2141368E;
	Wed, 14 Oct 2026 08:15:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sNHRHh46z2r4WQAAD6G6ig
	(envelope-from <tiwai@suse.de>); Wed, 14 Oct 2026 08:15:27 +0000
Date: Wed, 14 Oct 2026 10:15:26 +0200
Message-ID: <8733u8g0kh.wl-tiwai@suse.de>
From: Takashi Iwai <tiwai@suse.de>
To: Joonho Lee <mynameisjune111@gmail.com>
Cc: Takashi Iwai <tiwai@suse.com>,
	Jaroslav Kysela <perex@perex.cz>,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] ALSA: pcm: refresh capture pointers before drain
In-Reply-To: <rfc-core-capture-drain-2.112c40f0e9284eaa@gmail.com>
References: <rfc-core-capture-drain-0.112c40f0e9284eaa@gmail.com>
	<rfc-core-capture-drain-2.112c40f0e9284eaa@gmail.com>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/30.2 Mule/6.0
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Action: no action
X-Spam-Score: -3.51
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Level: 
X-Rspamd-Queue-Id: BF9091F7C5
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org

On Wed, 14 Oct 2026 05:30:57 +0200,
Joonho Lee wrote:
> 
> Refresh active capture pointers before the drain transition so the final
> captured tail is accounted before reads finish.
> 
> Assisted-by: LLM
> Signed-off-by: Joonho Lee <mynameisjune111@gmail.com>
> ---
>  sound/core/pcm_native.c | 32 +++++++++++++++++++++++++-------
>  1 file changed, 25 insertions(+), 7 deletions(-)
> 
> diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
> index defbb2977efe..622ae7be2d04 100644
> --- a/sound/core/pcm_native.c
> +++ b/sound/core/pcm_native.c
> @@ -2176,14 +2176,32 @@ static int snd_pcm_drain(struct snd_pcm_substream *substream,
>  	} else if (substream->f_flags & O_NONBLOCK)
>  		nonblock = 1;
>  
> -	snd_pcm_stream_lock_irq(substream);
> -	/* resume pause */
> -	if (runtime->state == SNDRV_PCM_STATE_PAUSED)
> -		snd_pcm_pause(substream, false);
> +	/* Keep linked runtimes alive until the initial drain action completes. */
> +	scoped_guard(rwsem_read, &snd_pcm_link_rwsem) {
> +		snd_pcm_stream_lock_irq(substream);
> +		/* Resume before refreshing capture positions. */
> +		if (runtime->state == SNDRV_PCM_STATE_PAUSED)
> +			snd_pcm_pause(substream, false);
> +		snd_pcm_stream_unlock_irq(substream);
> +
> +		/* A pointer error may stop the group: hold only this member's lock. */
> +		snd_pcm_group_for_each_entry(s, substream) {
> +			if (s->stream != SNDRV_PCM_STREAM_CAPTURE)
> +				continue;
> +			scoped_guard(pcm_stream_lock_irq, s) {
> +				if (s->runtime->state == SNDRV_PCM_STATE_RUNNING)
> +					result = snd_pcm_update_hw_ptr(s);
> +			}
> +			if (result < 0)
> +				break;
> +		}
>  
> -	/* pre-start/stop - all running streams are changed to DRAINING state */
> -	result = snd_pcm_action(&snd_pcm_action_drain_init, substream,
> -				ACTION_ARG_IGNORE);
> +		snd_pcm_stream_lock_irq(substream);
> +		/* Change the stable group to DRAINING only after all refreshes. */
> +		if (result >= 0)
> +			result = snd_pcm_action(&snd_pcm_action_drain_init,
> +						substream, ACTION_ARG_IGNORE);
> +	}
>  	if (result < 0)
>  		goto unlock;
>  	/* in non-blocking, we don't wait in ioctl but let caller poll */

IIUC, basically what here we do is to just call
snd_pcm_update_hw_ptr() for capture at drain init phase, so calling it
inside snd_pcm_do_drain_init() would make more sense, I suppose.

But, the problem is that snd_pcm_update_hw_ptr() itself takes an
action to stop the stream for XRUN.  So we'd need to fiddle along with 
it, too, as something like below.  (Maybe we need more brush-ups.)


thanks,

Takashi

-- 8< --
diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index 4d665b4148d7..a1b19d558234 100644
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
@@ -283,8 +292,8 @@ static void update_audio_tstamp(struct snd_pcm_substream *substream,
 	runtime->driver_tstamp = driver_tstamp;
 }
 
-static int snd_pcm_update_hw_ptr0(struct snd_pcm_substream *substream,
-				  unsigned int in_interrupt)
+int snd_pcm_update_hw_ptr0(struct snd_pcm_substream *substream,
+			   bool in_interrupt, bool notify)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	snd_pcm_uframes_t pos;
@@ -490,13 +499,13 @@ static int snd_pcm_update_hw_ptr0(struct snd_pcm_substream *substream,
 
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
@@ -1906,7 +1915,7 @@ void snd_pcm_period_elapsed_under_stream_lock(struct snd_pcm_substream *substrea
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
index a845f242a163..76983e5f4d4e 100644
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
