From: Reza Arbab <arbab@linux.vnet.ibm.com>
Subject: Re: WTH is going on with memory hotplug sysf interface (was: Re:
 [RFC PATCH] mm, hotplug: get rid of auto_online_blocks)
Date: Fri, 10 Mar 2017 13:00:37 -0600
Message-ID: <20170310190037.fifahjd47joim6zy@arbab-laptop>
References: <1488462828-174523-1-git-send-email-imammedo@redhat.com>
 <20170302142816.GK1404@dhcp22.suse.cz>
 <20170302180315.78975d4b@nial.brq.redhat.com>
 <20170303082723.GB31499@dhcp22.suse.cz>
 <20170303183422.6358ee8f@nial.brq.redhat.com>
 <20170306145417.GG27953@dhcp22.suse.cz>
 <20170307134004.58343e14@nial.brq.redhat.com>
 <20170309125400.GI11592@dhcp22.suse.cz>
 <20170310135807.GI3753@dhcp22.suse.cz>
 <20170310155333.GN3753@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20170310155333.GN3753@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Igor Mammedov <imammedo@redhat.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, "K. Y. Srinivasan" <kys@microsoft.com>, David Rientjes <rientjes@google.com>, Daniel Kiper <daniel.kiper@oracle.com>, linux-api@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-s390@vger.kernel.org, xen-devel@lists.xenproject.org, linux-acpi@vger.kernel.org, qiuxishi@huawei.com, toshi.kani@hpe.com, xieyisheng1@huawei.com, slaoub@gmail.com, iamjoonsoo.kim@lge.com, vbabka@suse.cz, Zhang Zhen <zhenzhang.zhang@huawei.com>, Yasuaki Ishimatsu <yasu.isimatu@gmail.com>, Tang Chen <tangchen@cn.fujitsu.com>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 10, 2017 at 04:53:33PM +0100, Michal Hocko wrote:
>OK, so while I was playing with this setup some more I probably got why
>this is done this way. All new memblocks are added to the zone Normal
>where they are accounted as spanned but not present.

It's not always zone Normal. See zone_for_memory(). This leads to a 
workaround for having to do online_movable in descending block order. 
Instead of this:

1. probe block 34, probe block 33, probe block 32, ...
2. online_movable 34, online_movable 33, online_movable 32, ...

you can online_movable the first block before adding the rest:

1. probe block 32, online_movable 32
2. probe block 33, probe block 34, ...
	- zone_for_memory() will cause these to start Movable
3. online 33, online 34, ...
	- they're already in Movable, so online_movable is equivalentr

I agree with your general sentiment that this stuff is very 
nonintuitive.

-- 
Reza Arbab

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
