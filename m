Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794844815;
	b=QKvxoToeMOFi0sBuX3n/0yVUoyPa253t62CHd2iIIw1S72xPFNdtiCxgitAz/6XOwbDr
	 JKh0TPSDYD2PTKUDW/062zc2jD/CEBomqLkecdlWq02gidfuVg+BlWsyZdntTYia3Avc/
	 pHYjNXILsgHOd40K8iS0Z71rbYoNmMxp/kE/hQ7dHJWVoN1Fmbp3Z6AMwVnD7wdNR+nYB
	 aJuvvxfdkPgFg62JXfEu6yFBk5ZMMJYL1WoXcWAcXuKsstJ0yUBHp00Jpnu1ONM3l23Ax
	 iKMshE7fnHXaxEOwryh2UnDFpiDNOQ45HaltpH+1Ev7KuT8NwIIkvBBJTLk+TggpuRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794844815;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=5FwU8er9jCeLmP2s1OrkSO00t5m4+Uddmg0A6k9pE18=;
	b=zEqOJp34+/zmTxjK9y3xdESWoe63vjz6lwWfkT764NZ+RtUOX+OuI4d8Sb/Iy66+eycI
	 VUQXjKYwutpD1HtC61R0AxdTQlxHo3Tg9ccOqt8ZGiJZaTazkLyX76c/AyW4R1nHEsRs3
	 0LgHVkPQf4uMfzUkCS9cwgirN2NL6HMjnAxEc6U3DMf1vVQ6uJarYkmYwFUhm9DhT67b6
	 EyPSyyiRlbWsgbfmlMpm0qz2LYUAslmKnohRCh48OB/w/XTY6NYeN8T5CoXgnvw0OE9gS
	 edcDGYZlmQfBkwHylh+8VXJbCFM4mEt9cDRtdV+h+IGLS4YK2clITHSfCRaw+r0PQXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=BPegepsl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A20606A322;
	Mon, 16 Nov 2026 16:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=BPegepsl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E621F000C4;
	Mon, 16 Nov 2026 16:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794844814;
	bh=5FwU8er9jCeLmP2s1OrkSO00t5m4+Uddmg0A6k9pE18=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=BPegepslNzGtyW1r/Rq123aCz2axqzJu12dxkG1nDchgLsphIUbg1Bfqs0vOTmzi1
	 rc/seV0/CbaEUvvVFZEpifVak1iXewOj2iUUC1KYi1zJZnav1XZIRe1Lm7BZgDhD2G
	 0DFtsqCaqCGn270wG1Wz5NkU7OmluEweJ+kDGlms=
Date: Mon, 16 Nov 2026 08:00:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yingjie Wang <x-professor@outlook.com>
Cc: "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>,
 "manfred@colorfullife.com" <manfred@colorfullife.com>, "legion@kernel.org"
 <legion@kernel.org>, "ebiederm@xmission.com" <ebiederm@xmission.com>,
 "vasily.averin@linux.dev" <vasily.averin@linux.dev>, "hannes@cmpxchg.org"
 <hannes@cmpxchg.org>, "mkoutny@suse.com" <mkoutny@suse.com>,
 "mhocko@suse.com" <mhocko@suse.com>, "alx@kernel.org" <alx@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org"
 <cgroups@vger.kernel.org>, "linux-api@vger.kernel.org"
 <linux-api@vger.kernel.org>, "linux-man@vger.kernel.org"
 <linux-man@vger.kernel.org>, "linux-hardening@vger.kernel.org"
 <linux-hardening@vger.kernel.org>, "stable@vger.kernel.org"
 <stable@vger.kernel.org>
Subject: Re: [PATCH v5 1/3] ipc/sem: account dynamically allocated sops
 arrays to memcg
Message-Id: <20261116080013.6a0e1f1a4d0421f432b39ec1@linux-foundation.org>
In-Reply-To: <179481695440.274194.11951572532773505066.semopm-shakeel@outlook.com>
References: <cover.1793250194.git.x-professor@outlook.com>
	<07d9034ec1fb5b6fd5eed2cf60ef3c84d5149e51.1793250194.git.x-professor@outlook.com>
	<avqD2Z3KJwPsCcVG@linux.dev>
	<179481695440.274194.11951572532773505066.semopm-shakeel@outlook.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 16 Nov 2026 08:20:52 +0000 Yingjie Wang <x-professor@outlook.com> wrote:

> > There is no kmem accounting in root cgroup, do you know why there is an increase
> > of 2.3% there?
> 
> I think the 2.3% mainly reflects boot-to-boot variation. The unchanged
> 64-operation stack path also slowed down by 1.9%, even though it does
> not reach the changed allocation.
> 
> For successful calls, the per-boot medians were:
> 
>   nops  V4 boots (ns)           V5 boots (ns)
>   64    230.5 229.4 230.0       231.2 235.0 235.4
>   65    546.0 551.2 548.2       551.2 562.6 566.3
> 
> The first V5 boot was very close to the upper end of the V4 results at
> 65 operations, while the later two boots were slower at both sizes.
> That is why I interpret the increase mainly as boot-to-boot variation,
> rather than root-cgroup charging.
> 
> __GFP_ACCOUNT does still change the allocation path, including selecting
> the kmalloc-cg cache, so a small contribution from that is also possible.
> 
> Andrew, could we clarify the root-cgroup result in the [1/3] changelog?
> Please change
> 
>   and successful calls in the root cgroup by at most 2.3%.
> 
> to
> 
>   and successful calls in the root cgroup by at most 2.3%, which
>   appears to be mainly boot-to-boot variation.

Yes, I have made both requested edits.
