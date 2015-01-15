From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] virtio_balloon: coding style fixes
Date: Thu, 15 Jan 2015 20:50:18 +0200
Message-ID: <20150115185018.GA31068@redhat.com>
References: <1421321941-21111-1-git-send-email-mst@redhat.com>
	<20150115130642.GC7008@dhcp22.suse.cz>
	<20150115134412.GA23874@redhat.com>
	<20150115141308.GH7000@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <20150115141308.GH7000@dhcp22.suse.cz>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-api@vger.kernel.org

On Thu, Jan 15, 2015 at 03:13:08PM +0100, Michal Hocko wrote:
> On Thu 15-01-15 15:44:12, Michael S. Tsirkin wrote:
> > On Thu, Jan 15, 2015 at 02:06:42PM +0100, Michal Hocko wrote:
> > > On Thu 15-01-15 13:39:06, Michael S. Tsirkin wrote:
> > > > Most of our code has
> > > > struct foo {
> > > > }
> > > > 
> > > > Fix two instances where balloon is inconsistent.
> > > 
> > > I hate to complain but is it really necessary to post such patches to
> > > linux-api?
> > 
> > Well it's human to err, so it seems wise to copy parties
> > interested in the ABI/API whenever we are changing files under include/uapi.
> > Whitespace changes should mostly be safe, but it's not unknown
> > e.g. to include unrelated changes in the same commit by mistake.
> > 
> > > I thought the list was primarily for API related discussions.
> > 
> > Basically this line in MAINTAINERS
> > 
> > ABI/API
> > L:      linux-api@vger.kernel.org
> > F:      Documentation/ABI/
> > F:      include/linux/syscalls.h
> > F:      include/uapi/
> > F:      kernel/sys_ni.c
> > 
> > normally means "send all patches affecting files under include/uapi/ to
> > this list", does it not?
> 
> Well, this should always be taken as a hint not a hard rule. So if there
> is a change which is adding/removing or changing signature then sure but
> not everything falls into that category.

At least for code I maintain, I really wish people would just Cc me in
any case.  There's been a bunch of cases where people don't Cc me, and
then another maintainer assumes my silence implies agreement, and
applies.  Not nice. OTOH it's easy to ignore an irrelevant patch.

> > Wasn't this the intent?
> > 
> > > This is not the only mail sent here which doesn't fall into that
> > > category IMO. It is far from low volume list for quite some time.
> > > 
> > > Please let's get back low volume and API only discussion!
> > 
> > Maybe send patch dropping include/uapi/ from there,
> > should help drive the volumes down?
> 
> This would be an overkill IMO. It would be much more preferable if
> people actually think about who from the suggested list (either from
> MAINTAINERS or ./scripts/get_maintainer.pl) should be really added.
> 
> [...]

Yea, think about it, then what?  I've no idea what is linux-abi for, and
what people subscribed there are interested in. How should I? All I know
is what's in MAINTAINERS, which say "ABI/API". So I copy all ABI/API
patches there.

> -- 
> Michal Hocko
> SUSE Labs
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
