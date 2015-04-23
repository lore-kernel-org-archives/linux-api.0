From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [RFC] simple_char: New infrastructure to simplify chardev
 management
Date: Thu, 23 Apr 2015 10:25:43 +0200
Message-ID: <20150423082543.GA10801@kroah.com>
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

Sorry for the long delay.

I looked at this, and at a first glance, this looks good.  The existing
char interface is a mess, and needs to really be simplified.  I think
this code can go a long way toward making that happen.

But I'm a bit confused as to how to use this.  Can you pick some
in-kernel driver and convert it to this interface to see how it would
"work"?

Ideally, between an interface like this, and the miscdevice interface,
that should be the main way to create character devices, simplifying a
lot of "boilerplate" code we have in drivers today.

Some minor comments on the code:

> +	ret = -ENOMEM;
> +	major = kmalloc(sizeof(struct simple_char_major), GFP_KERNEL);
> +	if (!major)
> +		goto out_unregister;
> +	cdev_init(&major->cdev, &simple_char_fops);
> +	kobject_set_name(&major->cdev.kobj, "%s", name);

The kobject in a cdev isn't a "real" kobject in that the name doesn't
matter, and it's never "registered" with sysfs.  It's only use for the
kobject map code, for looking up the cdev very quickly.  I really would
like to just split the kmap code out from being related to a kobject as
it's something that confuses a lot of people, but never spent the time
to do the work.

So a line like this shouldn't do anything, you don't have to set the
name here.

> +void simple_char_major_free(struct simple_char_major *major)
> +{
> +	BUG_ON(!idr_is_empty(&major->idr));

WARN_ON is best, we never want to add new BUG calls to the kernel.  Or,
if this really can never happen, we don't need to test for it.

thanks,

greg k-h
