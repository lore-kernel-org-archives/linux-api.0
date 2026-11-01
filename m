Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793491899;
	b=3MEHOFl/nd4JpBskZroJA7qjwPSCSq+v/AO9HysR7+C12IfzalgO3yu/UBQrKjasbp6d
	 JGmc/LQDqOPL9zeFhlvOJyLv8JWnBs5Xwn7kED1W+DR07X+v0/TyKo6+e3qbwCrpvtUXx
	 ZvBieCLx50g070A8L4QG6calWh5qeyIxJnk/xn1FMmXoBJDOd9SlRBHNZrTyz0MS3gNNf
	 rEeH5iiqcIn+CT3Y6FLyhevxaGsJ3c+bxOpQAYR8Ret9kRHivdllutH5LvsHU87DBYlK2
	 BrQBCVZzkymim1AkxIdgxyBmfoOviAtxtgwbkuUnzWVKMty4THU77GRvHshiWSBgSyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793491899;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=2EzAq3F/oZImqHNtfFN7yucFQTKmJ98J6mbsgnQaAnk=;
	b=pF7dZmO4LmjSNQeAydIxA/ooDPayjX7yEidS4Yncdvs/EyAJCj0OXiDkAGxvCXXXAHhT
	 p3qsvToWAFyd75RPDcdv8UdGvsWReyXyqOnCBsHyhY6cBup/CPZ+LwUlhl4YFpRufNewg
	 h+hmviTgh4fx5QYW/8TKgsZ2d3GaEdofCcc4PZ0jq6U3YrIOSc8JbdywcOY2+MBbfx6WB
	 jsA34WXBC3ra69xbuKKd3QFws5EOCaVQlxAYVCgvSGvTZ6Rv+0MqDbMYWBlUt1ZsoiFwl
	 80EMpdec1i/uK345HihXcETlu+FsofKU5dHe2aqYANlLawqkVNNo3Hgq62q53QO7sdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="ku4gpgB/";
	arc=none smtp.remote-ip=192.198.163.12
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66045606A31C;
	Sun,  1 Nov 2026 00:11:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 66045606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ku4gpgB/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793491897; x=1825027897;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=JxWINGtEXiE/19oIrBdKjOvxqg4jRzLQd0nxSgU6mLQ=;
  b=ku4gpgB/VHRLnWzSTwIfjQgUwAM0tU4WuXlNU3kEcpHXBtKTiNg78VJ5
   MTP8vTSZXuiK3RCABU1HT0RV4fC1h07TDe658sVIEz3Rf/UbYQnOcM1gI
   qvRhDbhkcg4xc9CEFs8RUh3BFyo47mn4kJ/H12cdnsR5J/teqK7Z2zgs/
   +NsgV1nNfT8dUBLKWbLMBNZhtft3slgiH0YoM4Qxc7/ia5gvtY7gUtOgc
   WaWps2WpDqfUL1rpewdpWLWMImuB/frwq/XZXIHEWBEDyFWNbuw5BIdmi
   zwZvhDzwYenLvGtg0u5TUP8AEjE41F7F3e3QgMeb0kqpCMO9r8X0lQCUg
   Q==;
X-CSE-ConnectionGUID: +ggxwgRVQo+MLcAYYTnAdw==
X-CSE-MsgGUID: 15JWxi0dQZ2eewat/82edQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11952"; a="2108915"
X-IronPort-AV: E=Sophos;i="6.27,188,1787036400"; 
   d="scan'208";a="2108915"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2026 17:11:36 -0700
X-CSE-ConnectionGUID: hWVuwracTrCN1bMAbJ7VaQ==
X-CSE-MsgGUID: 9l+96SLnSdSfe1kZ1buVAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,188,1787036400"; 
   d="scan'208";a="5762544"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 31 Oct 2026 17:11:32 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xNJAW-00000000dIq-1U6v;
	Sun, 01 Nov 2026 00:11:28 +0000
Date: Sun, 1 Nov 2026 08:10:33 +0800
From: kernel test robot <lkp@intel.com>
To: =?iso-8859-1?Q?Andr=E9?= Almeida <andrealmeid@igalia.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Christian Brauner <brauner@kernel.org>, Kees Cook <kees@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>, willy@infradead.org,
	mathieu.desnoyers@efficios.com,
	David Laight <david.laight.linux@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	akpm@linux-foundation.org, Yafang Shao <laoar.shao@gmail.com>,
	andrii.nakryiko@gmail.com, arnaldo.melo@gmail.com,
	Petr Mladek <pmladek@suse.com>
Cc: oe-kbuild-all@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>,
	kernel-dev@igalia.com, linux-mm@kvack.org,
	linux-api@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	=?iso-8859-1?Q?Andr=E9?= Almeida <andrealmeid@igalia.com>
Subject: Re: [PATCH v8 4/6] sched: Extend task command name with
 TASK_COMM_EXT_LEN
Message-ID: <202611010746.Qs8jUny8-lkp@intel.com>
References: <20261030-tonyk-long_name-v8-4-c9b030332254@igalia.com>
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
In-Reply-To: <20261030-tonyk-long_name-v8-4-c9b030332254@igalia.com>

Hi André,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 4dd16e31135ea8437a720222df34e8745f385d6d]

url:    https://github.com/intel-lab-lkp/linux/commits/Andr-Almeida/treewide-Get-rid-of-get_task_comm/20261030-183832
base:   4dd16e31135ea8437a720222df34e8745f385d6d
patch link:    https://lore.kernel.org/r/20261030-tonyk-long_name-v8-4-c9b030332254%40igalia.com
patch subject: [PATCH v8 4/6] sched: Extend task command name with TASK_COMM_EXT_LEN
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20261101/202611010746.Qs8jUny8-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261101/202611010746.Qs8jUny8-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611010746.Qs8jUny8-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/gpu/drm/nouveau/nouveau_chan.c: In function 'nouveau_channel_ctor':
>> drivers/gpu/drm/nouveau/nouveau_chan.c:343:58: warning: '%s' directive output may be truncated writing up to 63 bytes into a region of size 32 [-Wformat-truncation=]
     343 |         snprintf(args->name, __member_size(args->name), "%s[%d]",
         |                                                          ^~
   drivers/gpu/drm/nouveau/nouveau_chan.c:343:9: note: 'snprintf' output between 4 and 77 bytes into a destination of size 32
     343 |         snprintf(args->name, __member_size(args->name), "%s[%d]",
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     344 |                  current->comm, task_pid_nr(current));
         |                  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +343 drivers/gpu/drm/nouveau/nouveau_chan.c

ebb945a94bba2ce Ben Skeggs          2012-07-20  253  
5b8a43aeb9cbf6b Marcin Slusarz      2012-08-19  254  static int
5cca41ac70e5877 Ben Skeggs          2024-07-26  255  nouveau_channel_ctor(struct nouveau_cli *cli, bool priv, u64 runm,
06db7fded6dec88 Ben Skeggs          2022-06-01  256  		     struct nouveau_channel **pchan)
ebb945a94bba2ce Ben Skeggs          2012-07-20  257  {
152be54224de182 Danilo Krummrich    2023-10-02  258  	const struct nvif_mclass hosts[] = {
284ad706ad2f509 Ben Skeggs          2025-02-04  259  		{ BLACKWELL_CHANNEL_GPFIFO_B, 0 },
32cb1cc358ffed2 Ben Skeggs          2024-11-25  260  		{ BLACKWELL_CHANNEL_GPFIFO_A, 0 },
44f93b209e2afde Ben Skeggs          2024-11-25  261  		{    HOPPER_CHANNEL_GPFIFO_A, 0 },
06db7fded6dec88 Ben Skeggs          2022-06-01  262  		{    AMPERE_CHANNEL_GPFIFO_B, 0 },
7f4f35ea5b080e6 Ben Skeggs          2022-06-01  263  		{    AMPERE_CHANNEL_GPFIFO_A, 0 },
06db7fded6dec88 Ben Skeggs          2022-06-01  264  		{    TURING_CHANNEL_GPFIFO_A, 0 },
06db7fded6dec88 Ben Skeggs          2022-06-01  265  		{     VOLTA_CHANNEL_GPFIFO_A, 0 },
06db7fded6dec88 Ben Skeggs          2022-06-01  266  		{    PASCAL_CHANNEL_GPFIFO_A, 0 },
06db7fded6dec88 Ben Skeggs          2022-06-01  267  		{   MAXWELL_CHANNEL_GPFIFO_A, 0 },
06db7fded6dec88 Ben Skeggs          2022-06-01  268  		{    KEPLER_CHANNEL_GPFIFO_B, 0 },
06db7fded6dec88 Ben Skeggs          2022-06-01  269  		{    KEPLER_CHANNEL_GPFIFO_A, 0 },
06db7fded6dec88 Ben Skeggs          2022-06-01  270  		{     FERMI_CHANNEL_GPFIFO  , 0 },
06db7fded6dec88 Ben Skeggs          2022-06-01  271  		{       G82_CHANNEL_GPFIFO  , 0 },
06db7fded6dec88 Ben Skeggs          2022-06-01  272  		{      NV50_CHANNEL_GPFIFO  , 0 },
06db7fded6dec88 Ben Skeggs          2022-06-01  273  		{      NV40_CHANNEL_DMA     , 0 },
06db7fded6dec88 Ben Skeggs          2022-06-01  274  		{      NV17_CHANNEL_DMA     , 0 },
06db7fded6dec88 Ben Skeggs          2022-06-01  275  		{      NV10_CHANNEL_DMA     , 0 },
06db7fded6dec88 Ben Skeggs          2022-06-01  276  		{      NV03_CHANNEL_DMA     , 0 },
06db7fded6dec88 Ben Skeggs          2022-06-01  277  		{}
06db7fded6dec88 Ben Skeggs          2022-06-01  278  	};
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  279  	DEFINE_RAW_FLEX(struct nvif_chan_v0, args, name, TASK_COMM_LEN + 16);
5cca41ac70e5877 Ben Skeggs          2024-07-26  280  	struct nvif_device *device = &cli->device;
ebb945a94bba2ce Ben Skeggs          2012-07-20  281  	struct nouveau_channel *chan;
06db7fded6dec88 Ben Skeggs          2022-06-01  282  	const u64 plength = 0x10000;
06db7fded6dec88 Ben Skeggs          2022-06-01  283  	const u64 ioffset = plength;
06db7fded6dec88 Ben Skeggs          2022-06-01  284  	const u64 ilength = 0x02000;
06db7fded6dec88 Ben Skeggs          2022-06-01  285  	int cid, ret;
06db7fded6dec88 Ben Skeggs          2022-06-01  286  	u64 size;
06db7fded6dec88 Ben Skeggs          2022-06-01  287  
06db7fded6dec88 Ben Skeggs          2022-06-01  288  	cid = nvif_mclass(&device->object, hosts);
06db7fded6dec88 Ben Skeggs          2022-06-01  289  	if (cid < 0)
06db7fded6dec88 Ben Skeggs          2022-06-01  290  		return cid;
06db7fded6dec88 Ben Skeggs          2022-06-01  291  
06db7fded6dec88 Ben Skeggs          2022-06-01  292  	if (hosts[cid].oclass < NV50_CHANNEL_GPFIFO)
06db7fded6dec88 Ben Skeggs          2022-06-01  293  		size = plength;
06db7fded6dec88 Ben Skeggs          2022-06-01  294  	else
06db7fded6dec88 Ben Skeggs          2022-06-01  295  		size = ioffset + ilength;
ebb945a94bba2ce Ben Skeggs          2012-07-20  296  
ebb945a94bba2ce Ben Skeggs          2012-07-20  297  	/* allocate dma push buffer */
5cca41ac70e5877 Ben Skeggs          2024-07-26  298  	ret = nouveau_channel_prep(cli, size, &chan);
ebb945a94bba2ce Ben Skeggs          2012-07-20  299  	*pchan = chan;
ebb945a94bba2ce Ben Skeggs          2012-07-20  300  	if (ret)
ebb945a94bba2ce Ben Skeggs          2012-07-20  301  		return ret;
ebb945a94bba2ce Ben Skeggs          2012-07-20  302  
ebb945a94bba2ce Ben Skeggs          2012-07-20  303  	/* create channel object */
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  304  	args->version = 0;
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  305  	args->namelen = __member_size(args->name);
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  306  	args->runlist = __ffs64(runm);
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  307  	args->runq = 0;
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  308  	args->priv = priv;
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  309  	args->devm = BIT(0);
06db7fded6dec88 Ben Skeggs          2022-06-01  310  	if (hosts[cid].oclass < NV50_CHANNEL_GPFIFO) {
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  311  		args->vmm = 0;
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  312  		args->ctxdma = nvif_handle(&chan->push.ctxdma);
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  313  		args->offset = chan->push.addr;
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  314  		args->length = 0;
bbf8906b2cad17c Ben Skeggs          2014-08-10  315  	} else {
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  316  		args->vmm = nvif_handle(&chan->vmm->vmm.object);
06db7fded6dec88 Ben Skeggs          2022-06-01  317  		if (hosts[cid].oclass < FERMI_CHANNEL_GPFIFO)
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  318  			args->ctxdma = nvif_handle(&chan->push.ctxdma);
06db7fded6dec88 Ben Skeggs          2022-06-01  319  		else
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  320  			args->ctxdma = 0;
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  321  		args->offset = ioffset + chan->push.addr;
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  322  		args->length = ilength;
06db7fded6dec88 Ben Skeggs          2022-06-01  323  	}
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  324  	args->huserd = 0;
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  325  	args->ouserd = 0;
06db7fded6dec88 Ben Skeggs          2022-06-01  326  
06db7fded6dec88 Ben Skeggs          2022-06-01  327  	/* allocate userd */
06db7fded6dec88 Ben Skeggs          2022-06-01  328  	if (hosts[cid].oclass >= VOLTA_CHANNEL_GPFIFO_A) {
06db7fded6dec88 Ben Skeggs          2022-06-01  329  		ret = nvif_mem_ctor(&cli->mmu, "abi16ChanUSERD", NVIF_CLASS_MEM_GF100,
06db7fded6dec88 Ben Skeggs          2022-06-01  330  				    NVIF_MEM_VRAM | NVIF_MEM_COHERENT | NVIF_MEM_MAPPABLE,
06db7fded6dec88 Ben Skeggs          2022-06-01  331  				    0, PAGE_SIZE, NULL, 0, &chan->mem_userd);
06db7fded6dec88 Ben Skeggs          2022-06-01  332  		if (ret)
ebb945a94bba2ce Ben Skeggs          2012-07-20  333  			return ret;
ebb945a94bba2ce Ben Skeggs          2012-07-20  334  
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  335  		args->huserd = nvif_handle(&chan->mem_userd.object);
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  336  		args->ouserd = 0;
ebb945a94bba2ce Ben Skeggs          2012-07-20  337  
06db7fded6dec88 Ben Skeggs          2022-06-01  338  		chan->userd = &chan->mem_userd.object;
06db7fded6dec88 Ben Skeggs          2022-06-01  339  	} else {
06db7fded6dec88 Ben Skeggs          2022-06-01  340  		chan->userd = &chan->user;
06db7fded6dec88 Ben Skeggs          2022-06-01  341  	}
ebb945a94bba2ce Ben Skeggs          2012-07-20  342  
e270b3665f8321c Gustavo A. R. Silva 2025-04-16 @343  	snprintf(args->name, __member_size(args->name), "%s[%d]",
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  344  		 current->comm, task_pid_nr(current));
ebb945a94bba2ce Ben Skeggs          2012-07-20  345  
06db7fded6dec88 Ben Skeggs          2022-06-01  346  	ret = nvif_object_ctor(&device->object, "abi16ChanUser", 0, hosts[cid].oclass,
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  347  			       args, __struct_size(args), &chan->user);
06db7fded6dec88 Ben Skeggs          2022-06-01  348  	if (ret) {
06db7fded6dec88 Ben Skeggs          2022-06-01  349  		nouveau_channel_del(pchan);
ebb945a94bba2ce Ben Skeggs          2012-07-20  350  		return ret;
bbf8906b2cad17c Ben Skeggs          2014-08-10  351  	}
ebb945a94bba2ce Ben Skeggs          2012-07-20  352  
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  353  	chan->runlist = args->runlist;
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  354  	chan->chid = args->chid;
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  355  	chan->inst = args->inst;
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  356  	chan->token = args->token;
06db7fded6dec88 Ben Skeggs          2022-06-01  357  	return 0;
ebb945a94bba2ce Ben Skeggs          2012-07-20  358  }
ebb945a94bba2ce Ben Skeggs          2012-07-20  359  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
