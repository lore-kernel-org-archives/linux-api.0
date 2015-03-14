From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] capabilities: Ambient capability set V2
Date: Sat, 14 Mar 2015 20:04:28 +0100
Message-ID: <20150314190428.GA24289@amd>
References: <alpine.DEB.2.11.1502261612370.8994@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1502261612370.8994@gentwo.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Lameter <cl@linux.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, Jonathan Corbet <corbet@lwn.net>, Aaron Jones <aaronmdjones@gmail.com>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linuxfoundation.org, "Andrew G. Morgan" <morgan@kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Markku Savela <msa@moth.iki.fi>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

Hi!

>  		return -ENOSYS;
> Index: linux/include/linux/cred.h
> ===================================================================
> --- linux.orig/include/linux/cred.h	2015-02-25 13:43:06.929973954 -0600
> +++ linux/include/linux/cred.h	2015-02-25 13:43:06.925972078 -0600
> @@ -122,6 +122,7 @@ struct cred {
>  	kernel_cap_t	cap_permitted;	/* caps we're permitted */
>  	kernel_cap_t	cap_effective;	/* caps we can actually use */
>  	kernel_cap_t	cap_bset;	/* capability bounding set */
> +	kernel_cap_t	cap_ambient;	/* Ambient capability set */

lowercase "Ambient", for consistency?

Thanks,
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
