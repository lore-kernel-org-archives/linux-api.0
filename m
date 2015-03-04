From: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
Subject: Re: [PATCHv2 1/2] HSI: cmt_speech: Add cmt-speech driver
Date: Wed, 04 Mar 2015 12:09:16 +0100
Message-ID: <1425467356.2798.8.camel@tiscali.nl>
References: <1425343454-6551-1-git-send-email-sre@kernel.org>
	 <1425343454-6551-2-git-send-email-sre@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1425343454-6551-2-git-send-email-sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Ujfalusi <peter.ujfalusi-l0cyMroinI0@public.gmane.org>, Kai Vehmanen <kvcontact-nQfqiRJ1PMYxHbG02/KK1g@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Pali Rohar <pali.rohar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Aaro Koskinen <aaro.koskinen-X3B1VOXEql0@public.gmane.org>, Ivaylo Dimitrov <ivo.g.dimitrov.75-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-omap-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kai Vehmanen <kai.vehmanen-xNZwKgViW5gAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

A license nit only.

Sebastian Reichel schreef op di 03-03-2015 om 01:44 [+0100]:
> --- /dev/null
> +++ b/drivers/hsi/clients/cmt_speech.c
> @@ -0,0 +1,1457 @@
> +/*
> + * cmt_speech.c - HSI CMT speech driver
> + *
> + * Copyright (C) 2008,2009,2010 Nokia Corporation. All rights reserved.
> + *
> + * Contact: Kai Vehmanen <kai.vehmanen-xNZwKgViW5gAvxtiuMwx3w@public.gmane.org>
> + * Original author: Peter Ujfalusi <peter.ujfalusi-xNZwKgViW5gAvxtiuMwx3w@public.gmane.org>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> + * 02110-1301 USA
> + */

This states the license is GPL v2.

> +MODULE_LICENSE("GPL");

So you probably want 
    MODULE_LICENSE("GPL v2");

here.


Paul Bolle
