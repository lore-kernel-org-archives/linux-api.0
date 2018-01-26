From: Guillaume Nault <g.nault@alphalink.fr>
Subject: Re: [regresssion 4.15] Userspace compilation broken by
 uapi/linux/if_ether.h update
Date: Fri, 26 Jan 2018 11:51:38 +0100
Message-ID: <20180126105138.GU1422@alphalink.fr>
References: <20180125145819.GT1422@alphalink.fr>
 <032d01e4-81c8-ad2f-abaf-28a5584e6bef@hauke-m.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <032d01e4-81c8-ad2f-abaf-28a5584e6bef@hauke-m.de>
Sender: netdev-owner@vger.kernel.org
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: netdev@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Jan 25, 2018 at 11:21:34PM +0100, Hauke Mehrtens wrote:
> On 01/25/2018 03:58 PM, Guillaume Nault wrote:
> > Hi,
> > 
> > Commit 6926e041a892 ("uapi/if_ether.h: prevent redefinition of struct ethhdr"),
> > can break compilation of userspace programs (in my case, accel-ppp
> > (https://accel-ppp.org)).
> > 
> > This happens for userspace programs that end up including
> > linux/if_ether.h, netinet/in.h and linux/in.h in this order:
> > 
> > # cat test_ifether.c
> > #include <linux/if_ether.h>
> > #include <netinet/in.h>
> > #include <linux/in.h>
> > 
> > int main(void)
> > {
> > 	return 0;
> > }
> > 
> > # gcc test_ifether.c
> > In file included from test_ifether.c:2:0:
> > /usr/include/linux/in.h:29:3: error: redeclaration of enumerator ‘IPPROTO_IP’
> >    IPPROTO_IP = 0,  /* Dummy protocol for TCP  */
> >    ^
> > /usr/include/netinet/in.h:42:5: note: previous definition of ‘IPPROTO_IP’ was here
> >      IPPROTO_IP = 0,    /* Dummy protocol for TCP.  */
> >      ^~~~~~~~~~
> > 
> > 
> > Now that linux/libc-compat.h is included in linux/if_ether.h, it is
> > processed before netinet/in.h. Therefore, it sets the relevant
> > __UAPI_DEF_* guards to 1 (as _NETINET_IN_H isn't yet defined).
> > Then netinet/in.h is included, followed by linux/in.h. The later
> > doesn't realise that what it defines has already been included by
> > netinet/in.h because the __UAPI_DEF_* guards were set too early.
> > 
> > Of course the situation is a bit more complicated on real projects, as
> > these files aren't included directly. For example, in accel-ppp, the
> > PPPoE module (accel-ppp/accel-pppd/ctrl/pppoe/pppoe.c) uses
> > #include <net/ethernet.h>   /* includes linux/if_ether.h */
> > #include <arpa/inet.h>      /* includes netinet/in.h */
> > #include <linux/if_pppox.h> /* (through pppoe.h), includes linux/in.h */
> > 
> > 
> > I don't have a satisfying solution for now, but I'd really like it if
> > we could avoid shipping a kernel which forces userspace to play with
> > include files ordering to keep compiling.
> > 
> Hi,
> 
> This is about this commit:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6926e041a8920c8ec27e4e155efa760aa01551fd
> 
> On option would be to move this into include/uapi/linux/if_ether.h and
> remove the include for libc-compat.h:
> #ifndef __UAPI_DEF_ETHHDR
> #define __UAPI_DEF_ETHHDR		1
> #endif
> 
> This will only work if netinet/if_ether.h is included before
> linux/if_ether.h, but I think this is very likely.
>
I don't see what makes its likely. That's not directly related to your
point, but for example, glibc guarantees the opposite as it includes
linux/if_ether.h at the beginning of netinet/if_ether.h.

> I think we can do this because we do not need some special libc handling
> like it is done for other symbols as __UAPI_DEF_ETHHDR is currently only
> needed by musl and not by glibc.
> 
That's ok for me as long as existing projects keep compiling. But all
__UAPI_DEF_* are currently centralised in libc-compat.h. Adding
__UAPI_DEF_ETHHDR in if_ether.h looks like defeating the purpose of
libc-compat.h and I wonder if that'd be accepted. Maybe with a
different name.

In any case, we're really late in the release cycle. If more discussion
is needed, it's probably better to revert and take time to work on a
solution for the next release.
