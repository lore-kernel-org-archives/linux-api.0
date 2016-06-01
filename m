From: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Subject: Re: [PATCH 7/8] pkeys: add details of system call use to
 Documentation/
Date: Wed, 1 Jun 2016 10:49:37 -0600
Message-ID: <20160601104937.098a89a2@lwn.net>
References: <20160531152814.36E0B9EE@viggo.jf.intel.com>
	<20160531152824.2B18E890@viggo.jf.intel.com>
	<20160601104333.7c2014fa@lwn.net>
	<574F114F.8010701@sr71.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <574F114F.8010701-gkUM19QKKo4@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 1 Jun 2016 09:46:07 -0700
Dave Hansen <dave-gkUM19QKKo4@public.gmane.org> wrote:

> On 06/01/2016 09:43 AM, Jonathan Corbet wrote:
> >> > +There are 5 system calls which directly interact with pkeys:
> >> > +
> >> > +	int pkey_alloc(unsigned long flags, unsigned long init_access_rights)
> >> > +	int pkey_free(int pkey);
> >> > +	int sys_pkey_mprotect(unsigned long start, size_t len,
> >> > +			      unsigned long prot, int pkey);
> >> > +	unsigned long pkey_get(int pkey);
> >> > +	int pkey_set(int pkey, unsigned long access_rights);  
> > sys_pkey_mprotect() should just be pkey_mprotect(), right?  
> 
> Yes, and that are a few more instances of that farther down in the file.
>  I'll fix them all up.

While you're at it (I shouldn't have hit send quite so quickly :) 

> +	sys_pkey_alloc(0, PKEY_DISABLE_WRITE | PKEY_DISABLE_READ);
> +	sys_pkey_mprotect(ptr, size, PROT_READ|PROT_WRITE);
> +	something(ptr);

That should, IMO, be something like:

	key = pkey_alloc(...);
	pkey_mprotect(ptr, size, PROT_READ|PROT_WRITE, key);

?


jon
