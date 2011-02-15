From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH, v6 3/3] cgroups: introduce timer slack controller
Date: Tue, 15 Feb 2011 07:04:00 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1102150658540.26192@localhost6.localdomain6>
References: <1297688787-3592-1-git-send-email-kirill@shutemov.name> <1297688787-3592-4-git-send-email-kirill@shutemov.name> <alpine.LFD.2.00.1102141432440.26192@localhost6.localdomain6> <20110214151914.GA4210@shutemov.name> <alpine.LFD.2.00.1102141753240.26192@localhost6.localdomain6>
 <20110214223939.GA6230@shutemov.name>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110214223939.GA6230-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: Paul Menage <menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 15 Feb 2011, Kirill A. Shutemov wrote:
> On Mon, Feb 14, 2011 at 06:01:06PM +0100, Thomas Gleixner wrote:
> > > I think silent change here is wrong. cpuset returns -EBUSY in similar
> > > case.
> > 
> > And how is cpuset relevant for this ? Not at all. This is about
> > timer_slack and we better have a well defined scheme for all of this
> > and not some cobbled together thing with tons of exceptions and corner
> > cases. Of course undocumented as far the code goes.
> 
> I don't like silent cascade changes. Userspace can implement it if
> needed. -EBUSY is appropriate.

And I don't like totally uncommented code which follows come cobbled
together completely non obvious rules.

It's not about what you like. It's about getting useful functionality
when we add a new infrastructure like this.

So could you please explain what the rules of updating are, so that a
reviewer has a chance to understand the rationale of all this.

Thanks,

	tglx
