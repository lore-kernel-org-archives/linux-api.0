Received: from mta1.migadu.com (out-1.mta1.migadu.com [95.215.58.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A05B4A3852
	for <linux-api@vger.kernel.org>; Mon, 31 Aug 2026 14:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788187191; cv=none; b=HZvxMCvlkoasEziML2jqm38pT65fy5LlkEWLfr4ArguUhxY44AMF2ZZ/IkAac+qKQY6puk9XcQ3WVS05gjKAmgugXJ6cEnauQLTm9V8F75X3Tca1uEicZFqSM0v2KkVOIpyKF9zLCS0cszZ+13YYQcsxGTiKoMY8mE/sAcZUmj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788187191; c=relaxed/simple;
	bh=RDses7JcBCw+jya5iQzYcg6OrFwbWpbRoBvLO73VAbo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BnB+KP5w1JrUpEVexPtvh4iQtgP+VfXumUS6o9SEf2njzmfuxQ+G55hcP8HFp8OL2E3YC3q0G5y7H+wSixa0dHuvaYxM1E4O2ZxSVmxhTdDOPZ+8D3iXEWzpIKh6E/JmdjhGFlQyIEMXcesFOfreULQyABWfWp5B0dV8BOXsYBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iDFIFF9c; arc=none smtp.client-ip=95.215.58.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iDFIFF9c"
X-Envelope-To: linux-api@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=RDses7JcBCw+jya5iQzYcg6OrFwbWpbRoBvLO73VAbo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788187186; v=1; x=1788791986;
 b=iDFIFF9cv4YEth7lifb0ooBn/W4WAka04oTMFZ7kFt54O4e1tmrrLgeomn9a5nz9xDDvB8su
 SDEfQcYZozne5poZOjQ0zvUY4hl+7sxq7p8Xa9LCB23417pZenStT/sSoD56fVipJ2MeLQRV3sG
 Vqw4yuYBUiu7RYuoj07msI7E=
X-Envelope-To: linux-api@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 0ec48833378b7742;
	Mon, 31 Aug 2026 14:39:46 +0000
X-Mizu-Trace-ID: 0ec48833378b7742
X-Migadu-Flow: FLOW_OUT
Date: Mon, 31 Aug 2026 22:39:21 +0800
From: Chen Yu <chen.yu@linux.dev>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Qais Yousef <qyousef@layalina.io>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Madadi Vineeth Reddy <vineethr@linux.ibm.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Jianyong Wu <jianyong.wu@outlook.com>,
	Yangyu Chen <cyy@cyyself.name>,
	Tingyin Duan <tingyin.duan@gmail.com>,
	Vern Hao <vernhao@tencent.com>, Vern Hao <haoxing990@gmail.com>,
	Len Brown <len.brown@intel.com>, Aubrey Li <aubrey.li@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>, Chen Yu <yu.chen.surf@gmail.com>,
	Chen Yu <yu.c.chen@intel.com>,
	Adam Li <adamli@os.amperecomputing.com>,
	Aaron Lu <ziqianlu@bytedance.com>, Tim Chen <tim.c.chen@intel.com>,
	Josh Don <joshdon@google.com>, Luo Gengkun <luogengkun2@huawei.com>,
	Gavin Guo <gavinguo@igalia.com>, Yi Lai <yi1.lai@intel.com>,
	Ricardo Neri <ricardo.neri@intel.com>, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org
Subject: Re: [RFC PATCH 0/7] sched/cache: Per-task control of cache aware
 scheduling via prctl
Message-ID: <apWSGWzDXikBI7GT@three-body>
References: <cover.1787955777.git.tim.c.chen@linux.intel.com>
 <20260829092721.GB776954@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260829092721.GB776954@noisy.programming.kicks-ass.net>

Hi Peter,

On Sat, Aug 29, 2026 at 11:27:21AM +0200, Peter Zijlstra wrote:
> Subject: Re: [RFC PATCH 0/7] sched/cache: Per-task control of cache aware
>  scheduling via prctl
> 
> On Fri, Aug 28, 2026 at 03:29:07PM -0700, Tim Chen wrote:
>  
> > Feedbacks very welcome, especially on the interface shape (prctl vs. a QoS
> > attribute), the kernel-owned-cookie choice, and whether the always/advise/
> > never policy composition is the right model.
> 
> Who would be using this -- what workload prompted you do do this etc.
>

One motivation is that some cloud users would like finer-grained control over
cache‑aware scheduling. Vern Hao from Tencent previously asked about this:

https://lore.kernel.org/all/7d5bb7c4-abc5-470e-84fe-72a3b1d3a2f4@gmail.com/

and mentioned that, in their production environment, threads within the same
process do not always share data. On the other hand, it is possible that within
one process there are two thread groups, A and B. Threads in group A share data
with each other, while threads in group B do not. Typically, in Vern's environment,
group A and group B are cgroups. Group A usually runs memory‑intensive workloads, such
as KV‑cache related ones, and such workloads have intensive data sharing among themselves,
so they would like to enable cache‑aware scheduling separately. Furthermore, since group A
is memory‑intensive, the default cache‑aware scheduling threshold might reject aggregation
because group A's memory footprint is high. As a result, group A has a requirement to turn the
threshold parameter separately.

thanks,
Chenyu
