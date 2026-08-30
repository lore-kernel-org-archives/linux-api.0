Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B96031283E;
	Sun, 30 Aug 2026 21:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788125112; cv=none; b=dyfQDYQVkgQJorgQW8zI9srT2dW7hgZvHv7bUeGiBbWqHw5oqtd35zBe1GfMg2wVhamN4uCqVDKsXgXsOlSi8MvPE9jMgDnElPcbf38VA7anjI9V45JaL38+CsPS6JnyUwSwg0GGveW4otBNU6AfTlWXEtQJbOcY/JZprDBCuoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788125112; c=relaxed/simple;
	bh=e3DGhgfryeBvmyMQZklEG0R0wT6o3YGyy8gco7UnuL8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KEiz5HgAMC0E84jwoQF8a0y+Q4wAl1zJqNzvv2gk4KS7N+xp/wJeICrjCp/RSowiM2Wc2CkZ70Weh9imW259dOVYFDKYifwA8En+fkOG00dp5SFETft75FS0TZBvMD1cFBnTSh0B98lhr24dUMRdhORrbJo9kxarroClT7WX1KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ObNHNS9/; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ObNHNS9/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788125109; x=1819661109;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=e3DGhgfryeBvmyMQZklEG0R0wT6o3YGyy8gco7UnuL8=;
  b=ObNHNS9/2EFUuvXoD+Xdm0VGptK6ad1b33h7XrnFDaUQSTUPmY4gC3lX
   n63jstf/j0BrwA82Rb9Oycj5URXtI/+vzKB3qoDMStZHr/968lgTDHpqN
   VbUakUF/1az/w/YAhYTbqky1r4EXEU8sva84XwxejLweH1KmMoofIMonm
   hWfdie+KR/PKr/sGw43Gxzr+X9oIC75gPPduEYrObHxo/r+jBk4SqUcCJ
   YK12MtuTHbc6YMjhPAQtme93EFJkz0rZzNLMjDMFOmbpO25P0eABJFbdE
   tSYQKbkcAwfoSxUi5aFJpOrSKDvS9TpVEHnexAU2sGEcOzeSzDpCjfw8V
   Q==;
X-CSE-ConnectionGUID: 4VEBySaDTe6GS/qB6wfDFA==
X-CSE-MsgGUID: T30f9QZJSou8ViZqx44RTg==
X-IronPort-AV: E=McAfee;i="6800,10657,11891"; a="100047251"
X-IronPort-AV: E=Sophos;i="6.25,252,1779174000"; 
   d="scan'208";a="100047251"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2026 14:25:09 -0700
X-CSE-ConnectionGUID: KMlicqj9QYiOJSs2SPAA8w==
X-CSE-MsgGUID: qnUquIXZQEukjLDuvMohTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,252,1779174000"; 
   d="scan'208";a="268075473"
Received: from igk-lkp-server01.igk.intel.com (HELO 32268bdb9915) ([10.211.93.152])
  by orviesa008.jf.intel.com with ESMTP; 30 Aug 2026 14:25:05 -0700
Received: from kbuild by 32268bdb9915 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x0n1S-000000000Dr-1DlD;
	Sun, 30 Aug 2026 21:25:02 +0000
Date: Sun, 30 Aug 2026 23:24:06 +0200
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
Message-ID: <202608302318.ORNqwjNf-lkp@intel.com>
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
config: m68k-allmodconfig (https://download.01.org/0day-ci/archive/20260830/202608302318.ORNqwjNf-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260830/202608302318.ORNqwjNf-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608302318.ORNqwjNf-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/asm-generic/bug.h:31,
                    from arch/m68k/include/asm/bug.h:32,
                    from include/linux/bug.h:5,
                    from include/linux/slab.h:15,
                    from include/linux/xattr.h:15,
                    from security/smack/smack_lsm.c:18:
   security/smack/smack_lsm.c: In function 'smk_bu_tsk_to_obj':
   security/smack/smack_lsm.c:150:22: error: implicit declaration of function 'get_task_comm'; did you mean 'set_task_comm'? [-Wimplicit-function-declaration]
     150 |                 acc, get_task_comm(comm, tsk), note);
         |                      ^~~~~~~~~~~~~
   include/linux/printk.h:483:33: note: in definition of macro 'printk_index_wrap'
     483 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
   include/linux/printk.h:584:9: note: in expansion of macro 'printk'
     584 |         printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   security/smack/smack_lsm.c:148:9: note: in expansion of macro 'pr_info'
     148 |         pr_info("Smack %s: (%s %s %s) %s %s\n", smk_bu_mess[rc],
         |         ^~~~~~~
>> include/linux/kern_levels.h:5:25: warning: format '%s' expects argument of type 'char *', but argument 6 has type 'int' [-Wformat=]
       5 | #define KERN_SOH        "\001"          /* ASCII Start Of Header */
         |                         ^~~~~~
   include/linux/printk.h:483:25: note: in definition of macro 'printk_index_wrap'
     483 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ^~~~
   include/linux/printk.h:584:9: note: in expansion of macro 'printk'
     584 |         printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/kern_levels.h:14:25: note: in expansion of macro 'KERN_SOH'
      14 | #define KERN_INFO       KERN_SOH "6"    /* informational */
         |                         ^~~~~~~~
   include/linux/printk.h:584:16: note: in expansion of macro 'KERN_INFO'
     584 |         printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
         |                ^~~~~~~~~
   security/smack/smack_lsm.c:148:9: note: in expansion of macro 'pr_info'
     148 |         pr_info("Smack %s: (%s %s %s) %s %s\n", smk_bu_mess[rc],
         |         ^~~~~~~


vim +5 include/linux/kern_levels.h

314ba3520e513a Joe Perches 2012-07-30  4  
04d2c8c83d0e3a Joe Perches 2012-07-30 @5  #define KERN_SOH	"\001"		/* ASCII Start Of Header */
04d2c8c83d0e3a Joe Perches 2012-07-30  6  #define KERN_SOH_ASCII	'\001'
04d2c8c83d0e3a Joe Perches 2012-07-30  7  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
