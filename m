From: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH, v10 3/3] cgroups: introduce timer slack controller
Date: Mon, 17 Oct 2011 16:19:20 +0100
Message-ID: <20111017151920.GA16664@srcf.ucam.org>
References: <1318837019.6594.29.camel@twins>
 <alpine.LFD.2.02.1110171119580.3240@ionos>
 <20111017124647.GA12838@srcf.ucam.org>
 <1318856786.4172.22.camel@twins>
 <20111017141147.GA14581@srcf.ucam.org>
 <1318861707.4172.32.camel@twins>
 <20111017144013.GA15447@srcf.ucam.org>
 <1318862969.4172.45.camel@twins>
 <20111017145952.GB15769@srcf.ucam.org>
 <1318864260.4172.54.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1318864260.4172.54.camel@twins>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Paul Menage <menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, harald-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-o55+BOBDEFg@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Oct 17, 2011 at 05:11:00PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-10-17 at 15:59 +0100, Matthew Garrett wrote:
> > I'm not saying that it's a problem. I'm saying that your approach 
> > changes behavioural semantics in a way that may violate application 
> > expectations just as surely as changing the timer behaviour does. 
> > There's no free approach.
> 
> I'm not saying its free, I'm saying its a much better approach since it
> gets rid of the entire problem instead of papering over the worst of it.

It solves it for a specific case, ie animations. Any other timer driven 
behaviour continues. It really does need to be tied to session idle, not 
application visibility, and enforcement at the X level does nothing to 
help that.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
