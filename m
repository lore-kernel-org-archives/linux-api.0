Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDCB26ED3A;
	Mon,  9 Feb 2026 01:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770601640; cv=none; b=es8eXsm7F3wRb22QxijSwIzBxeI00d0xdNz20sKAuLcmkwNeGWcfRgxdIvMuJNqwUJRyiWEtaYUZmpmPE2m9KT/DEL1kEClZs8rn7WJHR/QmoTOamVRi2L4qmaBydxYKBEFp1J2QYCJeR9GeJ6/o4c26fZGoP8b6fbIP0cHljEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770601640; c=relaxed/simple;
	bh=11/Ll8LxeonAwm4mi4NKsuphF4lvEJ5SpvDFEQiwnNs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gvn04EZvDnL2Yx+GabdQzaDzFaAXo34pOoaaAM0MOiqwSBgtcQ4bt7Gc0eKtihkcDdiC9U/D1ovE5pAEulDilGOuhPfEKsnySIXv+yF8WVgPmekwg6x6NqejgNixMHcH9vzFhzOmFGpRo05QojlDD00im59rJN1I+MSD95BAAcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hTu4Yfpd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hTu4Yfpd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=X32YuifI+ATurFDA/X2SrjwmpjF2cxZywEZJiyoV0qY=; b=hTu4Yfpdx3o1ojbCQZiUIszf44
	YBcek9TCSIYHTmPifZYoSKavNx/oZSEdjaEGnxmlxZtQ6vUNZYDKCfGX1mwAFHWHVuvMkfIsTOWA0
	1CFKS9wD7UqzczDZ5+1DCFxUAfNDWemStfE+E42UoJoRSzVrpcxV6wJcqZizFqebMFd4/wX0dcisE
	wgx7+pr8xjVkc2pB/aJWmOl8WP/No2zK8XQJcGZYUGDMmLj84iJv16X4wiByuFP+IxNkY2NR15DOv
	CkcyP+XuJm6QMHKraXs6MUq1vn5V5AK/Q6DWsWli/YONqsJptad24UavwoJTil5qJwcRE2t/vHeCY
	9FmYmDsQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vpGMw-0000000EfLB-1EOZ;
	Mon, 09 Feb 2026 01:47:19 +0000
Message-ID: <36b18816-6c65-4fac-97ba-c50518026ad1@infradead.org>
Date: Sun, 8 Feb 2026 17:47:17 -0800
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arch: m68k: remove incomplete, unusable Apollo hardware
 support
To: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Cc: linux-api@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
 linux-m68k@lists.linux-m68k.org
References: <20260209013041.37536-1-enelsonmoore@gmail.com>
 <017a28fe-6c0e-48ec-8b1b-10e0d3b0a04e@infradead.org>
 <CADkSEUhoj2Hfix3SsW4LJqYxrN294CT449MLVtjpE9t2okAk+A@mail.gmail.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <CADkSEUhoj2Hfix3SsW4LJqYxrN294CT449MLVtjpE9t2okAk+A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2/8/26 5:45 PM, Ethan Nelson-Moore wrote:
> Hi, Randy,
> 
> On Sun, Feb 8, 2026 at 5:40 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>> There is an M68K maintainer who should be Cc-ed on this patch.
>> (now done)
> 
> I already did this in my first email - this email does not have anyone
> CC'd because it is just sent to linux-api because I forgot to do so
> initially.
> The original email with linux-m68k and maintainers included is here:
> https://lore.kernel.org/all/20260209005212.32370-1-enelsonmoore@gmail.com/

Got it. Thanks.

-- 
~Randy

