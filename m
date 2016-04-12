From: Chris Metcalf <cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v9 04/13] task_isolation: add initial support
Date: Tue, 12 Apr 2016 14:41:45 -0400
Message-ID: <570D4169.4010008@mellanox.com>
References: <1451936091-29247-1-git-send-email-cmetcalf@ezchip.com>
 <1451936091-29247-5-git-send-email-cmetcalf@ezchip.com>
 <20160119154214.GA2722@lerouge> <569EA050.5030106@ezchip.com>
 <20160128002801.GA14313@lerouge> <56ABACDD.5090500@ezchip.com>
 <20160130211125.GB7856@lerouge> <56BCDFE9.10200@ezchip.com>
 <20160304125603.GA23906@lerouge> <56E07BF0.3060509@mellanox.com>
 <20160408135622.GD24956@lerouge> <5707DDA8.10600@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5707DDA8.10600-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 4/8/2016 12:34 PM, Chris Metcalf wrote:
> However, this makes me wonder if "strict" mode should be the default
> for task isolation??  That way task isolation really doesn't conflict
> semantically with migration.  And we could provide a "weak" mode, or a
> "kernel-friendly" mode, or some such nomenclature, and define the
> migration semantics just for that case, where it makes it clear it's a
> bit unusual. 

I noodled around with this and decided it was a better default,
so I've made the changes and pushed it up to the branch:

     git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git dataplane

Now, by default when you enter task isolation mode, you are in
what I used to call "strict" mode, i.e. you can't use the kernel.

You can select a user-specified signal you want to deliver instead of
the default SIGKILL, and if you select signal 0, then you don't get
a signal at all and instead you get to keep running in task
isolation mode after making a syscall, page fault, etc.

Thus the API now looks like this in <linux/prctl.h>:

#define PR_SET_TASK_ISOLATION		48
#define PR_GET_TASK_ISOLATION		49
# define PR_TASK_ISOLATION_ENABLE	(1 << 0)
# define PR_TASK_ISOLATION_USERSIG	(1 << 1)
# define PR_TASK_ISOLATION_SET_SIG(sig)	(((sig) & 0x7f) << 8)
# define PR_TASK_ISOLATION_GET_SIG(bits) (((bits) >> 8) & 0x7f)
# define PR_TASK_ISOLATION_NOSIG \
	(PR_TASK_ISOLATION_USERSIG | PR_TASK_ISOLATION_SET_SIG(0))

I think this better matches what people should want to do in
their applications, and also matches the expectations people
have about what it means to go into task isolation mode in the
first place.

I got rid of the ONESHOT mode that I added in the v12 series, since
it didn't seem like it was what Frederic had been asking for anyway,
and it didn't seem particularly useful on its own.

Frederic, how does this align with your intuition for this stuff?

-- 
Chris Metcalf, Mellanox Technologies
http://www.mellanox.com
