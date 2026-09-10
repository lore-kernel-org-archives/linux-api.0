Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6884F37D124;
	Thu, 10 Sep 2026 23:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789082918; cv=none; b=undDWXoYA+D5yDITaCyqnIqGlX2y3gSFSdw8A816Equ4uhkCojDOxnJ9TaE9SvjxktJLdx5WTPSTFo1EUd/zwP6xjgqGzmzOFKEOG+C10X5Tls1k2OeKaLLAKlN49koxrVMplEhprB3kZ7ziPtgNLKOcrrPWteDtUDKZOda+wgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789082918; c=relaxed/simple;
	bh=DgNdupqIuoM6Ye8S4SN3R8N1EJA7LjIiIGno1ybJ9GA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Apoj3w4eRSYF5YSgOmt2C2Q1RTba0ScCKuwpldK8HIZ3htULVfmPEHOvUgfk4yeG1s6DKLa0oTB1ew1TxfKdQnGkx0bH32DiEOsAL9PiBPGh2DJzEfWUdbgtjGcINtiYb1kljvBoSZ1mN6ug9wdMrxyQ2qOZJZVXrPTncH9XcB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AjnVxQNz; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AjnVxQNz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789082916; x=1820618916;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=DgNdupqIuoM6Ye8S4SN3R8N1EJA7LjIiIGno1ybJ9GA=;
  b=AjnVxQNzAtNKlum+QjCJyTgRVYvukbH1A0t4u5dzOiuJtznNXvDg9T/5
   nGIrr1Z18Deewyixndw48plK/LkBU1DDUiW4w+H8SarFr0dnM/Zw6a63k
   ozeM9FaGT4F/S2qou8oFa4sdwngf05ynRznHK81BGtIbLCvzvNCjtx+m3
   R2+19lnH5dIH+ToAX40R0pkruKH+n8I1hbK+yCOuwovIdVX506BWtHz77
   mfoJS9tXbVl+mxmmUce1XplruwqsHM7c+yAa7hm3KFkqZ0PEdpn2kqcVl
   RntiPYWPmIkWEaxnHxwzLg6WNfqFxO+EbT0D7ebXeLMUkp/VZnFWVuLXs
   g==;
X-CSE-ConnectionGUID: /ayukqpYQw6KmQa1smSm1Q==
X-CSE-MsgGUID: kdN16iTgSxaJBL7+BmTh/w==
X-IronPort-AV: E=McAfee;i="6800,10657,11901"; a="100708160"
X-IronPort-AV: E=Sophos;i="6.27,96,1787036400"; 
   d="scan'208";a="100708160"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2026 16:28:35 -0700
X-CSE-ConnectionGUID: oX/RXOhMQ161etZcOVP3Kg==
X-CSE-MsgGUID: WiuMzg2GR7aHXS37Ronh3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,96,1787036400"; 
   d="scan'208";a="265565929"
Received: from unknown (HELO [10.241.243.185]) ([10.241.243.185])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2026 16:28:35 -0700
Message-ID: <bc2b92b6c9d0d63123adb9f5a2e29b6ec193792f.camel@linux.intel.com>
Subject: Re: [RFC PATCH 0/7] sched/cache: Per-task control of cache aware
 scheduling via prctl
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Shrikanth Hegde <sshegde@linux.ibm.com>, Peter Zijlstra
	 <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Vincent Guittot
 <vincent.guittot@linaro.org>,  Qais Yousef <qyousef@layalina.io>, K Prateek
 Nayak <kprateek.nayak@amd.com>, Juri Lelli	 <juri.lelli@redhat.com>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,  Valentin Schneider	
 <vschneid@redhat.com>, Madadi Vineeth Reddy <vineethr@linux.ibm.com>, 
 Jianyong Wu <jianyong.wu@outlook.com>, Yangyu Chen <cyy@cyyself.name>,
 Tingyin Duan <tingyin.duan@gmail.com>,  Vern Hao <vernhao@tencent.com>,
 Vern Hao <haoxing990@gmail.com>, Len Brown <len.brown@intel.com>,  Aubrey
 Li <aubrey.li@intel.com>, Zhao Liu <zhao1.liu@intel.com>, Chen Yu
 <yu.chen.surf@gmail.com>,  Chen Yu <yu.c.chen@intel.com>, Adam Li
 <adamli@os.amperecomputing.com>, Aaron Lu	 <ziqianlu@bytedance.com>, Tim
 Chen <tim.c.chen@intel.com>, Josh Don	 <joshdon@google.com>, Luo Gengkun
 <luogengkun2@huawei.com>, Gavin Guo	 <gavinguo@igalia.com>, Yi Lai
 <yi1.lai@intel.com>, Ricardo Neri	 <ricardo.neri@intel.com>,
 linux-kernel@vger.kernel.org, 	linux-api@vger.kernel.org
Date: Thu, 10 Sep 2026 16:28:34 -0700
In-Reply-To: <f0b6a0c3-4fa6-4f8c-99a0-a3c1a73507f3@linux.ibm.com>
References: <cover.1787955777.git.tim.c.chen@linux.intel.com>
	 <f0b6a0c3-4fa6-4f8c-99a0-a3c1a73507f3@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 (3.58.1-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2026-09-09 at 18:27 +0530, Shrikanth Hegde wrote:
> Hi Tim/Peter.
>=20
> I have been trying to catch up. I still have to read
> and might have missed some conversation details. So please
> bear with me for silly questions.

Thanks for taking a look.  You questions are helpful for
providing the context of why this series was proposed.

>=20
> On 8/29/26 3:59 AM, Tim Chen wrote:
> > Hi all,
> >=20
> > Cache aware scheduling today groups tasks by their mm: the LLC aggregat=
ion
> > target lives in mm_struct, so the address space is the unit of grouping=
.
> > That works, but in some scenarios that is too coarse and too eager, and=
 the
> > only knob we have over it is a single system-wide debugfs switch.
> >=20
> > It's too coarse because plenty of workloads share data across cooperati=
ng
> > *processes* rather than threads - a database with a process per connect=
ion,
> > a browser with a renderer per site, a server and its worker helpers. Th=
ey
> > pass data through shm or pipes and would love to be pulled onto the sam=
e
> > LLC, but they never share an mm, so today they can't be. And it's too e=
ager
> > in the other direction: a process whose threads don't actually share
> > anything gets aggregated anyway, just because they happen to sit in one
> > address space.
> >=20
> > So the core idea of this series is simple: allow other groupings than
> > the mm, make the grouping an object in its own right, and let user spac=
e
> > say "put these tasks together" explicitly.
>=20
> So, As you said, this is effectively asking user to make the decision.

By default, tasks are grouped by process and that make sense in many cases.
But sometimes the users have information about task characteristics that th=
ey wish to group
tasks in other ways.=20

In our discussions with Vern Hao from Tencent, they have multiple processes
in their workload, where some tasks in a process is responsible for
database access, some for encryption, and some dealing with disk access.
Those tasks across processes with similar function share more data than
tasks in a process for their applications. =20

Another scenario is grouping processes with shared memory together.

>=20
> But what tools do user space have today to make effective decisions?

As in the example above, this is for users who know about their workload
characteristics and wish to group their tasks in other way than the default
process grouping.

Also if people identify via perf c2c that tasks =20

> Application changes could turn out to be tricky to do and how an
> application developer will know whether to group them together or not?
> What's guidance there?

No changes is required on application. An admin or a separate daemon
can use prctl to group tasks together by sepcifying the pids pair of tasks
to be grouped. Please see the PR_SCHED_CACHE_SHARE_FROM operation in
patch 7 of the documentation.

>=20
> Can the grouping be done post the application started running?
> Like any option that says these pid's are to be bundled into one group?

Yes.

>=20
> I remember you guys discussed about cgroup and decided it is not a good o=
ption.
> That argument is still holds?

I think there is no strong case to support that tasks sharing
data necessarily belong in a cgroup. Using cgroup wouldn't cover all the us=
e cases
we want. With the proposed prctl based interface in this series,
the administrator can easily group the processes in a cgroup together
if that makes sense. We also would rather not disturb the cgroup
interface unnecessarily.

Tim
