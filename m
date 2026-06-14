Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D093CC7D3
	for <linux-api@vger.kernel.org>; Sun, 14 Jun 2026 17:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781456524; cv=none; b=IoxJtgDeeQ6GCK/trqk72YafoEc73VlzD75O4V6G6w4j+ySh+aHi1DP3Swd/Y2lCIUbBgFcT125rjk5uE0tOrpFRi2iRVlO1tYllXMa6hDksdRxcHeMfN4gnjUDmRZfrEvCmB0pyHTK5OYM1FopH6LIVhIyiDbTJQWOyyD8FrZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781456524; c=relaxed/simple;
	bh=1yEBQT6Y1d5TFgDp2pHF4WJKK323HHaT+zv6KXIhRp4=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=IgJP9in97no/O9xBQabSt/Ep8CgunKYEQY3rDB+kiDDl8FMH7asfMp3mxuYFRkncqkmHswSR36YuxX67UcESJOxxMpPPnyRDS46WCv65PWNeCAR/boIR2HyW3EbE2GwBwmEn7Sw5fAAzVkAap5fmc1Von3sghigqAjRuEJ3cWo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl; spf=pass smtp.mailfrom=xs4all.nl; dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b=fROLYcuW; arc=none smtp.client-ip=195.121.94.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b="fROLYcuW"
X-KPN-MessageId: bebca678-6812-11f1-beab-005056992ed3
Received: from mta.kpnmail.nl (unknown [10.31.161.189])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id bebca678-6812-11f1-beab-005056992ed3;
	Sun, 14 Jun 2026 19:01:54 +0200 (CEST)
Received: from mtaoutbound.kpnmail.nl (unknown [10.128.135.190])
	by mta.kpnmail.nl (Halon) with ESMTP
	id bebb89fb-6812-11f1-b5d6-0050569981f5;
	Sun, 14 Jun 2026 19:01:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:subject:message-id:to:from:date;
	bh=TkvuSFDK6/nDk3+azP5M9r9PTBzu0LKFls0/exWqpX8=;
	b=fROLYcuW/MmOuW2sy783kYo7rm+feBEHs+C3qHQHL9S6++THWI9AwtJqG+4LaypYOb19IzTENIkw1
	 Qvq7sSrDaERJcdObqp/XSF35FhxZDDgUMXjqMJudxHql4Pe6+O8E9tKXEkSoNP4vbtn4PQYS2yLP3L
	 mQ5DLnwuS2cOddP0DReP7a8TL9NW1/VmdQCcyZOzjJdsbgwQ+t/T7PhjAH/ebIKGRXCELnOVRFufA2
	 MobpJQFTrAGoM0R8eTk52bHHXUppDIGHHP+JzM0/QiMTcdHaB+pwR/XlkGF8PJbFndrNPvSPsR+4fQ
	 X9FI1ygMq9w/GHfm/r9lrFAOBCGy6kQ==
X-KPN-MID: 33|NgSPb67nQT6AAHKax3tyOezWhYdnnR9+HXDPHlo7VIrxz1Sm/HwtTtT/cL+EokG
 AL8l+YnRW/fN13mJQV02D8g==
X-CMASSUN: 33|faQlvmG+UzN1DtQfvhBkF70ELGQAYzCoDJur/Rn0K9qKaZCenrq3rSzYRR86mUt
 F9xmPYOWD8j7psBDZ+DUY/g==
X-KPN-VerifiedSender: Yes
Received: from cpxoxapps-mh01 (cpxoxapps-mh01.personalcloud.so.kpn.org [10.128.135.207])
	by mtaoutbound.kpnmail.nl (Halon) with ESMTPSA
	id beb0993f-6812-11f1-b8d7-005056995d6c;
	Sun, 14 Jun 2026 19:01:54 +0200 (CEST)
Date: Sun, 14 Jun 2026 19:01:54 +0200 (CEST)
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Al Viro <viro@zeniv.linux.org.uk>, NeilBrown <neil@brown.name>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Message-ID: <192910058.1683376.1781456514310@kpc.webmail.kpnmail.nl>
In-Reply-To: <20260614164438.2980769-12-jkoolstra@xs4all.nl>
References: <20260614164438.2980769-1-jkoolstra@xs4all.nl>
 <20260614164438.2980769-12-jkoolstra@xs4all.nl>
Subject: Re: [PATCH 11/12] vfs: short-circuit MAY_WRITE access for
 O_DIRECTORY opens
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal


> Op 14-06-2026 18:44 CEST schreef Jori Koolstra <jkoolstra@xs4all.nl>:
> 
>  
> Requesting write access on a directory can never succeed. Rather
> than performing a path-walk to determine whether the target is
> actually a directory (-EISDIR) or not (-ENOTDIR), we short-circuit
> to -ENOTDIR.
> 
> Currently O_WRONLY for directories is only blocked in may_open(),
> which happens after we have the inode for the target, so after any
> create via O_CREAT|O_DIRECTORY.
> 
> The advantage of short-circuiting is that we don't have to add even
> more logic to lookup_open() to differentiate -EISDIR/-ENOTDIR. Also,
> for filesystems that define atomic_open(), handling this cannot even be
> done at the VFS level, as we can't know ahead of calling
> ->atomic_open() what the result of the lookup is.
> 
> Suggested-by: Christian Brauner (Amutable) <brauner@kernel.org>
> Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>
> ---
>  fs/open.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/open.c b/fs/open.c
> index 5cf8ada58483..be980a737c82 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -1268,9 +1268,16 @@ inline int build_open_flags(const struct open_how *how, struct open_flags *op)
>  
>  	op->intent = flags & O_PATH ? 0 : LOOKUP_OPEN;
>  
> +	/*
> +	 * Requesting write access on a directory can never succeed. Rather
> +	 * than performing a path-walk to determine whether the target is
> +	 * actually a directory (-EISDIR) or not (-ENOTDIR), we short-circuit
> +	 * to -ENOTDIR.
> +	 */
> +	if ((flags & O_DIRECTORY) && (acc_mode & MAY_WRITE))
> +		return -ENOTDIR;
> +
>  	if (flags & O_CREAT) {
> -		if ((flags & O_DIRECTORY) && (acc_mode & MAY_WRITE))
> -			return -EISDIR;
>  		op->intent |= LOOKUP_CREATE;
>  		if (flags & O_EXCL) {
>  			op->intent |= LOOKUP_EXCL;
> -- 
> 2.54.0

Forgot to cc this to linux-api@vger.kernel.org. Hereby cc'ed.
