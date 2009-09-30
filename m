From: Daniel Lezcano <daniel.lezcano-GANU6spQydw@public.gmane.org>
Subject: Re: [PATCH 00/80] Kernel based checkpoint/restart [v18]
Date: Wed, 30 Sep 2009 18:16:55 +0200
Message-ID: <4AC38477.4070007@free.fr>
References: <1253749920-18673-1-git-send-email-orenl@librato.com>	<20090924154139.2a7dd5ec.akpm@linux-foundation.org>	<20090928163704.GA3327@us.ibm.com> <4AC20BB8.4070509@free.fr> <87iqf0o5sf.fsf@caffeine.danplanet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87iqf0o5sf.fsf-FLMGYpZoEPULwtHQx/6qkW3U47Q5hpJU@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Smith <danms-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

Dan Smith wrote:
> DL> Ok for the restart, but for the checkpoint, how do you access the
> DL> network setup from a process which belongs to another namespace
> DL> context ?
>
> So far the discussion has led to the kernel dumping all of that
> information on checkpoint, and then splitting it up into what can be
> done by userspace on restart and what still needs to be in the kernel.
>   
Ah, this was a discussion in the containers@ mailing list ?
Sorry I missed it, I will look at the containers@ archives.

If the checkpoint is done from the kernel, why the restart wouldn't be 
in the kernel too ?
Do you have a list of what is restartable from userspace or from the 
kernel ?

Is there any documentation about the statefile format I can use if I 
want to implement myself an userspace CR solution based on this kernel 
patchset ?
> Similarly, the task structure is currently exported by the kernel on
> checkpoint, but recreated in userspace on restart.
>   
(I guess you meant tasks hierarchy/tree) Well I understand why this is 
done from userspace but I don't like the idea of digging in the 
statefile, but there's no accounting for taste :)

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
