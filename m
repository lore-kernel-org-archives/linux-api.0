From: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH, v10 3/3] cgroups: introduce timer slack controller
Date: Mon, 17 Oct 2011 15:59:52 +0100
Message-ID: <20111017145952.GB15769@srcf.ucam.org>
References: <20111017032232.GA4816@srcf.ucam.org>
 <4E9BBB6D.4050004@linux.intel.com>
 <1318837019.6594.29.camel@twins>
 <alpine.LFD.2.02.1110171119580.3240@ionos>
 <20111017124647.GA12838@srcf.ucam.org>
 <1318856786.4172.22.camel@twins>
 <20111017141147.GA14581@srcf.ucam.org>
 <1318861707.4172.32.camel@twins>
 <20111017144013.GA15447@srcf.ucam.org>
 <1318862969.4172.45.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1318862969.4172.45.camel@twins>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Paul Menage <menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, harald-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-o55+BOBDEFg@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Oct 17, 2011 at 04:49:29PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-10-17 at 15:40 +0100, Matthew Garrett wrote:
> > On Mon, Oct 17, 2011 at 04:28:27PM +0200, Peter Zijlstra wrote:
> > > An XDamage and repaint from the X client, after which your copy will
> > > complete and you get what you asked for?
> > 
> > An XDamage and then an asynchronous RPC call to the remote server to 
> > identify the contents of the next frame before drawing them, plus some 
> > sort of new synchronisation mechanism for blocking the X query until 
> > that point?
> 
> Why would this be a problem? 
> 
> I mean, why would getting a copy of an otherwise invisible surface be a
> performance sensitive path? If the compositor needs the surface it would
> make it visible and send the XDamage once and keep it visible henceforth
> until the time it again becomes invisible, at which point you have to
> stop updates again.

I'm not saying that it's a problem. I'm saying that your approach 
changes behavioural semantics in a way that may violate application 
expectations just as surely as changing the timer behaviour does. 
There's no free approach.

> > Timers are a resource. People want to manage that resource. cgroups are 
> > a convenient mechanism for managing resources.
> 
> Yes, and a ball is round (unless you're a USA-ian, in which case they're
> ovoid), what's your point?

If there's no reason to want to manage that resource, why do we support 
timer slack at all?

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
