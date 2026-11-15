Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.10
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794778264;
	b=jVvmAEIaig7IZIjQjkTK9B8h3kO7xZWICL54FF7zQH7uTsL0AUDvy2hn4ZATtmWIr58y
	 +v9Nw1jX2Hv7TwTsIJgEFENmC8cd4Djm6vkBpLdmiZIflG9S9UgU/t8l5ioN0HXKeLqvU
	 dz+tRNNlaaxmd7FjbT6rU7UynJRZ8eMPI//aojI4dgdzR/gWCo6GELlOScQ6m+XuVL7l1
	 PabUEOPLsNeVPZlFMW1l+jzUIxHkLHpJSnV09GQ6+Ww3BtRkFOi/PO8r/XW2ot7lintWU
	 ua6dOI68vUCqsoaAazuxTg9pj7LqnH49j+A5jvy9othxbUc7EgcZirBX/LaPnyzkivA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794778264;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=gI3pT+vyemFy2bR8tG+tuc3UaQlX4B8AkgTSVPpKmCY=;
	b=sckvIKkkv59YBBCrtLZlJOoB5Z+IC9978c7iO7h4o8fVbB7MCKY0tahnsoTyMOMJHL2N
	 HOeM/Z+wnE8tLUoFkgVO72fLYa5QjVRR6JVl9KPrnFlHcfq0iWLczR+rX83NB644Gor/6
	 eALxvZ4m3ixdjE3v1C5Ch55KzFGzkih0wyttWHuAlueU9kCJnrSj3SMUXdipaU1MM+jY4
	 yVSbIiEFGXhVmlNgXEpvzvcmpJIa+r4W5WJON+0Ie9PJ93LimNL9l14KTsNgV7OpFWBxd
	 YdZaZgs4Ka84hiU4C6di3jOzplG691a+MCL1Dgt4ssorXDCh3cWrLiWcbD+tlvVC3vQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=TD+YLUMO;
	arc=none smtp.remote-ip=192.198.163.10
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01380606A323;
	Sun, 15 Nov 2026 21:31:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 01380606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=TD+YLUMO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794778264; x=1826314264;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=jCKBvtDwsyaFaVJiupvEpl5700EKZdPVw5dmNxMVuSs=;
  b=TD+YLUMOnp++488g7wSsWJ0ThD7ZUhZZrt2FwQ+vCNbhKFmazb6zjQwj
   giAAeJfrUpPTe8uJ8T6nGUYqT1lQxhNSDBUAxI5fPK4346GSjFx4WCfZH
   dozPqUdWuonnecNfEevhuPj+GOx+wIKkBxcFHnO0egL19PbZreeW8+Cr3
   IPI4RUERSSiqA8zExqSvJMYeSE3Wor45n0C2hJhrjX/vuY3b+Ry+R/JDl
   5XCb6By/JKONm/unI4zzmiONb6Y4gGl+5/4gM0/f0FrymXOnggUv+Efb6
   tnfYhJkVYTpFkvJ+dpK7i+csrkc823lI95zhlpRWg2+vMAtmBAMSA9wup
   g==;
X-CSE-ConnectionGUID: B3Rr7MApSwSgoLcdBj0/8w==
X-CSE-MsgGUID: oV7OuvJ1S8KBPOai3//Uug==
X-IronPort-AV: E=McAfee;i="6800,10657,11967"; a="3403312"
X-IronPort-AV: E=Sophos;i="6.27,215,1787036400"; 
   d="scan'208";a="3403312"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2026 13:31:03 -0800
X-CSE-ConnectionGUID: bfSLt/uHSn+iE3PZ81FKKw==
X-CSE-MsgGUID: EdM1X6NaTzWv3nFMBfQyZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,215,1787036400"; 
   d="scan'208";a="9722593"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 15 Nov 2026 13:31:00 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xShoP-000000017LS-0Ahq;
	Sun, 15 Nov 2026 21:30:57 +0000
Date: Mon, 16 Nov 2026 05:30:11 +0800
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
Message-ID: <202611160554.MGBENVam-lkp@intel.com>
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
config: xtensa-allnoconfig (https://download.01.org/0day-ci/archive/20261116/202611160554.MGBENVam-lkp@intel.com/config)
compiler: xtensa-linux-gcc (GCC) 16.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261116/202611160554.MGBENVam-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611160554.MGBENVam-lkp@intel.com/

All errors (new ones prefixed by >>):

>> ./arch/xtensa/include/generated/asm/syscall_table.h:474:16: error: 'sys_set_robust_list2' undeclared here (not in a function); did you mean 'sys_set_robust_list'?
     474 | __SYSCALL(473, sys_set_robust_list2)
         |                ^~~~~~~~~~~~~~~~~~~~
   arch/xtensa/kernel/syscall.c:31:44: note: in definition of macro '__SYSCALL'
      31 | #define __SYSCALL(nr, entry)    (syscall_t)entry,
         |                                            ^~~~~

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
