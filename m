From: Khalid Aziz <khalid.aziz@oracle.com>
Subject: Re: [PATCH v2] sparc64: Add support for Application Data Integrity
 (ADI)
Date: Mon, 7 Mar 2016 14:27:09 -0700
Message-ID: <56DDF22D.9090102@oracle.com>
References: <56DD9949.1000106@oracle.com>
 <20160307.115626.807716799249471744.davem@davemloft.net>
 <56DDC2B6.6020009@oracle.com>
 <20160307.140915.1323031236840000210.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20160307.140915.1323031236840000210.davem@davemloft.net>
Sender: owner-linux-mm@kvack.org
To: David Miller <davem@davemloft.net>
Cc: corbet@lwn.net, akpm@linux-foundation.org, dingel@linux.vnet.ibm.com, bob.picco@oracle.com, kirill.shutemov@linux.intel.com, aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, arnd@arndb.de, sparclinux@vger.kernel.org, rob.gardner@oracle.com, mhocko@suse.cz, chris.hyser@oracle.com, richard@nod.at, vbabka@suse.cz, koct9i@gmail.com, oleg@redhat.com, gthelen@google.com, jack@suse.cz, xiexiuqi@huawei.com, Vineet.Gupta1@synopsys.com, luto@kernel.org, ebiederm@xmission.com, bsegall@google.com, geert@linux-m68k.org, dave@stgolabs.net, adobriyan@gmail.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 03/07/2016 12:09 PM, David Miller wrote:
> From: Khalid Aziz <khalid.aziz@oracle.com>
> Date: Mon, 7 Mar 2016 11:04:38 -0700
>
>> On 03/07/2016 09:56 AM, David Miller wrote:
>>> From: Khalid Aziz <khalid.aziz@oracle.com>
>>> Date: Mon, 7 Mar 2016 08:07:53 -0700
>>>
>>>> PR_GET_SPARC_ADICAPS
>>>
>>> Put this into a new ELF auxiliary vector entry via ARCH_DLINFO.
>>>
>>> So now all that's left is supposedly the TAG stuff, please explain
>>> that to me so I can direct you to the correct existing interface to
>>> provide that as well.
>>>
>>> Really, try to avoid prtctl, it's poorly typed and almost worse than
>>> ioctl().
>>>
>>
>> The two remaining operations I am looking at are:
>>
>> 1. Is PSTATE.mcde bit set for the process? PR_SET_SPARC_ADI provides
>> this in its return value in the patch I sent.
>
> Unnecessary.  If any ADI mappings exist then mcde is set, otherwise it is
> clear.  This is internal state and the application has no need to every
> set nor query it.
>
> It is implicit from the mprotect() calls the user makes to enable ADI
> regions.
>
>> 2. Is TTE.mcd set for a given virtual address? PR_GET_SPARC_ADI_STATUS
>> provides this function in the patch I sent.
>
> Again, implied by the mprotect() calls.
>

Hi Dave,

I agree with your point of view. PSTATE.mcde and TTE.mcd are set in 
response to request from userspace. If userspace asked for them to be 
set, they already know but it was the database guys that asked for these 
two functions and they are the primary customers for the ADI feature. I 
am not crazy about this idea since this extends the mprotect API even 
further but would you consider using the return value from mprotect to 
indicate if PSTATE.mcde or TTE.mcd were already set on the given address?

Thanks,
Khalid

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
