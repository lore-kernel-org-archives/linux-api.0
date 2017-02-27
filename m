From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [RFC PATCH] mm, hotplug: get rid of auto_online_blocks
Date: Mon, 27 Feb 2017 12:50:19 +0100
Message-ID: <87a897x37o.fsf@vitty.brq.redhat.com>
References: <20170227092817.23571-1-mhocko@kernel.org>
	<87lgssvtni.fsf@vitty.brq.redhat.com> <20170227112510.GA4129@osiris>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170227112510.GA4129@osiris> (Heiko Carstens's message of "Mon,
	27 Feb 2017 12:25:10 +0100")
Sender: owner-linux-mm@kvack.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, "K. Y. Srinivasan" <kys@microsoft.com>, David Rientjes <rientjes@google.com>, Daniel Kiper <daniel.kiper@oracle.com>, linux-api@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-s390@vger.kernel.org, xen-devel@lists.xenproject.org, linux-acpi@vger.kernel.org, Michal Hocko <mhocko@suse.com>
List-Id: linux-api@vger.kernel.org

Heiko Carstens <heiko.carstens@de.ibm.com> writes:

> On Mon, Feb 27, 2017 at 11:02:09AM +0100, Vitaly Kuznetsov wrote:
>> A couple of other thoughts:
>> 1) Having all newly added memory online ASAP is probably what people
>> want for all virtual machines.

Sorry, obviously missed 'x86' in the above statement.

>
> This is not true for s390. On s390 we have "standby" memory that a guest
> sees and potentially may use if it sets it online. Every guest that sets
> memory offline contributes to the hypervisor's standby memory pool, while
> onlining standby memory takes memory away from the standby pool.
>
> The use-case is that a system administrator in advance knows the maximum
> size a guest will ever have and also defines how much memory should be used
> at boot time. The difference is standby memory.
>
> Auto-onlining of standby memory is the last thing we want.
>

This is actually a very good example of why we need the config
option. s390 kernels will have it disabled.

-- 
  Vitaly

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
