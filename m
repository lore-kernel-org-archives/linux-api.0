From: Daniel Lezcano <daniel.lezcano-GANU6spQydw@public.gmane.org>
Subject: Re: [PATCH 00/80] Kernel based checkpoint/restart [v18]
Date: Thu, 01 Oct 2009 00:08:28 +0200
Message-ID: <4AC3D6DC.9010500@free.fr>
References: <1253749920-18673-1-git-send-email-orenl@librato.com>	<20090924154139.2a7dd5ec.akpm@linux-foundation.org>	<20090928163704.GA3327@us.ibm.com> <4AC20BB8.4070509@free.fr>	<87iqf0o5sf.fsf@caffeine.danplanet.com> <4AC38477.4070007@free.fr>	<87eipoo0po.fsf@caffeine.danplanet.com> <4AC39CE5.9080908@free.fr> <877hvgnv6z.fsf@caffeine.danplanet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <877hvgnv6z.fsf-FLMGYpZoEPULwtHQx/6qkW3U47Q5hpJU@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Smith <danms-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

Dan Smith wrote:
> DL> Yep, I agree. But you didn't answer the question, what are the
> DL> network resources you plan to checkpoint / restart ?  eg. you let
> DL> the container to setup your network, will you restore netdev
> DL> statistics ? the mac address ? ipv4 ? ipv6 ?
>
> Yes, Yes, Yes, and Yes.  I'm making the assumption that the common
> case will be with a veth device in the container and that all of the
> aforementioned attributes should be copied over.  In the future case
> where we could potentially have a real device in the container, it
> probably doesn't make sense to copy the mac address.
>   

Be careful with the assumptions ;)
> DL> Is it possible to do a detailed list of network resources you plan
> DL> to CR with the different items you will address from userspace and
> DL> kernel space ?
>
> I'm sure it's possible, but no, I haven't planned out everything for
> the next year.  If you have strong feelings about what should be done
> in user and kernel space, feel free to share :)
>   

Dan,

I just want to understand what is your plan. If you say "yes I will 
checkpoint / restart" ipv4, ipv6, netdev statistics, etc ...  you should 
be able to give at least a small list of network resources you will 
checkpoint and how you will restart them, no ?

> DL> Argh ! I was hoping there was something else than the source code
>
> The header file makes it pretty clear what is going on, 
Certainly for you.
We are a little far away of the sys_checkpoint / sys_restart simple 
syscalls we talked about at the cr-minisummit in 2008.

Regards,
     -- Daniel



--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
