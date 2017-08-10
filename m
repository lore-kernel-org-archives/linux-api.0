From: =?UTF-8?Q?Colm_MacC=C3=A1rthaigh?= <colm-ZXBCfW2eEe/k1uMJSBkQmQ@public.gmane.org>
Subject: Re: [PATCH v2 0/2] mm,fork,security: introduce MADV_WIPEONFORK
Date: Thu, 10 Aug 2017 15:23:05 +0200
Message-ID: <CAAF6GDc2hsj-XJj=Rx2ZF6Sh3Ke6nKewABXfqQxQjfDd5QN7Ug@mail.gmail.com>
References: <20170806140425.20937-1-riel@redhat.com> <20170807132257.GH32434@dhcp22.suse.cz>
 <20170807134648.GI32434@dhcp22.suse.cz> <1502117991.6577.13.camel@redhat.com> <20170810130531.GS23863@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170810130531.GS23863-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Aug 10, 2017 at 3:05 PM, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> Too late for that. VM_DONTFORK is already implemented
>> through MADV_DONTFORK & MADV_DOFORK, in a way that is
>> very similar to the MADV_WIPEONFORK from these patches.
>
> Yeah, those two seem to be breaking the "madvise as an advise" semantic as
> well but that doesn't mean we should follow that pattern any further.

I would imagine that many of the crypto applications using
MADV_WIPEONFORK will also be using MADV_DONTDUMP. In cases where it's
for protecting secret keys, I'd like to use both in my code, for
example. Though that doesn't really help decide this.

There is also at least one case for being able to turn WIPEONFORK
on/off with an existing page; a process that uses privilege separation
often goes through the following flow:

1. [ Access privileged keys as a power user and initialize memory ]
2. [ Fork a child process that actually does the work ]
3. [ Child drops privileges and uses the memory to do work ]
4. [ Parent hangs around to re-spawn a child if it crashes ]

In that mode it would be convenient to be able to mark the memory as
WIPEONFORK in the child, but not the parent.

-- 
Colm
