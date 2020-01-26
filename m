From: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Subject: Re: [RFC PATCH 07/14] Add sample notification program [ver #3]
Date: Sun, 26 Jan 2020 07:47:30 -0800
Message-ID: <20200126154730.GA18893@roeck-us.net>
References: <157909503552.20155.3030058841911628518.stgit@warthog.procyon.org.uk>
 <157909509882.20155.1159021562184142124.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <157909509882.20155.1159021562184142124.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, nicolas.dichtel-pdR9zngts4EAvxtiuMwx3w@public.gmane.org, raven-PKsaG3nR2I+sTnJN9+BGXg@public.gmane.org, Christian Brauner <christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org>, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Jan 15, 2020 at 01:31:38PM +0000, David Howells wrote:
> The sample program is run like:
> 
> 	./samples/watch_queue/watch_test
> 
> and watches "/" for mount changes and the current session keyring for key
> changes:
> 
> 	# keyctl add user a a @s
> 	1035096409
> 	# keyctl unlink 1035096409 @s
> 
> producing:
> 
> 	# ./watch_test
> 	read() = 16
> 	NOTIFY[000]: ty=000001 sy=02 i=00000110
> 	KEY 2ffc2e5d change=2[linked] aux=1035096409
> 	read() = 16
> 	NOTIFY[000]: ty=000001 sy=02 i=00000110
> 	KEY 2ffc2e5d change=3[unlinked] aux=1035096409
> 
> Other events may be produced, such as with a failing disk:
> 
> 	read() = 22
> 	NOTIFY[000]: ty=000003 sy=02 i=00000416
> 	USB 3-7.7 dev-reset e=0 r=0
> 	read() = 24
> 	NOTIFY[000]: ty=000002 sy=06 i=00000418
> 	BLOCK 00800050 e=6[critical medium] s=64000ef8
> 
> This corresponds to:
> 
> 	blk_update_request: critical medium error, dev sdf, sector 1677725432 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
> 
> in dmesg.
> 
> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

mips:allmodconfig:

samples/watch_queue/watch_test.c: In function ‘keyctl_watch_key’:
samples/watch_queue/watch_test.c:34:17: error: ‘__NR_keyctl’ undeclared

Guenter
