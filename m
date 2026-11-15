Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794780728;
	b=ArPRbO/AG9k9TUZWjdhpSX9Uv9b/3NRQ5SpT0zzAQz/DVThUhL2eFgxsGUiZfoc4HuhW
	 siDO039QPcbvLjCZQqRRmofo2fZ/VVKpJRsamJXe2jILVL2L+CWlRDXeGJOVupWfVYgrF
	 417VWPspxnKldGh4/o3TG1ndSKURu2/KPcrBEdpbsWrbP+FCXE7MkexQQilQU0LGXpsyi
	 mmRfxjJCYe8EB6Zhe4djwoLNtHk8DONO6h5zeyEDEInoD+SCWGG3A3L7R4jOb73Tu4ytO
	 t2eePRqjGf0sAfI/k+7JgsTVJf5Rc4PoagIDvgphHuc0VBVn3kUyHzwzrOVMDB9kwiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794780728;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=q9s42YVPhc56VTV+G1TekC9EyggoNH/5JmNGm6Xx0OY=;
	b=G3NlcQpPNgauL0GS5F2pFxEtsGmPB+LqiVlzu7kYfwpExO1OtVu9M4O+XKW3+lcWOqST
	 5mbbOHpG+Lnl0l77pFK/ZBlcbpFbPvjwL0HVwwZ0MUKreobC6vHi3k3AOkgbp6tdbXvYw
	 zc36R7UT1gCrpgYUJjv8s/JXUgZikIXwIrsqj0di9ApGALpr6QJHGzp2ZIndN4n1Y78qI
	 l+fEveVqsON2uO8mqdHWdfll8glmTVPJVPKRluOypNG5Ce3KswQF6goDqiaSHBr5Ndp6d
	 9CFLmVIdSnQQPOC2cLXVuqavXMUqS96v4I1YGeG2ceJuZhFHK7Gk/dCIPDOFG8qn4Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=2dU+DbgF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B646606A31F;
	Sun, 15 Nov 2026 22:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=2dU+DbgF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D80C81F000C4;
	Sun, 15 Nov 2026 22:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794780727;
	bh=q9s42YVPhc56VTV+G1TekC9EyggoNH/5JmNGm6Xx0OY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=2dU+DbgFDrqSj3PWmmULOFhMRJrMipQby1pDwXNQGxLi46AXNwWZX7utTYV4vHXMw
	 OuPTqGy1iRd0KdBcAa+7e2q56eUOyyVc+qL8yfUS0ZDGXQiZX1nqa8ER3jfu0eQFvY
	 gnkUjz6mfockveWho3dsBBhBNdBl3oqMsZUPEw20=
Date: Sun, 15 Nov 2026 14:12:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yingjie Wang <x-professor@outlook.com>
Cc: Manfred Spraul <manfred@colorfullife.com>, Alexey Gladkov
 <legion@kernel.org>, "Eric W . Biederman" <ebiederm@xmission.com>, Vasily
 Averin <vasily.averin@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Michal =?ISO-8859-1?Q?Koutn=FD?=
 <mkoutny@suse.com>, Michal Hocko <mhocko@suse.com>, Alejandro Colomar
 <alx@kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
 "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
 "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
 "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
 Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH v5 0/3] ipc/sem: account dynamic sops arrays and
 validate SEMOPM
Message-Id: <20261115141206.920bdc8c5a84073712bb5c3b@linux-foundation.org>
In-Reply-To: <cover.1793250194.git.x-professor@outlook.com>
References: <cover.1793250194.git.x-professor@outlook.com>
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

On Thu, 29 Oct 2026 05:03:24 +0000 Yingjie Wang <x-professor@outlook.com> wrote:

> Shakeel, thanks for the suggestion.

Thanks.  Shakeel, please review [1/3]?

> Patch 1 now uses GFP_KERNEL_ACCOUNT for every dynamically allocated sops
> array. The first 64 operations still use the existing stack buffer. The
> fixed 1000-operation exemption and its conditional allocation flags have
> been removed.
> 
> I compared this version with v4 in a 4-vCPU KVM guest. The benchmark process
> was pinned to one vCPU. Each number is the median of 21 samples from three
> fresh boots of each kernel. In a leaf memory cgroup, the changes were:
> 
>                                       65       500      1000
>   successful semop()                   +3.2%     +3.2%     +2.3%
>   allocation-focused invalid semid     +5.6%     +9.1%    +11.9%
> 
> The invalid-sem-id case allocates and copies the operation array before
> returning EINVAL, so it emphasizes allocation overhead. The 64-operation
> stack controls changed by 0.9% and 0.5%, respectively. The already-accounted
> 1001-operation controls changed by 1.0% and -0.2%. Successful calls in the
> root cgroup changed by at most 2.3%, including the controls.
> 
> The sysctl handler parses writes into a temporary array while holding a
> per-IPC-namespace mutex. The mutex covers the snapshot, validation, and
> publication, so a failed write leaves the live settings unchanged and a
> partial write cannot restore fields from an older snapshot. The snapshot and
> publication use READ_ONCE() and WRITE_ONCE(), and reads continue through
> proc_dointvec(). The unused sem_check_semmni() helper is also removed.
> 
> The UAPI warning about physical fragmentation is obsolete now that the
> operation array uses kvmalloc(). The header describes SEMOPM as the
> compiled-in default and retains the uniform <= INT_MAX range comment.
> 
> Patches 2 and 3 are unchanged from v4 and retain Manfred's Reviewed-by tags.
> The series is based on 7be4bc52fd9e ("Merge tag 'driver-core-7.4-rc1' of
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core").

Thing is, the above is largely about what-changed-since-last-time. 
It's useful info, but it's short-term development-time stuff.  Most of
this is inappropriate for the long-term kernel record.

I had LLM suggest a replacement [0/N].  wdyt?

: An IPC namespace owner can raise SEMOPM and make semop() allocate a large
: operation array.  A blocked call retains the array.  These allocations are
: currently uncharged to the caller's memory cgroup, so repeated calls can
: consume host memory beyond a container's limit.  In one test, a call
: retained 60,936,448 bytes while a 32 MiB cgroup recorded less than 1 MiB. 
: Sixteen concurrent calls retained 100,860,416 bytes while the cgroup
: recorded about 1.3 MiB.
: 
: The SEMOPM sysctl also accepts negative values.  Because the operation
: count is unsigned, SEMOPM=-1 becomes an effective limit of UINT_MAX. 
: Separately, a rejected kernel.sem write can leave earlier fields changed:
: an invalid SEMMNI can return ERANGE after setting SEMOPM to zero, causing
: subsequent nonempty semop() calls in that IPC namespace to fail with
: E2BIG.
: 
: Patch 1 charges dynamically allocated operation arrays in the regular
: semop() path to the caller's memory cgroup.  Patch 2 parses and validates
: kernel.sem writes before publishing them and serializes writers within
: each IPC namespace.  Patch 3 removes the obsolete warning that SEMOPM
: above 1000 risks physical memory fragmentation; the operation array uses
: kvmalloc().
: 
: Accounting contains the large-array case when the caller's memory cgroup
: has an effective limit.  The series does not impose a maximum on positive
: SEMOPM values, so a root or unlimited cgroup can still request large
: allocations.
: 
: Validation included x86-64 and i386 builds, initial and user-owned IPC
: namespace checks, concurrent sysctl writes, operation-count boundaries,
: and allocation cleanup on success and error paths.  In a limited memory
: cgroup, accounting increased median successful-call time by 2.3% to 3.2%
: for 65, 500 and 1000 operations; the allocation-focused invalid semaphore
: ID case increased by 5.6% to 11.9%.

Also, [1/3] and [2/3] are cc:stable but include no clear description of
why we're recommending backports.  Backportable patches should clearly
state the userspace-visible runtime effects of the bug which is being
fixed.  Our downstream people (-stable maintainers and further
downstream) are swamped with bugfixes, so let's help them out!

So for [1/3] I inserted this statement:

: A caller can raise SEMOPM and keep large, uncharged operation arrays alive
: in blocked semop() calls.  Repeating this from a memory-limited cgroup can
: exhaust host memory outside that cgroup, causing reclaim, stalls, or OOM
: kills of unrelated processes.  Charging the arrays lets an effective memcg
: limit contain that memory use.

and for [2/3] I inserted

: A negative SEMOPM becomes a large unsigned limit in semop(), allowing
: operation counts that the configured limit should reject.  Separately, a
: kernel.sem write can return ERANGE for an invalid SEMMNI while leaving
: earlier fields changed; if it leaves SEMOPM at zero, subsequent nonempty
: semop() calls in that IPC namespace fail with E2BIG.  Validate the whole
: write before changing the live settings.

Please check these also.

