From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [RFC PATCH] mm, hotplug: get rid of auto_online_blocks
Date: Thu, 2 Mar 2017 15:28:16 +0100
Message-ID: <20170302142816.GK1404@dhcp22.suse.cz>
References: <20170227154304.GK26504@dhcp22.suse.cz>
 <1488462828-174523-1-git-send-email-imammedo@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1488462828-174523-1-git-send-email-imammedo@redhat.com>
Sender: owner-linux-mm@kvack.org
To: Igor Mammedov <imammedo@redhat.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, "K. Y. Srinivasan" <kys@microsoft.com>, David Rientjes <rientjes@google.com>, Daniel Kiper <daniel.kiper@oracle.com>, linux-api@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-s390@vger.kernel.org, xen-devel@lists.xenproject.org, linux-acpi@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu 02-03-17 14:53:48, Igor Mammedov wrote:
[...]
> When trying to support memory unplug on guest side in RHEL7,
> experience shows otherwise. Simplistic udev rule which onlines
> added block doesn't work in case one wants to online it as movable.
> 
> Hotplugged blocks in current kernel should be onlined in reverse
> order to online blocks as movable depending on adjacent blocks zone.

Could you be more specific please? Setting online_movable from the udev
rule should just work regardless of the ordering or the state of other
memblocks. If that doesn't work I would call it a bug.

> Which means simple udev rule isn't usable since it gets event from
> the first to the last hotplugged block order. So now we would have
> to write a daemon that would
>  - watch for all blocks in hotplugged memory appear (how would it know)
>  - online them in right order (order might also be different depending
>    on kernel version)
>    -- it becomes even more complicated in NUMA case when there are
>       multiple zones and kernel would have to provide user-space
>       with information about zone maps
> 
> In short current experience shows that userspace approach
>  - doesn't solve issues that Vitaly has been fixing (i.e. onlining
>    fast and/or under memory pressure) when udev (or something else
>    might be killed)

yeah and that is why the patch does the onlining from the kernel.
 
> > Can you imagine any situation when somebody actually might want to have
> > this knob enabled? From what I understand it doesn't seem to be the
> > case.
> For x86:
>  * this config option is enabled by default in recent Fedora,

How do you want to support usecases which really want to online memory
as movable? Do you expect those users to disable the option because
unless I am missing something the in kernel auto onlining only supporst
regular onlining.
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
