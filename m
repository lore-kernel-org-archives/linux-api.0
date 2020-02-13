From: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v4 8/8] mm: support both pid and pidfd for
 process_madvise
Date: Wed, 12 Feb 2020 16:28:37 -0800
Message-ID: <ae381f0c96c5a21c9e378d3c93cd819a77b3c0df.camel@linux.intel.com>
References: <20200212233946.246210-1-minchan@kernel.org>
         <20200212233946.246210-9-minchan@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200212233946.246210-9-minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oleksandr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tim Murray <timmurray-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Daniel Colascione <dancol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sandeep Patil <sspatil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sonny Rao <sonnyrao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Brian Geffon <bgeffon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, John Dias <joaodias-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Christian Brauner <christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org>, Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, 2020-02-12 at 15:39 -0800, Minchan Kim wrote:
> There is a demand[1] to support pid as well pidfd for process_madvise
> to reduce unnecessary syscall to get pidfd if the user has control of
> the target process(ie, they could guarantee the process is not gone
> or pid is not reused. Or, it might be okay to give a hint to wrong
> process).
> 
> This patch aims for supporting both options like waitid(2). So, the
> syscall is currently,
> 
> 	int process_madvise(int which, pid_t pid, void *addr,
> 		size_t length, int advise, unsigned long flag);
> 
> @which is actually idtype_t for userspace libray and currently,
> it supports P_PID and P_PIDFD.
> 
> [1]  https://lore.kernel.org/linux-mm/9d849087-3359-c4ab-fbec-859e8186c509-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org/
> 
> Cc: Christian Brauner <christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org>
> Suggested-by: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> Signed-off-by: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

So if you move patch 7 up before patch 2 you could squash this patch with
your current patch 2 and drop one patch from your series. It would
probably help to reduce the review overhead as well.
