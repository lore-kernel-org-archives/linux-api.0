Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713897;
	b=W4RWqkiUyX+othqsR2G6UW2hVNg0SEmK824M9RMHgSYB7tFv8UcVd3GDJ9H/0tSfDg+W
	 hjYPWnC7uUXbLo4+nGsFmqBEJMdJHDXJx4OdmOLVCvYxfUhUjMxylJIE3ECgWNhmYS28R
	 rDQ4iH5Ii7pU+2K1Db5umsJWwlW0ff0SD4IaZfLMfKeU7x5Mn0+lZRGlp60g1b/Apu90x
	 dnym8R8xN2sJY7PmmwKMnaETftdoMndkwwffqKKw6jElD3lxJZQgchi+WPGZBY4SKFUJM
	 ObytZVg1fTrpck54hbAW3cdNwYzbM8mt5ediZKcP9GVeBu4s+afGQULc63rSVMJujKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713897;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=Ct/RUV8kORD6UjUvJHzH/aKVQFdtMkLRtAiPkEShlX4=;
	b=NmmwM2Lh20xnceYxGGpdj5btjQx5C0EoZfOx+FLi6zVj1nRekQJ+q4xSS7WhnVFSfkeO
	 r1XChimSdvEar8huCqiw8uceo5Q/tBufTsWCgpP3/RWlMNNxMB7vjPey/4BkrB1kPe6so
	 4XWvzzb5HMMORvGaXOr37XpY81N2cMNwd7OCOqO2HIXmQi8mEhG1ybV5Eq2kp0QIKPpxP
	 Hrnq0cspRRn0fcYljYqZj+LJYRA3yhYIJg/Tw/8Hp2NRcXUNC5vUr0cJSpCFvnklHPU2A
	 iM8Vh7Zm+KPEQUh929svUGwCMhmvvq9ZPZfw9DQsw02W5hxUUqVlmEvAtk+KTedjvxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=J66YNkar;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E59F606A33A;
	Tue,  3 Nov 2026 13:51:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9E59F606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=J66YNkar
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Ct/RUV8kORD6UjUvJHzH/aKVQFdtMkLRtAiPkEShlX4=; b=J66YNkarHwO1F4xbmOVEZOH8SS
	X4od5VxDK79Alv3KGs231qfYB6oR/ZEtvkWPFKclAoJWVUe0kEr4PBpWDT/YCOPIXererHKQheCLA
	ldFMLv2vKj4IFjeBGz+LIFe70apwEAeQ2HZU7FXfyEv8x8s7B4ZbR2sGf2DwG11mp2XGq6iWjYWoT
	vAvfCSJNV8e0wqk/IGBpO3m1zGyCSNUslz0XM/r82k2Wra7091PPW1CTPDDd40gcvvc/qepec7md6
	jRZek8GAvjJTtOwv4WBjLoVJZqM3/JxZCbLA/idVhROoFZkX0CYyHq5tb/8LOXzyvaS8JtoTf4AIU
	siVW9ZTA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xOEvB-00000000hHr-3HwY;
	Tue, 03 Nov 2026 10:51:30 -0300
Message-ID: <cd12d2426f7d4c1ef6157fccdc8543e6@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>
Cc: Stefan Metzmacher <metze@samba.org>, Christoph Hellwig <hch@lst.de>,
 linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Jan Kara <jack@suse.cz>, io-uring@vger.kernel.org,
 linux-api@vger.kernel.org
Subject: Re: [PATCH] fs: add RWF_DIRECT for preadv2/pwritev2/io_uring to set
 IOCB_DIRECT per io
In-Reply-To: <20261103080718.GA4109@lst.de>
References: <20261012184642.558349-1-metze@samba.org>
 <20261021-kontakt-hauen-albern-9053a385d79e@brauner>
 <20261103080718.GA4109@lst.de>
Date: Tue, 03 Nov 2026 10:51:30 -0300
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Christoph Hellwig <hch@lst.de> writes:

> On Wed, Oct 21, 2026 at 01:04:06PM +0200, Christian Brauner wrote:
>> On Mon, Oct 12, 2026 at 08:46:42PM +0200, Stefan Metzmacher wrote:
>> > It's useful to control this per io request instead of using O_DIRECT
>> > for the file descriptor.
>> 
>> @Christoph thoughts on this?
>
> Puh.  This goes right into a big discussion right now.  We've
> traditionally said mixing buffered and direct I/O is madness, and
> that's certainly not untrue.  On the other hand people find this
> useful - nfsd is now making heavy use of it, and a few year ago
> there was a paper on how the lustre backend really gained by doing
> that.  So while some folks like Dave Chinner still get really angry
> at the idea of mixing the modes, I feel the ship has sailed and we
> need to make it work as good as possible.  For some cases like
> mmap'ed I/O it will always introduce data corruption, but we'd at
> least make sure there's nothing exploitable.  And the direct user
> exposed flag would open lots of these exploit vectors.

Yeah.  We also have xfstests that do mmap of O_DIRECT file descriptors,
so mixing buffered and DIO to same file.

Those particular tests fail against Windows Server due to unaligned IO.
The CIFS client ends up using an handle opened for unbuffered IO in
writeback, so the server will reject any unaligned IO to it.

It works against Samba, however, which doesn't enforce any alignment.

This could be fixed by using the per-io SMB flags that metze mentioned,
but unfortunately the client still can't use it as some servers like
Azure don't support them and will fail the requests rather than ignoring
the unsupported flags.
