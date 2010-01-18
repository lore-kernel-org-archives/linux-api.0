From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v6] add MAP_UNLOCKED mmap flag
Date: Mon, 18 Jan 2010 16:24:07 +0100
Message-ID: <1263828247.4283.612.camel@laptop>
References: <20100118133755.GG30698@redhat.com>
	 <84144f021001180609r4d7fbbd0p972d5bc0e227d09a@mail.gmail.com>
	 <20100118141938.GI30698@redhat.com>
	 <20100118143232.0a0c4b4d@lxorguk.ukuu.org.uk>
	 <1263826198.4283.600.camel@laptop>  <20100118150159.GB14345@redhat.com>
	 <1263827194.4283.609.camel@laptop>  <4B547A31.4090106@redhat.com>
	 <1263827683.4283.610.camel@laptop>  <4B547C09.8010906@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B547C09.8010906-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Avi Kivity <avi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Gleb Natapov <gleb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, andrew.c.morrow-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, 2010-01-18 at 17:19 +0200, Avi Kivity wrote:
> > I would not advice that, just mlock() the text and data you need for the
> > real-time thread. mlockall() is a really blunt instrument.
> >    
> 
> May not be feasible due to libraries. 

Esp for the real-time case I could advise not to use those libraries
then, since they're clearly not designed for that use case.
