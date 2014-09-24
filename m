From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH v4 0/4] quota: add project quota support
Date: Wed, 24 Sep 2014 11:42:39 -0400
Message-ID: <20140924154239.GA11342@thunk.org>
References: <CAPTn0cDFCj7AWjQpOF0brD82XJSSeem5_1aQCE=zQKiaLaeL1g@mail.gmail.com>
 <20140924125206.GA26916@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140924125206.GA26916-+0h/O2h83AeN3ZZ/Hiejyg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ext4 Developers List <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, "viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dmitry Monakhov <dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Sep 24, 2014 at 02:52:06PM +0200, Jan Kara wrote:
>   Whitespace got mangled in your patches so much they are hardly readable.
> Please resend them so that it is properly preserved. I'm not sure how other
> guys using gmail do this so you might need to ask them... Thanks!

And it would be nice if they are chained together so that people with
proper mail-threading readers can easily find all of your patches.

Probably the best way to do this is to configure your a local mail
transfer agent on your Linux desktop/laptop, and configure it to use
smart mail-router with authenticated SMTP to:

Host: smtp.gmail.com
Port: 465
Authentication: Yes
Username: #YOU#@gmail.com
Password: #YOUR_PASSWORD#
Security: SSL

Then use "git send-email" to post your patches, and it should all be
good.

(I'm guessing your cutting and pasting your patches into the mail send
window, and that unfortunately tends not to work well.)

Cheers,

						- Ted
