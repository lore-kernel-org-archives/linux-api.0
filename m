From: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>
Subject: Re: [PATCH] acpi: drop support for force_remove
Date: Sat, 15 Apr 2017 00:33:06 +0200
Message-ID: <13091724.qdDQ4T8Luo@aspire.rjw.lan>
References: <20170403074023.29121-1-mhocko@kernel.org> <20170411135233.GO6729@dhcp22.suse.cz> <CAJZ5v0hzv1oxpNJvSc2omqaOFRgiBB8UKCbRKGkgzHbEtqosbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZ5v0hzv1oxpNJvSc2omqaOFRgiBB8UKCbRKGkgzHbEtqosbQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Joey Lee <jlee-IBi9RG/b67k@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Kani Toshimitsu <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ACPI Devel Maling List <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tuesday, April 11, 2017 03:54:43 PM Rafael J. Wysocki wrote:
> On Tue, Apr 11, 2017 at 3:52 PM, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > On Tue 11-04-17 15:48:04, Rafael J. Wysocki wrote:
> >> On Tue, Apr 11, 2017 at 2:20 PM, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >> > On Tue 11-04-17 00:15:42, Rafael J. Wysocki wrote:
> > [...]
> >> >> I'll apply it if nobody has any problems with it.
> >> >
> >> > It is definitely your call but how long are we going to wait
> >> > (considering that the current behavior is obviously broken wrt memory
> >> > hotplug)?
> >>
> >> A couple of days more?  Surely not going to push it into 4.11 at this
> >> stage as it is an ABI change.
> >
> > Ohh, I didn't want to push it to 4.11 this late but having it in
> > linux-next might help to catch some users who are not following the
> > mailing list. Going to 4.12 would be really great but I wouldn't really
> > object even 4.13...
> 
> 4.12 is probably fine.  I don't see a compelling reason to sit on this
> for a whole cycle, FWIW.

It should hit linux-next next week.

Thanks,
Rafael
