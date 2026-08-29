Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0A41E9919;
	Sat, 29 Aug 2026 09:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787995687; cv=none; b=SYDqyBhRg2FUNbFjnkhAyNVxO1LUsEgjBW8EZldcbreEy37dqAzHqXrORUjgziQrgw+Kb5h+an/GrM8BxShiQ+ZXJhZatDsJ5vqeaWMPrh3wrvAtDqVVhoaTmDgDOzWURdscXb9nFF5SJuX0Qo0X522sW9bcewwB/HR0SW9GPBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787995687; c=relaxed/simple;
	bh=v/8YmhLrFnQRVVkJDwi/gdfTFBqsiyk2BeUZ+ACMX/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oAm7wZ0FOOVhbsWmxPRJFpdpmMSuu5RtPxfU4IWdYIGz6CJh0gqvBe9haoLbH4xQAhYCU/lDy/XGfhhrGRI9msNXTRn2GjhZAnMmomLM6B12p4usRw7nnnfERI43WtllGoObJ6oT0Er2u4RL3H6huwrreEdSku6kcV59mA3t6ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MgBO+uT5; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MgBO+uT5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gsx9FzCn0fYeIPez1WlJp41xEuPVWj4SvlX0oJHdrIk=; b=MgBO+uT5JRXLPLYJ2slbhZllMv
	jPZ0jbBQasvPZaSEPTCanzWK68CZziReYsRD7ykhO/Xs8gO+6ZLMxaUJ6sLbeCXgSZhAjDi4OT/72
	zypaCnWwMWy3RB+Csm7TtXL9ujEzeFGRydGNksD4W3eppzoxr48IsE9I+dLEqvX3+zCp4raNnzMwz
	QVVfCV/kq9qWmx3siUGyXd9TLqk4/2hXRjPcUgcR/u/zmA67Ak70R/MDQlban4dCjMKh071wHWb+P
	FVlrTDubxDdk3960Gk2O3LOke7eHU16j5H8mullUKrsHTXHCkJD+O3idnU7ZKqTfOgRJLJYPnOD3i
	cwixDHhw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1x0FLP-00000008mBV-1tk0;
	Sat, 29 Aug 2026 09:27:23 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 6551A300382; Sat, 29 Aug 2026 11:27:21 +0200 (CEST)
Date: Sat, 29 Aug 2026 11:27:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>,
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
Message-ID: <20260829092721.GB776954@noisy.programming.kicks-ass.net>
References: <cover.1787955777.git.tim.c.chen@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1787955777.git.tim.c.chen@linux.intel.com>

On Fri, Aug 28, 2026 at 03:29:07PM -0700, Tim Chen wrote:
 
> Feedbacks very welcome, especially on the interface shape (prctl vs. a QoS
> attribute), the kernel-owned-cookie choice, and whether the always/advise/
> never policy composition is the right model.

Who would be using this -- what workload prompted you do do this etc.

