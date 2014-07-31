From: David Vrabel <david.vrabel@citrix.com>
Subject: Re: [PATCH 1/2] xen: Implement ioctl to restrict
 privcmd to a specific domain
Date: Thu, 31 Jul 2014 15:11:12 +0100
Message-ID: <E1XCr4p-0007Nh-Rr@lists.xen.org>
References: <E1XCqEY-0005zn-RQ@lists.xen.org>
	<1406814787.10395.2.camel@kazak.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xen.org>
In-Reply-To: <1406814787.10395.2.camel@kazak.uk.xensource.com>
List-Unsubscribe: <http://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <http://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Sender: xen-devel-bounces@lists.xen.org
Errors-To: xen-devel-bounces@lists.xen.org
To: Ian Campbell <Ian.Campbell@citrix.com>, Frediano Ziglio <frediano.ziglio@citrix.com>
Cc: xen-devel <xen-devel@lists.xenproject.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, linux-api@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 31/07/14 14:53, Ian Campbell wrote:
> On Thu, 2014-07-31 at 14:16 +0100, Frediano Ziglio wrote:
> 
>>  include/xen/interface/domctl.h     | 1090 ++++++++++++++++++++++++++++++++++++
> 
> domctl is an stable toolstack only hypervisor interface, so the kernel
> cannot use it because it would then break.

Ok.  I guess we'll have to resurrect the idea to do something with XSM.

David
