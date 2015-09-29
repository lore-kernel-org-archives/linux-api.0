From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH 21/25] mm: implement new mprotect_key() system call
Date: Tue, 29 Sep 2015 16:39:43 +1000
Message-ID: <1443508783.29119.2.camel@ellerman.id.au>
References: <20150928191817.035A64E2@viggo.jf.intel.com>
	 <20150928191826.F1CD5256@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150928191826.F1CD5256-LXbPSdftPKxrdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>
Cc: borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 2015-09-28 at 12:18 -0700, Dave Hansen wrote:
> From: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> 
> mprotect_key() is just like mprotect, except it also takes a
> protection key as an argument.  On systems that do not support
> protection keys, it still works, but requires that key=0.

I'm not sure how userspace is going to use the key=0 feature? ie. userspace
will still have to detect that keys are not supported and use key 0 everywhere.
At that point it could just as well skip the mprotect_key() syscalls entirely
couldn't it?

> I expect it to get used like this, if you want to guarantee that
> any mapping you create can *never* be accessed without the right
> protection keys set up.
> 
> 	pkey_deny_access(11); // random pkey
> 	int real_prot = PROT_READ|PROT_WRITE;
> 	ptr = mmap(NULL, PAGE_SIZE, PROT_NONE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
> 	ret = mprotect_key(ptr, PAGE_SIZE, real_prot, 11);
> 
> This way, there is *no* window where the mapping is accessible
> since it was always either PROT_NONE or had a protection key set.
> 
> We settled on 'unsigned long' for the type of the key here.  We
> only need 4 bits on x86 today, but I figured that other
> architectures might need some more space.

If the existing mprotect() syscall had a flags argument you could have just
used that. So is it worth just adding mprotect2() now and using it for this? ie:

int mprotect2(unsigned long start, size_t len, unsigned long prot, unsigned long flags) ..

And then you define bit zero of flags to say you're passing a pkey, and it's in
bits 1-63?

That way if other arches need to do something different you at least have the
flags available?

cheers
