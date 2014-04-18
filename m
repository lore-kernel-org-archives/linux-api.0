From: Manfred Spraul <manfred-nhLOkwUX5cPe2c5cEj3t2g@public.gmane.org>
Subject: Re: [PATCH v3] ipc,shm: disable shmmax and shmall by default
Date: Fri, 18 Apr 2014 19:51:04 +0200
Message-ID: <53516608.8090409@colorfullife.com>
References: <1397784345.2556.26.camel@buesod1.americas.hpqcorp.net> <5350EFAA.2030607@colorfullife.com> <CAKgNAkhY94Y5Nut9+Jj1gcnio81CEmE5sQL_gH_zFnHD-yNx2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKgNAkhY94Y5Nut9+Jj1gcnio81CEmE5sQL_gH_zFnHD-yNx2Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Davidlohr Bueso <davidlohr-VXdhtT5mjnY@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, aswin-VXdhtT5mjnY@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 04/18/2014 05:36 PM, Michael Kerrisk (man-pages) wrote:
> On Fri, Apr 18, 2014 at 11:26 AM, Manfred Spraul
> <manfred-nhLOkwUX5cPe2c5cEj3t2g@public.gmane.org> wrote:
>> Obviously my patch has the opposite problem: 64-bit wrap-arounds.
> I know you alluded to a case in another thread, but I couldn't quite
> work out from the mail you referred to whether this was really the
> problem. (And I assume those folks were forced to fix their set-up
> scripts anyway.) So, it's not clear to me whether this is a real
> problem. (And your patch does not worsen things from the current
> situation, right?)
a) When I wrote the comment it was just an idea.
But now I think wrap-around could be an issue, e.g. 
find_vma_intersection(,addr,addr+ULONG_MAX) always returns false, even 
if there are vmas inbetween.

b) If we make ULONG_MAX the default, then it should work.

--
     Manfred
