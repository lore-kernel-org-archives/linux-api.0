From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v17 1/7] mm: support madvise(MADV_FREE)
Date: Wed, 4 Feb 2015 13:52:18 +0100
Message-ID: <20150204125218.GE29434@dhcp22.suse.cz>
References: <1413799924-17946-1-git-send-email-minchan@kernel.org>
 <1413799924-17946-2-git-send-email-minchan@kernel.org>
 <20141127144725.GB19157@dhcp22.suse.cz>
 <20141130235652.GA10333@bbox>
 <20141202100125.GD27014@dhcp22.suse.cz>
 <20141203000026.GA30217@bbox>
 <20141203101329.GB23236@dhcp22.suse.cz>
 <20141205070816.GB3358@bbox>
 <20141205083249.GA2321@dhcp22.suse.cz>
 <54D0F9BC.4060306@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54D0F9BC.4060306-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Jason Evans <je-b10kYP2dOMg@public.gmane.org>, zhangyanfei-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue 03-02-15 17:39:24, Michael Kerrisk wrote:
[...]
> If I'm reading the conversation right, the initially proposed text 
> was from the BSD man page (which would be okay), but most of the 
> text above seems  to have come straight from the page here:
> http://www.lehman.cuny.edu/cgi-bin/man-cgi?madvise+3
> 
> Right?
> 
> Unfortunately, I don't think we can use that text. It's from the 
> Solaris man page as far as I can tell, and I doubt that it's 
> under a license that we can use.

Ohh, I wasn't aware of that restriction and didn't notice anything at
the man page nor http://www.lehman.cuny.edu/cgi-bin/man-cgi.
But you are definitely right that it would be better to not use this
source. Sorry about that, I should have noticed that myself.

> If that's the case, we need to go back and come up with an
> original text. It might draw inspiration from the Solaris page,
> and take actual text from the BSD page (which is under a free
> license), and it might also draw inspiration from Jon Corbet's 
> description at http://lwn.net/Articles/590991/. 
> 
> Could you take another shot this please!

Minchan is obviously working on one and I will review it once he is done
with it.
-- 
Michal Hocko
SUSE Labs
