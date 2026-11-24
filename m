Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795551887;
	b=kesfLoXq+EXVi+3LoFVsOHtbDf8hQjcsphBIXVetmnipC3S2NAlz8f/h8cEtKK+QwH+r
	 NLrS+maImt+x7tv84XxpwFpi+hODTGOkdPt1fdEBnNUBEbU0rtVAdDUj3yETLQ2gLVqW5
	 I7eJ4P5n5HnWvwRCE2cZsUzysena6Q7sMLphQzXCbw+/sIdHnXUWGO5ajE2T6az/WN57F
	 +pTs04w1mKaD3BAt6px9Hw2q1nUyMEw2MuPLW9eZBIykxqJgSPIxIRqozXmHRKgpX1+M8
	 qa5d3CAO1fbzJ+u72Xp7hhBTan1sCux/t/7xjHS+9uM4FzEmCwDDaUZTlf2BmHoSLnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795551887;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=rn2JMXIObYI9wUt1ea1lSjudrwErALnnzN0nbwRNkfY=;
	b=nIUDVO3OLz/twRkXEBxT7LiSldeKxG2bSTcvXkJ5BN0pbKGjq6Voi7lE4EpFFOm2YSe9
	 MNmytJiO/AwlTL3KQj8/hryr1Y+WplmT8VM3ruHkCOVoc7m4V3+yNJj4GZkqf2LyS0yGX
	 QgrVsuBZNSK4KZGdJZZHEk6DQ8VZmlnmQYi/oYBiMYe0PzW38flJq7R7euydm/2uWID1y
	 yS5tujPzSaflOVuKWVik+wh5WbdO6ksIUsc99IhUCHh8zVPQyzQbYJgx09VmQsc7G6LQM
	 IiLWynUbVtj7POSB+L5J2xB5irol+v8WJNSj3rEPgNrKM4MDYPXlZ/Q5HzjYXqlswWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=kbBvAQ6g;
	arc=none smtp.remote-ip=220.197.31.5
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B855606A31E;
	Tue, 24 Nov 2026 20:24:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B855606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=kbBvAQ6g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=rn
	2JMXIObYI9wUt1ea1lSjudrwErALnnzN0nbwRNkfY=; b=kbBvAQ6gbcHIx2KYwd
	vNu0gcC2BTI++qH82V1ZKqs4a2b9R2vkycNe4I/zc0rZgFaY2hfhcA2wjzbJw37p
	1mqj9jrxBu2VVOIBpK47uhtnK9Ug7uJWD171N4WdrS3l9aJY1568GTc2zbM+Cfko
	j38J0XxKcCOaluJh948Q9HL6o=
Received: from ubuntu (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wCXnZZZ8gVrSzkaJQ--.10376S2;
	Wed, 25 Nov 2026 04:24:06 +0800 (CST)
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
Date: Wed, 25 Nov 2026 04:23:51 +0800
Message-ID: <20261124202351.817372-1-shaopei_1012@163.com>
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
X-CM-TRANSID:_____wCXnZZZ8gVrSzkaJQ--.10376S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tF4UAFyftF15Ww18tr48Xrb_yoW8XF17pa
	y3twsrta1DJw13GFn3Cw4xt3yru3WxKw4fJas8tw1UZrs8XF129r9xtFW2ka48G39Fqwn0
	qF4Yvas8C398uaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07USQ6JUUUUU=
X-CM-SenderInfo: pvkd01phlbiiirs6il2tof0z/xtbC6QbxgGsF8mbqeQAA33

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

