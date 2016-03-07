From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2] sparc64: Add support for Application Data Integrity
 (ADI)
Date: Mon, 07 Mar 2016 14:06:48 -0500 (EST)
Message-ID: <20160307.140648.619723704794000620.davem@davemloft.net>
References: <1456951177-23579-1-git-send-email-khalid.aziz@oracle.com>
	<56DDBBFD.8040106@intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <56DDBBFD.8040106@intel.com>
Sender: linux-doc-owner@vger.kernel.org
To: dave.hansen@intel.com
Cc: khalid.aziz@oracle.com, corbet@lwn.net, akpm@linux-foundation.org, dingel@linux.vnet.ibm.com, zhenzhang.zhang@huawei.com, bob.picco@oracle.com, kirill.shutemov@linux.intel.com, aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, arnd@arndb.de, sparclinux@vger.kernel.org, rob.gardner@oracle.com, mhocko@suse.cz, chris.hyser@oracle.com, richard@nod.at, vbabka@suse.cz, koct9i@gmail.com, oleg@redhat.com, gthelen@google.com, jack@suse.cz, xiexiuqi@huawei.com, Vineet.Gupta1@synopsys.com, luto@kernel.org, ebiederm@xmission.com, bsegall@google.com, geert@linux-m68k.org, dave@stgolabs.net, adobriyan@gmail.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Dave Hansen <dave.hansen@intel.com>
Date: Mon, 7 Mar 2016 09:35:57 -0800

> On 03/02/2016 12:39 PM, Khalid Aziz wrote:
>> +long enable_sparc_adi(unsigned long addr, unsigned long len)
>> +{
>> +	unsigned long end, pagemask;
>> +	int error;
>> +	struct vm_area_struct *vma, *vma2;
>> +	struct mm_struct *mm;
>> +
>> +	if (!ADI_CAPABLE())
>> +		return -EINVAL;
> ...
> 
> This whole thing with the VMA splitting and so forth looks pretty darn
> arch-independent.  Are you sure you need that much arch-specific code
> for it, or can you share more of the generic VMA management code?

This is exactly what I have suggested to him, and he has agreed to pursue.
