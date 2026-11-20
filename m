Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795192959;
	b=c9SI6FFUDU+vni1wlP7ppH2HnUzvcI+T7ThHteYpWSegYYufJqn5HG09LQV9ANP0trGw
	 ZH50FrOjZSGX1jwGIM1Rw+e8W8QjoSj31gEtNnYCJEZdSiVju4n0oMYRm7qm6G8DkbLQ2
	 ItBwZyH+5sLN8JXLwItOvbp2sNFdzm8wpR1kuoEnBfEVbqW+JHOnwjGeDE07E6ZwgDogE
	 CrNvwNabfzyt3OWd0wpXoWsoZdj48If4bqV0gA9SZgNAkh3Zbwwbr+VO5btDotT+LcfMq
	 9G2xWQ93kzVbbcnDBT8jppu6AwNYNvN+krZ8zjYAe23MJsy4g4USxRNH1jxLQaNF43Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795192959;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=oDmsI8Uk/q0hHSy3TwsQxw/VhMs+oyRmLBAasaqWnok=;
	b=cc5QBBXw3nl5L/ELH9lNEUKmT4e9yQ9YcBhJnfvdhdZ1dVN5c+7QIE8X8egVS8ZLweYx
	 s5QSDb3TvZo1cdwhJNHaWyKH0i8/FkN/Mdd84n4KWktZIKb90i+MzXXfuHiVRHVHcsU37
	 YhwmBwKExeWOKqyRh+owdOObyvvqAuOBrBK9jL/MBDvEAEr+36PZvvxLUi1btUFEjsfdQ
	 t1KQAyNO2PuZRbteninH1b9lmmOz5CwvJJQetTkvV3ksVo/Cosg1Xuu2HeRFMBEeBd2b4
	 xJpZK4gdxLfQCei+ABAj0kL+ESvISUznfYfca48faHe8XxH+/x4e0ja3mtpYhfruWVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31342606A604;
	Fri, 20 Nov 2026 16:42:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 31342606A604
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 060F16732A; Fri, 20 Nov 2026 17:42:35 +0100 (CET)
Date: Fri, 20 Nov 2026 17:42:34 +0100
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: Stefan Metzmacher <metze@samba.org>, Christoph Hellwig <hch@lst.de>,
	linux-fsdevel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	io-uring@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH] fs: add RWF_DIRECT for preadv2/pwritev2/io_uring to
 set IOCB_DIRECT per io
Message-ID: <20261120164234.GA32683@lst.de>
References: <20261012184642.558349-1-metze@samba.org> <20261021-kontakt-hauen-albern-9053a385d79e@brauner> <20261103080718.GA4109@lst.de> <03f82274-2749-4529-bf98-ede7cc79ad08@samba.org> <20261118-leihwagen-bauaufsicht-tritt-5fc43d456a16@brauner>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261118-leihwagen-bauaufsicht-tritt-5fc43d456a16@brauner>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Nov 18, 2026 at 03:53:56PM +0100, Christian Brauner wrote:
> On Tue, Nov 03, 2026 at 02:06:25PM +0100, Stefan Metzmacher wrote:
> > So what about making it opt-in as a start, like RWF_DONTCACHE with
> > FOP_DONTCACHE? A new FOP_DIRECT_PER_IO would be set by file systems
> > that base their I/O decisions on IOCB_DIRECT, all others return
> > -EOPNOTSUPP for RWF_DIRECT.
> 
> Sounds kinda ok to me. So xfs, ext4 and btrfs would set it, I guess.
> Everything else returns -EOPNOTSUPP they're converted. That's the same
> thing we did for RWF_DONTCACHE.
> 
> Christoph, how do you feel about that?

Not a fan, at least not without tightening up the coherency first.
