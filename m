Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5232D5592E6;
	Wed, 14 Oct 2026 15:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791991995; cv=none; b=dBHbGcVIctV2ZBOJpQVFqtA/LV42HD+ILZk5jv+3Q6ZzDscz/jwM5tB571S4mjMhVOELueqImWj6xGksZS3YV0pL9o32DS71TqyBYsZzKlCaFcdAxFNA5VE9dze4IUotGwIYAqHSq4oNFQhWqA+nYWrfiZiNA/Uvv1kyZ2A46uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791991995; c=relaxed/simple;
	bh=kYaPOCIL9ADmcpsPRjVGOOiHuV4wp+rfb/QDDMdU8/g=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VSERQe9VrDHO+IN8XUzqa3pPKGj66awQglNbvegyoo/1DWS8d/qwWMaX74L4A8qm9kjJBPmbAi4TjLzPxxQJixJUI1pxnNaXRer8b+uSxpVewq+0NrJI93CFHs8+M/36N9iCAUfM/UbwokEKeigEsv704oucXUe0fiXvI/yGZe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VxG78seI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+Rm9xkbd; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VxG78seI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+Rm9xkbd; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VxG78seI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+Rm9xkbd";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VxG78seI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+Rm9xkbd"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 212CA1F38E;
	Wed, 14 Oct 2026 15:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791991992; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nO/000/GJTg0U+Ozr0pF5LvrmdtR2TYrURkpJ2lA/2Y=;
	b=VxG78seIMXfzUwSyZIL2isWwCTCQUg+i7q/Z4KMLsuoPwV2K8ir0zf8pW8sw3JsVyp0Sot
	EzknGoAjoDtPawLM8QSltgsMhCLbgA+VnZJvuv9fTBQGc3xZp0t3WFziKy1lAbGZgErVPI
	rkRzX+rSCVePYkyeU8sMx3q6vY1+jyw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791991992;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nO/000/GJTg0U+Ozr0pF5LvrmdtR2TYrURkpJ2lA/2Y=;
	b=+Rm9xkbdc4tgzNwLbQuBzFOPgHFyY+W0b3IB+KEZJ6FkbKCI9R3P2vm0NwOW05X4EdPudh
	UeSEcWPrW9Nzt9Cg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791991992; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nO/000/GJTg0U+Ozr0pF5LvrmdtR2TYrURkpJ2lA/2Y=;
	b=VxG78seIMXfzUwSyZIL2isWwCTCQUg+i7q/Z4KMLsuoPwV2K8ir0zf8pW8sw3JsVyp0Sot
	EzknGoAjoDtPawLM8QSltgsMhCLbgA+VnZJvuv9fTBQGc3xZp0t3WFziKy1lAbGZgErVPI
	rkRzX+rSCVePYkyeU8sMx3q6vY1+jyw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791991992;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nO/000/GJTg0U+Ozr0pF5LvrmdtR2TYrURkpJ2lA/2Y=;
	b=+Rm9xkbdc4tgzNwLbQuBzFOPgHFyY+W0b3IB+KEZJ6FkbKCI9R3P2vm0NwOW05X4EdPudh
	UeSEcWPrW9Nzt9Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C0A0C133F1;
	Wed, 14 Oct 2026 15:33:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VNTjJbegz2otSwAAD6G6ig
	(envelope-from <tiwai@suse.de>); Wed, 14 Oct 2026 15:33:11 +0000
Date: Wed, 14 Oct 2026 17:33:11 +0200
Message-ID: <87jynkcn60.wl-tiwai@suse.de>
From: Takashi Iwai <tiwai@suse.de>
To: Joonho Lee <mynameisjune111@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>,
	Takashi Iwai <tiwai@suse.com>,
	Jaroslav Kysela <perex@perex.cz>,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] ALSA: pcm: refresh capture pointers before drain
In-Reply-To: <core-drain-linked-lock-reply.cf2e307fcac34b6a@gmail.com>
References: <rfc-core-capture-drain-0.112c40f0e9284eaa@gmail.com>
	<rfc-core-capture-drain-2.112c40f0e9284eaa@gmail.com>
	<8733u8g0kh.wl-tiwai@suse.de>
	<87y0c0el29.wl-tiwai@suse.de>
	<core-drain-linked-lock-reply.cf2e307fcac34b6a@gmail.com>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/30.2 Mule/6.0
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: -3.30
X-Spam-Level: 
X-Spamd-Result: default: False [-3.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_SEVEN(0.00)[7];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]

On Wed, 14 Oct 2026 17:20:55 +0200,
Joonho Lee wrote:
> 
> Hi Takashi,
> 
> Thanks for the suggestion and thoughts. I tried the smaller change and hit a
> recursive locking issue with linked capture streams.
> 
> I used a test driver with two linked capture substreams and made the
> later member's pointer callback return SNDRV_PCM_POS_XRUN during
> drain. This led to the function calls as follows! :
> 
>   snd_pcm_do_drain_init()
>     snd_pcm_update_hw_ptr()
>       snd_pcm_update_hw_ptr0()
>         __snd_pcm_xrun()
>           snd_pcm_stop()
>             snd_pcm_action()
>               snd_pcm_stream_group_ref()
> 
> The outer drain action already holds the group locks here. Lockdep
> reported the recursive acquisition of group->lock for atomic streams and
> group->mutex for nonatomic streams. Both tests remained stuck until
> the 45-second timeout. Removing the link let both tests complete.

OK, so my previous assumption was wrong, obviously...

> I went back to the notify=false approach from your first sketch, which is keeping the pointer update inside snd_pcm_do_drain_init(). I also
> added the guard to the early SNDRV_PCM_POS_XRUN branch, since that
> path still called __snd_pcm_xrun(). Drain init then handles the stop,
> while ordinary pointer updates keep their existing behavior.
> 
> With this change, all 24 linked test cases passed across both locking
> modes, including pointer errors, tail reads and reopen/recovery.
> KASAN and lockdep stayed quiet. This was tested with a synthetic
> driver under ARM64 QEMU; physical-device testing is still pending.
> 
> One thing I wanted to check before sending a revision is, how should
> drain report a pointer error?
> 
> The current change puts the failing member in SETUP and allows a
> healthy linked member to keep its tail in DRAINING. A blocking
> capture-only drain returns 0 if the rest of the action succeeds,
> and reading the failed member afterwards returns -EBADFD.
> 
> Would you prefer that behavior, or should we remember the error,
> finish stopping all members, and return -EPIPE from drain? My v2 proposal
> returned -EPIPE and moved the linked group to XRUN, so this changes
> what userspace sees.

Honestly speaking, I'm no longer sure whether my suggestion is better
for now.  It's certainly clearer if we can call the update_hwptr stuff
inside drain_init call, but this looks like a hard way, and the
conditional call at each PCM operation sounds fragile, too.

Maybe we can go back to your way as v2, but slightly differently.
Namely, factor out the snd_pcm_link_rwsem and update hwptr loop into a
helper function, and just call it in snd_pcm_drain().  The already
existing calls of snd_pcm_pause() and snd_pcm_action() with
snd_pcm_action_drain_init can be kept as-is; they need no protection
of snd_pcm_link_rwsem.

Also, I think it's fine to call snd_pcm_update_hw_ptr() no matter
whether it's playback or capture stream.


thanks,

Takashi
