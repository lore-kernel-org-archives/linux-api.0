From: =?UTF-8?Q?Colm_MacC=C3=A1rthaigh?= <colm-ZXBCfW2eEe/k1uMJSBkQmQ@public.gmane.org>
Subject: Re: [PATCH v2 0/2] mm,fork,security: introduce MADV_WIPEONFORK
Date: Fri, 11 Aug 2017 00:09:57 +0200
Message-ID: <CAAF6GDdFjS612mx1TXzaVk1J-Afz9wsAywTEijO2TG4idxabiw@mail.gmail.com>
References: <20170806140425.20937-1-riel@redhat.com> <20170807132257.GH32434@dhcp22.suse.cz>
 <20170807134648.GI32434@dhcp22.suse.cz> <1502117991.6577.13.camel@redhat.com>
 <20170810130531.GS23863@dhcp22.suse.cz> <CAAF6GDc2hsj-XJj=Rx2ZF6Sh3Ke6nKewABXfqQxQjfDd5QN7Ug@mail.gmail.com>
 <20170810153639.GB23863@dhcp22.suse.cz> <CAAF6GDeno6RpHf1KORVSxUL7M-CQfbWFFdyKK8LAWd_6PcJ55Q@mail.gmail.com>
 <20170810170144.GA987@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170810170144.GA987-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Aug 10, 2017 at 7:01 PM, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Does anybody actually do that using the minherit BSD interface?

I can't find any OSS examples. I just thought of it in response to
your question, but now that I have, I do want to use it that way in
privsep code.

As a mere user, fwiw it would make /my/ code less complex (in
Kolmogorov terms) to be an madvise option. Here's what that would look
like in user space:

mmap()

#if MAP_INHERIT_ZERO
    minherit() || pthread_atfork(workaround_fptr);
#elif MADVISE_WIPEONFORK
    madvise() || pthread_atfork(workaround_fptr);
#else
    pthread_atfork(workaround_fptr);
#endif

Vs:

#if MAP_WIPEONFORK
    mmap( ... WIPEONFORK) || pthread_atfork(workaround_fptr);
#else
    mmap()
#endif

#if MAP_INHERIT_ZERO
    madvise() || pthread_atfork(workaround_fptr);
#endif

#if !defined(MAP_WIPEONFORK) && !defined(MAP_INHERIT_ZERO)
    pthread_atfork(workaround_fptr);
#endif

The former is neater, and also a lot easier to stay structured if the
code is separated across different functional units. Allocation is
often handled in special functions.

For me, madvise() is the principle of least surprise, following
existing DONTDUMP semantics.

-- 
Colm
