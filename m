Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120AD5304D6;
	Thu, 15 Oct 2026 15:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792079637; cv=none; b=snrQwPJWy82fTHxgJmUgTPum6Tl4VmycmDZquv5nF4ZAhZOb+wDfHBfnDrkmnY1/njjUl138NCbRKW3VNsvEIEgtNY26dT7Ll3Q7bwFAq37KifQNJQ3G3Z5RGkoZ6nfcVUwp6jMEGxRMeKnrWR21N7ipB3fWXWd8CLT9zlhgJDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792079637; c=relaxed/simple;
	bh=szSOKTZI6sPBIesZEFAIAV8wA9jmkwFvA+0UNSqxtPM=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G7tHYyFallRFQA4UmxtJ81B04um3JWG0H9Y34QbmqDXmxu2LHc92l1Pmr4zoSDipk3uzOV3is1rYl7zwN2HcxvN2cooafT3tkGC76BmOjloGuB5R+a0F3OEQs4mET1sa/DVxKV+sxkvXfh6pLAZXTJ9+kq5d3xnA0BUcbOpsLHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kLaIm0l0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Ur9re3NL; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kLaIm0l0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Ur9re3NL; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kLaIm0l0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Ur9re3NL";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kLaIm0l0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Ur9re3NL"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E858321C4D;
	Thu, 15 Oct 2026 15:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792079622; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e1A3uNezMjXsi2mMTrHEb5G0ghAb2qLCa/VAfDFRMpM=;
	b=kLaIm0l0/KjCx9M+uVIFBnJazqoQEI13+g/qQ2vSgFu1AHpv0L6l8Xc2YFzBsmwsgaj8us
	RmLa+MWsM5wp8eXVHOTnHvIQlbMra2xF98C44B31U757sU2cbS+H4y0Eu2QMQucSVM/JnE
	fkrbYNMWIqcGsRHLWYRbEfUZAtwdG4c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792079622;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e1A3uNezMjXsi2mMTrHEb5G0ghAb2qLCa/VAfDFRMpM=;
	b=Ur9re3NLhrKwqgpcIOut1rLlJIVsTPAKwBCTxq1l9WXyAgWQ8vmltBLIxE6jb/zMv6tCPf
	7GkisXT/m087gMDQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792079622; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e1A3uNezMjXsi2mMTrHEb5G0ghAb2qLCa/VAfDFRMpM=;
	b=kLaIm0l0/KjCx9M+uVIFBnJazqoQEI13+g/qQ2vSgFu1AHpv0L6l8Xc2YFzBsmwsgaj8us
	RmLa+MWsM5wp8eXVHOTnHvIQlbMra2xF98C44B31U757sU2cbS+H4y0Eu2QMQucSVM/JnE
	fkrbYNMWIqcGsRHLWYRbEfUZAtwdG4c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792079622;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e1A3uNezMjXsi2mMTrHEb5G0ghAb2qLCa/VAfDFRMpM=;
	b=Ur9re3NLhrKwqgpcIOut1rLlJIVsTPAKwBCTxq1l9WXyAgWQ8vmltBLIxE6jb/zMv6tCPf
	7GkisXT/m087gMDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 93CD813223;
	Thu, 15 Oct 2026 15:53:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id E52GGgb30GrQaQAAD6G6ig
	(envelope-from <tiwai@suse.de>); Thu, 15 Oct 2026 15:53:42 +0000
Date: Thu, 15 Oct 2026 17:53:42 +0200
Message-ID: <87mrsf6juh.wl-tiwai@suse.de>
From: Takashi Iwai <tiwai@suse.de>
To: Joonho Lee <mynameisjune111@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>,
	Takashi Iwai <tiwai@suse.com>,
	Jaroslav Kysela <perex@perex.cz>,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] ALSA: pcm: refresh capture pointers before drain
In-Reply-To: <core-drain-helper-reply.0c1099dbd0ca4a37@gmail.com>
References: <rfc-core-capture-drain-0.112c40f0e9284eaa@gmail.com>
	<rfc-core-capture-drain-2.112c40f0e9284eaa@gmail.com>
	<8733u8g0kh.wl-tiwai@suse.de>
	<87y0c0el29.wl-tiwai@suse.de>
	<core-drain-linked-lock-reply.cf2e307fcac34b6a@gmail.com>
	<87jynkcn60.wl-tiwai@suse.de>
	<core-drain-helper-reply.0c1099dbd0ca4a37@gmail.com>
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
X-Spam-Score: -3.30
X-Spam-Level: 
X-Spam-Flag: NO

On Thu, 15 Oct 2026 01:52:03 +0200,
Joonho Lee wrote:
> 
> Hi Takashi,
> 
> Thanks, I've reworked the local version along those lines.
> 
> The helper takes snd_pcm_link_rwsem for reading and updates each running
> member under its own stream lock. It uses snd_pcm_update_hw_ptr() for both
> playback and capture. I call it after the existing pause-resume step so a
> paused capture stream gets its final pointer update too. The pause and
> drain-init actions remain outside the link rwsem.
> 
> A pointer error now follows the usual XRUN path and returns -EPIPE before
> drain-init. This restores the group-wide error handling from v2 and removes
> the "notify" boolean argument introduced in v3 proposal.
> 
> While checking this version, I also confirmed three problems in the first
> patch: 
> 1) a reader already waiting for data could lose the capture tail
> 2) finishing a capture read could stop a linked playback stream
> 3) DELAYand SYNC_PTR(HWSYNC) rejected capture DRAINING. The local fixes preserve
> the unread count when waking the reader, finish capture with
> snd_pcm_drain_done(), and use the cached pointer for capture hwsync.
> 
> I reproduced all three failures with the helper plus the old first patch,
> then checked the fixes in both atomic and nonatomic modes. The blocked
> reader now receives all 64 final frames, capture EOF leaves linked playback
> in DRAINING, and both position queries succeed without another pointer
> callback. The 26 linked-stream checks, including paused drain and pointer
> errors, and the 10 existing lifecycle/reset cases also passed under ARM64
> QEMU with KASAN and lockdep, but physical real-world device testing is still pending in this time.
> 
> There is one concurrency point I'd like to check. The helper releases the
> link rwsem before drain-init, and snd_pcm_link() allows another RUNNING
> stream to join in that interval. The new member could enter drain-init
> without being visited by the refresh loop.
> My question is, should we handle concurrent linking across these two steps, or leave that outside this change's scope?

I guess we can leave this for now.  The invalid state like OPEN or
SUSPENDED is checked at snd_pcm_pre_drain_init().


thanks,

Takashi
