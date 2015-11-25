From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v4 00/16] MADV_FREE support
Date: Wed, 25 Nov 2015 12:36:46 -0500
Message-ID: <20151125173646.GA10156@cmpxchg.org>
References: <1448006568-16031-1-git-send-email-minchan@kernel.org>
 <20151124135851.bd50e261e30ed4e178baaef9@linux-foundation.org>
 <20151125025318.GA2678@bbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151125025318.GA2678@bbox>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Jason Evans <je-b10kYP2dOMg@public.gmane.org>, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, yalin.wang2010-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 25, 2015 at 11:53:18AM +0900, Minchan Kim wrote:
> That's really what we(Daniel, Michael and me) want so far.
> A people who is reluctant to it is Johannes who wanted to support
> MADV_FREE on swapless system via new LRU from the beginning.
> 
> If Johannes is not strong against Andrew's plan, I will resend
> new patchset(ie, not including new stuff) based on next -mmotm.
> 
> Hannes?

Yeah, let's shelve the new stuff for now and get this going. As Daniel
said, the feature is already useful, and we can improve it later on.
