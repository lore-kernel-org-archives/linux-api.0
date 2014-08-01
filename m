From: "Jan Beulich" <JBeulich-IBi9RG/b67k@public.gmane.org>
Subject: Re: [Xen-devel] [PATCH 1/2] xen: Implement ioctl to restrict
 privcmd to a specific domain
Date: Fri, 01 Aug 2014 09:27:25 +0100
Message-ID: <53DB6B8D02000078000284D3@mail.emea.novell.com>
References: <E1XCqEY-0005zn-V2@lists.xen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E1XCqEY-0005zn-V2-GuqFBffKawuEi8DpZVb4nw@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Frediano Ziglio <frediano.ziglio-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Cc: David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, xen-devel <xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

>>> On 31.07.14 at 15:16, <frediano.ziglio-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org> wrote:
> Add a RESTRICT ioctl to /dev/xen/privcmd, which allows privileged commands
> file descriptor to be restricted to only working with a particular domain.

The "with" here has been quite confusing, and I realized that you
mean the subject domain rather than the actor one only after
having gone through quite some parts of the patch. For a patch
this size, a little more of a description (and the original motivation)
would have helped.

Wrt motivation: Why does this need enforcing in the kernel at all?
Doesn't XSM_DM_PRIV mode deal specifically with what you're
trying to do here? Or else I guess I really need some better
explanation of what this is about.

Jan
