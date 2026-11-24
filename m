Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.3
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795544435;
	b=ICChWgRM26X8ozbhn2soMrpp6LEF/eETFlC+EakHmeC8ATauzYIXZZIR2iJCwNMUNBiR
	 Kqyp2JxNI6bdmjvnAnswHTVaDMz3eBN3DDOF964h+iJwSB+jwttYqm4Cl8iWR9JTUs7pa
	 OCrDPwRzsbwA+6mHM+l1kEyb0ksraW2+b1Ru2oGSGej7LrnutmdiosRpOneaQt3rlEezf
	 djnJ7fy9xte0PmN/de08ovyRT4svtSRZjOx1QZ6r4TpIhy57r09jVvctYTEjUzn/b2h1l
	 HUtk0lvbyC4GEtohmOm7TddmzfegoHRg6PbPirveW4WCouCp2ULbFwKYr+685w029Nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795544435;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=rn2JMXIObYI9wUt1ea1lSjudrwErALnnzN0nbwRNkfY=;
	b=hCtGBSh8uUtuq/RZ1l/JV536RAOAYCbeTzeHI833+54S6XycX8/3yrKbDfU/OU4x5cYI
	 LgjcPJSPVF5NVQViiw0tFtFhRUQh0TMQwpGVlHTjW8J43Z9kr/j5FKqVbf3eh5f4Bx3pO
	 taewL22OJ09As5Z3y42BwF+MlxQF8ekBl/Pb4Mxp1XljrhQrF5S8dXm0on7TSbdGFWOVY
	 ItCy3hqFFv6wn+se1J14PTlYPZBL4jG6lWRY8XS6W7TwXFIjYEx6dxCEqDC11/FdCJvDz
	 idDVcgo+lz/mEVlT452Bd9SkYwomU54ulEgwSgvYdMq3TldYtE8piBP6sBxPRlpOX0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=A349BdiF;
	arc=none smtp.remote-ip=117.135.210.3
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE6A606A687;
	Tue, 24 Nov 2026 18:20:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6FE6A606A687
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=A349BdiF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=rn
	2JMXIObYI9wUt1ea1lSjudrwErALnnzN0nbwRNkfY=; b=A349BdiFhOFLw5eB4o
	2gs6Xa+Z4epe2azGQRjXucIG6mi0DH9tr1ZwgnqIsQ1nlUDvaYtv1J4vCZCshXSS
	HHzNZn8d8anK6dTGhqBjGdcLWSuKKdDFWp6It2/jnNJTPQyKJT0N4ccY25ZkbmOb
	0Orcs6kAvM3MLC7DG+OtseQ1U=
Received: from ubuntu (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgAH7o8k1QVrJbHLHw--.27478S2;
	Wed, 25 Nov 2026 02:19:29 +0800 (CST)
From: Shaopei Zhu <shaopei_1012@163.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	exfat@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] exfat: add EXFAT_IOC_COMBINE to append a file's clusters to another
Date: Wed, 25 Nov 2026 02:19:11 +0800
Message-ID: <20261124181911.773506-1-shaopei_1012@163.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <awXMJaZ58iS3K2N0@casper.infradead.org>
References: <20261124142807.773299-1-shaopei_1012@163.com> <awXMJaZ58iS3K2N0@casper.infradead.org>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgAH7o8k1QVrJbHLHw--.27478S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tF4UAFyftF15Ww18tr48Xrb_yoW8XF17pa
	y3twsrta1DJw13GFn3Cw4xt3yru3WxKw4fJas8tw1UZrs8XF129r9xtFW2ka48G39Fqwn0
	qF4Yvas8C398uaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UqeHgUUUUU=
X-CM-SenderInfo: pvkd01phlbiiirs6il2tof0z/xtbC6hGdLGsF1TGqyAAA3i

On Tue, Nov 24, 2026 at 05:40:53PM +0000, Matthew Wilcox wrote:
> On Tue, Nov 24, 2026 at 10:28:07PM +0800, Shaopei Zhu wrote:
> > As with EXT4_IOC_MOVE_EXT and F2FS_IOC_MOVE_RANGE, the source must be
> > open for reading and writing, the destination for writing, and both must
> > be regular files on the same mount.  Files whose allocation, chain
> > layout or valid_size are inconsistent, as after a failed truncate or on
> > a corrupt volume, are refused with -EIO before anything is changed.
>
> Why are you designing your own ioctl instead of implementing
> EXT4_IOC_MOVE_EXT in exfat?  That's the normal way of doing things as
> it lets us later hoist the ioctl from all the filesystems implementing
> it to the VFS.

Hi Matthew,

Thanks for looking at this.  That paragraph was badly worded: I only
meant that the permission rules are the same as for those ioctls, not
that the operation is similar.

EXT4_IOC_MOVE_EXT is a defragmentation primitive: it copies the data of
the original file into the donor's blocks and exchanges the block
mappings, so the contents and sizes of both files stay the same, and
the range has to lie within both files.  It cannot append one file to
another, which is what is needed here: the clusters of the source are
linked onto the end of the destination, the destination grows and the
source is unlinked, without copying any data.

I will reword that paragraph in the next version so that it states the
rules without suggesting that the operations are related.

Thanks,
Shaopei

