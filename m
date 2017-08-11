From: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/2] mm,fork,security: introduce MADV_WIPEONFORK
Date: Fri, 11 Aug 2017 16:11:44 +0200
Message-ID: <c8cda773-b28d-f35f-7f18-6735584cb173@redhat.com>
References: <20170806140425.20937-1-riel@redhat.com>
 <20170807132257.GH32434@dhcp22.suse.cz>
 <20170807134648.GI32434@dhcp22.suse.cz> <1502117991.6577.13.camel@redhat.com>
 <20170810130531.GS23863@dhcp22.suse.cz>
 <CAAF6GDc2hsj-XJj=Rx2ZF6Sh3Ke6nKewABXfqQxQjfDd5QN7Ug@mail.gmail.com>
 <20170810153639.GB23863@dhcp22.suse.cz>
 <CAAF6GDeno6RpHf1KORVSxUL7M-CQfbWFFdyKK8LAWd_6PcJ55Q@mail.gmail.com>
 <20170810170144.GA987@dhcp22.suse.cz>
 <CAAF6GDdFjS612mx1TXzaVk1J-Afz9wsAywTEijO2TG4idxabiw@mail.gmail.com>
 <20170811140653.GO30811@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170811140653.GO30811-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?Q?Colm_MacC=c3=a1rthaigh?= <colm-ZXBCfW2eEe/k1uMJSBkQmQ@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 08/11/2017 04:06 PM, Michal Hocko wrote:

> I am sorry to look too insisting here (I have still hard time to reconcile
> myself with the madvise (ab)use) but if we in fact want minherit like
> interface why don't we simply add minherit and make the code which wants
> to use that interface easier to port? Is the only reason that hooking
> into madvise is less code? If yes is that a sufficient reason to justify
> the (ab)use of madvise? If there is a general consensus on that part I
> will shut up and won't object anymore. Arguably MADV_DONTFORK would fit
> into minherit API better as well.

It does, OpenBSD calls it MAP_INHERIT_NONE.

Could you implement MAP_INHERIT_COPY and MAP_INHERIT_SHARE as well?  Or
is changing from MAP_SHARED to MAP_PRIVATE and back impossible?

Thanks,
Florian
