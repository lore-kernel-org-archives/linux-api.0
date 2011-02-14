From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH, v6 1/3] cgroups: export cgroup_iter_{start,next,end}
Date: Mon, 14 Feb 2011 16:09:17 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1102141608250.26192@localhost6.localdomain6>
References: <1297688787-3592-1-git-send-email-kirill@shutemov.name> <1297688787-3592-2-git-send-email-kirill@shutemov.name> <alpine.LFD.2.00.1102141421500.26192@localhost6.localdomain6> <20110214143902.GA3666@shutemov.name>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110214143902.GA3666-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: Paul Menage <menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 14 Feb 2011, Kirill A. Shutemov wrote:

> On Mon, Feb 14, 2011 at 02:27:44PM +0100, Thomas Gleixner wrote:
> > 
> > Lacks any sensible explanation why and whatfor this needs to be
> > exported.
> 
> I thought it's obvious since it's part of the patchset.
> Am I wrong?

Yes, because we want a sensible changelog for the patch itself.
 
> > And I really doubt that we want to export that at all.
> 
> Why?
> Do you think cgroup_timer_slack built as module is useless?

Pretty much.
 
Thanks,

	tglx
