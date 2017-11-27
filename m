From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] mm: disable `vm.max_map_count' sysctl limit
Date: Mon, 27 Nov 2017 08:22:07 -0800
Message-ID: <20171127162207.GA8265@bombadil.infradead.org>
References: <23066.59196.909026.689706@gargle.gargle.HOWL>
 <20171127101232.ykriowhatecnvjvg@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20171127101232.ykriowhatecnvjvg@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Mikael Pettersson <mikpelinux@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Nov 27, 2017 at 11:12:32AM +0100, Michal Hocko wrote:
> On Sun 26-11-17 17:09:32, Mikael Pettersson wrote:
> > - Reaching the limit causes various memory management system calls to
> >   fail with ENOMEM, which is a lie.  Combined with the unpredictability
> >   of the number of mappings in a process, especially when non-trivial
> >   memory management or heavy file mapping is used, it can be difficult
> >   to reproduce these events and debug them.  It's also confusing to get
> >   ENOMEM when you know you have lots of free RAM.

[snip]

> Could you be more explicit about _why_ we need to remove this tunable?
> I am not saying I disagree, the removal simplifies the code but I do not
> really see any justification here.

I imagine he started seeing random syscalls failing with ENOMEM and
eventually tracked it down to this stupid limit we used to need.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
