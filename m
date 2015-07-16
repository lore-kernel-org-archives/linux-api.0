From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH -mm v8 4/7] proc: add kpagecgroup file
Date: Thu, 16 Jul 2015 12:28:41 +0300
Message-ID: <20150716092841.GA2001@esperanza>
References: <cover.1436967694.git.vdavydov@parallels.com>
 <c6cbd44b9d5127cdaaa6f7d330e9bf715ec55534.1436967694.git.vdavydov@parallels.com>
 <CAJu=L58kZW2WRpx8wLx=FXdS29BJ+euLRdDcTXJKwf-VLT6SCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJu=L58kZW2WRpx8wLx=FXdS29BJ+euLRdDcTXJKwf-VLT6SCA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andres Lagar-Cavilla <andreslc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Raghavendra K T <raghavendra.kt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Jul 15, 2015 at 12:03:18PM -0700, Andres Lagar-Cavilla wrote:
> For both /proc/kpage* interfaces you add (and more critically for the
> rmap-causing one, kpageidle):
> 
> It's a good idea to do cond_sched(). Whether after each pfn, each Nth
> pfn, each put_user, I leave to you, but a reasonable cadence is
> needed, because user-space can call this on the entire physical
> address space, and that's a lot of work to do without re-scheduling.

I really don't think it's necessary. These files can only be
read/written by the root, who has plenty ways to kill the system anyway.
The program that is allowed to read/write these files must be conscious
and do it in batches of reasonable size. AFAICS the same reasoning
already lays behind /proc/kpagecount and /proc/kpageflag, which also do
not thrust the "right" batch size on their readers.

Thanks,
Vladimir
