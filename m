From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
Date: Fri, 23 Oct 2009 16:26:00 -0700
Message-ID: <m1y6n1lmk7.fsf@fess.ebiederm.org>
References: <m1iqeauyvl.fsf@fess.ebiederm.org>
	<20091020183329.GB22646@us.ibm.com> <m1r5sxsw7w.fsf@fess.ebiederm.org>
	<20091021062021.GA2667@us.ibm.com> <m1eioxrtsb.fsf@fess.ebiederm.org>
	<20091023004253.GA7915@us.ibm.com> <m1bpjyrkep.fsf@fess.ebiederm.org>
	<20091023053001.GA24972@us.ibm.com> <m1ws2mpsuk.fsf@fess.ebiederm.org>
	<20091023192124.GA11088@us.ibm.com>
	<20091023204812.GA26524@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091023204812.GA26524-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org> (Sukadev Bhattiprolu's message of "Fri\, 23 Oct 2009 13\:48\:12 -0700")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Oren Laadan <orenl-RdfvBDnrOixBDgjK7y7TUQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-GANU6spQydw@public.gmane.org>, randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Nathan Lynch <nathanl-V7BBcbaFuwjMbYB6QlFGEg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Louis.Rilling-aw0BnHfMbSpBDgjK7y7TUQ@public.gmane.org, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> writes:

> Sukadev Bhattiprolu [sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org] wrote:
> | Eric W. Biederman [ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org] wrote:
> | | > Anyway, is RESERVED_PIDS meant for initial kernel-threads/daemons - if so
> | | > would it be ok enforce it only in init_pid_ns ?
> | | 
> | | It is mean for initial user space daemons, things that start on boot.
> | | 
> | | I don't know how much the protection matters at this date, but we have it.
> | 
> | Well, since it is not security or other critical restriction, can we allow
> | set_pidmap() a free hand - even in init-pid-ns ? It could prevent a simple
> | subtree C/R of one of the early daemons for debug for instance.
>
> So here is how I have it at present. I would like to remove the RESERVED_PIDS
> check in set_pidmap() if its ok to do so.
>
> alloc_pid() does this:
>
> 	if (target_pids)
> 		set_pidmap(tmp, target_pids[i])
> 	else
> 		alloc_pidmap(tmp);
>
> Sukadev
> ---
>
>>From bc6093fc4fc2f01070647df6f1e85e45edc89d27 Mon Sep 17 00:00:00 2001
> From: Sukadev Bhattiprolu <suka@suka.(none)>
> Date: Thu, 22 Oct 2009 16:57:28 -0700
> Subject: [PATCH] Define set_pidmap() function
>
> Define a set_pidmap() interface which is like alloc_pidmap() only that
> caller specifies the pid number to be assigned.
>
> Changelog[v9]:
> 	- Complete rewrite this patch based on Eric Biederman's code.
> Changelog[v7]:
>         - [Eric Biederman] Generalize alloc_pidmap() to take a range of pids.
> Changelog[v6]:
>         - Separate target_pid > 0 case to minimize the number of checks needed.
> Changelog[v3]:
>         - (Eric Biederman): Avoid set_pidmap() function. Added couple of
>           checks for target_pid in alloc_pidmap() itself.
> Changelog[v2]:
>         - (Serge Hallyn) Check for 'pid < 0' in set_pidmap().(Code
>           actually checks for 'pid <= 0' for completeness).
>
> Signed-off-by: Sukadev Bhattiprolu <sukadev-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> ---
>  kernel/pid.c |   40 ++++++++++++++++++++++++++++++++--------
>  1 files changed, 32 insertions(+), 8 deletions(-)
>
> diff --git a/kernel/pid.c b/kernel/pid.c
> index c4d9914..9346755 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -147,18 +147,19 @@ static int alloc_pidmap_page(struct pidmap *map)
>  	return 0;
>  }
>  
> -static int alloc_pidmap(struct pid_namespace *pid_ns)
> +static int do_alloc_pidmap(struct pid_namespace *pid_ns, int last, int min,
> +		int max)
>  {
> -	int i, offset, max_scan, pid, last = pid_ns->last_pid;
> +	int i, offset, max_scan, pid;
>  	int rc = -EAGAIN;
>  	struct pidmap *map;
>  
>  	pid = last + 1;
>  	if (pid >= pid_max)
> -		pid = RESERVED_PIDS;
> +		pid = min;
>  	offset = pid & BITS_PER_PAGE_MASK;
>  	map = &pid_ns->pidmap[pid/BITS_PER_PAGE];
> -	max_scan = (pid_max + BITS_PER_PAGE - 1)/BITS_PER_PAGE - !offset;
> +	max_scan = (max + BITS_PER_PAGE - 1)/BITS_PER_PAGE - !offset;
>  	for (i = 0; i <= max_scan; ++i) {
>  		rc = alloc_pidmap_page(map);
>  		if (rc)
> @@ -168,7 +169,6 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
>  			do {
>  				if (!test_and_set_bit(offset, map->page)) {
>  					atomic_dec(&map->nr_free);
> -					pid_ns->last_pid = pid;
>  					return pid;
>  				}
>  				offset = find_next_offset(map, offset);
> @@ -179,16 +179,16 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
>  			 * bitmap block and the final block was the same
>  			 * as the starting point, pid is before last_pid.
>  			 */
> -			} while (offset < BITS_PER_PAGE && pid < pid_max &&
> +			} while (offset < BITS_PER_PAGE && pid < max &&
>  					(i != max_scan || pid < last ||
>  					    !((last+1) & BITS_PER_PAGE_MASK)));
>  		}
> -		if (map < &pid_ns->pidmap[(pid_max-1)/BITS_PER_PAGE]) {
> +		if (map < &pid_ns->pidmap[(max-1)/BITS_PER_PAGE]) {
>  			++map;
>  			offset = 0;
>  		} else {
>  			map = &pid_ns->pidmap[0];
> -			offset = RESERVED_PIDS;
> +			offset = min;
>  			if (unlikely(last == offset)) {
>  				rc = -EAGAIN;
>  				break;
> @@ -199,6 +199,30 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
>  	return rc;
>  }
>  
> +static int alloc_pidmap(struct pid_namespace *pid_ns)
> +{
> +	int nr;
> +
> +	nr = do_alloc_pidmap(pid_ns, pid_ns->last, RESERVED_PIDS, pid_max);
                                     pid_ns->last_pid,

Looks like I missed that one.

> +	if (nr >= 0)
> +		pid_ns->last_pid = nr;
> +	return nr;
> +}
> +
> +static int set_pidmap(struct pid_namespace *pid_ns, int target)
> +{
> +	if (!target)
> +		return alloc_pidmap(pid_ns);
> +
> +	if (target >= pid_max)
> +		return -EINVAL;
> +
> +	if ((target < 0) || (target < RESERVED_PIDS && pid_ns == &init_pid_ns))
> +		return -EINVAL;

if ((target < 0) || ((target < RESERVED_PIDS) && (pid_ns->last_pid >= RESERVED_PIDS)))

Please.

Eric

> +
> +	return do_alloc_pidmap(pid_ns, target - 1, target, target + 1);
> +}
> +
>  int next_pidmap(struct pid_namespace *pid_ns, int last)
>  {
>  	int offset;
> -- 
> 1.6.0.4
