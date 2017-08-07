From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH v2 0/2] mm,fork,security: introduce MADV_WIPEONFORK
Date: Mon, 7 Aug 2017 16:19:18 +0200
Message-ID: <134bbcf4-5717-7f53-0bf1-57158e948bbe@redhat.com>
References: <20170806140425.20937-1-riel@redhat.com>
 <20170807132257.GH32434@dhcp22.suse.cz>
 <20170807134648.GI32434@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170807134648.GI32434@dhcp22.suse.cz>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
To: Michal Hocko <mhocko@kernel.org>, riel@redhat.com
Cc: linux-kernel@vger.kernel.org, mike.kravetz@oracle.com, linux-mm@kvack.org, colm@allcosts.net, akpm@linux-foundation.org, keescook@chromium.org, luto@amacapital.net, wad@chromium.org, mingo@kernel.org, kirill@shutemov.name, dave.hansen@intel.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 08/07/2017 03:46 PM, Michal Hocko wrote:
> How do they know that they need to regenerate if they do not get SEGV?
> Are they going to assume that a read of zeros is a "must init again"? Isn't
> that too fragile?

Why would it be fragile?  Some level of synchronization is needed to set
things up, of course, but I think it's possible to write a lock-free
algorithm to maintain the state even without strong guarantees of memory
ordering from fork.

In the DRBG uniqueness case, you don't care if you reinitialize because
it's the first use, or because a fork just happened.

In the API-mandated fork check, a detection false positive before a fork
is not acceptable (because it would prevent legitimate API use), but I
think you can deal with this case if you publish a pointer to a
pre-initialized, non-zero mapping.

Thanks,
Florian

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
