From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v2 0/1] man/set_mempolicy.2,mbind.2: add MPOL_LOCAL NUMA
 memory policy documentation
Date: Mon, 10 Oct 2016 08:55:13 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1610100854001.27158@east.gentwo.org>
References: <alpine.DEB.2.20.1610040333050.10814@east.gentwo.org> <20161009185601.3310-1-kwapulinski.piotr@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20161009185601.3310-1-kwapulinski.piotr@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Piotr Kwapulinski <kwapulinski.piotr@gmail.com>
Cc: mtk.manpages@gmail.com, kirill.shutemov@linux.intel.com, vbabka@suse.cz, rientjes@google.com, mhocko@kernel.org, mgorman@techsingularity.net, liangchen.linux@gmail.com, nzimmer@sgi.com, a.p.zijlstra@chello.nl, riel@redhat.com, lee.schermerhorn@hp.com, jmarchan@redhat.com, joe@perches.com, corbet@lwn.net, iamyooon@gmail.com, n-horiguchi@ah.jp.nec.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-man@vger.kernel.org, akpm@linux-foundation.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sun, 9 Oct 2016, Piotr Kwapulinski wrote:

> +arguments must specify the empty set. If the "local node" is low
> +on free memory the kernel will try to allocate memory from other
> +nodes. The kernel will allocate memory from the "local node"
> +whenever the memory for this node will be released. If the

"whenever memory for this node is available"?

Otherwise

Reviewed-by: Christoph Lameter <cl@linux.com>

