Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0005C1A6835;
	Tue, 29 Sep 2026 04:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790656847; cv=none; b=NqpC0w3V2qoEww/od1BQwqyOngS71R2Gl/jkJPh7LImZ3fi2zbv6dINIJAnU3YrWBEK/gEZG8dCjDNoapCIQUwzd3uVlS25GZZ06CdtULoVfWcNoLH5Z4DHH0sWaV34S6ao9sWK6FZUdIGs/HF2W36nNu4yUIVP9JTorkl+521A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790656847; c=relaxed/simple;
	bh=YYgI3SsGaMEC8Lf7VARNcjhVM3wPMngSwwxoVP4GhP4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fIwz4CgObCqzgReclcwyS7c279z4Q+6DG1tvDbrDAzLpufN2vXb9olkV7g2pri8KA7MGlkesbXMQrVbrOA7xE1fN3cmBlkCsgMfA/gL9mU8lQBJftpxBTbmzmcN7Hp9fh7FNwS+qjTmX9+4Yoq/pCPOcvndiGgpYFMyFHu7gshw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PE1EMYv9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PE1EMYv9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A34B1F000FF;
	Tue, 29 Sep 2026 04:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790656845;
	bh=38wvNs26i9YJ6nAQDXTmZlLvIOwAshpW/4FHBSWaFO8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PE1EMYv9mh1X76JqdzsjsjTwY85UTQ8F4PlJoSj2OYBWwxqTVGqDRFYVGKbCqlsFI
	 lvpzr2C2KWBGbauL7FJ59gT4CttRL/YfU2kfMqtxhXDlZWSA6NIqiupfeeFEKCsAOo
	 JoHPiFBVHGWB8jGYKR+7Ws1MM/9UblLjnUdyoU1M=
Date: Tue, 29 Sep 2026 06:40:40 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: omer zalman <omerzalman42@gmail.com>
Cc: akpm@linux-foundation.org, arnd@arndb.de, quic_johmoo@quicinc.com,
	linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] check-uapi: reject zero and malformed job counts
Message-ID: <2026092917-paycheck-issue-0738@gregkh>
References: <CAGLNFZes3CXA568n+5_rgoneDh7w-2=MS34ON7n1tq3ezeZzsw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGLNFZes3CXA568n+5_rgoneDh7w-2=MS34ON7n1tq3ezeZzsw@mail.gmail.com>

On Mon, Sep 28, 2026 at 07:44:32PM -0400, omer zalman wrote:
> With -j 0, the per-header loop waits on an empty PID before any
> worker starts. It counts that wait error as an ABI failure even when
> the header passes. Reject non-positive or malformed job counts as
> prerequisite errors before starting the check.
> 
> Signed-off-by: Omer Zalman <omerzalman42@gmail.com>
> 
> The exact git-format-patch file is attached because Gmail's web
> composer removes tabs from inline diffs.

Please do not use gmail web interface for patches, the email
documentation in the kernel should explain how to do this properly.

thanks,

greg k-h
