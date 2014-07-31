From: Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [PATCH 1/2] xen: Implement ioctl to restrict
 privcmd to a specific domain
Date: Thu, 31 Jul 2014 14:53:07 +0100
Message-ID: <E1XCqnB-0006fL-TZ@lists.xen.org>
References: <E1XCqEY-0005zn-RQ@lists.xen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xen.org>
In-Reply-To: <E1XCqEY-0005zn-RQ@lists.xen.org>
List-Unsubscribe: <http://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <http://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Sender: xen-devel-bounces@lists.xen.org
Errors-To: xen-devel-bounces@lists.xen.org
To: Frediano Ziglio <frediano.ziglio@citrix.com>
Cc: linux-api@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, David Vrabel <david.vrabel@citrix.com>, xen-devel <xen-devel@lists.xenproject.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
List-Id: linux-api@vger.kernel.org

On Thu, 2014-07-31 at 14:16 +0100, Frediano Ziglio wrote:

>  include/xen/interface/domctl.h     | 1090 ++++++++++++++++++++++++++++++++++++

domctl is an stable toolstack only hypervisor interface, so the kernel
cannot use it because it would then break.

Ian.
