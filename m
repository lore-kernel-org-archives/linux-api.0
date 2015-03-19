From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] mremap: add MREMAP_NOHOLE flag --resend
Date: Wed, 18 Mar 2015 22:22:46 -0700
Message-ID: <20150318222246.bc608dd0.akpm@linux-foundation.org>
References: <deaa4139de6e6422a0cec1e3282553aed3495e94.1426626497.git.shli@fb.com>
	<20150318153100.5658b741277f3717b52e42d9@linux-foundation.org>
	<20150319050826.GA1591708@devbig257.prn2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150319050826.GA1591708-XA4dbxeItU7BTsLV8vAZyg2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shaohua Li <shli-b10kYP2dOMg@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mel-wPRd99KPJ+uzQB+pC5nmwQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, 18 Mar 2015 22:08:26 -0700 Shaohua Li <shli-b10kYP2dOMg@public.gmane.org> wrote:

> > Daniel also had microbenchmark testing results for glibc and jemalloc. 
> > Can you please do this?
> 
> I run Daniel's microbenchmark too, and not surprise the result is
> similar:
> glibc: 32.82
> jemalloc: 70.35
> jemalloc+mremap: 33.01
> tcmalloc: 68.81
> 
> but tcmalloc doesn't support mremap currently, so I cant test it.

But Daniel's changelog implies strongly that tcmalloc would benefit
from his patch.  Was that inaccurate or is this a difference between
his patch and yours?
