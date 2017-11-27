From: Mikael Pettersson <mikpelinux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm: disable `vm.max_map_count' sysctl limit
Date: Mon, 27 Nov 2017 20:18:00 +0100
Message-ID: <CAM43=SPVvBTPz31Uu=iz3fpS9tb75uSmL=pYP3AfsfmYr9u4Og@mail.gmail.com>
References: <23066.59196.909026.689706@gargle.gargle.HOWL> <20171127101232.ykriowhatecnvjvg@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171127101232.ykriowhatecnvjvg-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 27, 2017 at 11:12 AM, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > I've kept the kernel tunable to not break the API towards user-space,
> > but it's a no-op now.  Also the distinction between split_vma() and
> > __split_vma() disappears, so they are merged.
>
> Could you be more explicit about _why_ we need to remove this tunable?
> I am not saying I disagree, the removal simplifies the code but I do not
> really see any justification here.

In principle you don't "need" to, as those that know about it can bump it
to some insanely high value and get on with life.  Meanwhile those that don't
(and I was one of them until fairly recently, and I'm no newcomer to Unix or
Linux) get to scratch their heads and wonder why the kernel says ENOMEM
when one has loads of free RAM.

But what _is_ the justification for having this arbitrary limit?
There might have
been historical reasons, but at least ELF core dumps are no longer a problem.

/Mikael
