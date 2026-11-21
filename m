Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795221371;
	b=PlIXzLCtceABJMGkQ0e5ecEJwWb97oCECWviMUIXj/u3QCAVuWdxOq0h9DcDZFmp+In8
	 +6IcfRoOs1b/Jc9N2AymHV7eX8E4UnDq6ZByIofXAfoNY4ajZLLNMr0C87yKUCpIkuVUf
	 EEyu364YsAQ7I2oaswkX4YuQuNELWYzCD+IAqw8xq2nj1yi3W4o9/cYSkIXShScMyBsCh
	 TCHbDNX6sLgjgG9fVN/2Hq7I1Qw0DZmgZ0qtmV6nV0VHK0l2dczXBiLIvfHp3HWmqdWcz
	 6ihq0rainugsa1NId6+t8lFGlACyPDpM1qDKuFgNAWuS0LV6FssD031SRu4k39QLQBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795221371;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=U/0XuajbgDayC8b7/gOQZ/dCtUSknit6rPJA2WUmI40=;
	b=FNAwWI1dxQr2AaVbu0wcH4w+djzV5qkDN0rJuSc8RFJYXimMhHmRB2zNV9C0fVvbhoPg
	 Bruw+3exYUKpbgGd7x1ThdN0S+QiIfLEiPGY4Qy1IaAl0LbNrYhrEA1nNJrgdY5KOnWFl
	 zeQHZWgtsbSc49Op5ZvVgpV/qAzbgqpcOe9EMN307ZpGnzAAZ9VMpYmJfoEuT1YqlzBil
	 IxP6P3zS37w8XuQ4iH5VUOS3uPeN8o8/+84rGaD090hB7a7UPPxd2YOrNG/79GT4Kzmwr
	 aHvAGIp0VvtNhNsmFS0GrHe5tOMls/SRyiIAVePtxbVXXVY3gYz/a9lj5r+mYsGN1sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="U58Y0/wQ";
	arc=none smtp.remote-ip=192.198.163.18
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC71C606A6A3;
	Sat, 21 Nov 2026 00:36:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC71C606A6A3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=U58Y0/wQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795221369; x=1826757369;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=2eDu3gGP65K8nxizJGWHJCwzKAZa5mWX3NYPVgpmuE4=;
  b=U58Y0/wQDPG/DwpA45TYON49OHcbV6ODYW0UyoQB0J4tFJ0SaURA0cZl
   3/jllUXo7NzL+/18pKEPHXHB+wvu3ZhGiRY9Q9rbAMTCmLoTo+p/Py1WQ
   nLngMx7hjZCsKt8FbfjMloDavRsqo7DUzZqkVh3hIHYAW0Ovsv0zy0dr3
   qVx7iZo7j738PhGqgW+vYzTbg4BrrpQyuip30+eiZQSfc3b2pRMClPBNU
   nEOs3BiJ8wCVMutK42FIujCbnpmYanv2DtSjyXVGT7bibpNfxZWmStYud
   qdp+TvL3Y6cgKzXLLMb0hNqSoyapmvkIKxtskgUwz6UxgcJVb4Uu5G5LR
   A==;
X-CSE-ConnectionGUID: 3qxTbvQISgW9gGLFPtQl8A==
X-CSE-MsgGUID: eMPnBQgqT+eHinyhzJqkaA==
X-IronPort-AV: E=McAfee;i="6800,10657,11972"; a="4139378"
X-IronPort-AV: E=Sophos;i="6.27,224,1787036400"; 
   d="scan'208";a="4139378"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 16:36:05 -0800
X-CSE-ConnectionGUID: TkUg6+zjTWKgMxqa7euqfA==
X-CSE-MsgGUID: oar82XJmQuqMkiuLvzDleg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,224,1787036400"; 
   d="scan'208";a="12646916"
Received: from igk-lkp-server01.igk.intel.com (HELO 1073a420ae3a) ([10.211.93.152])
  by fmviesa011.fm.intel.com with ESMTP; 20 Nov 2026 16:36:02 -0800
Received: from kbuild by 1073a420ae3a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xUZ5C-000000004C1-1t1H;
	Sat, 21 Nov 2026 00:35:58 +0000
Date: Sat, 21 Nov 2026 01:35:34 +0100
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
Subject: Re: [PATCH v8 05/10] futex: Create get_robust_list2() syscall
Message-ID: <20261121013133.eLi73Mpq-lkp@intel.com>
References: <20261115-tonyk-robust_futex-v8-5-a4fe47333a28@igalia.com>
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
In-Reply-To: <20261115-tonyk-robust_futex-v8-5-a4fe47333a28@igalia.com>

Hi André,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 9f74092fda91ef93c2b07585785c1dc83cd7971f]

url:    https://github.com/intel-lab-lkp/linux/commits/Andr-Almeida/futex-Skip-test_futex_robust_unlock-if-not-supported/20261115-143110
base:   9f74092fda91ef93c2b07585785c1dc83cd7971f
patch link:    https://lore.kernel.org/r/20261115-tonyk-robust_futex-v8-5-a4fe47333a28%40igalia.com
patch subject: [PATCH v8 05/10] futex: Create get_robust_list2() syscall
config: arm64-randconfig-r2300-20261120 (https://download.01.org/0day-ci/archive/20261121/20261121013133.eLi73Mpq-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 12.5.0
sparse: v0.6.5-rc1-21-g84ec0658
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261121/20261121013133.eLi73Mpq-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/20261121013133.eLi73Mpq-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   kernel/futex/syscalls.c:119:46: sparse: sparse: dereference of noderef expression
   kernel/futex/syscalls.c:216:14: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct robust_list_head *head @@     got struct robust_list_head [noderef] __user * @@
   kernel/futex/syscalls.c:216:14: sparse:     expected struct robust_list_head *head
   kernel/futex/syscalls.c:216:14: sparse:     got struct robust_list_head [noderef] __user *
>> kernel/futex/syscalls.c:218:16: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected void [noderef] __user *__rpu_val @@     got struct robust_list_head *head @@
   kernel/futex/syscalls.c:218:16: sparse:     expected void [noderef] __user *__rpu_val
   kernel/futex/syscalls.c:218:16: sparse:     got struct robust_list_head *head

vim +218 kernel/futex/syscalls.c

   170	
   171	SYSCALL_DEFINE4(get_robust_list2, int, pid,
   172			void __user * __user *, head_ptr,
   173			unsigned int, index, unsigned int, flags)
   174	{
   175		struct robust_list_head *head;
   176		void __user *entry_ptr;
   177		uintptr_t entry;
   178	
   179		if (index >= FUTEX_ROBUST_LISTS_PER_USER)
   180			return -EINVAL;
   181	
   182		if (flags)
   183			return -EINVAL;
   184	
   185		/*
   186		 * The first two indexes are reserved for the kernel to be used with the
   187		 * legacy syscall, so we hide them from userspace.
   188		 *
   189		 * We map [0, FUTEX_ROBUST_LISTS_PER_USER) to
   190		 *  [FUTEX_ROBUST_LIST2_IDX, FUTEX_ROBUST_LIST2_MAX_IDX)
   191		 */
   192		index += FUTEX_ROBUST_LIST2_IDX;
   193	
   194		entry_ptr = futex_get_robust_list_common(pid, false, index);
   195		if (IS_ERR(entry_ptr))
   196			return PTR_ERR(entry_ptr);
   197	
   198		entry = (uintptr_t) entry_ptr;
   199	
   200		if (futex_in_32bit_syscall()) {
   201			u32 entry32;
   202	
   203			if (entry && !(entry & FUTEX_ROBUST_LIST_ENTRY_32BIT))
   204				return -EOPNOTSUPP;
   205	
   206			entry32 = (u32)entry;
   207			entry32 &= FUTEX_ROBUST_LIST_ENTRY_MASK;
   208	
   209			if (copy_to_user(head_ptr, &entry32, sizeof(entry32)))
   210				return -EFAULT;
   211	
   212			return 0;
   213		}
   214	
   215		entry &= FUTEX_ROBUST_LIST_ENTRY_MASK;
   216		head = (__force struct robust_list_head __user *)entry;
   217	
 > 218		return put_user(head, head_ptr);
   219	}
   220	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
