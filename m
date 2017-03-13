From: Andi Kleen <ak@linux.intel.com>
Subject: Re: WTH is going on with memory hotplug sysf interface (was: Re:
 [RFC PATCH] mm, hotplug: get rid of auto_online_blocks)
Date: Mon, 13 Mar 2017 16:16:04 -0700
Message-ID: <20170313231604.GF32070@tassilo.jf.intel.com>
References: <20170302142816.GK1404@dhcp22.suse.cz>
 <20170302180315.78975d4b@nial.brq.redhat.com>
 <20170303082723.GB31499@dhcp22.suse.cz>
 <20170303183422.6358ee8f@nial.brq.redhat.com>
 <20170306145417.GG27953@dhcp22.suse.cz>
 <20170307134004.58343e14@nial.brq.redhat.com>
 <20170309125400.GI11592@dhcp22.suse.cz>
 <20170310135807.GI3753@dhcp22.suse.cz>
 <20170310155333.GN3753@dhcp22.suse.cz>
 <20170313151100.GS31518@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170313151100.GS31518@dhcp22.suse.cz>
Sender: linux-acpi-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Igor Mammedov <imammedo@redhat.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, "K. Y. Srinivasan" <kys@microsoft.com>, David Rientjes <rientjes@google.com>, Daniel Kiper <daniel.kiper@oracle.com>, linux-api@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-s390@vger.kernel.org, xen-devel@lists.xenproject.org, linux-acpi@vger.kernel.org, qiuxishi@huawei.com, toshi.kani@hpe.com, xieyisheng1@huawei.com, slaoub@gmail.com, iamjoonsoo.kim@lge.com, vbabka@suse.cz, Zhang Zhen <zhenzhang.zhang@huawei.com>, Reza Arbab <arbab@linux.vnet.ibm.com>, Yasuaki Ishimatsu <yasu.isimatu@gmail.com>, Tang Chen <tangchen@cn.fujits>
List-Id: linux-api@vger.kernel.org

> and ARCH_SPARSEMEM_DEFAULT is enabeld on 64b. So I guess whatever was
> the reason to add this code back in 2006 is not true anymore. So I am
> really wondering. Do we absolutely need to assign pages which are not
> onlined yet to the ZONE_NORMAL unconditionally? Why cannot we put them
> out of any zone and wait for memory online operation to put them where
> requested?

I don't remember any specific reason. May have just been simplification.
Should be fine to use any zone.

-Andi
