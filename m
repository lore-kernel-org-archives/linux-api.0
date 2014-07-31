From: Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [PATCH 1/2] xen: Implement ioctl to restrict
 privcmd to a specific domain
Date: Thu, 31 Jul 2014 15:58:02 +0100
Message-ID: <E1XCro2-00006t-21@lists.xen.org>
References: <E1XCqEY-0005zn-RQ@lists.xen.org>
	<1406814787.10395.2.camel@kazak.uk.xensource.com>
	<E1XCr4q-0007Nh-3J@lists.xen.org>
	<1406817823.6753.4.camel@hamster.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xen.org>
In-Reply-To: <1406817823.6753.4.camel@hamster.uk.xensource.com>
List-Unsubscribe: <http://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <http://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Sender: xen-devel-bounces@lists.xen.org
Errors-To: xen-devel-bounces@lists.xen.org
To: Frediano Ziglio <frediano.ziglio@citrix.com>
Cc: xen-devel <xen-devel@lists.xenproject.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, David Vrabel <david.vrabel@citrix.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, 2014-07-31 at 15:43 +0100, Frediano Ziglio wrote:
> The code just require that:
> - sizeof(struct xen_domctl) does not increase;
> - position and size of cmd, domain and interface_version does not
> change;
> - XEN_DOMCTL_createdomain is 1.

This is not a stable interface, so you cannot actually rely on any of
those.

For the first one in particular its not that hard to imagine someone
needing a larger subop struct at some point.

Ian.
