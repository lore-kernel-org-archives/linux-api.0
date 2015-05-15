From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 2/2] mmap2: clarify MAP_POPULATE
Date: Thu, 14 May 2015 17:13:29 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1505141713130.14864@chino.kir.corp.google.com>
References: <1431527892-2996-1-git-send-email-miso@dhcp22.suse.cz> <1431527892-2996-3-git-send-email-miso@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1431527892-2996-3-git-send-email-miso@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
To: Michal Hocko <miso@dhcp22.suse.cz>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-mm@kvack.org, Michal Hocko <mhocko@suse.cz>
List-Id: linux-api@vger.kernel.org

On Wed, 13 May 2015, Michal Hocko wrote:

> From: Michal Hocko <mhocko@suse.cz>
> 
> David Rientjes has noticed that MAP_POPULATE wording might promise much
> more than the kernel actually provides and intend to provide. The
> primary usage of the flag is to pre-fault the range. There is no
> guarantee that no major faults will happen later on. The pages might
> have been reclaimed by the time the process tries to access them.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Acked-by: David Rientjes <rientjes@google.com>

Thanks for following up!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
