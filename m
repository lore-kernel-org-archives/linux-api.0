Received: from mail-wr2-f30.google.com (mail-wr2-f30.google.com [74.125.225.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1A5469822
	for <linux-api@vger.kernel.org>; Mon, 21 Sep 2026 09:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.94
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789982353; cv=none; b=cxppLA2iZRq77X6eMAgAVr/uUHwzLysEGE4OXqJI4gi+dkRtlTcqtMtnmlVbZqNVHp1WqiUXi2Q1JBMaFvzrZHGnAGLdPtZCvsdQi+z5nhj/4D8mMPVhDr2nYT4XlhDcFkrx0qQ80SncNs2/hIBzxR7q9F36cRRNcTI6chkYC4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789982353; c=relaxed/simple;
	bh=487whN/ep3N2STbygC0sdA1IIhi1sdLZN0hb0tTo+do=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BwAXmet9cpuSCRdC24ludSWrqdBlBKin1KdqYKhxIfYPpNAn073USXGoXynsepX87GVKrkLpNj/g6YA5rT66O87IKUwhLXiDLxpiVqHx2hsgyStQe1SQtId+S4Zq/0qwDnySRX3pTqZQySjBJXv7UN2crszZu7p0W7P/KAr5dow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HFcDn9DR; arc=none smtp.client-ip=74.125.225.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HFcDn9DR"
Received: by mail-wr2-f30.google.com with SMTP id ffacd0b85a97d-48439feca17so2074402f8f.1
        for <linux-api@vger.kernel.org>; Mon, 21 Sep 2026 02:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789982349; x=1790587149; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MGiXLlnO4e+UrjavjSVvmX2UYt3SrnKyX7o77pnTk5E=;
        b=HFcDn9DRX52z4pi9uX2bxrNrX04T/pV/rTmqZb80qHkUPlkQHmWeYERRZt1mNUm0De
         WXHBsXDe3Nf3Xvd3sTHLc+V96YXPoctVie/4crz7J391f5jgz0LbjLB7/pStRO0RyrlH
         8YY9qK2IaYMk50J7GQnTo+3qwj3HqVqUwIhByBluE3DB42ojXeaNKe7jPmKxGqm5zAqi
         HUj1Yw9Hy1baRu9YGjFMg0Y3OCctpYiAa3Eoeqfc3qJQIdLWoum7CtzDDuKEMgaRDbSI
         uBf8ZXE46N6vk1AUhVTC+a3F0lJqc8aBeF3ueDnTpsUPkJtbXDoPBfB15UaEyxE1ztv1
         CS1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789982349; x=1790587149;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MGiXLlnO4e+UrjavjSVvmX2UYt3SrnKyX7o77pnTk5E=;
        b=maRG6Q9JKJL5wZC9KhGjBstEn3nd7P2nOf778Sqc/l+yFIqkBLauXSO9prb2x3Ma/u
         XU6S+r+mo9zyJRL6URkkat+aFRt7qEWjjXQZ4eiRZelRNnJhlPGy+8hR3J0x+6VRAR5g
         O6DOC6aIWT/VrqPh0yYpbPsY/ePMU84bG7CxRsn2uJ7RRaM/LOwm9n/xmJaai/8qS+/0
         5gN+C7u5FHTdfivFibfRKQa+x0+nOorAWNYTX4+4bO8FDLN1PN5Q23son08jUj/j1NOI
         BVxtRPtyvDFMPyNIOy1ptZbiVoVl1qHN8c45U0W5VGae7DuUEg+3zr5cw6vpDDggoAKu
         QviQ==
X-Forwarded-Encrypted: i=1; AKwUvBwge04sXaK0j6jc4l9jO0Nrj7guIBpDRkc5ytrD/7Gl5hL2vmLJnpXNOARjqoSemXlsv/oxdMp/nkU=@vger.kernel.org
X-Gm-Message-State: AFuF++ldoO7pXI14nZ9YpppDHhl+xtmoIyKVbls1LwRMQ+6FqbQFmsBn
	2Xov18HpZI0kDdyKBZ8pnCE4uwS8Y8XFYpY3K+JSUM5x5ho2PFJKLikT
X-Gm-Gg: AYBFou2hgqxgTVT0DSAX2tI/63ibLHBEDcZXmnEF2DHilzHVx/Syzo/sspLtKZhRnj9
	JfvrcskcFIBKLVxeDuDxDszgpDy+Lc3SgYWtQjYg7v+cl+OKtZCf7uo/rlGYTkcGP10hg1/dl1H
	EvEjFSjxSRFEUBO6XI+LL6MPKg/IgvG9kZM42kqHQzj7QbIr+7K2kSoRnKqWCeMG7dqR3FxSEb/
	xfRxhlM4W6rqbssadxkOy5OTluJTebYLAvjgWkc6i+jD4TVNvCdd2y98dfAjih092Jka0b/8yBl
	Dp6KgaZ2rRXifSMNOML42//NaruqvqEg7ONOMOvMmAgFvJtf+NTKfwbuavNyqV7W4Dblh5U68kN
	wKqTwzlOUqDaGj7fW02qLFRU9TOdCSXlnAFPDYrMU4jaTq/IqbwGPyGfF2GAedq8PxIWyfehzt6
	QfIE5dmEwJX0CPx/yQz7I3ntvV/Ke8mMZZPXyPpYuftuoGRM6Nud6bmcMT5ewc61NAMBjZP3Alt
	jHuRtTNRMAkk6Okqns1STJx8XKf2Oa98irh
X-Received: by 2002:a05:6000:24c2:b0:487:d79:7cf7 with SMTP id ffacd0b85a97d-4871e377accmr13347203f8f.52.1789982349132;
        Mon, 21 Sep 2026 02:19:09 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4872459d409sm20519075f8f.33.2026.09.21.02.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 02:19:08 -0700 (PDT)
Date: Mon, 21 Sep 2026 10:19:07 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Mikko Rantalainen <mikko.rantalainen@peda.net>, Matthew Wilcox
 <willy@infradead.org>, linux-fsdevel@vger.kernel.org,
 linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
 brauner@kernel.org, viro@zeniv.linux.org.uk, alx@kernel.org,
 dalias@libc.org
Subject: Re: [RFC PATCH 0/1] close(): stop exposing non-retryable EINTR
Message-ID: <20260921101907.162d3533@pumpkin>
In-Reply-To: <wb5ulikmcromcpolaf7icazadijmadrspctqe3ffgnm3bffdwe@t4oz5ond537b>
References: <20260913193815.2862366-1-mikko.rantalainen@peda.net>
	<aqcmz5uI7PgN5CT7@casper.infradead.org>
	<bcdb8f85-d53a-4824-8e34-8d190ec7f4b2@peda.net>
	<cf83be66-e540-4abf-b377-7e344d62a1dd@peda.net>
	<wb5ulikmcromcpolaf7icazadijmadrspctqe3ffgnm3bffdwe@t4oz5ond537b>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 21 Sep 2026 10:49:23 +0200
Jan Kara <jack@suse.cz> wrote:

> Hi!
> 
> On Mon 14-09-26 15:40:01, Mikko Rantalainen wrote:
> > Mikko Rantalainen (2026-09-14 12:07 Europe/Helsinki):  
> > > ---
> > > retval = filp_flush(file, current->files);
> > > 
> > > WARN_ONCE(retval == -EINTR ||
> > >           retval == -ERESTARTSYS ||
> > >           retval == -ERESTARTNOINTR ||
> > >           retval == -ERESTARTNOHAND ||
> > >           retval == -ERESTART_RESTARTBLOCK,
> > >           "close: ->flush %ps returned interrupt error %d\n",
> > >           file->f_op->flush, retval);
> > > ---
> > > 
> > > That would leave the existing userspace ABI unchanged while making
> > > remaining offending implementations easier to find and fix.
> > > 
> > > I also considered retrying filp_flush() inside close(), but I don't
> > > think that can be done generically. ->flush() is not documented as
> > > safe to restart from the beginning after partial execution, and
> > > an interruptible wait could immediately encounter the same
> > > still-pending signal again. So fixing the interruptibility at the
> > > offending wait seems safer if the above invariant is indeed
> > > the intended one.  
> > 
> > Another thing I noticed is that there are already several paths where
> > the kernel calls filp_close() and intentionally ignores its return value.
> > 
> > For example, close_files() does:
> > 
> >     filp_close(file, files);
> > 
> > without checking the result. The same is true for do_close_on_exec(),
> > and close_range() explicitly says:
> > 
> >     Currently, errors to close a given file descriptor are ignored.
> > 
> > So I don't think a ->flush() implementation can rely on returning EINTR
> > and having somebody retry the interrupted operation. There are valid
> > close paths where nobody will ever see that return value, even when the
> > process itself continues running.
> > 
> > This seems to strengthen Matthew's point: if some work performed by  
> > ->flush() is required for correctness, that work has to tolerate these  
> > close paths without depending on userspace retry. Returning an
> > interruption result cannot be the recovery mechanism.
> > 
> > I'm therefore leaning towards treating an observable -EINTR/-ERESTART*
> > from ->flush() as suspicious in general, rather than just special-casing
> > the close(2) syscall. The fatal-signal case is harmless because the task
> > will not observe the result, but close-on-exec and close_range() show
> > that unobserved filp_close() errors are already part of normal operation
> > as well.
> > 
> > That also makes me think documenting the intended ->flush() contract
> > would be useful: if required close-time work must not depend on the
> > caller retrying filp_close(), that seems like an important invariant for
> > implementations to know.
> > 
> > What guarantees must file_operations::flush provide when its caller may
> > have no way to act on its return value?
> > 
> > In any case, I'm now thinking that returning EINTR for close() is a bug
> > when file descriptor is already freed. I think the only question is how
> > it should be solved. I initially thought it should just be mapped to
> > success. Maybe it should be logged as subsystem bug *and* mapped to
> > success for userspace instead?  
> 
> I agree that nobody can sanely assume returning EINTR from open(2) helps
> anything (or that userspace is able to do anything based on that).

What about opens of serial ports waiting for modem signals or opens
of tape drives waiting for rewind, finding tape marks etc?

> Generally any error (perhaps outside EBADF) from close(2) is at best
> informative telling you that something is unhealthy but userspace cannot
> sensibly do anything about it.

The program can exit with error to indicate that the output file is
likely to be invalid.
Although the last thing anybody wants is a pile of AI generated patches
saying that a program forgot to check the return from close().

David

> OTOH this "something is unhealthy" message
> does carry some value for possible debugging of the issues by sysadmin so
> I'm not sure just ignoring the errors is the right way to go.
> 
> This raises a question: Are you actually seeing some case where you can see
> EINTR returned? Because IMO the best fix is to just fix the .flush method
> that can return EINTR to do that only in case of fatal signal and then you
> don't have to be doing this special-casing in VFS.
> 
> 								Honza
> 

