From: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 0/6] support "dataplane" mode for nohz_full
Date: Mon, 11 May 2015 08:57:59 -0400
Message-ID: <20150511085759.71deeb64@gandalf.local.home>
References: <1431107927-13998-1-git-send-email-cmetcalf@ezchip.com>
	<20150508141824.797eb0d89d514e39fd30fffe@linux-foundation.org>
	<20150508172210.559830a9@gandalf.local.home>
	<554D428E.6020702@ezchip.com>
	<20150508161909.308d60e21f6b83b897174276@linux-foundation.org>
	<20150509070538.GA9413@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150509070538.GA9413-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "Srivatsa S. Bhat" <srivatsa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


NO_HZ_LEAVE_ME_THE_FSCK_ALONE!


On Sat, 9 May 2015 09:05:38 +0200
Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
 
> So I think we should either rename NO_HZ_FULL to NO_HZ_PURE, or keep 
> it at NO_HZ_FULL: because the intention of NO_HZ_FULL was always to be 
> such a 'zero overhead' mode of operation, where if user-space runs, it 
> won't get interrupted in any way.


All kidding aside, I think this is the real answer. We don't need a new
NO_HZ, we need to make NO_HZ_FULL work. Right now it doesn't do exactly
what it was created to do. That should be fixed.

Please lets get NO_HZ_FULL up to par. That should be the main focus.

-- Steve
