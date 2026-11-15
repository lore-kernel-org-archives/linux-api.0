Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.10
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794776217;
	b=0abiWuz968jGToF/5tdBBEQONBxGvALNTD7Hu4Dd6mh6as3oYX8jOHKD3tamA0asa/Lo
	 c8t30hiqSPESOQEp7o2gSNfKEw5ZcMgAWGJTjdrNUgCE0TSZ8PmI4Z6DY40e9v6wXoL/p
	 wyb8dONPM0CUxV78xKGD8x9VTHmySTFw9gIcfRYFOqMm+dNAsYah6VcogL3WrXKdMKgjU
	 bwfL24HaQ9X/D5rBUdbS6SN63Xj7JDHUDlFRxa+BQ38sHAV0c+LzybY/6946NHBbe9YGo
	 7EqI0OroAv7+n8MRqoq+zafA5+0N2NQdklyNz6G0L5eIuWZx9ZO/ZOTWxOQf6TL4w6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794776217;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=pQ18VYP4e0hHBSYVMyNIzTprFNB1v1N4VsN7V00lXUg=;
	b=3CwZvSMd8TzqZTPqAe2VQQxUNt03rALBQVHHzGjxhvf8DnWAkKI8wS6Oi0r2nQJfpd2n
	 02cUodA+UGYR+1ja+lF6H6NGYF4I3jH5ThbZP/TfWgRMn93cTHso0Pk8qX4zd8IkLX0NA
	 tYodTunxVIIIE/h3cCo+HsBYf0XBqXm3wkMF0VGxnVKs1BsXif6wULTQAjeY0lkiDpPMs
	 iJtTSJ/UKA88OSWnHhnkPiHVZQchW4iTzy6CaF+JricpuHlQ/AEKYLoV4T5ZNBwzkiru+
	 zYVAisWaz1dDwRScyuMiASgPkaanAAYujOPDlztJInul1yZXk1QkRfNdXO5EtBDuhkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=DNC3es+k;
	arc=none smtp.remote-ip=198.175.65.10
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62DB606A329;
	Sun, 15 Nov 2026 20:56:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E62DB606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=DNC3es+k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794776216; x=1826312216;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=sc4QS5AlKLJP7BylE7BZlLOkn14oXlThBi63pXetv8s=;
  b=DNC3es+kBTdoPG14pbF0Y+maxDdCtYMhJ3M48Wt/Z2NPk3q0YmcgsZGr
   gYBh0QwbOjEGLrvUFfRfegBhAq8tM5zsBp+RMUMzNaOH40PC34wFvj+g+
   XXGY8HHBJ+/9aB84Fqba1Pvd4JeUqCwPYuxYDVPLuuVTGOCTWbwOYRbVU
   2p+DmgGnVm0x8GeEk7YJkeazXRA2DkjAaMTZJvT1jDxhfZErAr2zfQg1A
   fJLLxnfYOvqAnMbQsj0l9hrWe0WguKyVSqVWqwGWqAY+TWVQh8hwv8Lab
   Zy8apvmqCtLnCIS/quwcfmHtN+eUW0k+odp98Q/Ae5HGBFWv0HZBGgDkv
   Q==;
X-CSE-ConnectionGUID: 1KHHu8UKSCWMeW6+XLphhQ==
X-CSE-MsgGUID: v/zwx0YhRDSea7vxppOvjw==
X-IronPort-AV: E=McAfee;i="6800,10657,11967"; a="3419001"
X-IronPort-AV: E=Sophos;i="6.27,215,1787036400"; 
   d="scan'208";a="3419001"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2026 12:56:56 -0800
X-CSE-ConnectionGUID: SLyD6Io5QK+/e3nuDZYyyg==
X-CSE-MsgGUID: oJ+ew8+xSnGKaDaj17OI9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,215,1787036400"; 
   d="scan'208";a="11108114"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa012.fm.intel.com with ESMTP; 15 Nov 2026 12:56:52 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xShHM-000000017Jc-3JnU;
	Sun, 15 Nov 2026 20:56:48 +0000
Date: Mon, 16 Nov 2026 04:55:57 +0800
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
Subject: Re: [PATCH v8 06/10] futex: Wire up set_robust_list2 syscall
Message-ID: <202611160433.ySzwblT6-lkp@intel.com>
References: <20261115-tonyk-robust_futex-v8-6-a4fe47333a28@igalia.com>
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
In-Reply-To: <20261115-tonyk-robust_futex-v8-6-a4fe47333a28@igalia.com>

Hi André,

kernel test robot noticed the following build errors:

[auto build test ERROR on 9f74092fda91ef93c2b07585785c1dc83cd7971f]

url:    https://github.com/intel-lab-lkp/linux/commits/Andr-Almeida/futex-Skip-test_futex_robust_unlock-if-not-supported/20261115-143110
base:   9f74092fda91ef93c2b07585785c1dc83cd7971f
patch link:    https://lore.kernel.org/r/20261115-tonyk-robust_futex-v8-6-a4fe47333a28%40igalia.com
patch subject: [PATCH v8 06/10] futex: Wire up set_robust_list2 syscall
config: openrisc-allnoconfig (https://download.01.org/0day-ci/archive/20261116/202611160433.ySzwblT6-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 16.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261116/202611160433.ySzwblT6-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611160433.ySzwblT6-lkp@intel.com/

All errors (new ones prefixed by >>):

>> ./arch/openrisc/include/generated/asm/syscall_table_32.h:474:16: error: 'sys_set_robust_list2' undeclared here (not in a function); did you mean 'sys_set_robust_list'?
     474 | __SYSCALL(473, sys_set_robust_list2)
         |                ^~~~~~~~~~~~~~~~~~~~
   arch/openrisc/kernel/sys_call_table.c:19:37: note: in definition of macro '__SYSCALL'
      19 | #define __SYSCALL(nr, call) [nr] = (call),
         |                                     ^~~~

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
