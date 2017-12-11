From: Steve Grubb <sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: RFC(v2): Audit Kernel Container IDs
Date: Mon, 11 Dec 2017 14:37:05 -0500
Message-ID: <1574245.bUo6J1duCc@x2>
References: <20171012141359.saqdtnodwmbz33b2@madcap2.tricolour.ca> <f8ea78be-9bbf-2967-7b12-ac93bb85b0bc@schaufler-ca.com> <1513009857.6310.337.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1513009857.6310.337.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>, Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Network Development <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Monday, December 11, 2017 11:30:57 AM EST Eric Paris wrote:
> > Because a container doesn't have to use namespaces to be a container
> > you still need a mechanism for a process to declare that it is in
> > fact
> > in a container, and to identify the container.
> 
> I like the idea but I'm still tossing it around in my head (and
> thinking about Casey's statement too). Lets say we have a 'docker-like'
> container with pid=100  netns=X,userns=Y,mountns=Z. If I'm on the host
> in all init namespaces and I run
>   nsenter -t 100 -n ip link set eth0 promisc on
> How should this be logged?

If it is a normal process, then everything would match the init name space and 
you wouldn't have entered a container. If it were a container, any generated 
event should have the container ID from registration attached to it.

> Did this command run in it's own 'container' unrelated to the 'docker-like'
> container?

That should be determined by what's in the task struct.

-Steve
