Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793289782;
	b=0lkZiUAJSsY1f3ZM71XZ5aB8s5f5/BpkFbcozkQdKtQVHi1Z5s3tp1xfmtKON3WqZpV2
	 TArzTO3KXQ1GYgWILNdBLTQCdlqlG+Q2Uc+v4s9vPcWHW4lyr3tM5xjk4Z7nB/+Kr6EIe
	 yom2drew08k3O7oEXHqGs85cVC4zXdkrZ1ttTZOM43lo3eTcvlfh8hEghRlHXaun920XX
	 yNvj12E3MX2ilS/5Wivq/vLQmry9EWEu7Ze3oJMI9bDn4GJ+cGuw6oQJKeMqgU8jvP3qT
	 eIzFmLOb5cTmJRi6jwwl4E0up1rnYEteWyTAUJ60zahx2kC7SswOqJZlh3K1TnsO2IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793289782;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Date:From:To:
	 Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=PPW5Q0x3JdxJm44k3yT7XZsAyL8QT3/iKNWG1q7+ESA=;
	b=yZXwookd7EAvQt7SRz63rT0WVal4QgnnDy7yARA+XiAGbBdkASH+6lPMnhkg/zpAY324
	 FGyyq8tVVG9HgoZlpj/VdN/p0nyScYxLojG7b/izBni9XAbq5fea48PR4ilwGHcrReqUu
	 3fhNjNe9XHy1crciYkbPvP22yx73Vhx5aucz3hblIB5Vnz9PSX2fLV96xNVZNdpEm1EuV
	 jMJksHi7eDRxP0/FRMFB47b2xJvMQvyw2bcmd8q7QX6iroWHKLnNZ/PGrIbLsKhChoDdd
	 IatWzWpUdFYph6vU3pK7x4DG+sPyKdlwFLycZz2RVwL+N13PfgPNjiz6pDZsTqlz46g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=j+eXamop;
	arc=none smtp.remote-ip=115.124.30.111
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3961A606A31C;
	Thu, 29 Oct 2026 16:02:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3961A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=j+eXamop
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793289775; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=PPW5Q0x3JdxJm44k3yT7XZsAyL8QT3/iKNWG1q7+ESA=;
	b=j+eXamopFcprMv9/BmpQ8UhrDYG7GrwvSCkH6W7MuhlrwJylVyWVljRGfHiwzRYR8rbzlCVF0ZCWHY6UxlxCXvkspPzEImWGDZIjnOh+whFHBMmokgvNqFuixT9Ag8XZitMVHTysnTEKfNIA1plYRuqWtcL3pOs+76wYJZiS9KE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=peng_wang@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0XDjrWUn_1793289774;
Received: from localhost(mailfrom:peng_wang@linux.alibaba.com fp:SMTPD_---0XDjrWUn_1793289774 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 30 Oct 2026 00:02:54 +0800
Date: Fri, 30 Oct 2026 00:02:53 +0800
From: Peng Wang <peng_wang@linux.alibaba.com>
To: Frederic Weisbecker <frederic@kernel.org>
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
Message-ID: <auNuLZiBZyHLFYUr@MacBook-Pro.local>
Reply-To: Peng Wang <peng_wang@linux.alibaba.com>
References: <cover.1792242566.git.peng_wang@linux.alibaba.com>
 <58bc33cb018a2651e9cc3fc02baad7de4d543705.1792242566.git.peng_wang@linux.alibaba.com>
 <att2hiYaaHTIkzG9@localhost.localdomain>
 <atuMJiJEwbzGjiu4@MacBook-Pro.local>
 <auIbt5JAC2cHw5jr@localhost.localdomain>
 <auLqmMdd8RIdf6st@U-3K7XLPQ6-0046.local>
 <auNR5c6hXlb_FFkB@localhost.localdomain>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <auNR5c6hXlb_FFkB@localhost.localdomain>

On Thu, Oct 29, 2026 at 03:02:13PM +0100, Frederic Weisbecker wrote:
> Le Thu, Oct 29, 2026 at 02:41:28PM +0800, Peng Wang a éãrit :
> > Hi Frederic,
> > 
> > > Do you mean that your database runs better when hosts CPUs are in nohz_full?
> > 
> > Yes. In our database tests, suppressing the host's non-idle
> > periodic tick improved performance, with the rest of the host
> > configuration unchanged.
> 
> Out of curiosity, for such database tests, only the host tick is off, not the guest
> tick, right?

Yes. Only the host's non-idle tick policy changed. The guest did
not use nohz_full, and its tick configuration was unchanged.

> 
> > > But how does this new interface help? Ie: why is it worse to have all CPUs in
> > 
> > The tick policy itself can therefore affect guest performance.
> > A large host runs VMs for many customers with different workloads.
> > Customers create and release VMs independently, so the same host
> > CPU can be reassigned to a different workload while other VMs
> > remain running.
> > 
> > We want to choose whether to retain the non-idle tick or allow its
> > suppression for the workload currently assigned to each CPU, and
> > revisit that choice when the CPU is reassigned. Per-CPU control
> > lets us do this without rebooting or taking CPUs offline.
> 
> Ok in that case, do you know about the current work in progress
> to make nohz_full opt-able through cpusets? It implies taking the
> target CPUs offline shortly but the policy is to be setup before VM
> is launched, right?

Not always. Waiman mentioned the cpuset work earlier; it could
cover selecting the policy before a new VM starts.

Some customers express a preference for host tick suppression
through the management interface when changing workloads within
a running VM. The host operator decides whether to allow
suppression on the CPUs backing that VM.

We want to support revisiting that decision while keeping those
CPUs online and the VM running, with nohz_full membership
unchanged. Could such an operation fit into the cpuset work?

Thanks,
Peng

> 
> Thanks.
> 
> -- 
> Frederic Weisbecker
> SUSE Labs
