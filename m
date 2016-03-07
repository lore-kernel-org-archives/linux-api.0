From: Khalid Aziz <khalid.aziz@oracle.com>
Subject: Re: [PATCH v2] sparc64: Add support for Application Data Integrity
 (ADI)
Date: Mon, 7 Mar 2016 11:15:16 -0700
Message-ID: <56DDC534.3040301@oracle.com>
References: <1456951177-23579-1-git-send-email-khalid.aziz@oracle.com>
 <56DDBBFD.8040106@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <56DDBBFD.8040106@intel.com>
Sender: owner-linux-mm@kvack.org
To: Dave Hansen <dave.hansen@intel.com>, davem@davemloft.net, corbet@lwn.net, akpm@linux-foundation.org, dingel@linux.vnet.ibm.com, zhenzhang.zhang@huawei.com, bob.picco@oracle.com, kirill.shutemov@linux.intel.com, aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, arnd@arndb.de, sparclinux@vger.kernel.org
Cc: rob.gardner@oracle.com, mhocko@suse.cz, chris.hyser@oracle.com, richard@nod.at, vbabka@suse.cz, koct9i@gmail.com, oleg@redhat.com, gthelen@google.com, jack@suse.cz, xiexiuqi@huawei.com, Vineet.Gupta1@synopsys.com, luto@kernel.org, ebiederm@xmission.com, bsegall@google.com, geert@linux-m68k.org, dave@stgolabs.net, adobriyan@gmail.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 03/07/2016 10:35 AM, Dave Hansen wrote:
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
>

All of the VMA splitting/merging code is rather generic and is very 
similar to the code for mbind, mlock, madavise and mprotect. Currently 
there is no code sharing across all of these implementations. Maybe that 
should change. In any case, I am looking at changing the interface to go 
through mprotect instead as Dave suggested. I can share the code in 
mprotect in that case. The only arch dependent part will be to set the 
VM_SPARC_ADI flag on the VMA.

Thanks,
Khalid

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
