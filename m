From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH, v8 1/3] hrtimer: introduce effective timer slack
Date: Fri, 4 Mar 2011 13:55:21 +0100
Message-ID: <201103041355.21740.arnd@arndb.de>
References: <1299161947-9903-1-git-send-email-kirill@shutemov.name> <201103031732.28964.arnd@arndb.de> <20110304122035.GB14933@shutemov.name>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110304122035.GB14933-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: Paul Menage <menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Friday 04 March 2011, Kirill A. Shutemov wrote:
> > Does this make sense to you?
> 
> Hm.. I think we can add this kind of functionality to timer slack cgroup
> as a policy/stratagy later. I want to integrate basic functionality to
> kernel first.

Yes, makes sense. I wasn't objecting the current patch set, just trying
to make sure that the other idea does not get lost, and we don't introduce
anything now that prevents us from doing it later.

	Arnd
