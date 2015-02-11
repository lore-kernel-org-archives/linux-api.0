From: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC] simple_char: New infrastructure to simplify chardev
 management
Date: Wed, 11 Feb 2015 11:10:00 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1502111029310.10719@pobox.suse.cz>
References: <d3ab93173d51cebf00dd2263fd0ce9f8cd6258f7.1423609645.git.luto@amacapital.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d3ab93173d51cebf00dd2263fd0ce9f8cd6258f7.1423609645.git.luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 10 Feb 2015, Andy Lutomirski wrote:

> This isn't adequately tested, and I don't have a demonstration (yet).
> It's here for review for whether it's a good idea in the first place
> and for weather the fully_dynamic mechanism is a good idea.
[ ... snip ... ]
> Signed-off-by: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>

Andy, thanks a lot, this really *is* needed. I am willing to port things I 
am responsible for (such as hidraw) to this once this gets merged.

Acked-by: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>

-- 
Jiri Kosina
SUSE Labs
