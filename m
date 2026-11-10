Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794327725;
	b=aLGnCS3j0tdF6BmpcRdPxFtzDIxl+72HgiNGiUnfGlnRxmO9X0VWscgKVEJGf/BhhDwr
	 9B9YXitaICIzI11Mfqo4JoGJtXYKm6cfVUYapDmRc4cvZQ5KznN11Y3AoMRckIkyswrgs
	 P2pvUlwMoAM+SB/0CpwwJ9ZuccmCpZCvjDTOC2HuVfrBZs5Hlgcmp7hUFnEtAdQdEI8xf
	 yhgk0rIqSXgP8t336hTBYsoLU0DSz26x0qMR3x6T9xWoTKbr/UFKznUjcaPVUsUTKIWAf
	 g8XGuhAD5TnCliA7IYzsiSY9ZhwP0uEnmmvN46OcyTf/U8QyHBm+df49KdkgTdAnBng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794327725;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=YF22N2q4+EVjchzKm7DJjpiWxKzMohvIopxi7htOEPM=;
	b=FoMyFrnVXed021hth6TFsHgpIU+m+RDon1QbKqX+JNQyLa67Ty7H8ozKhqRLFOcC53RP
	 rVuJlTw0xwiaqqzss7sMdWEsQk+BQVu5mb7YjYvbQ24FNmGpqOh2MfW0QV4h2zVg3KJdv
	 YDBFiXR+LWQ7K1zUbeFtJy8hGmjiKLXVJ/xjOB5m7Gf52FiMY7nArUdUxMmDkxbDtJBLe
	 yMJ3o0KbE3po6zixz0sh+9JZsUO8avScxU7KtPnpcRuFEWh5lrBpmNwj5pk0Gt7oPlSP/
	 6Z/aCazt6OdHsIcbsrRYwHrpJoFfkaLiKzmM98VFS2NsPb8HQbMm6UIHoWif+VTBTiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bApd0IWq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92036606A335;
	Tue, 10 Nov 2026 16:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bApd0IWq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A401F0089F;
	Tue, 10 Nov 2026 16:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794327725;
	bh=YF22N2q4+EVjchzKm7DJjpiWxKzMohvIopxi7htOEPM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bApd0IWqTszQysGvdmEv04lCt1XgUDyKMRYVX8CA2uXMbR1cyMAH54zaPeMXrAlqj
	 safYnsVPu/gqHE0UcWmmFH3oJBx1iRr5oOYp5zTeflAb5cmMiLE6seTxTTrqAl5Nb0
	 lJHn7LmqlhaMQYH/3uFgnL+fuiu3ufd1VpIGkrrApvbPVsjUbz/+QhdBQOqK/yE3H8
	 uK3GupdElCh5eIevPlkK1vLZJ7RrMTDLQdzdHgXC8nQDcO2TzDPabGa981PZaA0PDm
	 /N+jMkb769ue4sbkzCAMZdCxJIu48/ioqpNZs4ZPc9oAZvFAC8mM4GqWeUhPGHd5Ef
	 gimge/4axigqg==
Date: Tue, 10 Nov 2026 17:21:56 +0100
From: Christian Brauner <brauner@kernel.org>
To: Danny Hu <dannyhu@arista.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Mimi Zohar <zohar@linux.ibm.com>, Roberto Sassu <roberto.sassu@huawei.com>, 
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Eric Snowberg <eric.snowberg@oracle.com>, 
	Jan Kara <jack@suse.cz>, Victor Kamensky <kamensky@cisco.com>, 
	Taras Kondratiuk <takondra@cisco.com>, Zheng Zengkai <zhengzengkai@huawei.com>, 
	zhangguangzhi <zhangguangzhi3@huawei.com>, Jason Yan <yanaijie@huawei.com>, silviu.vlasceanu@huawei.com, 
	hpa@zytor.com, arnd@arndb.de, james.w.mcmechan@gmail.com, niveditas98@gmail.com, 
	pierre@arista.com, julien@arista.com, kbharathi@arista.com, 
	alexandr.lobakin@intel.com, linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-kbuild@vger.kernel.org, initramfs@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, bug-cpio@gnu.org
Subject: Re: [PATCH v6 0/4] initramfs: add support for xattrs in the initial
 ram disk
Message-ID: <20261110-hengst-tontechnik-ausfuhr-265b06d68611@brauner>
References: <20261105193743.2654656-1-dannyhu@arista.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261105193743.2654656-1-dannyhu@arista.com>

On Thu, Nov 05, 2026 at 11:37:39AM -0800, Danny Hu wrote:
> This proposal consists in including file metadata as additional files named
> METADATA!!!, for each file added to the ram disk. The CPIO parser in the
> kernel recognizes these special files from the file name, and calls the
> appropriate parser to add metadata to the previously extracted file.

No, sorry. We're not going to do this:

* This is in-band signalling by filename. A METADATA!!! entry changes
  the meaning of whatever came before it in the stream.

  Which is just the TRAILER!!! nonsense all over again (cf. [1]).
  No cpio tool knows about it and a kernel without this parser silently
  extracts the metadata as junk files.

* It sets whatever xattrs the archive comes with through vfs_setxattr()
  during early boot. Which is insane.

  Not just security.ima but security.capability, security.selinux,
  trusted.* and anything else.

  And we've NAKed this before in 2018 (cf. [2]).
  The magic file name scheme was called a kludge back then too (cf. [3]).
  Nothing about that has changed.

* The initrd is already covered as a whole. Appraising
  individual files inside an image whose integrity is plain weird.

* If kernel and initrd are owned by different parties this can be
  done in userspace. A trusted /init can apply xattrs from a manifest
  before it runs anything else. That was pointed out in 2019 already
  (cf. [4], [5], [6]).

This has been proposed in some form since 2018 and never found a
maintainer willing to take it. I'm not taking a private cpio extension
into init/initramfs.c either.

[1]: https://lore.kernel.org/r/d69f329c-8365-bb0e-69ee-774cbea141b2@zytor.com
[2]: https://lore.kernel.org/r/3d1bfbd7-7d45-4cf1-32d6-7f6985b42393@schaufler-ca.com
[3]: https://lore.kernel.org/r/f2886ac7-aff9-94bc-5f65-b3b2e946a6ff@schaufler-ca.com
[4]: https://lore.kernel.org/r/20190512091748.s6fvy2f5p2a2o6ja@isilmar-4.linta.de
[5]: https://lore.kernel.org/r/20190512194322.GA71658@rani.riverdale.lan
[6]: https://lore.kernel.org/r/CALCETrV3b205L38xqPr6QqwGn6-vxQdPoJGUygJJpgM-JqqXfQ@mail.gmail.com
