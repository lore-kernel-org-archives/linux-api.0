From: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH, v10 3/3] cgroups: introduce timer slack controller
Date: Mon, 17 Oct 2011 15:40:13 +0100
Message-ID: <20111017144013.GA15447@srcf.ucam.org>
References: <1318705910.2664.5.camel@laptop>
 <20111017013921.GA30035@tango.0pointer.de>
 <20111017032232.GA4816@srcf.ucam.org>
 <4E9BBB6D.4050004@linux.intel.com>
 <1318837019.6594.29.camel@twins>
 <alpine.LFD.2.02.1110171119580.3240@ionos>
 <20111017124647.GA12838@srcf.ucam.org>
 <1318856786.4172.22.camel@twins>
 <20111017141147.GA14581@srcf.ucam.org>
 <1318861707.4172.32.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1318861707.4172.32.camel@twins>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Paul Menage <menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, harald-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-o55+BOBDEFg@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Oct 17, 2011 at 04:28:27PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-10-17 at 15:11 +0100, Matthew Garrett wrote:
> > Whether or not you want the animation to carry on animating is policy, 
> > and you need something to be the policy agent. Let's say firefox is 
> > invisible. I now grab a copy of its window contents. What do I get?
> 
> An XDamage and repaint from the X client, after which your copy will
> complete and you get what you asked for?

An XDamage and then an asynchronous RPC call to the remote server to 
identify the contents of the next frame before drawing them, plus some 
sort of new synchronisation mechanism for blocking the X query until 
that point?

> >  in preference to merging a piece 
> > of code that's functionally consistent with the rest of the cgroups 
> > infrastructure?
> 
> Yep.. because as of yet there isn't a sane use-case to warrant adding
> the maintenance burden. Any cgroup controller is functionally
> consistent, per definition, that doesn't make it useful or even sane.

Timers are a resource. People want to manage that resource. cgroups are 
a convenient mechanism for managing resources.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
