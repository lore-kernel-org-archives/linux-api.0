From: Khalid Aziz <khalid.aziz@oracle.com>
Subject: Re: [PATCH v2] sparc64: Add support for Application Data Integrity
 (ADI)
Date: Mon, 7 Mar 2016 11:22:24 -0700
Message-ID: <56DDC6E0.4000907@oracle.com>
References: <1456951177-23579-1-git-send-email-khalid.aziz@oracle.com>
 <20160305.230702.1325379875282120281.davem@davemloft.net>
 <56DD9949.1000106@oracle.com>
 <20160307.115626.807716799249471744.davem@davemloft.net>
 <56DDC2B6.6020009@oracle.com>
 <CALCETrXN43nT4zq2MpO90VrgK3k+DKHjOHWf7iOhS7TSBmdCPQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <CALCETrXN43nT4zq2MpO90VrgK3k+DKHjOHWf7iOhS7TSBmdCPQ@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: David Miller <davem@davemloft.net>, Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, dingel@linux.vnet.ibm.com, bob.picco@oracle.com, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Andrea Arcangeli <aarcange@redhat.com>, Arnd Bergmann <arnd@arndb.de>, sparclinux@vger.kernel.org, Rob Gardner <rob.gardner@oracle.com>, Michal Hocko <mhocko@suse.cz>, chris.hyser@oracle.com, Richard Weinberger <richard@nod.at>, Vlastimil Babka <vbabka@suse.cz>, Konstantin Khlebnikov <koct9i@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Greg Thelen <gthelen@google.com>, Jan Kara <jack@suse.cz>, xiexiuqi@huawei.com, Vineet.Gupta1@synopsys.com, Andrew Lutomirski <luto@kernel.org>, "Eric W. Biederman" <ebiederm@xmissi>
List-Id: linux-api@vger.kernel.org

On 03/07/2016 11:08 AM, Andy Lutomirski wrote:
> On Mon, Mar 7, 2016 at 10:04 AM, Khalid Aziz <khalid.aziz@oracle.com> wrote:
>> On 03/07/2016 09:56 AM, David Miller wrote:
>>>
>>> From: Khalid Aziz <khalid.aziz@oracle.com>
>>> Date: Mon, 7 Mar 2016 08:07:53 -0700
>>>
>>>> PR_GET_SPARC_ADICAPS
>>>
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
>> 1. Is PSTATE.mcde bit set for the process? PR_SET_SPARC_ADI provides this in
>> its return value in the patch I sent.
>>
>> 2. Is TTE.mcd set for a given virtual address? PR_GET_SPARC_ADI_STATUS
>> provides this function in the patch I sent.
>>
>> Setting and clearing version tags can be done entirely from userspace:
>>
>>          while (addr < end) {
>>                  asm volatile(
>>                          "stxa %1, [%0]ASI_MCD_PRIMARY\n\t"
>>                          :
>>                          : "r" (addr), "r" (version));
>>                  addr += adicap.blksz;
>>          }
>> so I do not have to add any kernel code for tags.
>
> Is the effect of that to change the tag associated with a page to
> which the caller has write access?

No, it changes the tag associated with the virtual address for the 
caller. Physical page backing this virtual address is unaffected. Tag 
checking is done for virtual addresses. The one restriction where 
physical address is relevant is when two processes map the same physical 
page, they both have to use the same tag for the virtual addresses that 
map on to the shared physical pages.

>
> I sense DoS issues in your future.
>

Are you concerned about DoS even if the tag is associated with virtual 
address, not physical address?

Thanks,
Khalid

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
