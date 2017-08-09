From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH v2 0/2] mm,fork,security: introduce MADV_WIPEONFORK
Date: Wed, 9 Aug 2017 14:42:51 +0200
Message-ID: <8fe8040c-7595-ec09-6ce7-0da4fadc82c4@redhat.com>
References: <20170806140425.20937-1-riel@redhat.com>
 <20170807132257.GH32434@dhcp22.suse.cz>
 <20170807134648.GI32434@dhcp22.suse.cz> <1502117991.6577.13.camel@redhat.com>
 <20170809095957.kv47or2w4obaipkn@node.shutemov.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170809095957.kv47or2w4obaipkn@node.shutemov.name>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
To: "Kirill A. Shutemov" <kirill@shutemov.name>, Rik van Riel <riel@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>, linux-kernel@vger.kernel.org, mike.kravetz@oracle.com, linux-mm@kvack.org, colm@allcosts.net, akpm@linux-foundation.org, keescook@chromium.org, luto@amacapital.net, wad@chromium.org, mingo@kernel.org, dave.hansen@intel.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 08/09/2017 11:59 AM, Kirill A. Shutemov wrote:
> It's not obvious to me what would break if kernel would ignore
> MADV_DONTFORK or MADV_DONTDUMP.

Ignoring MADV_DONTDUMP could cause secrets to be written to disk,
contrary to the expected security policy of the system.

Thanks,
Florian

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
