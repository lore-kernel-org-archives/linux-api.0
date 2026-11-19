Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795082461;
	b=GLn68kK+6oSr2TYi7io+iURH1zuZJls1bu4m3aTJrUNLGestoooVszv7L5iMzNNX7yb4
	 I4wg8xRVaNmzcgKkkARDZF8o3n1s2Dg3sb7agiwebEdZR+T/T1gqq/D0svlXUxr9a+6Az
	 GgV7buUSxwlHawKmWUx0ULvwcQjEGSXDu8o+k+N78tQeBXjnHlxuElNoSTVRpIee03mmQ
	 tsPqhMlTHmdwNFetVJtR9RVXbtSy1HXtk6QJQtLoXeaqu/HZfVb8Diz9wRTJLM2zB6+w+
	 qCQijwoaL8q3TyKHKMIi1Q4HgGxBQG4G4muDKLM0BONZyPD4BB5YH4VNx8eZm4GiOQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795082461;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bQXf7a2tchZd0sm6ejvBeIAXUJshrV4kEWj9Zx7JZ6o=;
	b=syrVFVEJ4RTpLzlmrQWEy+Ii4Z4MZk5x4VTv3+mtAehzk/ZKrUkvk3vaE2gVtTlyZBhP
	 a2diNo9vMy8MEc8ZxDTVs9WnljTw1TVHAje3e4uxKsVZJZ8fSBhKfYU61nOxxh5cR8jca
	 gzp2rfa69oejJCCiXYKpM62xCxWkPCivH6wxtqlfTWOzoRraZ63MchBwNMzXb24BTjJeB
	 uagDp4DcodTUemW0g5sMe9hKlDfyR9socgxBJVfYtQpgSiAX4PooaIX+u1iFmSfAJ+tD2
	 jvBiBlEsAbcOwIWkIP3dxPCTskFoO/2/s2tnPlDAE6rXksQZrc3ug0uVTcsy8J95sKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qQtx8HcI;
	arc=none smtp.remote-ip=209.85.208.178
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A42D606A337
	for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 10:01:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2A42D606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qQtx8HcI
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-3acd523a802so18989801fa.2
        for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 02:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795082459; x=1795687259; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bQXf7a2tchZd0sm6ejvBeIAXUJshrV4kEWj9Zx7JZ6o=;
        b=qQtx8HcI9xOYAewqsC1qeKXYpNZYkorGxO+WUf8GNlozJTjTfjp6RYu0ME9dnQS7SU
         QlKY2a5rrUaalMRM2QkFx1q2fMNmh0+6Kx9oHBLriNElluMZgw2IJqtD+3DSP2pgxNzk
         2TmsS6xkE/qzDTWdZfTpZ+KAbD1lTDxAfFCzr6drsaxvmeBYV8fzzvm70Eui4lhqXTnh
         HgbHImFNfpvHwHXydOauwOfe17ING4Q6TVfyd4rcZEWzKr9mr4fzMJ+Vemn7/3JBMyOg
         1EBPQX8TZZCNUbaVOuHs0Ki+dm4jvN/9bSy06FQShgIIqQcy0wSxBtWSC2/KV4f07jNA
         MUdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795082459; x=1795687259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bQXf7a2tchZd0sm6ejvBeIAXUJshrV4kEWj9Zx7JZ6o=;
        b=1+hm6fTIaMwwZjpeNAlotCucWF/pqmMxVHM87VPxlZSQX8R1CPIqeHEf3OLnaE8AeM
         hcAbVlKXuzK4xXnqm2bU1yosd45AIirww/WGp4CEjtMJD/a6vtYmeDBtIkxTd+BPgIgM
         MqalYbRkpl+l3nu83GSJNg8zbv9D+C5+USS2nRC/GY+3YoKe+wY1mqyOIvaPE6sipNJF
         mUqCRN6/IDALX8Qvn1imn4SRYBBgDJNaoR8/PPC87tXmNWz2I6S8kJJ0BVfCsxvrwBgk
         xg24LmAiqCBMk0UfIyI+Q1xzJkRHVolG13Mo/CkzIzAxYxi50+rXEx0mjaMkLXGI+UWx
         OYnA==
X-Forwarded-Encrypted: i=1; AL+hErGNx4qydn4b4buu/vsb2UWRzSW3Ua+kPtH4yhmW1wibCzmDW2TWSJ0hzRr8TWBlHRD+0chwlQEmXZU=@vger.kernel.org
X-Gm-Message-State: APuU4Z+07/Z7gZ8y1g1c/tAvmwLsmUUEnnc2KaXGi7Zyc8LdCpwHeMzN
	xCxZdZI+78cLehKN9kXG1FUemmJQsHqfNM7wIPKKb+arZvpX08gtQGUu
X-Gm-Gg: AYBFou1S7vmdeiq7HP3tV1KMfRQTX1UuXYQkYidvJD7MmzTbPsoDmcBzv21q7L0zKIT
	AFhMPPTL4NbqQl3MD+uZKv+yAxRLOitWRwjCk7gPu6j0pKowUEoVE+sM06YNxzDiPfmg8u3AqB/
	ZON8VlF1T9jxkt/W4VUK4SYa4o0TDZ52VCXPkBc+pGqgvH+Q4qkWATHF57FVPcxyVAy8Yzss2RQ
	bel+S9AkHH65ypWWt2GxDSaCWm397ygmdbjVuqVdxZTA8c8xopu0nDBZWTq01FyymKtA6PNT8gz
	gxipOvCEbh++6sbjkeult8PZWtmvWOAaHBxMdPpB56T7pb1BLwUgEwchUVvS58g9EhZ6PcTjscZ
	9c5npLxRR4/6miSWYpLzVkvvKRb1U69ZRYqKTMofZwFGqpU69K+ywQ3y/awVFD9bb5nFrMNyjV/
	ppSLTd9rGZjbcQKusfpAqTufKrw8yY7fU35vaa1vHrY2RW/eU7DySI5sT08IEdq+vkSzr4Sn4H6
	gDXYM0zG1ynEoU42uZG2cVcUe5gfBTJd2Qa05ZHYyAh9lLJXp1enCi/FbNvpw8Bj2tmGRWJQHBq
	fxUYFNmh7NO3bzNi1cpVPWG/OA45pfsdjwARLh79wVZwDUjJaUqCqbmkS0F4mI+Eb7GCb21/H9k
	7thZ/x8dV2nsQ7jl7QqL5fv+ThI44jb/LIGW1H9BAz2vKDpF73wAuIcI3cMU=
X-Received: by 2002:a05:651c:1987:b0:3ac:7ad6:2003 with SMTP id 38308e7fff4ca-3ae670dda79mr17356091fa.6.1795082459145;
        Thu, 19 Nov 2026 02:00:59 -0800 (PST)
Received: from Lauri-G-Pro-14-M4.intra.lakuz.com (n2vuxeervp7z67jbft6-1.v6.elisa-laajakaista.fi. [2001:99a:2ab:bb00:352b:8deb:4901:b3ca])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3ae6ea7c798sm8419451fa.11.2026.11.19.02.00.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 19 Nov 2026 02:00:57 -0800 (PST)
From: Lauri Gates <lauri.gates@gmail.com>
To: Dave Chinner <dgc@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>,
	Christian Brauner <christian@brauner.io>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF buffer lock
Date: Thu, 19 Nov 2026 11:59:43 +0200
Message-ID: <20261119095943.85048-1-lauri.gates@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <av4Hn9u80fs8iHZ6@dread>
References: <av4Hn9u80fs8iHZ6@dread>
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

On Wed, Nov 18, 2026 at 10:16PM +0200, Dave Chinner wrote:
> I really don't care if it is exposed by statx or file_attr; checking
> the flag through either interface will be orders of magnitude faster
> than using FIEMAP to iterate extents on every file to find shared
> extents. My concern with statx is coherency - it runs completely
> unlocked and so can race with operations that add/remove the reflink
> flag...

Thanks, Dave and Christian. Given Christian's preference and the
coherency point, I'll write the RFC against file_attr, once the
question at the end is settled. xfs_fileattr_get() already reads the
flags under XFS_ILOCK_SHARED, so the new flag gets that without extra
work. The answer can still go stale right after the call, as with any
stat result: a clone that lands after the read is missed, just as one
that lands after FIEMAP returns is missed today.

As I suggested on the 6th, the flag would take the inverted meaning,
so that an unset flag stays the safe answer: say FS_XFLAG_NOSHARED
("no extents shared with another file"), read-only, in
FS_XFLAG_RDONLY_MASK next to the case-folding flags. XFS would set it
when XFS_DIFLAG2_REFLINK is clear, and ocfs2 when
OCFS2_HAS_REFCOUNT_FL is clear. btrfs keeps no per-inode record and
would leave it unset, as would nfs and cifs, so their files read as
"may share" and a du tool falls back to FIEMAP there, as it does
today.

overlayfs needs care: ovl_fileattr_get() reads the upper inode, which
for a metacopy file has no data extents. The overlayfs patch would
take the flag from the lower data inode, and leave it unset ("may
share") while that inode is not yet known (the lazy lookup on
data-only lower layers).

Christian, one question on the shape within file_attr: would you take
the inverted flag, or would you rather keep a plain "may share" flag
and add a mask to struct file_attr that says which xflags the
filesystem reports?
