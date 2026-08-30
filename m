Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B78E2D5C7A;
	Sun, 30 Aug 2026 22:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788130580; cv=none; b=iS7ZJzf5cjIhjKi8XR4V34MmRkkojfN2hE/Z9A9SW3ey3MR4aWFEC5y+vcTNDWpvV/fHxqJv7Zdo7zlOnCpEgeRNLWRbLNdOiTAOZhDPt5+TotVSvL7oMyOoGyZT+YzyOftshi5YVQsxbc2SIyFRVIA1s3MjuDQv7FE7JI/Jc/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788130580; c=relaxed/simple;
	bh=w2+MqKImWzvJSAsgyiI2Ii4OdoNpIUEYROMw5ChEGl8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FSH26Sxn+9DfL+Z2FUbI4ikyflCnvyRlE93bKSuajt88jBznhGZLZkPWRrJDO2JvMT6S+1mhsmbBBK/wJeYZ1HGQiCIj7I+2z2fSYndDJwjY9x8VTzW+JhjkUehtmUnSs118BOy7iIBT/Sj+96zyRknCUms8yGzOjLXytM9bqZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HsO29Q73; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HsO29Q73"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788130578; x=1819666578;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=w2+MqKImWzvJSAsgyiI2Ii4OdoNpIUEYROMw5ChEGl8=;
  b=HsO29Q73F2wZHId1/+MSz2yLzRuMdcKbqUGQ6GczG7oKyH3+aVqG1wyV
   i/DO7/IsxQrtB75s7cxZHSu6MUavqPoX0lUf/n0nxLVxfuO3BUfl8DkTW
   DZF/ogpquYmgxgjnnIzSb5MGKvlFUG3oEGSlh2m+lMC+Dm32GWjHw0l3W
   fYOe91qmvvGtt31+Yt3QrZso3y8nBFRcLwrPV/U7oWuFqbn2qEwwynghK
   8WJXkGxsIkmIP4fDpk7WVDbybVhaRyJkJR6PefaV6nmcQDFWEMgXiI+Ls
   uzPckbFcND60cGhOPjHIwJGI+4caGhENhg8anlkyD3nO+bLx6cAsXOyLk
   Q==;
X-CSE-ConnectionGUID: Ij15GTZNRtKBoPbcn9+p3Q==
X-CSE-MsgGUID: afoDczH5Tee+TBHZx06vvw==
X-IronPort-AV: E=McAfee;i="6800,10657,11891"; a="88462317"
X-IronPort-AV: E=Sophos;i="6.25,252,1779174000"; 
   d="scan'208";a="88462317"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2026 15:56:17 -0700
X-CSE-ConnectionGUID: RywSKtqsQvSRZEniFtSE1g==
X-CSE-MsgGUID: TucMrbV9Sc+der39RTEi7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,252,1779174000"; 
   d="scan'208";a="292139749"
Received: from igk-lkp-server01.igk.intel.com (HELO 32268bdb9915) ([10.211.93.152])
  by fmviesa002.fm.intel.com with ESMTP; 30 Aug 2026 15:56:12 -0700
Received: from kbuild by 32268bdb9915 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x0oRc-000000000GZ-40gG;
	Sun, 30 Aug 2026 22:56:08 +0000
Date: Mon, 31 Aug 2026 00:55:20 +0200
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
Subject: Re: [PATCH v5 6/6] selftests: prctl: Add test for long thread names
Message-ID: <202608310045.6IJtlqhj-lkp@intel.com>
References: <20260827-tonyk-long_name-v5-6-5fa843782a00@igalia.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260827-tonyk-long_name-v5-6-5fa843782a00@igalia.com>

Hi André,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 73e3f0710014fe6d4ed98cfc02292f6121db7558]

url:    https://github.com/intel-lab-lkp/linux/commits/Andr-Almeida/treewide-Get-rid-of-get_task_comm/20260827-152300
base:   73e3f0710014fe6d4ed98cfc02292f6121db7558
patch link:    https://lore.kernel.org/r/20260827-tonyk-long_name-v5-6-5fa843782a00%40igalia.com
patch subject: [PATCH v5 6/6] selftests: prctl: Add test for long thread names
config: loongarch-allyesconfig (https://download.01.org/0day-ci/archive/20260831/202608310045.6IJtlqhj-lkp@intel.com/config)
compiler: clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260831/202608310045.6IJtlqhj-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608310045.6IJtlqhj-lkp@intel.com/

All warnings (new ones prefixed by >>):

   security/smack/smack_lsm.c:150:8: error: call to undeclared function 'get_task_comm'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     150 |                 acc, get_task_comm(comm, tsk), note);
         |                      ^
   security/smack/smack_lsm.c:150:8: note: did you mean 'get_task_mm'?
   include/linux/sched/mm.h:151:26: note: 'get_task_mm' declared here
     151 | extern struct mm_struct *get_task_mm(struct task_struct *task);
         |                          ^
>> security/smack/smack_lsm.c:150:8: warning: format specifies type 'char *' but the argument has type 'int' [-Wformat]
     148 |         pr_info("Smack %s: (%s %s %s) %s %s\n", smk_bu_mess[rc],
         |                                       ~~
         |                                       %d
     149 |                 smk_of_task(tsp)->smk_known, oskp->smk_known,
     150 |                 acc, get_task_comm(comm, tsk), note);
         |                      ^~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/printk.h:584:34: note: expanded from macro 'pr_info'
     584 |         printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
         |                                 ~~~     ^~~~~~~~~~~
   include/linux/printk.h:511:60: note: expanded from macro 'printk'
     511 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                                                     ~~~    ^~~~~~~~~~~
   include/linux/printk.h:483:19: note: expanded from macro 'printk_index_wrap'
     483 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ~~~~    ^~~~~~~~~~~
   1 warning and 1 error generated.


vim +150 security/smack/smack_lsm.c

d166c8024d620d Casey Schaufler    2014-08-27  132  
fba3d32825f4bb Konstantin Andreev 2026-05-11  133  static int
fba3d32825f4bb Konstantin Andreev 2026-05-11  134  smk_bu_tsk_to_obj(struct task_struct *tsk, const struct task_smack *tsp,
fba3d32825f4bb Konstantin Andreev 2026-05-11  135  		  char *note, struct smack_known *oskp, int mode, int rc)
d166c8024d620d Casey Schaufler    2014-08-27  136  {
fba3d32825f4bb Konstantin Andreev 2026-05-11  137  #ifdef CONFIG_SECURITY_SMACK_BRINGUP
d166c8024d620d Casey Schaufler    2014-08-27  138  	char acc[SMK_NUM_ACCESS_TYPE + 1];
fba3d32825f4bb Konstantin Andreev 2026-05-11  139  	char comm[TASK_COMM_LEN];
d166c8024d620d Casey Schaufler    2014-08-27  140  
d166c8024d620d Casey Schaufler    2014-08-27  141  	if (rc <= 0)
d166c8024d620d Casey Schaufler    2014-08-27  142  		return rc;
bf4b2fee997997 Casey Schaufler    2015-03-21  143  	if (rc > SMACK_UNCONFINED_OBJECT)
bf4b2fee997997 Casey Schaufler    2015-03-21  144  		rc = 0;
d166c8024d620d Casey Schaufler    2014-08-27  145  
d166c8024d620d Casey Schaufler    2014-08-27  146  	smk_bu_mode(mode, acc);
fba3d32825f4bb Konstantin Andreev 2026-05-11  147  
bf4b2fee997997 Casey Schaufler    2015-03-21  148  	pr_info("Smack %s: (%s %s %s) %s %s\n", smk_bu_mess[rc],
fba3d32825f4bb Konstantin Andreev 2026-05-11  149  		smk_of_task(tsp)->smk_known, oskp->smk_known,
fba3d32825f4bb Konstantin Andreev 2026-05-11 @150  		acc, get_task_comm(comm, tsk), note);
d166c8024d620d Casey Schaufler    2014-08-27  151  	return 0;
d166c8024d620d Casey Schaufler    2014-08-27  152  #else
fba3d32825f4bb Konstantin Andreev 2026-05-11  153  	return rc;
d166c8024d620d Casey Schaufler    2014-08-27  154  #endif
fba3d32825f4bb Konstantin Andreev 2026-05-11  155  }
fba3d32825f4bb Konstantin Andreev 2026-05-11  156  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
