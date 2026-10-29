Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793292554;
	b=FE4MX0fuK9vKkLaIlxo5lIDQDaCZ0Atx14cMIjML04LAlQg2d535zUp7N/gLdQxEDHGa
	 uo6pq4dTCc5hqu/IB/XHQWoS8gz5a0KdfdpfzKggibs1FH9n0JyT/XTrWuP0ZWNzME918
	 OhWAPiXh+ceAcg+62ATlC3hZaos3SFTK/QxzwrWRj63j6PU03pDJ1tillznbcHSXBWEkL
	 F8bZ1469vW72mPyV7mCamkS3rcSlY3tktLQTB0acMF9KVCtUoYZah91rza+y8zx8XuyUn
	 Henjs5lkZuLI0OBf/eBHhIInWqO2pY6K/V7sTvBz0AMq8nEjgcrJtarVCf5chUorn8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793292554;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=5wi6r2Bh1Iv9QLbnNFqtqG0uwuLtzn/pkDXD94Z+vfY=;
	b=k5gVCJOWbrHdytBdkHQcBnlNqANwRa7Xp5iy0CCVoVHwLAR1U5Jh6YQpf7kccXnB03bp
	 ga09urW2SnKnLLobEVuH4UiN+Cv1+UXT0W8s+rBzTcLlnEoIqZwipu+7YNvtKJZ8aZy8U
	 AO2qkDPYc4gjQBxOEriAD1QoAvyNMWVi+9fJCm79kVBOw6qUUkPpGL5TcPpoecwdazgCp
	 AmeRkSqR0fcT8Q+AwViTUopQWzWi90i4VBtGTiDOuHyqwTSDV0JC5pFU1hR3GFkULn+C4
	 +tCbVlKwZQsadVU66a54QAlFKA8deP8LpCgp0+XGS2X6xCqmd04eUdPTUpdeeu+7FRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jo8fCLzQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D14606A31A;
	Thu, 29 Oct 2026 16:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jo8fCLzQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E314D1F01816;
	Thu, 29 Oct 2026 16:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793292553;
	bh=5wi6r2Bh1Iv9QLbnNFqtqG0uwuLtzn/pkDXD94Z+vfY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jo8fCLzQXKF02wU2RYT3THNRYIo6oYKarU7ZSxQMGfgseSFX22gAow3w3didTfBiN
	 IDtqFugaiIQBFdhlXyAlM9Hb+KbjcnS4Kh0WQ5OePvIjoe35IpI5JqjQ/RB4Ad1rDg
	 LQieX2k5UTDQqOazFftaFHd/HB56LjtJIg9PwAuDvcnuRwtga0nV8oUsThcSBImJYt
	 mhEi7EM1F8PUgGauhXwwZ9LiiEF9fqBXghIsvYfiBpyUArpgidd/n4P2eB6/ronNaC
	 qX1DjrimPuZpkw77rx3TVi4ThEGAufAa/w5ag8O75EfYgjhfpT9lmIdAagdu0RrbSU
	 I5uBDOmRqYoIQ==
Date: Thu, 29 Oct 2026 17:49:10 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Peng Wang <peng_wang@linux.alibaba.com>
Cc: Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
	He Rongguang <herongguang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
	driver-core@lists.linux.dev, linux-trace-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/2] tick/nohz: Add a policy dependency for full
 dynticks
Message-ID: <auN5Bku9w2VDZFFX@localhost.localdomain>
References: <cover.1792242566.git.peng_wang@linux.alibaba.com>
 <58bc33cb018a2651e9cc3fc02baad7de4d543705.1792242566.git.peng_wang@linux.alibaba.com>
 <att2hiYaaHTIkzG9@localhost.localdomain>
 <atuMJiJEwbzGjiu4@MacBook-Pro.local>
 <auIbt5JAC2cHw5jr@localhost.localdomain>
 <auLqmMdd8RIdf6st@U-3K7XLPQ6-0046.local>
 <auNR5c6hXlb_FFkB@localhost.localdomain>
 <auNuLZiBZyHLFYUr@MacBook-Pro.local>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <auNuLZiBZyHLFYUr@MacBook-Pro.local>

Le Fri, Oct 30, 2026 at 12:02:53AM +0800, Peng Wang a écrit :
> > Ok in that case, do you know about the current work in progress
> > to make nohz_full opt-able through cpusets? It implies taking the
> > target CPUs offline shortly but the policy is to be setup before VM
> > is launched, right?
> 
> Not always. Waiman mentioned the cpuset work earlier; it could
> cover selecting the policy before a new VM starts.
> 
> Some customers express a preference for host tick suppression
> through the management interface when changing workloads within
> a running VM. The host operator decides whether to allow
> suppression on the CPUs backing that VM.

I think people should know ahead if they will run latency critical workloads
or common workloads in their VMs. Because those are completely different.

> 
> We want to support revisiting that decision while keeping those
> CPUs online and the VM running, with nohz_full membership
> unchanged. Could such an operation fit into the cpuset work?

If that is really necessary then I guess we can have a file to control that
in cpuset once the nohz_full interface is ready. Though I'm a bit skeptical due
to the overhead of user <-> kernel transitions and housekeeping.

Thanks.

> 
> Thanks,
> Peng
> 
> > 
> > Thanks.
> > 
> > -- 
> > Frederic Weisbecker
> > SUSE Labs

-- 
Frederic Weisbecker
SUSE Labs
