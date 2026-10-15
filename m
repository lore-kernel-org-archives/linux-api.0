Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83233EDE4A;
	Thu, 15 Oct 2026 15:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792079709; cv=none; b=lRMQdF7Nj/LTjzt8R7FnzQEIs94G1hB56nFMI3hSouo5u5+Ef81si0MSeVL62hARKhlwGHPJrF+OiE6D++qgriJb7CzDT/6fiaXPUTMzbzHAFFbQtqcTVpFuTV1Q/v1iwRTNpuYEcVMsxf1irfU1eMbL7RJJ2nHuwKgZk5gE/rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792079709; c=relaxed/simple;
	bh=Mm9HzRKkk4tW4bCOUykqIKx1brIaNF3LG0gwTprIRwg=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JO2zfea8JZSPilRiSZLwBZh6CB+4Og8cop8zpTmNjDhgsJdgCS9rbO/p8vApbXKuoCLCl+Ag5JNoVpJ6WnGhrZSjDyCJ9bB1/FHzOAJ7o39vYU61bEJUUKfes+BenuWHj7sYRzhmznQH4CeEnH+HqYlem4EKtzPg95bcFlMFPss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ewotnY1m; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Uv5YXZfD; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ewotnY1m; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Uv5YXZfD; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ewotnY1m";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Uv5YXZfD";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ewotnY1m";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Uv5YXZfD"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9EBC621E0E;
	Thu, 15 Oct 2026 15:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792079692; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5tCCVRhXkN+55GQ3Vfya2stH/YrirP9KhGruijeWctM=;
	b=ewotnY1mU8zx7Z0gq0t2a8JhqjHduXj3w2OHg37JySnuvGESu871nf0GoKF8lVl6aTP30W
	ZcquN2qaLrkCsn5AGm3U/iWjiz8BCns9VucCGL1cmx/0+aonh2ohMTpX7IFtLlFHn0Cqss
	pwB9k48SeaKyRjiWrj+3osZFryJtFFw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792079692;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5tCCVRhXkN+55GQ3Vfya2stH/YrirP9KhGruijeWctM=;
	b=Uv5YXZfDrKp+1scruZxbgbymg86Pe/aHf49gpTMDKD9juL5Z6ekAF51M7iRpFAKZnpEHWv
	eiKI/G6CvsKL27Bg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792079692; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5tCCVRhXkN+55GQ3Vfya2stH/YrirP9KhGruijeWctM=;
	b=ewotnY1mU8zx7Z0gq0t2a8JhqjHduXj3w2OHg37JySnuvGESu871nf0GoKF8lVl6aTP30W
	ZcquN2qaLrkCsn5AGm3U/iWjiz8BCns9VucCGL1cmx/0+aonh2ohMTpX7IFtLlFHn0Cqss
	pwB9k48SeaKyRjiWrj+3osZFryJtFFw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792079692;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5tCCVRhXkN+55GQ3Vfya2stH/YrirP9KhGruijeWctM=;
	b=Uv5YXZfDrKp+1scruZxbgbymg86Pe/aHf49gpTMDKD9juL5Z6ekAF51M7iRpFAKZnpEHWv
	eiKI/G6CvsKL27Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 44E4013223;
	Thu, 15 Oct 2026 15:54:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sqjXA0z30GoXawAAD6G6ig
	(envelope-from <tiwai@suse.de>); Thu, 15 Oct 2026 15:54:52 +0000
Date: Thu, 15 Oct 2026 17:54:51 +0200
Message-ID: <87ld7z6jsk.wl-tiwai@suse.de>
From: Takashi Iwai <tiwai@suse.de>
To: Joonho Lee <mynameisjune111@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>,
	Takashi Iwai <tiwai@suse.com>,
	Jaroslav Kysela <perex@perex.cz>,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org
Subject: Re: [RFC PATCH v4 0/2] ALSA: pcm: preserve capture tail during drain
In-Reply-To: <rfc-v4-core-capture-drain-0.b56779f7976d4657@gmail.com>
References: <rfc-v4-core-capture-drain-0.b56779f7976d4657@gmail.com>
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

On Thu, 15 Oct 2026 02:35:59 +0200,
Joonho Lee wrote:
> 
> This v4 replaces both patches in the core capture-drain v3 series. It
> follows Takashi Iwai's suggestion to refresh linked pointers in a helper
> before drain-init and fixes three tail-handling problems in patch 1.
> 
> Patch 1 allows buffered capture reads in DRAINING. When drain wakes a
> reader waiting for data, wait_for_avail() returns the remaining frame
> count. Capture EOF uses snd_pcm_drain_done(), so a linked playback stream
> can continue draining. DELAY and SYNC_PTR(HWSYNC) use the cached final
> capture pointer without calling the driver again after capture stops.
> Sashiko's review identified these three problems in the earlier patch.
> 
> Patch 2 takes snd_pcm_link_rwsem for reading and updates each running
> member under its own stream lock. It calls snd_pcm_update_hw_ptr() for
> both playback and capture. The helper runs after the existing pause-resume
> step, allowing a paused capture stream to receive its final update.
> The pause and drain-init actions remain outside the link rwsem.
> 
> A pointer error follows the ordinary XRUN path and returns -EPIPE before
> drain-init. This restores v2's group-wide error handling. V3 instead put
> the failing member in SETUP and could return success from blocking drain
> while another member retained its tail. V4 removes v3's notify argument
> and the conditional notifications in the pointer update code.
> 
> Previous core v3:
> https://lore.kernel.org/all/rfc-v3-core-capture-drain-0.cf2e307fcac34b6a@gmail.com/
> Takashi's latest suggestion:
> https://lore.kernel.org/all/87jynkcn60.wl-tiwai@suse.de/
> My implementation and test report:
> https://lore.kernel.org/all/core-drain-helper-reply.0c1099dbd0ca4a37@gmail.com/
> 
> The separate five-patch virtio-snd lifetime v3 series is unchanged:
> https://lore.kernel.org/all/cover.1791881787.git.mynameisjune111@gmail.com/
> Apply those five patches to the public base below, then these two patches.
> Remove both old core patches before applying v4. Core has no dependency
> on the generic control-wait or VZ compatibility RFC. The lifetime stack
> is pinned here to reproduce the tested integration. Neither companion
> RFC is revised by this series. A future VZ revision will need the new
> core prerequisite IDs.
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
> -Woverride-init warnings in arch/arm64 outside sound/. The exported v4
> core source matches the tested source byte for byte.
> 
> These tests use synthetic drivers and modified fault/reset backends.
> Physical-device and Virtualization.framework microphone testing of this
> core revision is still pending. Concurrent LINK, wraparound, and
> forward/rewind behavior have not been exercised by this test set.
> The updated reproducer and logs are local; the earlier public package
> contains an older core revision. There is no new reproducer upload for
> this candidate.
> 
> One design question remains: the helper releases the link rwsem before
> drain-init, and snd_pcm_link() permits another RUNNING stream to join in
> that interval. That member could enter drain-init without a refresh by
> the helper. Should this change protect the membership across both steps,
> or should concurrent linking be handled separately? I have reviewed this
> interval in the source but have not reproduced it with a stress test.
> 
> Do the restored group-wide XRUN/-EPIPE behavior and cached capture hwsync
> semantics look appropriate? Which physical-driver coverage would you
> want before this can move beyond RFC?
> 
> LLM assistance was used for implementation, reproducer development,
> analysis, and documentation. I reviewed the changes and test evidence.
> Assisted-by: LLM
> 
> Joonho Lee (2):
>   ALSA: pcm: allow capture reads while draining
>   ALSA: pcm: refresh linked pointers before draining

Both patches look OK.  Once when you submit a non-RFC patch set, I can
try merging.


thanks,

Takashi
