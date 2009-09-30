From: Dan Smith <danms-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/80] Kernel based checkpoint/restart [v18]
Date: Wed, 30 Sep 2009 11:28:36 -0700
Message-ID: <877hvgnv6z.fsf@caffeine.danplanet.com>
References: <1253749920-18673-1-git-send-email-orenl@librato.com>
	<20090924154139.2a7dd5ec.akpm@linux-foundation.org>
	<20090928163704.GA3327@us.ibm.com> <4AC20BB8.4070509@free.fr>
	<87iqf0o5sf.fsf@caffeine.danplanet.com> <4AC38477.4070007@free.fr>
	<87eipoo0po.fsf@caffeine.danplanet.com> <4AC39CE5.9080908@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AC39CE5.9080908-GANU6spQydw@public.gmane.org> (Daniel Lezcano's message of "Wed\, 30 Sep 2009 20\:01\:09 +0200")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Lezcano <daniel.lezcano-GANU6spQydw@public.gmane.org>
Cc: "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

DL> Yep, I agree. But you didn't answer the question, what are the
DL> network resources you plan to checkpoint / restart ?  eg. you let
DL> the container to setup your network, will you restore netdev
DL> statistics ? the mac address ? ipv4 ? ipv6 ?

Yes, Yes, Yes, and Yes.  I'm making the assumption that the common
case will be with a veth device in the container and that all of the
aforementioned attributes should be copied over.  In the future case
where we could potentially have a real device in the container, it
probably doesn't make sense to copy the mac address.

DL> Is it possible to do a detailed list of network resources you plan
DL> to CR with the different items you will address from userspace and
DL> kernel space ?

I'm sure it's possible, but no, I haven't planned out everything for
the next year.  If you have strong feelings about what should be done
in user and kernel space, feel free to share :)

DL> Argh ! I was hoping there was something else than the source code

The header file makes it pretty clear what is going on, but maybe the
Documentation/checkpoint/readme.txt will help.  Putting all the
details in such a documentation file would be rather silly at the
moment, given that new things are being added at a rapid rate and it
would duplicate the only description that matters, which is the
header file.

-- 
Dan Smith
IBM Linux Technology Center
email: danms-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
