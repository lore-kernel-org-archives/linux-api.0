Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1845530CD81;
	Fri, 16 Oct 2026 08:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792138853; cv=none; b=IKbosIFQvAIGoOlKK5EQswWiA4oOrPd5e/IMh0DpLTw9IHBIEyLbRM0X2ZM4+0Olvqg8JY72m8AhMv2kA4OiFV8t3e+klkAC/+cF8qUoztnepKAH0I+V5A3yMrfQPwh4K/ZpKqB9Zpm7MxQINHMnteZBfibe3ljjE+w2sSypGKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792138853; c=relaxed/simple;
	bh=BOOkYLgUaPu0axgwVqPPQh923YwcL1wTo6GS7Rp7sGA=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lnryXxmjLix90sZA9SzRSK2IyB9SOONHt3+8E/89Bp/0HORdUq1iCsip4zThCVpDk9qIq+/Iu79gb1URxOmj3ioXsZ1s7jq3oTt95FJFE1l1lja+lcMvTapMh01c+0J/X3y2LJp66VA95fsMk6tkSC+sAWq0GMvYG6fTQt7giE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1Y0vH9yD; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=gdubjBOU; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1Y0vH9yD; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=gdubjBOU; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1Y0vH9yD";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="gdubjBOU";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1Y0vH9yD";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="gdubjBOU"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 022741F43B;
	Fri, 16 Oct 2026 08:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792138850; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3HDGHxYDCOJkufrEMSIyp3sPGUcQk5bS4SZm0hZm9ac=;
	b=1Y0vH9yDBziQxlw9EIOF1hm215hZ/1OJTXV7vuZzw8IKdXU+tESZo4vuXN2P48OBT42d+w
	DhCD4rbtX0Zxaz22EAam7Dev+cJpKqUJQf1Tg7OsNZc57v3iKi0MhEgNVXmGuLdbC6guNh
	/UrYADTURV7p+DX9M7c7AjMEpjHAQMU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792138850;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3HDGHxYDCOJkufrEMSIyp3sPGUcQk5bS4SZm0hZm9ac=;
	b=gdubjBOUA1cqHhws1qZuQUVL8YDtXhFeBSpeQTqUs4oW8EBMu1LMQHOLDSPHnWOQ/xw0U6
	yUvYm/dIAxeN48Dw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792138850; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3HDGHxYDCOJkufrEMSIyp3sPGUcQk5bS4SZm0hZm9ac=;
	b=1Y0vH9yDBziQxlw9EIOF1hm215hZ/1OJTXV7vuZzw8IKdXU+tESZo4vuXN2P48OBT42d+w
	DhCD4rbtX0Zxaz22EAam7Dev+cJpKqUJQf1Tg7OsNZc57v3iKi0MhEgNVXmGuLdbC6guNh
	/UrYADTURV7p+DX9M7c7AjMEpjHAQMU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792138850;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3HDGHxYDCOJkufrEMSIyp3sPGUcQk5bS4SZm0hZm9ac=;
	b=gdubjBOUA1cqHhws1qZuQUVL8YDtXhFeBSpeQTqUs4oW8EBMu1LMQHOLDSPHnWOQ/xw0U6
	yUvYm/dIAxeN48Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A754E1339F;
	Fri, 16 Oct 2026 08:20:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2GRaH2He0Wo4UwAAD6G6ig
	(envelope-from <tiwai@suse.de>); Fri, 16 Oct 2026 08:20:49 +0000
Date: Fri, 16 Oct 2026 10:20:49 +0200
Message-ID: <87o6cu5a5a.wl-tiwai@suse.de>
From: Takashi Iwai <tiwai@suse.de>
To: Joonho Lee <mynameisjune111@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>,
	Takashi Iwai <tiwai@suse.com>,
	Jaroslav Kysela <perex@perex.cz>,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org
Subject: Re: [PATCH v5 0/2] ALSA: pcm: preserve capture tail during drain
In-Reply-To: <v5-core-capture-drain-0.e9b40d3bc08c4162@gmail.com>
References: <v5-core-capture-drain-0.e9b40d3bc08c4162@gmail.com>
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

On Fri, 16 Oct 2026 01:48:03 +0200,
Joonho Lee wrote:
> 
> Capture drain can leave final frames buffered after the device stops.
> This series lets userspace read those frames and refreshes the linked
> streams' hardware pointers before drain-init.
> 
> Patch 1 allows capture reads in DRAINING, preserves the unread count when
> waking a blocked reader, and finishes capture with snd_pcm_drain_done()
> so linked playback can continue draining. DELAY and SYNC_PTR(HWSYNC) use
> the cached final capture pointer after capture stops.
> 
> Patch 2 refreshes each running member under its stream lock while holding
> snd_pcm_link_rwsem for reading. It updates both playback and capture,
> after the existing pause-resume step. The pause and drain-init actions
> remain outside the link rwsem. Pointer errors follow the normal XRUN
> path and return -EPIPE before drain-init.
> 
> Changes since RFC v4:
> - Submit as a non-RFC series following Takashi's response.
> - No changes to either patch body, including the commit message, diff,
>   and existing trailers. This cover and the mail headers are updated.
> 
> Takashi said both patches look OK and that he can try merging a non-RFC
> series:
> https://lore.kernel.org/all/87ld7z6jsk.wl-tiwai@suse.de/
> Previous RFC v4:
> https://lore.kernel.org/all/rfc-v4-core-capture-drain-0.b56779f7976d4657@gmail.com/
> Implementation and test discussion:
> https://lore.kernel.org/all/core-drain-helper-reply.0c1099dbd0ca4a37@gmail.com/
> 
> The five-patch virtio-snd lifetime v3 series is unchanged:
> https://lore.kernel.org/all/cover.1791881787.git.mynameisjune111@gmail.com/
> The base and prerequisite IDs below preserve the tested integration:
> apply the five lifetime patches, then these two core patches. Replace
> both earlier core patches when testing this revision. Core has no
> dependency on the generic control-wait or VZ compatibility RFC. This
> submission does not revise either companion series.
> 
> The following validation is from RFC v4's unchanged source; no new
> runtime tests were run for this mail-only revision.
> 
> Validation used ARM64 QEMU with KASAN and lockdep:
> - 26 linked-stream checks passed across atomic and nonatomic modes,
>   including paused drain, first/later member pointer errors, normal XRUN
>   handling, tail reads, and unlink/prepare/reopen recovery.
> - The three patch-1 failures were reproduced with the helper and the old
>   first patch in both locking modes. All six corresponding fixed cases
>   passed: a blocked reader received all 64 final frames, capture EOF
>   left linked playback in DRAINING, and both position queries succeeded
>   without another pointer callback.
> - Four additional blocked-reader runs compared baseline and fixed modules
>   in both modes with a stronger gate: thread sleep and a pointer callback
>   after START. They confirmed the baseline loss and fixed 64-frame read.
> - The 10 existing lifecycle and timeout/reset scenarios passed, including
>   held STOP/RELEASE, SIGKILL, reset, and subsequent I/O recovery.
> - No KASAN, lockdep, or panic diagnostics appeared in the 54 selected
>   logs, which include the baseline behavioral-failure comparisons.
> 
> The full Image and modules were first built with the new helper and the
> old first patch. After fixing the three tail issues, sound/core was
> rebuilt with W=1 against that same configuration and symbol versions,
> and the corrected PCM module was used for the runs above. The module
> build had no warnings or errors. The full build had 517 existing
> -Woverride-init warnings in arch/arm64 outside sound/. The exported v5
> core source matches the tested source byte for byte.
> 
> These tests use synthetic drivers and modified fault/reset backends.
> 
> LLM assistance was used for implementation, reproducer development,
> analysis, and documentation. I reviewed the changes and test evidence.
> Assisted-by: LLM
> 
> Joonho Lee (2):
>   ALSA: pcm: allow capture reads while draining
>   ALSA: pcm: refresh linked pointers before draining

Applied both to for-next branch now.  Thanks.


Takashi
