Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D862354A7E1;
	Wed,  9 Sep 2026 12:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788958726; cv=none; b=I0U2sgAhkuwTHwQI2FnsdDvQ4HX//tLYY0Dmzi6in8m5N7xglXakw/DBE7pFHb6PUwN0x0AbWXyMkAIFjYtxI0L3FweyKxwGdnSHkDaCYTQ1e9ThEPpm8hCGAXaB6G0eKsZ94cUPIDYoAw2IOd4j2kMQRMZ0hfk54sqr1ZrQQCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788958726; c=relaxed/simple;
	bh=P/GjnsVtcWHXfRx0BSUPNiYpu1+dngLkwr1fDX8Llv0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TIp02JkwXOZM+AYr86kRe+WkEmLJxRilNj83qDxcHpotna/og8cKivYh/2jULObvuykw8CdUnpS+iaW5VNdztoAdzCTcGz01wSfRD/Jlejxktu6+LB0x4xyFWyj3OVS/OS+FmmCfMZ4XAYcu7t/fIvfD1J8XXf+z6l3wqBpdYmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WHydVhYF; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WHydVhYF"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 689B1uaO1931497;
	Wed, 9 Sep 2026 12:57:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=YH2R2y
	tkM5UtQtNaVDud7KGFMBQiUVt3sENY+u2fbww=; b=WHydVhYFVuAmBQUJLmZwc7
	co+he40fq5koimV4pxl10tI5eiN1D3KLROumetbOuVo5HQSDbKSO4lWaUhPTFKEB
	K3cNOjV6tfqAU2J71eXXdAwZ02PM0IvimVjnDf6CFN3pIZnHcBEfgD3d5qE5U8PJ
	77XYukTPAJ6VHoAJmTvnUUqIQzjvXi5/4Z6zobc1A5wHQMKQ+Y4fc1EtccVDigKo
	p39+ldFNi1c65xsgTRDV0c/u4ewActGI3AjbgJBtq8mKKC1kgse6hYX7YXFXKi/q
	MzVEf5ODnZdQMp3LhW4lLfWF0yGnEWpFvU6nhMQ4M8T8Em0i+/+72zKmUp1OrGSA
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ggbqk5uxv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Sep 2026 12:57:53 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 689CuMFn011979;
	Wed, 9 Sep 2026 12:57:52 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ggymgj5nm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Sep 2026 12:57:52 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 689Cvo3p49414466
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 9 Sep 2026 12:57:50 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C06A12004E;
	Wed,  9 Sep 2026 12:57:50 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7590B2005A;
	Wed,  9 Sep 2026 12:57:41 +0000 (GMT)
Received: from [9.124.210.73] (unknown [9.124.210.73])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  9 Sep 2026 12:57:41 +0000 (GMT)
Message-ID: <f0b6a0c3-4fa6-4f8c-99a0-a3c1a73507f3@linux.ibm.com>
Date: Wed, 9 Sep 2026 18:27:40 +0530
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/7] sched/cache: Per-task control of cache aware
 scheduling via prctl
To: Tim Chen <tim.c.chen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Qais Yousef <qyousef@layalina.io>,
        K Prateek Nayak <kprateek.nayak@amd.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Madadi Vineeth Reddy <vineethr@linux.ibm.com>,
        Jianyong Wu <jianyong.wu@outlook.com>, Yangyu Chen <cyy@cyyself.name>,
        Tingyin Duan <tingyin.duan@gmail.com>, Vern Hao <vernhao@tencent.com>,
        Vern Hao <haoxing990@gmail.com>, Len Brown <len.brown@intel.com>,
        Aubrey Li <aubrey.li@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
        Chen Yu <yu.chen.surf@gmail.com>, Chen Yu <yu.c.chen@intel.com>,
        Adam Li <adamli@os.amperecomputing.com>,
        Aaron Lu <ziqianlu@bytedance.com>, Tim Chen <tim.c.chen@intel.com>,
        Josh Don <joshdon@google.com>, Luo Gengkun <luogengkun2@huawei.com>,
        Gavin Guo <gavinguo@igalia.com>, Yi Lai <yi1.lai@intel.com>,
        Ricardo Neri <ricardo.neri@intel.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
References: <cover.1787955777.git.tim.c.chen@linux.intel.com>
Content-Language: en-US
From: Shrikanth Hegde <sshegde@linux.ibm.com>
In-Reply-To: <cover.1787955777.git.tim.c.chen@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: YYBnDDqG9DhVtLl89RG2AxdUqwLEsrb5
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDE0MCBTYWx0ZWRfX6uan7egCfcnK
 b2ArM61rEWkuzyAnyg3C3h/8o84xypN8z0TiKqenLAVn0x5Bc8WjPZ680916rrR2oOnAKNOxAbn
 JWq0lq6OJ6R0Qwht0rxCyV8RqZc/09M=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDE0MCBTYWx0ZWRfX0w0i3Z2dUhOC
 IOGSKmiBYvCsYrsIy0sLib5XlbSOfjq5Ldn64B2NQmzvGpjNQwThNC917seNwBcsi/Q+XFop6eU
 8apiLl+PIZqG/QYI5dwkkQX3E4MLS8ERZzb35/2O1YaqS6xVWiF0YH6Ox/OyCXWVnABcMwlYIfe
 wOyRfalmTlBfElCLUsSIZgPzoAHOhA0COjCvHsYxsCjF63t7hkNEbiFvM6yXO0JC9tVhNiUphUW
 G/NU8DeKWucyithWuQZP1L+5KX74sQV5xWgCCMGxhuNLX8NFnqur1OmBA6Lu1rvDaRXI2Trp2ZP
 FMfpZ+e/o0o417alRuTtQsLrtIHP4Sa5zAk/WfOH4X2zFvV+9pNK1swdJxzsUMsR8ngRzGBPMqc
 BKrBTOxHkLpcgoqRlyFbBQKvkOqYCbnK9/GP2Mw96ChBndbt8rYyI0k/RA3D6naK2ckTAlnddHs
 tt1yaAn05x8cDYP3TXg==
X-Authority-Analysis: v=2.4 cv=JaKMa0KV c=1 sm=1 tr=0 ts=6aa157d2 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=TvwXzUd-0t_fAsFUuIcA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: pM-1tVMLu4egZEG2uO2PJVtyCkW1Fmt2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 adultscore=0 bulkscore=0 priorityscore=1501 suspectscore=0 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609090140

Hi Tim/Peter.

I have been trying to catch up. I still have to read
and might have missed some conversation details. So please
bear with me for silly questions.

On 8/29/26 3:59 AM, Tim Chen wrote:
> Hi all,
> 
> Cache aware scheduling today groups tasks by their mm: the LLC aggregation
> target lives in mm_struct, so the address space is the unit of grouping.
> That works, but in some scenarios that is too coarse and too eager, and the
> only knob we have over it is a single system-wide debugfs switch.
> 
> It's too coarse because plenty of workloads share data across cooperating
> *processes* rather than threads - a database with a process per connection,
> a browser with a renderer per site, a server and its worker helpers. They
> pass data through shm or pipes and would love to be pulled onto the same
> LLC, but they never share an mm, so today they can't be. And it's too eager
> in the other direction: a process whose threads don't actually share
> anything gets aggregated anyway, just because they happen to sit in one
> address space.
> 
> So the core idea of this series is simple: allow other groupings than
> the mm, make the grouping an object in its own right, and let user space
> say "put these tasks together" explicitly.

So, As you said, this is effectively asking user to make the decision.

But what tools do user space have today to make effective decisions?
Application changes could turn out to be tricky to do and how an
application developer will know whether to group them together or not?
What's guidance there?

Can the grouping be done post the application started running?
Like any option that says these pid's are to be bundled into one group?

I remember you guys discussed about cgroup and decided it is not a good option.
That argument is still holds?
