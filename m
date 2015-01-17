From: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: futex(2) man page update help request
Date: Fri, 16 Jan 2015 17:11:49 -0800
Message-ID: <D0DEF5CA.B7F02%dvhart@linux.intel.com>
References: <537346E5.4050407@gmail.com>
 <CF98E3EF.90564%dvhart@linux.intel.com>
 <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com>
 <5373D0CA.2050204@redhat.com>
 <alpine.DEB.2.02.1405150121230.6261@ionos.tec.linutronix.de>
 <CAKgNAkjQ5Dd_U9OojXdgeforpRevvPHNFAw99kBFPCwHgf7Ggg@mail.gmail.com>
 <alpine.DEB.2.02.1405151144390.6261@ionos.tec.linutronix.de>
 <54B7D87C.3090901@gmail.com>
 <alpine.DEB.2.11.1501152313330.5526@nanos>
 <54B92B71.2090509@gmail.com>
 <alpine.DEB.2.11.1501161618080.5526@nanos>
 <54B97A72.2050205@gmail.com>
 <1421456216.27134.2.camel@stgolabs.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1421456216.27134.2.camel-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Torvald Riegel <triegel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Petr Baudis <pasky-AlSwsSmVLrQ@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, bill o gallmeister <bgallmeister-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 1/16/15, 4:56 PM, "Davidlohr Bueso" <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org> wrote:


>On Fri, 2015-01-16 at 21:54 +0100, Michael Kerrisk (man-pages) wrote:
>> On 01/16/2015 04:20 PM, Thomas Gleixner wrote:
>> > On Fri, 16 Jan 2015, Michael Kerrisk (man-pages) wrote:
>> > 
>> >> Hello Thomas,
>> >>
>> >> On 01/15/2015 11:23 PM, Thomas Gleixner wrote:
>> >>> On Thu, 15 Jan 2015, Michael Kerrisk (man-pages) wrote:
>> >>>>> [EINVAL] uaddr equal uaddr2. Requeue to same futex.
>> >>>>
>> >>>> ??? I added this, but does this error not occur only for PI
>>requeues?
>> >>>
>> >>> It's equally wrong for normal futexes. And its actually the same
>>code
>> >>> checking for this for all variants.
>> >>
>> >> I don't understand "equally wrong" in your reply, I'm sorry. Do you
>> >> mean:
>> >>
>> >> a) This error text should be there for both normal and PI requeues
>> > 
>> > It is there for both. The requeue code has that check independent of
>> > the requeue type (normal/pi). It never makes sense to requeue
>> > something to itself whether normal or pi futex. We added this for PI,
>> > because there it is harmful, but we did not special case it. So normal
>> > futexes get the same treatment.
>> 
>> Hello Thomas, 
>> 
>> Color me stupid, but I can't see this in futex_requeue(). Where is that
>> check that is "independent of the requeue type (normal/pi)"?
>> 
>> When I look through futex_requeue(), all the likely looking sources
>> of EINVAL are governed by a check on the 'requeue_pi' argument.
>
>Yeah, its not very straightforward, I was also scratching my head. First
>we do:
>
>	if (requeue_pi) {
>		/*
>		 * Requeue PI only works on two distinct uaddrs. This
>		 * check is only valid for private futexes. See below.
>		 */
>		if (uaddr1 == uaddr2)
>			return -EINVAL;

We check here to abort as early as possible for the usual security reasons.

>
>Then:
>
>	/*
>	 * The check above which compares uaddrs is not sufficient for
>	 * shared futexes. We need to compare the keys:
>	 */
>	if (requeue_pi && match_futex(&key1, &key2)) {
>		ret = -EINVAL;
>		goto out_put_keys;
>	}
>
>I wonder why we're checking for requeue_pi again, when, at least
>according to the comments, it should be for shared. I guess it would
>make sense depending on the mappings as the keys are the only true way
>of determining if both futexes are the same, so perhaps:
>
>	if ((requeue_pi || (flags & FLAGS_SHARED)) && match_futex())

No, the rule only applies to requeue_pi. This check is the for-sure
version of the uaddr comparison above. We could add if flags &
FLAGS_SHARED, but I'm not sure it's worth it.

--
Darren Hart
Intel Open Source Technology Center



--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
