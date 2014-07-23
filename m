From: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 0/5] futex: introduce an optimistic spinning futex
Date: Wed, 23 Jul 2014 06:55:03 +0200
Message-ID: <1406091303.5076.33.camel@marge.simpson.net>
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com>
	 <8761iq3bp3.fsf@tassilo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8761iq3bp3.fsf-KWJ+5VKanrL29G5dvP0v1laTQe2KTcn/@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
Cc: Waiman Long <Waiman.Long-VXdhtT5mjnY@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Davidlohr Bueso <davidlohr-VXdhtT5mjnY@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>, Scott J Norton <scott.norton-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, 2014-07-21 at 09:42 -0700, Andi Kleen wrote:

> FWIW the main problem is currently that switch-through-idle is so 
> slow. I think improving that would give a boost to far more
> situations.

Two high frequency idle enter/exit suckage spots:

1) nohz (tick) - it's expensive to start/stop tick on every micro-idle,
throttle it or something.

2) ondemand governor - tweak silly default settings to reflect the
reality that we routinely schedule communicating threads cross core.

(3. seek/destroy fastpath cycles, damn things multiply over time)

-Mike
