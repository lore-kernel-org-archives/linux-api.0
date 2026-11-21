Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.10
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795220106;
	b=aBzoge76y/SuMh5ICLVzmQEpJ79KG5+m1OieK/KX6vNL3mCIKBsDXKTsQEreBZNtslcJ
	 gZYGaYpNSNiCGSLJ4JZEQvlqNcnMFSmpjOLYJf3q874/7nbkkawxuTrbTz2W8H76jCkrP
	 vznaYLAo1Mh6i/b2FTgufhS1Pe8bQFIOWSPPwI39KB13oxb8Dnu5YeKgEN6Si2JLWwpHo
	 DXynFzMGstwEQ+fS85/NpWp+eYIQcdoH3oCBznpXLiwKkt2DmnU8UEZ3RYBsSk7sy30rZ
	 YKMjPvJebrc+wh+X4u9f6b2tNcBJlkTpzQLJXb/hrjNZdV8gqEwPbhn3ynHzNOK1qUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795220106;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=T9CC67yW6ZZZbDpmi5wzEAieGVvfyNJMz2LvQFuATaw=;
	b=UuC4LWTd68ZlfbiURATa8jrtXsxSIw+5dKPjpcqfCIKy+2CRlqE24RiuV/Zjmd5xlmFI
	 +xhhURg+oqW0HfL97hK5E7CqTFAeSKqHWVeUJU9hPDPH9Sy4r70Kv1JenJIT5nCxLrZQK
	 zKvao7Z0zfIxmD2VyBZd9rW+RwT7Wtj8hLgyj1jJH4PMr3DEapKDcymoMWFM9EbEoTA8x
	 GT0BOrF0ZpUt3tPTpnT0NLbpE/DcS8HdfX1r2eHshgrZzIdXeBu9AClYsJf5wR8aExmqD
	 uouk43/cH3p6p7VtZ+gtfkvxhX6Gnfisp7PGXuwBPovZIJFqX2DeG5Kab+XSIDeVbyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=BRWiYWJj;
	arc=none smtp.remote-ip=198.175.65.10
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E3D606A69E;
	Sat, 21 Nov 2026 00:15:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 31E3D606A69E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=BRWiYWJj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795220103; x=1826756103;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=2YbBBzcDwkZrNY/VJZvLtpxAvTQm8OTalckKPH6/sWs=;
  b=BRWiYWJjNswHMpNL1+jZHfMkpL0VJWvmxWqbkMHB3oWIk+C2ByJt9rHq
   g9GWJjtRMrV88nSDfNUW7tBqgMV5Wqc5U2HI4Jw6MdA4JnpcQ2ABpNBdQ
   sCbzi2KcGSv8l3F3CyH4EkR3yJ+6d7sPEfPgiuhSGryk2Op1rkli9ByMg
   /8JDNw+oGz2zMMtlyC9UOJqqTBqKdOauR9FFpH6WPPGed9t5Z0HDQjrqN
   K5eCGr2feDTuF5IUFcMtyX6V1Lg7hvkWgPe9IQdfv0r9doELgG6R+Q/ok
   AK/F585UafxYScdzjPytfp8eLDHVgjysfBtEyCa88Lz4pfy3dq1p803NV
   Q==;
X-CSE-ConnectionGUID: RoVjgKmMSR2CLrrbOpFV2Q==
X-CSE-MsgGUID: 5xnWl/21QWaBSllDn57XLw==
X-IronPort-AV: E=McAfee;i="6800,10657,11972"; a="4016795"
X-IronPort-AV: E=Sophos;i="6.27,223,1787036400"; 
   d="scan'208";a="4016795"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 16:15:02 -0800
X-CSE-ConnectionGUID: u+Cl7NC8TbqtpSeXfCYzuA==
X-CSE-MsgGUID: 89obI7y6Qmmo1VnltVOfvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,223,1787036400"; 
   d="scan'208";a="11236324"
Received: from igk-lkp-server01.igk.intel.com (HELO 1073a420ae3a) ([10.211.93.152])
  by fmviesa001.fm.intel.com with ESMTP; 20 Nov 2026 16:14:59 -0800
Received: from kbuild by 1073a420ae3a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xUYkr-000000004Bd-0fgS;
	Sat, 21 Nov 2026 00:14:57 +0000
Date: Sat, 21 Nov 2026 01:14:37 +0100
From: kernel test robot <lkp@intel.com>
To: =?iso-8859-1?Q?Andr=E9?= Almeida <andrealmeid@igalia.com>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Darren Hart <dvhart@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>, Arnd Bergmann <arnd@arndb.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Waiman Long <longman@redhat.com>,
	Ryan Houdek <Sonicadvance1@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-api@vger.kernel.org,
	kernel-dev@igalia.com,
	=?iso-8859-1?Q?Andr=E9?= Almeida <andrealmeid@igalia.com>
Subject: Re: [PATCH v8 04/10] futex: Create set_robust_list2() syscall
Message-ID: <20261121010932.k2PIHQOd-lkp@intel.com>
References: <20261115-tonyk-robust_futex-v8-4-a4fe47333a28@igalia.com>
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
In-Reply-To: <20261115-tonyk-robust_futex-v8-4-a4fe47333a28@igalia.com>

Hi André,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 9f74092fda91ef93c2b07585785c1dc83cd7971f]

url:    https://github.com/intel-lab-lkp/linux/commits/Andr-Almeida/futex-Skip-test_futex_robust_unlock-if-not-supported/20261115-143110
base:   9f74092fda91ef93c2b07585785c1dc83cd7971f
patch link:    https://lore.kernel.org/r/20261115-tonyk-robust_futex-v8-4-a4fe47333a28%40igalia.com
patch subject: [PATCH v8 04/10] futex: Create set_robust_list2() syscall
config: nios2-randconfig-r2306-20261120 (https://download.01.org/0day-ci/archive/20261121/20261121010932.k2PIHQOd-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 8.5.0
sparse: v0.6.5-rc1-21-g84ec0658
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261121/20261121010932.k2PIHQOd-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/20261121010932.k2PIHQOd-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> kernel/futex/syscalls.c:111:46: sparse: sparse: dereference of noderef expression

vim +111 kernel/futex/syscalls.c

   107	
   108	SYSCALL_DEFINE4(set_robust_list2, struct robust_list_head * __user, head, unsigned int,
   109			cmd, unsigned int, index, unsigned int, flags)
   110	{
 > 111		uintptr_t entry = (__force uintptr_t)head;
   112		size_t align = sizeof(u32);
   113		int ret;
   114	
   115		if (flags)
   116			return -EINVAL;
   117	
   118		if (cmd >= FUTEX_ROBUST_LIST_CMD_USER_MAX)
   119			return -EINVAL;
   120	
   121		if (cmd == FUTEX_ROBUST_LIST_CMD_CREATE_64 ||
   122		    cmd == FUTEX_ROBUST_LIST_CMD_MODIFY_64) {
   123			if (futex_in_32bit_syscall())
   124				return -EOPNOTSUPP;
   125			align = sizeof(u64);
   126		}
   127	
   128		switch (cmd) {
   129		case FUTEX_ROBUST_LIST_CMD_CREATE_64:
   130		case FUTEX_ROBUST_LIST_CMD_CREATE_32:
   131			if (index)
   132				return -EINVAL;
   133	
   134			if (entry % align)
   135				return -EINVAL;
   136	
   137			/*
   138			 * The first two indexes are reserved for the kernel to be used
   139			 * with the legacy syscall, so we hide them from userspace.
   140			 *
   141			 * We map [0, FUTEX_ROBUST_LISTS_PER_USER) to
   142			 *  [FUTEX_ROBUST_LIST2_IDX, FUTEX_ROBUST_LIST2_MAX_IDX)
   143			 */
   144			ret = futex_robust_list_create(entry, cmd);
   145	
   146			if (ret >= 0)
   147				ret -= FUTEX_ROBUST_LIST2_IDX;
   148	
   149			return ret;
   150	
   151		case FUTEX_ROBUST_LIST_CMD_MODIFY_64:
   152		case FUTEX_ROBUST_LIST_CMD_MODIFY_32:
   153			if (entry % align)
   154				return -EINVAL;
   155			return futex_robust_list_modify(entry, cmd, index);
   156		case FUTEX_ROBUST_LIST_CMD_LIST_LIMIT:
   157			return FUTEX_ROBUST_LISTS_PER_USER;
   158		}
   159	
   160		return -EINVAL;
   161	}
   162	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
