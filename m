Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B010E34A78E;
	Mon, 31 Aug 2026 17:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788195898; cv=none; b=ca9L2v8mGbGNXKLwqkPVUiHSxtASEaL03lMWgiScBf6zLCPJAmwete5F3J1Z0DQkW4bLI68a08YPk3sQRopK5UoHtvvu4BVesav/Y5u38BWLG8oMEOH1ZM3w37Nv4kVeaJYMeUkslziVi1O5EXWLutcgZMHyrsdFmKN4PTq8SDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788195898; c=relaxed/simple;
	bh=lG8xayAZb0TCrchSBn2U3X4gZ2fxxr4ler3a2QCsaWc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=I5S9c2L1Z6yKgrexTWnvScevnDVOJ7aE+UdTXFRWJgIaAcwPGBRQKrtXwbfCG7kkMn0qQbx0+eoESNrRXkbvC/iaEcOmgwDVyZ+8naRZ7fswjuN4AOhqELSDs6Sh6II7eOoHcGn3uWn4rDwtL4DVUwjw7ZZ/G4Vm0dk19slSfXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EJqo0KX9; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EJqo0KX9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788195897; x=1819731897;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=lG8xayAZb0TCrchSBn2U3X4gZ2fxxr4ler3a2QCsaWc=;
  b=EJqo0KX9oAnfWe2g/kg9BWtmR5MpRPcYY8GprY0pjkjj+VgPWjz3Mwv1
   VNnSZwTbfVUTaF/yZehY/hnnM8zwSj6OtuPk1MAc42MieeO7v/UMO4LKI
   PYRo81/gF3DlmO9/v14oSP+Uy5X49klc1NBh9ZNlTGZ0o7lC0CiJRkldO
   +6LoJa/HtpdUPKg00yTeINja53SEqoQRro78VNAEIkLidZXW/wmWK4fd7
   E8cFK2oNlbpnYG08xaGzDXxTfNl74K7vxa3ENyq1ag+o8xAPR7RY1zpv8
   8pfRs+PaZ39eqZmXYb8vUU7eOLlV51UXnwi9TqK5SzBFr/d5fpBQAWaJF
   Q==;
X-CSE-ConnectionGUID: s2nXCAtRQx6tTvfmfzyeew==
X-CSE-MsgGUID: MEs+cFOFRC+E8sV1yLMYIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11892"; a="87743465"
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="87743465"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 10:04:56 -0700
X-CSE-ConnectionGUID: YFLULgetTQSbKeRg0Bg4GQ==
X-CSE-MsgGUID: MG0a+PvbRH+GxSSH2wHQvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="264565479"
Received: from unknown (HELO [10.241.243.185]) ([10.241.243.185])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 10:04:54 -0700
Message-ID: <30768541782e981703b82227e67ab24942090980.camel@linux.intel.com>
Subject: Re: [RFC PATCH 0/7] sched/cache: Per-task control of cache aware
 scheduling via prctl
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Chen Yu <chen.yu@linux.dev>, Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Vincent Guittot
 <vincent.guittot@linaro.org>,  Qais Yousef <qyousef@layalina.io>, K Prateek
 Nayak <kprateek.nayak@amd.com>, Juri Lelli	 <juri.lelli@redhat.com>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,  Valentin Schneider	
 <vschneid@redhat.com>, Madadi Vineeth Reddy <vineethr@linux.ibm.com>, 
 Shrikanth Hegde <sshegde@linux.ibm.com>, Jianyong Wu
 <jianyong.wu@outlook.com>, Yangyu Chen <cyy@cyyself.name>,  Tingyin Duan
 <tingyin.duan@gmail.com>, Vern Hao <vernhao@tencent.com>, Vern Hao
 <haoxing990@gmail.com>,  Len Brown <len.brown@intel.com>, Aubrey Li
 <aubrey.li@intel.com>, Zhao Liu <zhao1.liu@intel.com>,  Chen Yu
 <yu.chen.surf@gmail.com>, Chen Yu <yu.c.chen@intel.com>, Adam Li	
 <adamli@os.amperecomputing.com>, Aaron Lu <ziqianlu@bytedance.com>, Tim
 Chen	 <tim.c.chen@intel.com>, Josh Don <joshdon@google.com>, Luo Gengkun	
 <luogengkun2@huawei.com>, Gavin Guo <gavinguo@igalia.com>, Yi Lai	
 <yi1.lai@intel.com>, Ricardo Neri <ricardo.neri@intel.com>, 
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Date: Mon, 31 Aug 2026 10:04:53 -0700
In-Reply-To: <apWSGWzDXikBI7GT@three-body>
References: <cover.1787955777.git.tim.c.chen@linux.intel.com>
	 <20260829092721.GB776954@noisy.programming.kicks-ass.net>
	 <apWSGWzDXikBI7GT@three-body>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 (3.58.1-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2026-08-31 at 22:39 +0800, Chen Yu wrote:
> Hi Peter,
>=20
> On Sat, Aug 29, 2026 at 11:27:21AM +0200, Peter Zijlstra wrote:
> > Subject: Re: [RFC PATCH 0/7] sched/cache: Per-task control of cache awa=
re
> >  scheduling via prctl
> >=20
> > On Fri, Aug 28, 2026 at 03:29:07PM -0700, Tim Chen wrote:
> > =20
> > > Feedbacks very welcome, especially on the interface shape (prctl vs. =
a QoS
> > > attribute), the kernel-owned-cookie choice, and whether the always/ad=
vise/
> > > never policy composition is the right model.
> >=20
> > Who would be using this -- what workload prompted you do do this etc.
> >=20
>=20
> One motivation is that some cloud users would like finer-grained control =
over
> cache=E2=80=91aware scheduling. Vern Hao from Tencent previously asked ab=
out this:
>=20
> https://lore.kernel.org/all/7d5bb7c4-abc5-470e-84fe-72a3b1d3a2f4@gmail.co=
m/
>=20
> and mentioned that, in their production environment, threads within the s=
ame
> process do not always share data. On the other hand, it is possible that =
within
> one process there are two thread groups, A and B. Threads in group A shar=
e data
> with each other, while threads in group B do not. Typically, in Vern's en=
vironment,
> group A and group B are cgroups. Group A usually runs memory=E2=80=91inte=
nsive workloads, such
> as KV=E2=80=91cache related ones, and such workloads have intensive data =
sharing among themselves,
> so they would like to enable cache=E2=80=91aware scheduling separately. F=
urthermore, since group A
> is memory=E2=80=91intensive, the default cache=E2=80=91aware scheduling t=
hreshold might reject aggregation
> because group A's memory footprint is high. As a result, group A has a re=
quirement to turn the
> threshold parameter separately.

I also remembered in discussions with Vern, His usage scenario has processe=
s each comprising of threads
doing different functions, like one thread responsible for database lookup,=
 one for encryption/decryption
and one for file IO ...etc. So the threads in different processes performin=
g similar function
has more common data and perform better when grouped together.

Also in separate discussions with Qais, he has also mentioned that
for his environment, tasks in the same process may not share data.
https://lore.kernel.org/lkml/20260219140828.a7pyzupun7lsdw34@airbuntu/ :

>> This initial implementation treats threads within the same process as
>> entities that are likely to share data. During load balancing, the

>This is a very aggressive assumption. From what I've seen, only few tasks =
truly
>share data. Lumping everything in a process together is an easy way to
>classify, but I think we can do better.

So this series is an attempt to address such cases where grouping
tasks by other criteria than mm makes sense.

Tim
