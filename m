Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B7835F161;
	Thu, 24 Sep 2026 17:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790269276; cv=none; b=QB0990op6VmrBPeFiaFh3dGbXK4KzjEFqq2rWtIU/te23do6/tr5Gp13uCtVPpEdmckcB3WkxpD0TNiA3XHfqNi6+/VFHeBYGBuLFLLl4EuNf9xcuN0GszTvT6XDSV9ZpSVPgk44Oc5Bohwy9LG0aADPCRD9UoercAdWN0Jsbxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790269276; c=relaxed/simple;
	bh=ooJhgB38QPlK088fZ0OJWYlg3DEOC7xMjtX4/OovQ24=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YGHrzo9KhmpTVRXcfEUt02XIRS+5m82TaAj1pkWdd5NB7+q7CLl2lbMLofmOlN86lqtGpaRSxtJCcnnX9O8Q8RsRYOpPSzVBuC9jRYZEWjcmo2suNKTa+UG1Rw3QWJgOY7MEIXwY8ZWuaLV52AbniNGwQ9gH6/+TjhXQ4IPBPsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Dq8y8fpb; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Emnmt40d; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=q/HhEC8J; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=97b27Qav; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Dq8y8fpb";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Emnmt40d";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="q/HhEC8J";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="97b27Qav"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6E0EB219EA;
	Thu, 24 Sep 2026 17:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790269268; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3HW0Sn2F1kXuJYxmIs4JnguZGO0MfEN0+vn7YSbBw8s=;
	b=Dq8y8fpbrooPvDe+fz9TJxkWRhRjlf5pRPLGJS4WKxYhIlVJ2dN8/KcMt6R7JeGgFauhRP
	XyS4YbDpvklOMpG8rj5jK+KUot27PnjG2DwZwklen4/97cYvijFmDIPvJOtZuK8F3g96OS
	2ob2VevWbewhkc/IXnXX6RAF53xdkME=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790269268;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3HW0Sn2F1kXuJYxmIs4JnguZGO0MfEN0+vn7YSbBw8s=;
	b=Emnmt40dakyB2rhiu0JFR11bM/ncOnmEX/zGlxH3rqzHjo73rNnz+LMU2Keu5lf+EFaQHc
	DoAA6b+rf/1IP6Ag==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790269264; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3HW0Sn2F1kXuJYxmIs4JnguZGO0MfEN0+vn7YSbBw8s=;
	b=q/HhEC8JNCIA11MYR3fn+365t8+fngPtf7Vgg749bUgVS/jO8xeBBzrLULpV8ZLW4a5em6
	V6pISMWV5FiX2LDpMEueZy0pYpJ463G3oUeTfN4H/uterZw3T4AumwLJdqcfwhqefbyHfp
	G11sXyUE4amK+3PtXO6MtgGri1hZEps=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790269264;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3HW0Sn2F1kXuJYxmIs4JnguZGO0MfEN0+vn7YSbBw8s=;
	b=97b27Qav8QQMnK27QqURwKgt/G6MCwhXkGNTFMMbf0VtcUhP6k+M+TVV659NKMtB/Bb5MR
	oFpbveN0+0NqVrDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 42C7D13354;
	Thu, 24 Sep 2026 17:01:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6+AvCFBXtWrXSAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 24 Sep 2026 17:01:04 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C8B32A132E; Thu, 24 Sep 2026 19:00:59 +0200 (CEST)
Date: Thu, 24 Sep 2026 19:00:59 +0200
From: Jan Kara <jack@suse.cz>
To: David Laight <david.laight.linux@gmail.com>
Cc: Jan Kara <jack@suse.cz>, 
	Mikko Rantalainen <mikko.rantalainen@peda.net>, Matthew Wilcox <willy@infradead.org>, 
	linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, 
	brauner@kernel.org, viro@zeniv.linux.org.uk, alx@kernel.org, dalias@libc.org
Subject: Re: [RFC PATCH 0/1] close(): stop exposing non-retryable EINTR
Message-ID: <e7r623alr6ksfm76hpitkybqkkb2wx2v6jzq2buebhyq7pzxhe@fxqy6ljywt4x>
References: <20260913193815.2862366-1-mikko.rantalainen@peda.net>
 <aqcmz5uI7PgN5CT7@casper.infradead.org>
 <bcdb8f85-d53a-4824-8e34-8d190ec7f4b2@peda.net>
 <cf83be66-e540-4abf-b377-7e344d62a1dd@peda.net>
 <wb5ulikmcromcpolaf7icazadijmadrspctqe3ffgnm3bffdwe@t4oz5ond537b>
 <20260921101907.162d3533@pumpkin>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921101907.162d3533@pumpkin>
X-Spam-Score: -2.30
X-Spam-Level: 
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Flag: NO

On Mon 21-09-26 10:19:07, David Laight wrote:
> On Mon, 21 Sep 2026 10:49:23 +0200
> Jan Kara <jack@suse.cz> wrote:
> 
> > Hi!
> > 
> > On Mon 14-09-26 15:40:01, Mikko Rantalainen wrote:
> > > Mikko Rantalainen (2026-09-14 12:07 Europe/Helsinki):  
> > > > ---
> > > > retval = filp_flush(file, current->files);
> > > > 
> > > > WARN_ONCE(retval == -EINTR ||
> > > >           retval == -ERESTARTSYS ||
> > > >           retval == -ERESTARTNOINTR ||
> > > >           retval == -ERESTARTNOHAND ||
> > > >           retval == -ERESTART_RESTARTBLOCK,
> > > >           "close: ->flush %ps returned interrupt error %d\n",
> > > >           file->f_op->flush, retval);
> > > > ---
> > > > 
> > > > That would leave the existing userspace ABI unchanged while making
> > > > remaining offending implementations easier to find and fix.
> > > > 
> > > > I also considered retrying filp_flush() inside close(), but I don't
> > > > think that can be done generically. ->flush() is not documented as
> > > > safe to restart from the beginning after partial execution, and
> > > > an interruptible wait could immediately encounter the same
> > > > still-pending signal again. So fixing the interruptibility at the
> > > > offending wait seems safer if the above invariant is indeed
> > > > the intended one.  
> > > 
> > > Another thing I noticed is that there are already several paths where
> > > the kernel calls filp_close() and intentionally ignores its return value.
> > > 
> > > For example, close_files() does:
> > > 
> > >     filp_close(file, files);
> > > 
> > > without checking the result. The same is true for do_close_on_exec(),
> > > and close_range() explicitly says:
> > > 
> > >     Currently, errors to close a given file descriptor are ignored.
> > > 
> > > So I don't think a ->flush() implementation can rely on returning EINTR
> > > and having somebody retry the interrupted operation. There are valid
> > > close paths where nobody will ever see that return value, even when the
> > > process itself continues running.
> > > 
> > > This seems to strengthen Matthew's point: if some work performed by  
> > > ->flush() is required for correctness, that work has to tolerate these  
> > > close paths without depending on userspace retry. Returning an
> > > interruption result cannot be the recovery mechanism.
> > > 
> > > I'm therefore leaning towards treating an observable -EINTR/-ERESTART*
> > > from ->flush() as suspicious in general, rather than just special-casing
> > > the close(2) syscall. The fatal-signal case is harmless because the task
> > > will not observe the result, but close-on-exec and close_range() show
> > > that unobserved filp_close() errors are already part of normal operation
> > > as well.
> > > 
> > > That also makes me think documenting the intended ->flush() contract
> > > would be useful: if required close-time work must not depend on the
> > > caller retrying filp_close(), that seems like an important invariant for
> > > implementations to know.
> > > 
> > > What guarantees must file_operations::flush provide when its caller may
> > > have no way to act on its return value?
> > > 
> > > In any case, I'm now thinking that returning EINTR for close() is a bug
> > > when file descriptor is already freed. I think the only question is how
> > > it should be solved. I initially thought it should just be mapped to
> > > success. Maybe it should be logged as subsystem bug *and* mapped to
> > > success for userspace instead?  
> > 
> > I agree that nobody can sanely assume returning EINTR from open(2) helps
> > anything (or that userspace is able to do anything based on that).
> 
> What about opens of serial ports waiting for modem signals or opens
> of tape drives waiting for rewind, finding tape marks etc?

Err. Not sure how I wrote open(2) there. It should have been close(2)...

> > Generally any error (perhaps outside EBADF) from close(2) is at best
> > informative telling you that something is unhealthy but userspace cannot
> > sensibly do anything about it.
> 
> The program can exit with error to indicate that the output file is
> likely to be invalid.

Yes. That was covered by my paragraph below about "something is unhealthy"
message.

								Honza

> > OTOH this "something is unhealthy" message
> > does carry some value for possible debugging of the issues by sysadmin so
> > I'm not sure just ignoring the errors is the right way to go.
> > 
> > This raises a question: Are you actually seeing some case where you can see
> > EINTR returned? Because IMO the best fix is to just fix the .flush method
> > that can return EINTR to do that only in case of fatal signal and then you
> > don't have to be doing this special-casing in VFS.
> > 
> > 								Honza
> > 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
