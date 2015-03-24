From: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 13/14] kdbus: add walk-through user space example
Date: Tue, 24 Mar 2015 17:46:00 +0100
Message-ID: <551194C8.4070707@suse.cz>
References: <1425906560-13798-1-git-send-email-gregkh@linuxfoundation.org> <1425906560-13798-14-git-send-email-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1425906560-13798-14-git-send-email-gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, arnd-r2nGTMty4D4@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org, jkosina-AlSwsSmVLrQ@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 03/09/2015, 02:09 PM, Greg Kroah-Hartman wrote:
> --- /dev/null
> +++ b/samples/kdbus/Makefile
> @@ -0,0 +1,10 @@
> +# kbuild trick to avoid linker error. Can be omitted if a module is built.
> +obj- := dummy.o
> +
> +hostprogs-y += kdbus-workers
> +
> +always := $(hostprogs-y)

Errr, no. Not only it causes build failures (even with KDBUS=n), it
definitely should not be built for everyone.

And why is it a host prog? It's a sample prog for the kernel I am
building, i.e. for the destination arch, like all the other samples.

thanks,
-- 
js
suse labs
