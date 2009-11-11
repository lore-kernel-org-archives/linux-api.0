From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: [v12][PATCH 3/9] Define set_pidmap() function
Date: Wed, 11 Nov 2009 14:39:24 -0800
Message-ID: <20091111223924.GD24988@suka>
References: <20091111043440.GA9377@suka> <20091111044329.GC11393@suka>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932083AbZKKWi5@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091111044329.GC11393@suka>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: mtk.manpages@googlemail.com, arnd@arndb.de, Containers <containers@lists.linux-foundation.org>, Nathan Lynch <nathanl@austin.ibm.com>, matthltc@suka.localdomain, "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com, linux-api@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com, Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Cc: LKML

Sukadev Bhattiprolu [sukadev@linux.vnet.ibm.com] wrote:
| 
| Subject: [v12][PATCH 3/9] Define set_pidmap() function
| 
| Define a set_pidmap() interface which is like alloc_pidmap() only that
| caller specifies the pid number to be assigned.
| 
| Changelog[v9]:
| 	- Completely rewrote this patch based on Eric Biederman's code.
| Changelog[v7]:
|         - [Eric Biederman] Generalize alloc_pidmap() to take a range of pids.
| Changelog[v6]:
|         - Separate target_pid > 0 case to minimize the number of checks needed.
| Changelog[v3]:
|         - (Eric Biederman): Avoid set_pidmap() function. Added couple of
|           checks for target_pid in alloc_pidmap() itself.
| Changelog[v2]:
|         - (Serge Hallyn) Check for 'pid < 0' in set_pidmap().(Code
|           actually checks for 'pid <= 0' for completeness).
| 
| Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
| Acked-by: Oren Laadan <orenl@cs.columbia.edu>
| ---
|  kernel/pid.c |   41 +++++++++++++++++++++++++++++++++--------
|  1 files changed, 33 insertions(+), 8 deletions(-)
| 
| diff --git a/kernel/pid.c b/kernel/pid.c
| index c4d9914..afef766 100644
| --- a/kernel/pid.c
| +++ b/kernel/pid.c
| @@ -147,18 +147,19 @@ static int alloc_pidmap_page(struct pidmap *map)
|  	return 0;
|  }
| 
| -static int alloc_pidmap(struct pid_namespace *pid_ns)
| +static int do_alloc_pidmap(struct pid_namespace *pid_ns, int last, int min,
| +		int max)
|  {
| -	int i, offset, max_scan, pid, last = pid_ns->last_pid;
| +	int i, offset, max_scan, pid;
|  	int rc = -EAGAIN;
|  	struct pidmap *map;
| 
|  	pid = last + 1;
|  	if (pid >= pid_max)
| -		pid = RESERVED_PIDS;
| +		pid = min;
|  	offset = pid & BITS_PER_PAGE_MASK;
|  	map = &pid_ns->pidmap[pid/BITS_PER_PAGE];
| -	max_scan = (pid_max + BITS_PER_PAGE - 1)/BITS_PER_PAGE - !offset;
| +	max_scan = (max + BITS_PER_PAGE - 1)/BITS_PER_PAGE - !offset;
|  	for (i = 0; i <= max_scan; ++i) {
|  		rc = alloc_pidmap_page(map);
|  		if (rc)
| @@ -168,7 +169,6 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
|  			do {
|  				if (!test_and_set_bit(offset, map->page)) {
|  					atomic_dec(&map->nr_free);
| -					pid_ns->last_pid = pid;
|  					return pid;
|  				}
|  				offset = find_next_offset(map, offset);
| @@ -179,16 +179,16 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
|  			 * bitmap block and the final block was the same
|  			 * as the starting point, pid is before last_pid.
|  			 */
| -			} while (offset < BITS_PER_PAGE && pid < pid_max &&
| +			} while (offset < BITS_PER_PAGE && pid < max &&
|  					(i != max_scan || pid < last ||
|  					    !((last+1) & BITS_PER_PAGE_MASK)));
|  		}
| -		if (map < &pid_ns->pidmap[(pid_max-1)/BITS_PER_PAGE]) {
| +		if (map < &pid_ns->pidmap[(max-1)/BITS_PER_PAGE]) {
|  			++map;
|  			offset = 0;
|  		} else {
|  			map = &pid_ns->pidmap[0];
| -			offset = RESERVED_PIDS;
| +			offset = min;
|  			if (unlikely(last == offset)) {
|  				rc = -EAGAIN;
|  				break;
| @@ -199,6 +199,31 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
|  	return rc;
|  }
| 
| +static int alloc_pidmap(struct pid_namespace *pid_ns)
| +{
| +	int nr;
| +
| +	nr = do_alloc_pidmap(pid_ns, pid_ns->last_pid, RESERVED_PIDS, pid_max);
| +	if (nr >= 0)
| +		pid_ns->last_pid = nr;
| +	return nr;
| +}
| +
| +static int set_pidmap(struct pid_namespace *pid_ns, int target)
| +{
| +	if (!target)
| +		return alloc_pidmap(pid_ns);
| +
| +	if (target >= pid_max)
| +		return -EINVAL;
| +
| +	if ((target < 0) || (target < RESERVED_PIDS &&
| +				pid_ns->last_pid >= RESERVED_PIDS))
| +		return -EINVAL;
| +
| +	return do_alloc_pidmap(pid_ns, target - 1, target, target + 1);
| +}
| +
|  int next_pidmap(struct pid_namespace *pid_ns, int last)
|  {
|  	int offset;
| -- 
| 1.6.0.4
| 
| _______________________________________________
| Containers mailing list
| Containers@lists.linux-foundation.org
| https://lists.linux-foundation.org/mailman/listinfo/containers
