From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v2 0/2] mm,fork,security: introduce MADV_WIPEONFORK
Date: Thu, 10 Aug 2017 16:11:12 +0200
Message-ID: <20170810141111.GY23863@dhcp22.suse.cz>
References: <20170806140425.20937-1-riel@redhat.com>
 <20170807132257.GH32434@dhcp22.suse.cz>
 <20170807134648.GI32434@dhcp22.suse.cz>
 <CAAF6GDcNoDUaDSxV6N12A_bOzo8phRUX5b8-OBteuN0AmeCv0g@mail.gmail.com>
 <20170810132110.GU23863@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20170810132110.GU23863@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
To: Colm =?iso-8859-1?Q?MacC=E1rthaigh?= <colm@allcosts.net>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org, mike.kravetz@oracle.com, linux-mm@kvack.org, Florian Weimer <fweimer@redhat.com>, akpm@linux-foundation.org, keescook@chromium.org, luto@amacapital.net, wad@chromium.org, mingo@kernel.org, kirill@shutemov.name, dave.hansen@intel.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu 10-08-17 15:21:10, Michal Hocko wrote:
[...]
> Thanks, these references are really useful to build a picture. I would
> probably use an unlinked fd with O_CLOEXEC to dect this but I can see
> how this is not the greatest option for a library.

Blee, brainfart on my end. For some reason I mixed fork/exec...
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
