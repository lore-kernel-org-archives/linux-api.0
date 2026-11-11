Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=14.137.139.23
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794404764;
	b=YfEljnEQcThIpxDw1Ru9P6HenWAP0S66LPul2rn3QW7c1Xvqnr8CeIwRA8jqzydWSZUk
	 c00L1zpUfND/7tfNIJYx+b+FGD8n3RRP052wKSYNKmWlxbVmugc/gtsYW5wvo2HS+oZeR
	 NXZ92qYisG49C8bjBxyWw18PhW5EBGbN4sgRmhW7zRvu3VOQqFiqaUm/nNUbKGnAFlCMz
	 u9qVhkTgNNh4euM1vbpgke5LBitB7F59bDiv1QHLkIT3SmDu/xfZQBNLNsngxv41Hy5fL
	 qyw0ZXMsADkhGU3qdDEpTkL0tep4S77W0QPjfyuonaWVMi3jk7rrzaAoJaV0PYzT7iQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794404764;
	h=DMARC-Filter:Received:Received:Received:Message-ID:Subject:From:To:
	 Cc:Date:In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=GChzuQwizYdxuw5okzd0/BLCXbP7+oS5+fDo44Dl/P4=;
	b=l/yx1zXd4myXoNdsfY2e95vgUbXgRsXcawaKGg4mwbTNcbhwT3nGFY7zWWEkptKj07qW
	 10R+zcf49LCa9DLx6oKrzuoO2H5KZlVr4ivS6DfbtgEkKQKvUXB2645sJScYRbFs0zI44
	 qEUn4ivCBNZ09B+emaRew0pIqqNPBuuDCM3Nbcgcc8y1lV4XLURqDgM8pthM/OvWunbos
	 ZmS1USWhbdRJFvK+1J8wfD5t/7HMAocdr+flSvJuGcY/cAoikpPRZkLjHo3hx7B3KVRHf
	 sJogX7HJgcKfuWgagl3IGCPrioj8FQBK1NXcqTkrRIrfIKLZR2ibnnvoUwapx36pmqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=14.137.139.23
Received: from frasgout11.his.huawei.com (frasgout11.his.huawei.com [14.137.139.23])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03558606A31C;
	Wed, 11 Nov 2026 13:46:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 03558606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.18.224.196])
	by frasgout11.his.huawei.com (SkyGuard) with ESMTPS id 4jPlCC0S7cz1HCGG;
	Wed, 11 Nov 2026 21:45:27 +0800 (CST)
Received: from mail02.huawei.com (unknown [7.182.16.157])
	by mail.maildlp.com (Postfix) with ESMTP id 4B15C404A4;
	Wed, 11 Nov 2026 21:45:54 +0800 (CST)
Received: from [10.204.63.22] (unknown [10.204.63.22])
	by dep2_app1 (Coremail) with UTF8SMTPA id nRC2B0DGq2GBcfRq7+QQAA--.41743S2;
	Wed, 11 Nov 2026 14:45:53 +0100 (CET)
Message-ID: <a9edb8a433e8efcba3d11b2a06fa1063df41a24d.camel@huaweicloud.com>
Subject: Re: [PATCH v6 0/4] initramfs: add support for xattrs in the initial
 ram disk
From: Roberto Sassu <roberto.sassu@huaweicloud.com>
To: Christian Brauner <brauner@kernel.org>, Danny Hu <dannyhu@arista.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Mimi Zohar
 <zohar@linux.ibm.com>,  Roberto Sassu <roberto.sassu@huawei.com>, Dmitry
 Kasatkin <dmitry.kasatkin@gmail.com>, Eric Snowberg
 <eric.snowberg@oracle.com>, Jan Kara <jack@suse.cz>, Victor Kamensky
 <kamensky@cisco.com>, Taras Kondratiuk <takondra@cisco.com>, Zheng Zengkai
 <zhengzengkai@huawei.com>, zhangguangzhi <zhangguangzhi3@huawei.com>, Jason
 Yan <yanaijie@huawei.com>, silviu.vlasceanu@huawei.com, hpa@zytor.com,
 arnd@arndb.de,  james.w.mcmechan@gmail.com, niveditas98@gmail.com,
 pierre@arista.com,  julien@arista.com, kbharathi@arista.com,
 alexandr.lobakin@intel.com,  linux-fsdevel@vger.kernel.org,
 linux-integrity@vger.kernel.org,  linux-security-module@vger.kernel.org,
 linux-kbuild@vger.kernel.org,  initramfs@vger.kernel.org,
 linux-api@vger.kernel.org,  linux-kernel@vger.kernel.org, bug-cpio@gnu.org
Date: Wed, 11 Nov 2026 14:45:34 +0100
In-Reply-To: <20261110-hengst-tontechnik-ausfuhr-265b06d68611@brauner>
References: <20261105193743.2654656-1-dannyhu@arista.com>
	 <20261110-hengst-tontechnik-ausfuhr-265b06d68611@brauner>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1 
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-CM-TRANSID:nRC2B0DGq2GBcfRq7+QQAA--.41743S2
X-Coremail-Antispam: 1UD129KBjvJXoWxWr1UtFWDuFW5XFyrWry7GFg_yoW5tw1rpa
	9xKr1UWF4DtrW8Aw4kCa17Ca4Fkwn8Gry3WrnYg348Aws8uFnrZFWIkw1F9rsFvr4kKa1j
	vrsIv34q93WqyaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWUJVW8JwA2z4x0Y4vEx4A2jsIEc7CjxV
	AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AF
	wI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUIF
	4iUUUUU
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAQAADWrz3cxlVAAEsx

On Tue, 2026-11-10 at 17:21 +0100, Christian Brauner wrote:
> On Thu, Nov 05, 2026 at 11:37:39AM -0800, Danny Hu wrote:
> > This proposal consists in including file metadata as additional files n=
amed
> > METADATA!!!, for each file added to the ram disk. The CPIO parser in th=
e
> > kernel recognizes these special files from the file name, and calls the
> > appropriate parser to add metadata to the previously extracted file.
>=20
> No, sorry. We're not going to do this:
>=20
> * This is in-band signalling by filename. A METADATA!!! entry changes
>   the meaning of whatever came before it in the stream.

Yes, it is a hack, but such an image is backward compatible with
previous versions. There is no new format, version bump, etc.

>   Which is just the TRAILER!!! nonsense all over again (cf. [1]).
>   No cpio tool knows about it and a kernel without this parser silently
>   extracts the metadata as junk files.

METADATA!!! is stored in ramfs/tmpfs if not processed, so it is just a
temporary file, like the rest of the initramfs content.

> * It sets whatever xattrs the archive comes with through vfs_setxattr()
>   during early boot. Which is insane.

Similarly, the archive can already ship arbitrary binaries that get
executed as root. If you want, we could restrict it to security.ima and
security.evm only.

>   Not just security.ima but security.capability, security.selinux,
>   trusted.* and anything else.
>=20
>   And we've NAKed this before in 2018 (cf. [2]).
>   The magic file name scheme was called a kludge back then too (cf. [3]).
>   Nothing about that has changed.
>=20
> * The initrd is already covered as a whole. Appraising
>   individual files inside an image whose integrity is plain weird.

I agree when the image is prebuilt and has a known reference value. As
far as I know, there is no reference value when the initial ram disk is
dynamically generated on the host. In the latter case, using finer-
granularity measurement/appraisal is the only option.


> * If kernel and initrd are owned by different parties this can be
>   done in userspace. A trusted /init can apply xattrs from a manifest
>   before it runs anything else. That was pointed out in 2019 already
>   (cf. [4], [5], [6]).

Unless the trusted /init is in the kernel image and launched as User-
Mode-Driver (UMD), you need to measure/appraise it, which again
requires its signature to be carried in the initial ram disk.


> This has been proposed in some form since 2018 and never found a
> maintainer willing to take it. I'm not taking a private cpio extension
> into init/initramfs.c either.

I understand. v3 was close to being upstreamed but then got stuck
because nobody was willing to take it, despite all review comments
being addressed. In its favor, this extension is harmless. If
METADATA!!! is not there, nothing happens. If it is there and not
supported, it is a junk file removed together with the rest of the
initramfs content.

Roberto

> [1]: https://lore.kernel.org/r/d69f329c-8365-bb0e-69ee-774cbea141b2@zytor=
.com
> [2]: https://lore.kernel.org/r/3d1bfbd7-7d45-4cf1-32d6-7f6985b42393@schau=
fler-ca.com
> [3]: https://lore.kernel.org/r/f2886ac7-aff9-94bc-5f65-b3b2e946a6ff@schau=
fler-ca.com
> [4]: https://lore.kernel.org/r/20190512091748.s6fvy2f5p2a2o6ja@isilmar-4.=
linta.de
> [5]: https://lore.kernel.org/r/20190512194322.GA71658@rani.riverdale.lan
> [6]: https://lore.kernel.org/r/CALCETrV3b205L38xqPr6QqwGn6-vxQdPoJGUygJJp=
gM-JqqXfQ@mail.gmail.com
>=20

