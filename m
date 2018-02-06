From: Guillaume Nault <g.nault-pHk1y4uTXVDytLWWfqlThQ@public.gmane.org>
Subject: Re: [regresssion 4.15] Userspace compilation broken by
 uapi/linux/if_ether.h update
Date: Tue, 6 Feb 2018 16:08:48 +0100
Message-ID: <20180206150848.GX1422@alphalink.fr>
References: <20180125145819.GT1422@alphalink.fr>
 <032d01e4-81c8-ad2f-abaf-28a5584e6bef@hauke-m.de>
 <20180126105138.GU1422@alphalink.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180126105138.GU1422-pHk1y4uTXVDytLWWfqlThQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hauke Mehrtens <hauke-5/S+JYg5SzeELgA04lAiVw@public.gmane.org>
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Jan 26, 2018 at 11:51:38AM +0100, Guillaume Nault wrote:
> On Thu, Jan 25, 2018 at 11:21:34PM +0100, Hauke Mehrtens wrote:
> > On 01/25/2018 03:58 PM, Guillaume Nault wrote:
> > > Hi,
> > > 
> > > Commit 6926e041a892 ("uapi/if_ether.h: prevent redefinition of struct ethhdr"),
> > > can break compilation of userspace programs (in my case, accel-ppp
> > > (https://accel-ppp.org)).
> > > 
> > > This happens for userspace programs that end up including
> > > linux/if_ether.h, netinet/in.h and linux/in.h in this order:
> > > 
> > > # cat test_ifether.c
> > > #include <linux/if_ether.h>
> > > #include <netinet/in.h>
> > > #include <linux/in.h>
> > > 
> > > int main(void)
> > > {
> > > 	return 0;
> > > }
> > > 
> > > # gcc test_ifether.c
> > > In file included from test_ifether.c:2:0:
> > > /usr/include/linux/in.h:29:3: error: redeclaration of enumerator ‘IPPROTO_IP’
> > >    IPPROTO_IP = 0,  /* Dummy protocol for TCP  */
> > >    ^
> > > /usr/include/netinet/in.h:42:5: note: previous definition of ‘IPPROTO_IP’ was here
> > >      IPPROTO_IP = 0,    /* Dummy protocol for TCP.  */
> > >      ^~~~~~~~~~
> > > 
> > > 
> > > Now that linux/libc-compat.h is included in linux/if_ether.h, it is
> > > processed before netinet/in.h. Therefore, it sets the relevant
> > > __UAPI_DEF_* guards to 1 (as _NETINET_IN_H isn't yet defined).
> > > Then netinet/in.h is included, followed by linux/in.h. The later
> > > doesn't realise that what it defines has already been included by
> > > netinet/in.h because the __UAPI_DEF_* guards were set too early.
> > > 
> > > Of course the situation is a bit more complicated on real projects, as
> > > these files aren't included directly. For example, in accel-ppp, the
> > > PPPoE module (accel-ppp/accel-pppd/ctrl/pppoe/pppoe.c) uses
> > > #include <net/ethernet.h>   /* includes linux/if_ether.h */
> > > #include <arpa/inet.h>      /* includes netinet/in.h */
> > > #include <linux/if_pppox.h> /* (through pppoe.h), includes linux/in.h */
> > > 
> > > 
> > > I don't have a satisfying solution for now, but I'd really like it if
> > > we could avoid shipping a kernel which forces userspace to play with
> > > include files ordering to keep compiling.
> > > 
> > Hi,
> > 
> > This is about this commit:
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6926e041a8920c8ec27e4e155efa760aa01551fd
> > 
> > On option would be to move this into include/uapi/linux/if_ether.h and
> > remove the include for libc-compat.h:
> > #ifndef __UAPI_DEF_ETHHDR
> > #define __UAPI_DEF_ETHHDR		1
> > #endif
> >
Hauke, please submit a patch implementing this approach and let's see
where it goes.
