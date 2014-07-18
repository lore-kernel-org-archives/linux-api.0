From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [tytso-DPNOqEs/LNQ@public.gmane.org: [PATCH, RFC -v3] random: introduce getrandom(2)
 system call]
Date: Fri, 18 Jul 2014 10:04:03 -0400
Message-ID: <20140718140403.GI1491@thunk.org>
References: <20140718125606.GH1491@thunk.org>
 <5293846.HEIrYe5Drj@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5293846.HEIrYe5Drj@wuerfel>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Jul 18, 2014 at 03:16:18PM +0200, Arnd Bergmann wrote:
> On Friday 18 July 2014 08:56:06 Theodore Ts'o wrote:
> > 
> > The change in the v3 version of the commit was to eliminate potential
> > short reads and EINTR returns when reading from urandom (once the
> > urandom pool is initialized).  This was based on comments and requests
> > from Theo de Raadt.  See the NOTES section in the suggested man page for
> > a more in-depth discussion of the issues involved.
> 
> I think there is a problem with the completion...
>
> However, here you can get called an arbitrary number of times.
> It seems entirely possible than an attacker can manage to call
> this function 2 billion times. Assuming a latency of 1 microsecond
> per syscall, that would take about half an hour. After that, you
> never again get any urandom data out of the syscall.
> 
> I think you are better off using a plain wait_event() here.

Nice catch, thanks!!

I'll rework the patch to use wait_event().

							- Ted
