From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [RFC PATCH] mm: extend memfd with ability to create "secret"
 memory areas
Date: Thu, 6 Feb 2020 10:51:13 -0800
Message-ID: <df5a888b-1a11-e806-741d-94684b22c966@intel.com>
References: <20200130162340.GA14232@rapoport-lnx>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200130162340.GA14232@rapoport-lnx>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Christopher Lameter <cl@linux.com>, Dave Hansen <dave.hansen@linux.intel.com>, James Bottomley <jejb@linux.ibm.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Matthew Wilcox <willy@infradead.org>, Peter Zijlstra <peterz@infradead.org>, "Reshetova, Elena" <elena.reshetova@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Tycho Andersen <tycho@tycho.ws>, linux-api@vger.kernel.org, linux-mm@kvack.org
List-Id: linux-api@vger.kernel.org

On 1/30/20 8:23 AM, Mike Rapoport wrote:
>  include/linux/memfd.h      |   9 ++
>  include/uapi/linux/magic.h |   1 +
>  include/uapi/linux/memfd.h |   6 +
>  mm/Kconfig                 |   4 +
>  mm/Makefile                |   1 +
>  mm/memfd.c                 |  10 +-
>  mm/secretmem.c             | 244 +++++++++++++++++++++++++++++++++++++
>  7 files changed, 273 insertions(+), 2 deletions(-)

It seems pretty self-contained and relatively harmless.

But, how much work is it going to be to tell the rest of the kernel that
page_to_virt() doesn't work any more?  Do we need to make kmap() work on
these?

I guess fixing vm_normal_page() would fix a lot of that.

In general, my concern about creating little self-contained memory types
is that they will get popular and folks will start wanting more features
from them.  For instance, what if I want NUMA affinity, migration, or
large page mappings that are secret?

Can these pages work as guest memory?

Who would the first users of this thing be?
