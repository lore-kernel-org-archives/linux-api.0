From: Nikitas Angelinas <nikitasangelinas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 0/4] quota: add project quota support
Date: Wed, 24 Sep 2014 15:27:52 -0700
Message-ID: <20140924222752.GA23810@frew4006.xyus.xyratex.com>
References: <CAPTn0cDFCj7AWjQpOF0brD82XJSSeem5_1aQCE=zQKiaLaeL1g@mail.gmail.com>
 <20140924125206.GA26916@quack.suse.cz>
 <20140924154239.GA11342@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140924154239.GA11342-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ext4 Developers List <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, "viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dmitry Monakhov <dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Sep 24, 2014 at 11:42:39AM -0400, Theodore Ts'o wrote:
> On Wed, Sep 24, 2014 at 02:52:06PM +0200, Jan Kara wrote:
> >   Whitespace got mangled in your patches so much they are hardly readable.
> > Please resend them so that it is properly preserved. I'm not sure how other
> > guys using gmail do this so you might need to ask them... Thanks!
> 
> And it would be nice if they are chained together so that people with
> proper mail-threading readers can easily find all of your patches.
> 
> Probably the best way to do this is to configure your a local mail
> transfer agent on your Linux desktop/laptop, and configure it to use
> smart mail-router with authenticated SMTP to:
> 
> Host: smtp.gmail.com
> Port: 465
> Authentication: Yes
> Username: #YOU#@gmail.com
> Password: #YOUR_PASSWORD#
> Security: SSL
> 
> Then use "git send-email" to post your patches, and it should all be
> good.
> 
> (I'm guessing your cutting and pasting your patches into the mail send
> window, and that unfortunately tends not to work well.)
> 
> Cheers,
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Li Xi,


You can set up Mutt (likely Alpine, maybe others) to work with GMail, if
you want to; I believe it handles whitespace and patch series well by
default. There are relevant resources online to assist with the
configuration, if you need them. It also includes an SMTP feature, if you
want to make use of it.



Cheers,
Nikitas
