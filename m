Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793711195;
	b=0EiLEkJMEUcEO6ZWSyR26CZzj1aptMzEDq66oHDyVw5b0dx+OkpmdQJnJHwdMpMBlNFn
	 WqaAC+BIzXUfbkIyyIbtPCxOLlovImRQDij0RTm2biAqGaigrUxJEfMloOprD8akYdoiU
	 Apmr3C5nTQ/bsv/yP1zINj8VwrnZVxMvCtpXDGHnbsSOdBCoOQ8A5nfh1I/PNEMmUnusZ
	 4pi7eJ/FgI4SWAiZdsKsB3MQb12nCDac1fITNGSgmYaJ6wkO8tD0oPyxMrQPS2a2+H7TO
	 6wrwVQR6TziNW2r81m5hHZj6XJIe9I1501e8FJyogaeWBtXcdSI3JuLbUpIcNNlyceQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793711195;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=Sm8eBtV1xdp4zAa6YXthLgHufsLnCQQpa5HRuwqjWGo=;
	b=FJ10m+O4Vvpy+yLm4qwBMtNHiyZEaEarp8tnvh9uumX3cGG/zX9E/2Ug4/zGKmLXdigE
	 MFR8nbkXzh3rx6nx4Ag1EzfXsrdoJr3ZkdqWa1BMQiABD2izf1r5YTUpXgGefGFiqC35S
	 ZZ5u8bVDkoLcfQ4wm3kBwO9/ZRLXZqpTjtA3j032vTLDpYzhyMyVgAuQHhl5hRo68NluM
	 0Eu3IMZ8AR0Pw/pnc4JrA6z/tJsOlWQhPWd8CB6PeM1tXJmi2EUvL61kuNepFnEP2GadP
	 Ozu00YfROlVzZuuR3Q0Y0oR9LfpTk+HhxZ/8m8T681GB0vRx0jCAqJrChNdCHu6xvYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=okGQ0kfZ;
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99D260850A8;
	Tue,  3 Nov 2026 13:06:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A99D260850A8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key, unprotected) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=okGQ0kfZ
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=Sm8eBtV1xdp4zAa6YXthLgHufsLnCQQpa5HRuwqjWGo=; b=okGQ0kfZR6mrUlaKfdWRPwy7pB
	ClSdB9O/OBJ+chZFgiv03XevWUUjIyBILk9BUbjgtnafp98eDUC+nZHUMPX1zXqI98nOMiK1EeOMS
	7aev26NTuSPHTtDHMcno7Twne45XuisPSDFbi+7XtjE9zFug9ScfdXF9Y1HqN5CsrvCZg0TjvcD6t
	8v3qhSoBwB/Bs+itW+B0bcubZJ//14nVFa7e9oVobwgqMwJHSaXcXpazZ6On0bV8bIXNymZxRY54b
	O6d/MO7FSzpSzz1QdtiYsoTow/km3RpsgKNAJKuV7ng4sTIFZloFnUY+f2VYKh4i2N3iqnRabQC7M
	fSYvocaZWFp7prHFRyVwDW0u2MnTZ95dePJ8jJM+9o8KEF01+rghnD4wjAO+gDPKTeSK3bxeVnKU0
	oW29qF5NR3i9vjQQ/L8XynTzqALcJVJaDkz2igp2gXoB28LftmIz97iZlCYAPesr+eIkB0UpX6GMq
	hIiLv0JdiOQfkcWn/PVT6sGo;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xOEDa-00000007tbJ-1uxh;
	Tue, 03 Nov 2026 13:06:26 +0000
Message-ID: <03f82274-2749-4529-bf98-ede7cc79ad08@samba.org>
Date: Tue, 3 Nov 2026 14:06:25 +0100
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs: add RWF_DIRECT for preadv2/pwritev2/io_uring to set
 IOCB_DIRECT per io
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Jan Kara <jack@suse.cz>, io-uring@vger.kernel.org, linux-api@vger.kernel.org
References: <20261012184642.558349-1-metze@samba.org>
 <20261021-kontakt-hauen-albern-9053a385d79e@brauner>
 <20261103080718.GA4109@lst.de>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <20261103080718.GA4109@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 03.11.26 um 09:07 schrieb Christoph Hellwig:
> On Wed, Oct 21, 2026 at 01:04:06PM +0200, Christian Brauner wrote:
>> On Mon, Oct 12, 2026 at 08:46:42PM +0200, Stefan Metzmacher wrote:
>>> It's useful to control this per io request instead of using O_DIRECT
>>> for the file descriptor.
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
Userspace can already mix the modes on the same file today, by
opening it twice, once with and once without O_DIRECT, or even on a
single struct file with fcntl(F_SETFL, O_DIRECT). The patch requires
FMODE_CAN_ODIRECT in kiocb_set_rw_flags(), the same check open() and
fcntl() do for O_DIRECT, so it doesn't allow direct I/O on files
that couldn't do it before.

The use case is Samba: SMB3 clients request unbuffered I/O per
request (SMB2_READFLAG_READ_UNBUFFERED and
SMB2_WRITEFLAG_WRITE_UNBUFFERED). Samba wants to use a strategy
similar to NFSD_IO_DIRECT in nfsd: for reads the range is aligned
down and up to the STATX_DIOALIGN values and read with RWF_DIRECT,
for writes the aligned middle is written with RWF_DIRECT and the
unaligned head and tail (if any) with RWF_DONTCACHE (or plain
buffered I/O if the file system doesn't support it). Without
RWF_DIRECT Samba would have to keep a second O_DIRECT file
descriptor for every open, which only hides the mixing from the
kernel.

> There's also issues where file systems still check O_DIRECT for
> behavior and not IOCB_DIRECT, and this would increase the problems
> with that compared to the existing in-kernel only users.
> NFS for example has quite a few O_DIRECT checks, and some of them
> feel wrong for this.

Right, that's the real difference: with two opens or F_SETFL the
O_DIRECT in file->f_flags always matches IOCB_DIRECT, with RWF_DIRECT
it doesn't, and FMODE_CAN_ODIRECT alone doesn't tell whether a file
system copes with that. For some file systems FMODE_CAN_ODIRECT is
still only derived from ->direct_IO = noop_direct_IO in
do_dentry_open(), so it just means that O_DIRECT can be opened.
cifs.ko is an example: with cache=loose cifs_file_write_iter()
decides by O_DIRECT, so an RWF_DIRECT write would be written
unbuffered by netfs, but without the cache invalidation and oplock
reset cifs does for O_DIRECT.

So what about making it opt-in as a start, like RWF_DONTCACHE with
FOP_DONTCACHE? A new FOP_DIRECT_PER_IO would be set by file systems
that base their I/O decisions on IOCB_DIRECT, all others return
-EOPNOTSUPP for RWF_DIRECT. Once all file systems that set
FMODE_CAN_ODIRECT also set FOP_DIRECT_PER_IO, the flag could be
removed again and RWF_DIRECT would just depend on FMODE_CAN_ODIRECT.

I looked at the local file systems Samba typically exports in
v7.4-rc1: xfs, ext4, btrfs and f2fs (and also ext2, exfat, gfs2,
nilfs2, zonefs, ntfs and ceph) decide per I/O based on
iocb->ki_flags & IOCB_DIRECT, falling back to buffered I/O per
request where direct I/O isn't possible (e.g. ext4 for encrypted,
verity or inline data files, nilfs2 for writes) or failing it with
-EOPNOTSUPP (f2fs for atomic write files, ntfs for compressed or
encrypted files). O_DIRECT in file->f_flags is only used for
checks at open time (or the start of an f2fs atomic write), so they
could set FOP_DIRECT_PER_IO right away.

Others like cifs, nfs, 9p, overlayfs and the other backing file
users, ntfs3, erofs, ocfs2 and fuse have O_DIRECT dependencies in
their open or I/O paths, they just wouldn't set FOP_DIRECT_PER_IO
for now. Fixing them is independent of RWF_DIRECT.

Should I send a v2 that adds FOP_DIRECT_PER_IO and sets it for the
file systems listed above?

metze
