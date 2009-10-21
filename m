From: Arnd Bergmann <arndbergmann-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: [RFC][v8][PATCH 10/10]: Document clone3() syscall
Date: Wed, 21 Oct 2009 15:26:50 +0200
Message-ID: <200910211526.50584.arnd@arndb.de>
References: <20091013044925.GA28181@us.ibm.com> <200910211037.38413.arnd@arndb.de> <20091021093338.GA11670@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091021093338.GA11670-I/5MKhXcvmPrBKCeMvbIDA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Cc: Arnd Bergmann <arndbergmann-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>, serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-3NddpPZAyC0@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, Nathan Lynch <nathanl-V7BBcbaFuwjMbYB6QlFGEg@public.gmane.org>, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Louis.Rilling-aw0BnHfMbSpBDgjK7y7TUQ@public.gmane.org, roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, sukadev-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wednesday 21 October 2009, Pavel Machek wrote:
> > > Hmm, is there reason why pids are not at the end of struct
> > > clone_struct? Passing most parameters in special structure, then pids
> > > separately is strange...
> > 
> > I suggested doing that, it's a lot easier to handle fixed length data
> > structures than an array at the end.
> 
> You could still put the something * pids at the end of (fixed length)
> structure.
> 
> (Not that I agree with the argument, pid array is variable-length,
> anyway, and inlining it at the end of structure should not make code
> more complex).

Please read up on the v1 to v7 patches, we've been through all this
before. There are obviously a lot of ways to do it, many of which are
equally good. The important thing to note is that the user-visible
interface should *not* pass the structure into the library that provides
this function but build the structure itself, so it doesn't matter that
much.

If you put the array at the end of the data structure, the wrapper
will have to copy the array provided by the user to a temporary
buffer. Passing the array as a separate syscall argument avoids
this.

	Arnd <><
