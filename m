Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454CF49DBBE;
	Wed, 14 Oct 2026 08:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791966948; cv=none; b=e/K5yN7T0sUiBzZqURe+vaO4W+KI75S/8G3swlUE/pxwsHkg0ibtaRMcmDpHzTX4AXZCr8YGDF5lnl+/Jq0f0THypxJis8/bWaRbS28k2RtheqIYN7+mqGuU+QBgHS1LoszBrwLOPh3jdGChmuxKZ9EFamvoV3xdlYfwA4djZMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791966948; c=relaxed/simple;
	bh=XeozNg/h5C4jVFbWkdfCWI/sqt1my2Ywc8swaj3gL6Q=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H0ogOYSUDiHPoVvRd8uPpN8U317/ko/+pGs1kM5zdfHSJ5CHlfLuSkXRFgSF/22DGKjasu6Cz7ZbHlk/KXGaTR40Ar5GRLKFs37e18OXBgMVZ+zKTb4tzwphNXmnuvtSeXCDPzMn4fX3yymcyXJTvacro3k1jrLi1hVdwqYOerw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jnda8rWU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9WcVn9yN; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jnda8rWU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9WcVn9yN; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jnda8rWU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9WcVn9yN";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jnda8rWU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9WcVn9yN"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2FFAB1F7C5;
	Wed, 14 Oct 2026 08:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791966944; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4+ZShSKKnj+mFUVmqcVFWILyz1RAsBq/MpO5bmLA0z0=;
	b=jnda8rWUW3aKFgJjvKayxs/qS2W308YuYmsluXDnk+3HP5Y+jyqsfqltn935lXoJoIGHij
	QEgkpWaBUEGWVEyXdfPz2botr2SdkJLjU4H4YZcHI5k9jsgPvlPuOM99zl6tnfdC2Hpd26
	B7yaTonzDq8kZcgDw3nSBbFMLuP6V8A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791966944;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4+ZShSKKnj+mFUVmqcVFWILyz1RAsBq/MpO5bmLA0z0=;
	b=9WcVn9yN9gUVIhuZB5hgKPkOEBm70DaEeHcFPORmX4aCvXKdYjju6JJGl4y1VAvHXd1qAy
	BlMHJV65xa0+1iAA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791966944; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4+ZShSKKnj+mFUVmqcVFWILyz1RAsBq/MpO5bmLA0z0=;
	b=jnda8rWUW3aKFgJjvKayxs/qS2W308YuYmsluXDnk+3HP5Y+jyqsfqltn935lXoJoIGHij
	QEgkpWaBUEGWVEyXdfPz2botr2SdkJLjU4H4YZcHI5k9jsgPvlPuOM99zl6tnfdC2Hpd26
	B7yaTonzDq8kZcgDw3nSBbFMLuP6V8A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791966944;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4+ZShSKKnj+mFUVmqcVFWILyz1RAsBq/MpO5bmLA0z0=;
	b=9WcVn9yN9gUVIhuZB5hgKPkOEBm70DaEeHcFPORmX4aCvXKdYjju6JJGl4y1VAvHXd1qAy
	BlMHJV65xa0+1iAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A74D01368E;
	Wed, 14 Oct 2026 08:35:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Pq7SEN8+z2rrcAAAD6G6ig
	(envelope-from <tiwai@suse.de>); Wed, 14 Oct 2026 08:35:43 +0000
Date: Wed, 14 Oct 2026 10:35:42 +0200
Message-ID: <87y0c0el29.wl-tiwai@suse.de>
From: Takashi Iwai <tiwai@suse.de>
To: Joonho Lee <mynameisjune111@gmail.com>
Cc: Takashi Iwai <tiwai@suse.com>,
	Jaroslav Kysela <perex@perex.cz>,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] ALSA: pcm: refresh capture pointers before drain
In-Reply-To: <8733u8g0kh.wl-tiwai@suse.de>
References: <rfc-core-capture-drain-0.112c40f0e9284eaa@gmail.com>
	<rfc-core-capture-drain-2.112c40f0e9284eaa@gmail.com>
	<8733u8g0kh.wl-tiwai@suse.de>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/30.2 Mule/6.0
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Spamd-Result: default: False [-3.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -3.30
X-Spam-Level: 
X-Spam-Flag: NO

On Wed, 14 Oct 2026 10:15:26 +0200,
Takashi Iwai wrote:
> 
> On Wed, 14 Oct 2026 05:30:57 +0200,
> Joonho Lee wrote:
> > 
> > Refresh active capture pointers before the drain transition so the final
> > captured tail is accounted before reads finish.
> > 
> > Assisted-by: LLM
> > Signed-off-by: Joonho Lee <mynameisjune111@gmail.com>
> > ---
> >  sound/core/pcm_native.c | 32 +++++++++++++++++++++++++-------
> >  1 file changed, 25 insertions(+), 7 deletions(-)
> > 
> > diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
> > index defbb2977efe..622ae7be2d04 100644
> > --- a/sound/core/pcm_native.c
> > +++ b/sound/core/pcm_native.c
> > @@ -2176,14 +2176,32 @@ static int snd_pcm_drain(struct snd_pcm_substream *substream,
> >  	} else if (substream->f_flags & O_NONBLOCK)
> >  		nonblock = 1;
> >  
> > -	snd_pcm_stream_lock_irq(substream);
> > -	/* resume pause */
> > -	if (runtime->state == SNDRV_PCM_STATE_PAUSED)
> > -		snd_pcm_pause(substream, false);
> > +	/* Keep linked runtimes alive until the initial drain action completes. */
> > +	scoped_guard(rwsem_read, &snd_pcm_link_rwsem) {
> > +		snd_pcm_stream_lock_irq(substream);
> > +		/* Resume before refreshing capture positions. */
> > +		if (runtime->state == SNDRV_PCM_STATE_PAUSED)
> > +			snd_pcm_pause(substream, false);
> > +		snd_pcm_stream_unlock_irq(substream);
> > +
> > +		/* A pointer error may stop the group: hold only this member's lock. */
> > +		snd_pcm_group_for_each_entry(s, substream) {
> > +			if (s->stream != SNDRV_PCM_STREAM_CAPTURE)
> > +				continue;
> > +			scoped_guard(pcm_stream_lock_irq, s) {
> > +				if (s->runtime->state == SNDRV_PCM_STATE_RUNNING)
> > +					result = snd_pcm_update_hw_ptr(s);
> > +			}
> > +			if (result < 0)
> > +				break;
> > +		}
> >  
> > -	/* pre-start/stop - all running streams are changed to DRAINING state */
> > -	result = snd_pcm_action(&snd_pcm_action_drain_init, substream,
> > -				ACTION_ARG_IGNORE);
> > +		snd_pcm_stream_lock_irq(substream);
> > +		/* Change the stable group to DRAINING only after all refreshes. */
> > +		if (result >= 0)
> > +			result = snd_pcm_action(&snd_pcm_action_drain_init,
> > +						substream, ACTION_ARG_IGNORE);
> > +	}
> >  	if (result < 0)
> >  		goto unlock;
> >  	/* in non-blocking, we don't wait in ioctl but let caller poll */
> 
> IIUC, basically what here we do is to just call
> snd_pcm_update_hw_ptr() for capture at drain init phase, so calling it
> inside snd_pcm_do_drain_init() would make more sense, I suppose.
> 
> But, the problem is that snd_pcm_update_hw_ptr() itself takes an
> action to stop the stream for XRUN.  So we'd need to fiddle along with 
> it, too, as something like below.  (Maybe we need more brush-ups.)

On the second thought, it should be fine to call snd_pcm_stop() & co
from that context, too.  Maybe a small change like below suffices.


Takashi

-- 8< --
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -2119,8 +2119,11 @@ static int snd_pcm_do_drain_init(struct snd_pcm_substream *substream,
 		if (runtime->state == SNDRV_PCM_STATE_RUNNING) {
 			snd_pcm_state_t new_state;
 
-			new_state = snd_pcm_capture_avail(runtime) > 0 ?
-				SNDRV_PCM_STATE_DRAINING : SNDRV_PCM_STATE_SETUP;
+			if (snd_pcm_update_hw_ptr(substream) < 0)
+				new_state = SNDRV_PCM_STATE_SETUP;
+			else
+				new_state = snd_pcm_capture_avail(runtime) > 0 ?
+					SNDRV_PCM_STATE_DRAINING : SNDRV_PCM_STATE_SETUP;
 			snd_pcm_do_stop(substream, new_state);
 			snd_pcm_post_stop(substream, new_state);
 		}
