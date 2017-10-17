From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v4] mm, sysctl: make NUMA stats configurable
Date: Tue, 17 Oct 2017 10:14:02 +0200
Message-ID: <20171017081402.y5kz5i6puxcgrmkv@dhcp22.suse.cz>
References: <1508203258-9444-1-git-send-email-kemi.wang@intel.com>
 <20171017075420.dege7aabzau5wrss@dhcp22.suse.cz>
 <7103ce83-358e-2dfb-7880-ac2faea158f1@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <7103ce83-358e-2dfb-7880-ac2faea158f1@intel.com>
Sender: owner-linux-mm@kvack.org
To: kemi <kemi.wang@intel.com>
Cc: "Luis R . Rodriguez" <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, Mel Gorman <mgorman@techsingularity.net>, Johannes Weiner <hannes@cmpxchg.org>, Christopher Lameter <cl@linux.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Dave <dave.hansen@linux.intel.com>, Tim Chen <tim.c.chen@intel.com>, Andi Kleen <andi.kleen@intel.com>, Jesper Dangaard Brouer <brouer@redhat.com>, Ying Huang <ying.huang@intel.com>, Aaron Lu <aaron.lu@intel.com>, Proc sysctl <linux-fsdevel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue 17-10-17 16:03:44, kemi wrote:
> On 2017年10月17日 15:54, Michal Hocko wrote:
[...]
> > So basically any value will enable numa stats. This means that we would
> > never be able to extend this interface to e.g. auto mode (say value 2).
> > I guess you meant to check sysctl_vm_numa_stat == ENABLE_NUMA_STAT?
> > 
> 
> I meant to make it more general other than ENABLE_NUMA_STAT(non 0 is enough), 
> but it will make it hard to scale, as you said.
> So, it would be like this:
> 0 -- disable
> 1 -- enable
> other value is invalid.
> 
> May add option 2 later for auto if necessary:)

But if you allow to set 2 without EINVAL now then you cannot change it
in future.

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
