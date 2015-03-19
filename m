From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 3/3] mm: idle memory tracking
Date: Thu, 19 Mar 2015 13:41:03 +0300
Message-ID: <20150319104103.GA12162@esperanza>
References: <cover.1426706637.git.vdavydov@parallels.com>
 <0b70e70137aa5232cce44a69c0b5e320f2745f7d.1426706637.git.vdavydov@parallels.com>
 <20150319101205.GC27066@moon>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150319101205.GC27066@moon>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Mar 19, 2015 at 01:12:05PM +0300, Cyrill Gorcunov wrote:
> On Wed, Mar 18, 2015 at 11:44:36PM +0300, Vladimir Davydov wrote:
> > +static void set_mem_idle(void)
> > +{
> > +	int nid;
> > +
> > +	for_each_online_node(nid)
> > +		set_mem_idle_node(nid);
> > +}
> 
> Vladimir, might we need get_online_mems/put_online_mems here,
> or if node gets offline this wont be a problem? (Asking
> because i don't know).

I only need to dereference page structs corresponding to the node here,
and page structs are not freed when the node gets offline AFAICS, so I
guess it must be safe.

Thanks,
Vladimir
