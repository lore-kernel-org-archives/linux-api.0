From: James Morris <james.l.morris@oracle.com>
Subject: Re: [PATCH v2] sparc64: Add support for Application Data Integrity
 (ADI)
Date: Tue, 08 Mar 2016 20:33:01 +1100
Message-ID: <56DE9C4D.8000709@oracle.com>
References: <1456951177-23579-1-git-send-email-khalid.aziz@oracle.com> <20160305.230702.1325379875282120281.davem@davemloft.net> <56DD9949.1000106@oracle.com> <20160307.115626.807716799249471744.davem@davemloft.net> <56DDC2B6.6020009@oracle.com> <CALCETrXN43nT4zq2MpO90VrgK3k+DKHjOHWf7iOhS7TSBmdCPQ@mail.gmail.com> <56DDC6E0.4000907@oracle.com> <CALCETrU5NCzh3b7We8903G0_Tm-oycgP3+gS9fG+vC_rdgTddw@mail.gmail.com> <56DDDA31.9090105@oracle.com> <CALCETrXXU0fs2ezq+Wn_kr4dZTO=0RJmt6b=XBSA-wM7W_9j9A@mail.gmail.com> <56DE1341.4080206@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <56DE1341.4080206@oracle.com>
Sender: owner-linux-mm@kvack.org
To: Andy Lutomirski <luto@amacapital.net>, Khalid Aziz <khalid.aziz@oracle.com>
Cc: David Miller <davem@davemloft.net>, Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, dingel@linux.vnet.ibm.com, bob.picco@oracle.com, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Andrea Arcangeli <aarcange@redhat.com>, Arnd Bergmann <arnd@arndb.de>, sparclinux@vger.kernel.org, Rob Gardner <rob.gardner@oracle.com>, Michal Hocko <mhocko@suse.cz>, chris.hyser@oracle.com, Richard Weinberger <richard@nod.at>, Vlastimil Babka <vbabka@suse.cz>, Konstantin Khlebnikov <koct9i@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Greg Thelen <gthelen@google.com>, Jan Kara <jack@suse.cz>, xiexiuqi@huawei.com, Vineet.Gupta1@synopsys.com, Andrew Lutomirski <luto@kernel.org>, "Eric W. Biederman" <ebiederm@xmissio>
List-Id: linux-api@vger.kernel.org

On 03/08/2016 10:48 AM, James Morris wrote:
> On 03/08/2016 06:54 AM, Andy Lutomirski wrote:
>>
>> This makes sense, but I still think the design is poor.  If the hacker
>> gets code execution, then they can trivially brute force the ADI bits.
>>
>
> ADI in this scenario is intended to prevent the attacker from gaining
> code execution in the first place.

Here's some more background from Enrico Perla (who literally wrote the 
book on kernel exploitation):

https://blogs.oracle.com/enrico/entry/hardening_allocators_with_adi

Probably the most significant advantage from a security point of view is 
the ability to eliminate an entire class of vulnerability: adjacent heap 
overflows, as discussed above, where, for example, adjacent heap objects 
are tagged differently.  Classic linear buffer overflows can be eliminated.

As Kees Cook outlined at the 2015 kernel summit, it's best to mitigate 
classes of vulnerabilities rather than patch each instance:

https://outflux.net/slides/2011/defcon/kernel-exploitation.pdf

The Linux ADI implementation is currently very rudimentary, and we 
definitely welcome continued feedback from the community and ideas as it 
evolves.

- James

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
