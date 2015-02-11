From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [RFC] simple_char: New infrastructure to simplify chardev
 management
Date: Wed, 11 Feb 2015 08:44:59 +0800
Message-ID: <20150211004459.GA30746@kroah.com>
References: <d3ab93173d51cebf00dd2263fd0ce9f8cd6258f7.1423609645.git.luto@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <d3ab93173d51cebf00dd2263fd0ce9f8cd6258f7.1423609645.git.luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Feb 10, 2015 at 03:44:05PM -0800, Andy Lutomirski wrote:
> This isn't adequately tested, and I don't have a demonstration (yet).
> It's here for review for whether it's a good idea in the first place
> and for weather the fully_dynamic mechanism is a good idea.
> 
> The current character device interfaces are IMO awful.

That's a total understatement.  Redoing the char interface has been in
my todo list for a decade now.  It's the complexity that happens to be
used by just a handful of drivers that have prevented me from doing the
rework in the past.  Creating a "new" interface that we then port code
to is a very good idea, as it can happen over time in a much more
orderly way.

And we can throw the kernel-janitors people at it once it's working, to
convert the rest of the tree, providing them a useful outlet for their
need for patch cleanups :)

So yes, I'm all for this, thanks so much for looking into this.  I'm at
a conference this week, but will go over it on the plane home and give
you some review comments.

greg k-h
