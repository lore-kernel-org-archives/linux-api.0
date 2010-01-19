From: Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>
Subject: Re: [PATCH v6] add MAP_UNLOCKED mmap flag
Date: Tue, 19 Jan 2010 10:07:07 +0200
Message-ID: <84144f021001190007q54a334dfwed64189e6cf0b7c4@mail.gmail.com>
References: <20100118133755.GG30698@redhat.com>
	 <20100118141938.GI30698@redhat.com>
	 <84144f021001180805q4d1203b8qab8ccb1de87b2866@mail.gmail.com>
	 <20100118170816.GA22111@redhat.com>
	 <84144f021001181009m52f7eaebp2bd746f92de08da9@mail.gmail.com>
	 <20100118181942.GD22111@redhat.com>
	 <20100118191031.0088f49a@lxorguk.ukuu.org.uk>
	 <20100119071734.GG14345@redhat.com>
	 <84144f021001182337o274c8ed3q8ce60581094bc2b9@mail.gmail.com>
	 <20100119075205.GI14345@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100119075205.GI14345-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gleb Natapov <gleb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, andrew.c.morrow-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Gleb,

On Tue, Jan 19, 2010 at 9:52 AM, Gleb Natapov <gleb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> It would be probably useful if you could point us to the application
>> source code that actually wants this feature.
>>
> This is two line patch to qemu that calls mlockall(MCL_CURRENT|MCL_FUTURE)
> at the beginning of the main() and changes guest memory allocation to
> use MAP_UNLOCKED flag. All alternative solutions in this thread suggest
> that I should rewrite qemu + all library it uses. You see why I can't
> take them seriously?

Well, that's not going to be portable, is it, so the application
design would still be broken, no? Did you try using (or extending)
posix_madvise(MADV_DONTNEED) for the guest address space? It seems to
me that you're trying to use a big hammer (mlock) when a polite hint
for the VM would probably be sufficient for it do its job.

                        Pekka
