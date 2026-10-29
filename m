Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793282537;
	b=ZbmJCcl+bo8Til7SD8n+G/jwTzOYEIBoCaeYvQQbsUgoLyOdOLrPYCcXwAYN5rUBEw+B
	 V7WPGE+ADOfezLyvdQ4S1TfHMp8kbIMGu36ezLG+GLdNXDFASSVc+rMj1y1ynYE/aSf8u
	 dE9qR46cQ8vXiMSeaszvr98Up9m/zNBscSBPDWCkuEFtH5rm7xeu14zR1UZVq6xky2+hu
	 7m+jb06ssa4vnLxp4yb+Ac0svnmzDXPiz0ndeNSF0EL4UaORHCDCUaMcgHBMSH5/VBKJl
	 m6Hm2sjuWrI6ab9Cx3zjuZAvXq9+G9jmSX/rB2gYf968xhWcfU2m+KXi4l85z2scvHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793282537;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=sw9b5i5WLSBIXyPstV+YM76/P9T1C9sWYcZnq+XWeW0=;
	b=O7eQS2XN77u7DgyRsMYQVnO6h0Pmjh74Ijq48k4n52IyCno39idoQ1S2+aJTmiFZaqYv
	 /n9ucrxgZPCwYY4e07poG3n04JkuM09fy8nJAQJ9bArCSw3Rn1CUX+oHY2CkNaVHhHbuh
	 FeW5/jT1tjdKEQlT6kYv+zWsZqQxnY0oh0taGtKm4RaRbwLfwy6a+ROZ70TCep9mCkx/u
	 Bz/+aFjN8WhYLo1c6znTjLtsZwKh8dyQKwRbNSAjeU/kVdmcf99yfpqkiA14xtyFUgCG+
	 IlkXt2hIfkPb7sKPZxGoyU7TizkSYM7Rwhv0bsRImB6EqBiJ4/HqkaTnJrNHKJTIisw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MC1JJf+V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F406D606A31D;
	Thu, 29 Oct 2026 14:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MC1JJf+V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12AA71F01825;
	Thu, 29 Oct 2026 14:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793282536;
	bh=sw9b5i5WLSBIXyPstV+YM76/P9T1C9sWYcZnq+XWeW0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MC1JJf+Vgr7VTcro43Hgd+be34yLuBACy41tB9UT8aTU/+EzRekP8IF/K/vKujBbI
	 PJvcYGlmTu9Fruo1jhk/qornxAqtHRSM8NZuIK3SA7KLLm66sEgQVIiQ1P+xWqKgFC
	 4JH1WO/i0OV3hp8z1h80pHFrxoEbWqKerj//C+3RJKk2lQOY5aKVNgagqClCY9uHKk
	 9rBgUhfTq01/ibUK7j/aWeW9Xd2E2YyQWawwcu5/msyJtiojL8JTRoTcXndFKVQpZn
	 8fJ7CLymIVVGhnF8jX2GJKXGHvAghDcsqzjNN/OsVdpeoFx0FJdS6Q71CJDpkMzQ3s
	 RDWgG3ZxcRKmA==
Date: Thu, 29 Oct 2026 15:02:13 +0100
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
Message-ID: <auNR5c6hXlb_FFkB@localhost.localdomain>
References: <cover.1792242566.git.peng_wang@linux.alibaba.com>
 <58bc33cb018a2651e9cc3fc02baad7de4d543705.1792242566.git.peng_wang@linux.alibaba.com>
 <att2hiYaaHTIkzG9@localhost.localdomain>
 <atuMJiJEwbzGjiu4@MacBook-Pro.local>
 <auIbt5JAC2cHw5jr@localhost.localdomain>
 <auLqmMdd8RIdf6st@U-3K7XLPQ6-0046.local>
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
In-Reply-To: <auLqmMdd8RIdf6st@U-3K7XLPQ6-0046.local>

Le Thu, Oct 29, 2026 at 02:41:28PM +0800, Peng Wang a écrit :
> Hi Frederic,
> 
> > Do you mean that your database runs better when hosts CPUs are in nohz_full?
> 
> Yes. In our database tests, suppressing the host's non-idle
> periodic tick improved performance, with the rest of the host
> configuration unchanged.

Out of curiosity, for such database tests, only the host tick is off, not the guest
tick, right?

> > But how does this new interface help? Ie: why is it worse to have all CPUs in
> 
> The tick policy itself can therefore affect guest performance.
> A large host runs VMs for many customers with different workloads.
> Customers create and release VMs independently, so the same host
> CPU can be reassigned to a different workload while other VMs
> remain running.
> 
> We want to choose whether to retain the non-idle tick or allow its
> suppression for the workload currently assigned to each CPU, and
> revisit that choice when the CPU is reassigned. Per-CPU control
> lets us do this without rebooting or taking CPUs offline.

Ok in that case, do you know about the current work in progress
to make nohz_full opt-able through cpusets? It implies taking the
target CPUs offline shortly but the policy is to be setup before VM
is launched, right?

Thanks.

-- 
Frederic Weisbecker
SUSE Labs
