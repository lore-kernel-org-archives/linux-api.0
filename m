From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: [regresssion 4.15] Userspace compilation broken by
 uapi/linux/if_ether.h update
Date: Fri, 26 Jan 2018 14:21:12 -0500 (EST)
Message-ID: <20180126.142112.325554964556420357.davem@davemloft.net>
References: <032d01e4-81c8-ad2f-abaf-28a5584e6bef@hauke-m.de>
        <20180126105138.GU1422@alphalink.fr>
        <20180126171723.GV1422@alphalink.fr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180126171723.GV1422-pHk1y4uTXVDytLWWfqlThQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: g.nault-pHk1y4uTXVDytLWWfqlThQ@public.gmane.org
Cc: hauke-5/S+JYg5SzeELgA04lAiVw@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Guillaume Nault <g.nault-pHk1y4uTXVDytLWWfqlThQ@public.gmane.org>
Date: Fri, 26 Jan 2018 18:17:23 +0100

> On Fri, Jan 26, 2018 at 11:51:38AM +0100, Guillaume Nault wrote:
>> On Thu, Jan 25, 2018 at 11:21:34PM +0100, Hauke Mehrtens wrote:
>> > On 01/25/2018 03:58 PM, Guillaume Nault wrote:
>> > > Now that linux/libc-compat.h is included in linux/if_ether.h, it is
>> > > processed before netinet/in.h. Therefore, it sets the relevant
>> > > __UAPI_DEF_* guards to 1 (as _NETINET_IN_H isn't yet defined).
>> > > Then netinet/in.h is included, followed by linux/in.h. The later
>> > > doesn't realise that what it defines has already been included by
>> > > netinet/in.h because the __UAPI_DEF_* guards were set too early.
>> > > 
>> > This is about this commit:
>> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6926e041a8920c8ec27e4e155efa760aa01551fd
>> > 
>> > On option would be to move this into include/uapi/linux/if_ether.h and
>> > remove the include for libc-compat.h:
>> > #ifndef __UAPI_DEF_ETHHDR
>> > #define __UAPI_DEF_ETHHDR		1
>> > #endif
>> > 
>> > This will only work if netinet/if_ether.h is included before
>> > linux/if_ether.h, but I think this is very likely.
>> >
>> I don't see what makes its likely. That's not directly related to your
>> point, but for example, glibc guarantees the opposite as it includes
>> linux/if_ether.h at the beginning of netinet/if_ether.h.
>> 
>> > I think we can do this because we do not need some special libc handling
>> > like it is done for other symbols as __UAPI_DEF_ETHHDR is currently only
>> > needed by musl and not by glibc.
>> > 
>> That's ok for me as long as existing projects keep compiling. But all
>> __UAPI_DEF_* are currently centralised in libc-compat.h. Adding
>> __UAPI_DEF_ETHHDR in if_ether.h looks like defeating the purpose of
>> libc-compat.h and I wonder if that'd be accepted. Maybe with a
>> different name.
>> 
>> In any case, we're really late in the release cycle. If more discussion
>> is needed, it's probably better to revert and take time to work on a
>> solution for the next release.
>> 
> Hi David,
> 
> I just realise you've sent your last pull request for this release. I
> was waiting for feedbacks in order to avoid a revert. Should I send a
> revert now or do you prefer to sort this out later and backport a fix
> in 4.15.1?

We can do a -stable backport, and I was planning to help looking into this
as well.
