Received: from mail-lr2-f12.google.com (mail-lr2-f12.google.com [74.125.230.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA074EFFA3
	for <linux-api@vger.kernel.org>; Thu, 17 Sep 2026 17:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664632; cv=pass; b=lkhoLCcIwbNyinTCsRrBGV52imgwanX6Qljwf+3TkbYARUHwbAp0WMv58aw9ae4IfpGeq9PJfXZy1nuL3HdCDx7LjgISU/c8fe/lbEbh5+cROFiBVU6y6WrCuezDnowQgfMRF29iqpfDdw3FrGItumIEMNeVKh8q9hpBFj5IvRc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664632; c=relaxed/simple;
	bh=dWqrfywKjEtr5wtVAxc0WKSejhs/grxWyCMDV7MugWk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Xu37rGIoyeZfkZKV1yvCKeNAh6MwusNtGNx+ozkba2qvEq+/x/KfjupdzDKVMharMjSSJ2oK+EQRK+C28roju6+F/P5itr2PyrIcfpDSKHBTWkBtXU1ttOCL9iQg5TmR+v9r+haWnBPvtitve1RR063zPAVNMtBU1q/7mSv2pe0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b=AEQcnPwo; arc=pass smtp.client-ip=74.125.230.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b="AEQcnPwo"
Received: by mail-lr2-f12.google.com with SMTP id 38308e7fff4ca-3a2ff15fadfso4458071fa.0
        for <linux-api@vger.kernel.org>; Thu, 17 Sep 2026 10:03:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789664628; cv=none;
        d=google.com; s=arc-20260327;
        b=o4vSRamqOyPQIGl8mC4iPctMaDojm6bnbD8nfl7hLAS60yiVQtX6lFC1jCw8VVo5yb
         w40wnsoi7KC0sgEoyRgvhinsYEhwAPSN7LaVD4ixrTXUvHqKRa91gwBfxCgkOlgUdwpp
         qb2IbGk9S7yMPISXPcNNa09ZSzyMq1tUWTKD7DvrrJFkvFNg/S2IE+gcwilmVIMTfBZN
         WFt+Z2hvQr3daq4WAZWr8NXzVgG4EgBeiy77MaKidVZlbb9kvz7HPoBpqQ41eS0cuG+P
         +o5CrHSpbZC/Jp4e3WE5UH5DBSyWgFjpaEaAv8dOpNuGcTxVEtebfjxji9y5QQYs6vb9
         YI+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HzeMyhC6Hs8/MFNRkyNR3mA2RoNAqfMyU39GFmQO9Xo=;
        fh=MteIUbO7TjjS3h6GZHBBxOAccyYusJXfYnDRw/cmd3c=;
        b=hbnr4D0ISzipSlt4tSh6oGfZrCIQaEF1AbSWel1M23g2cqONsqBameF1Zv4VaK5rv3
         UiiwmthZbEpWs4ny1dLrVmb4X9lvvOp6fwdIpLVwu5cRtCF3A7O+2HL7cpmny+O2aitp
         g2g19sG3pqTYBgBAWLJd+DvIVjRFRSkkjdB/2GbHQbgP6mGpVDxchIRd2P8AUglfb64l
         T7V6makueiUaP+A3Kw9xQ9iS6hudTTOoINShHwV/dophe8gJNXmiTkpekruWOCdGKZuj
         S4v14CRGxleuPh9IpVQDt+trOQV/stqB3tQxkXxn/hkUYCfS/TrmmTXnKgqyPahhq6ZN
         waeg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1789664628; x=1790269428; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HzeMyhC6Hs8/MFNRkyNR3mA2RoNAqfMyU39GFmQO9Xo=;
        b=AEQcnPwoyXxDxi2G8HTMRz15+ecoMBo5bPl7J5kGmkKH9WfbT/LeHTAUBaptEqfNZI
         3Ms/Veu1OHZhbSQLHqnPoVtcLq7cmGp8H24HP7/zwWbI+1ZglS5gfgkEAg0R8cWEb+wz
         L2SWReCxRPh4U0Umk5XPEIBJDpCfDnEIBf+FymifgNEI5tD2/wWNHHIzM5ThWBZZOiTA
         Ve68G0CmbyHZxDBhMEl5UA09CBE4QCSyLbo6aQnQzR0WWnVzY5LREuNFAHXiwXFkLJwl
         +kT1uEinEXc+M+g95MQyLXJ1RQDHLJ/Adl4ej1K5Z01vB03TxXBnkdbJGF+LJJ/ltAoW
         wnJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789664628; x=1790269428;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HzeMyhC6Hs8/MFNRkyNR3mA2RoNAqfMyU39GFmQO9Xo=;
        b=qYH2EmCEsjNFwRYhvdpd1NuAWIAsqKXOsvCk3YRcxrobui0ciGsv9yOMR4QToTkX3y
         W9b88Jw4wCzCkJChTuMR/Q7xivY0hmqYeOdnjcljXx9VH2F7nPdggiBbxpY300LKc3rU
         1zVlIUbi9+xOANDO7T/eQZLi3tzHS23QeuJAq3vHw3zFeUUrtgGh0xGgxC/bSyIH4xuJ
         hFbUV2xQbhY6AAdyeVAo+6qvUkQiQxhwZdw1z0kn45ojlmSMJp585AcMmQl6eej+Ffnl
         MWRvLJ2BJUJABn2LZFnftWjnZBmJ7lfCmXd3+bJV57fHKPW7lcO7RU7YERLJZIF9QNb0
         JfIg==
X-Forwarded-Encrypted: i=1; AKwUvBwE2P+6YlDxhh+L8Oz9yfkYll8f8nGHJwc8MWG97vEpfumEmRe/rCcFxpToGTgc4IGFSeHLK4MQ3F4=@vger.kernel.org
X-Gm-Message-State: AFuF++mA9eWz4Gx342E6ifyBvQI3pSa1x2+Jm8sqnVKDD18KlPhl9GXL
	az5ivYckVPqOoAdrGhW8VmzJfh/9DlKDB/WaNi+mL//il4x/rtVcRVPwEENHB619zDmcJ7TaFOC
	1781zHE7R3OsdWNol5I7dYTD641gDpA088pUO722X
X-Gm-Gg: AYBFou0Z3RJ28VbMBCabtC1gdWGRbmSKm1tGv52xfrq7CJWoDMNZ1CwvbjdBwrZWVar
	/ylpkqZFTmRfZ6MPQcBK3E2OsMQ3Z08X9I/mrAA0rTRBbtiw6vCdfoqbgQvCz120GV9eM8zsbEp
	pqEtUdgZlQw7yheggyUEoOgrFZEfsOwief9mu9tR8oVy1jMeqZYUPKCbwEUtDpO1aTkF1QdIJv+
	b5N6McQ1zGD3EJdXpitXuKYJ9dR42gQ8o4rBtjJYIYStP8MA8hwWrXuU0VMaabyQ1W4fusUVl6N
	WBLV3QlOut6C/ViwQOL4knfbcv/bm4U9fYPnvn+ffYiYAQ46EzQfzn1gDfzodI25
X-Received: by 2002:a05:6512:2205:b0:5b6:10bc:b86b with SMTP id
 2adb3069b0e04-5b8ba70ed39mr1313029e87.25.1789664628461; Thu, 17 Sep 2026
 10:03:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260913193815.2862366-1-mikko.rantalainen@peda.net>
 <aqcmz5uI7PgN5CT7@casper.infradead.org> <20260913235145.GY25906@brightrain.aerifal.cx>
 <eeb50cae-87af-4a40-b9c6-f4fa9981425e@peda.net> <CALCETrUgLj4Dz0s6PMofViJwausRWCvNvJphxWHUeWCCaRBtQg@mail.gmail.com>
 <f61886ed-3026-4db7-ae22-b882264141bd@peda.net>
In-Reply-To: <f61886ed-3026-4db7-ae22-b882264141bd@peda.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 17 Sep 2026 10:03:36 -0700
X-Gm-Features: AcwNN1Weixzr00PWb42k0GJpV9JCtwN__AI5EcYFAoTJRpSFfr7ruhHRECy9F1k
Message-ID: <CALCETrVnE2unnjHokG=bGLEXAeC0U8QRx_wb8fQDh-Fe5O6PBg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/1] close(): stop exposing non-retryable EINTR
To: Mikko Rantalainen <mikko.rantalainen@peda.net>
Cc: Rich Felker <dalias@libc.org>, Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, brauner@kernel.org, 
	viro@zeniv.linux.org.uk, jack@suse.cz, alx@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 17, 2026 at 3:37=E2=80=AFAM Mikko Rantalainen
<mikko.rantalainen@peda.net> wrote:
>
> On 9/17/26 02:16, Andy Lutomirski wrote:
> > On Mon, Sep 14, 2026 at 2:44=E2=80=AFAM Mikko Rantalainen
> > <mikko.rantalainen@peda.net> wrote:
> >
> >> NFS and devices make the question more interesting, though. Some
> >> implementations put meaningful state transitions into their close path=
.
> >> Tape devices are an obvious historical example: depending on the
> >> device/mode, close may write filemarks, flush tape buffers, rewind, et=
c.
> >> Those operations are not necessarily replaceable by fsync() before
> >> close().
> >
> > I realize this would be complex and maybe a can of worms, but maybe we
> > should have a new improved syscall here.  close() is indeed deeply
> > problematic.
> >
> > On the one hand, we have the actual task of closing an fd in the sense
> > of removing it from the table.  This should really be doable without
> > blocking or without side effects (except possibly for zapping
> > old-style POSIX locks -- it doesn't really make sense to be able to
> > close all fds to a file while still keeping it locked, especially
> > since we report the pid of the lock-holding process).
> >
> > On the other hand, close has actual *meaningful* effects, many of
> > which you've mentioned in your email.  IMO it would be really nice to
> > be able to explicitly *do* those effects separately from closing the
> > fd, maybe even asynchronously via io_uring.
> >
> > Would it be so bad to have a new operation to do (possibly with
> > moderately fine control) the close work and another one to just
> > release fd- and process-associated locks and drop the fd?
>
> I think introducing yet another syscall would be bad replacement
> for the *inability to decide the exact semantics* we want to use for
> the current syscalls, especially close().
>
> It's pretty clear that close() is poorly defined right now. The only
> thing that we know for sure is that it releases the file descriptor
> and in case of Linux, this happens for sure unless EBADF is returned.

I think I mostly agree with your analysis except that I really don't
like the ENOSPC.  The kernel actually has the ability to commit to
having space for pending writes on an fd *without syncing*, then I
think that capability should be expose to userspace.  fsync is a
pretty poor alternative for code that just wants to make sure that, in
the absence of a bug, crash or physical failure, the data won't be
lost.
