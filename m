From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC][v8][PATCH 9/10]: Define clone3() syscall
Date: Thu, 22 Oct 2009 21:19:27 +0900
Message-ID: <4AE04DCF.6040908@zytor.com>
References: <20091013044925.GA28181@us.ibm.com>	 <cfd18e0f0910152325m4a9125c2q18f36f5bd7d4a0@mail.gmail.com>	 <20091016180631.GA31036@us.ibm.com>	 <20091019174405.GE27627@count0.beaverton.ibm.com>	 <4ADCDAA8.5080408@zytor.com>	 <20091019235012.GF27627@count0.beaverton.ibm.com>	 <cfd18e0f0910202126w1ebfa2e2u2ecbaa23b198d100@mail.gmail.com>	 <4ADF06B7.50508@zytor.com>	 <cfd18e0f0910220326w1a71b899s5ff0fce9e0a2b8ed@mail.gmail.com>	 <4AE0444B.5070603@zytor.com> <cfd18e0f0910220514y1bd5967aj3a04bc3f5b38948b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cfd18e0f0910220514y1bd5967aj3a04bc3f5b38948b-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Nathan Lynch <nathanl-V7BBcbaFuwjMbYB6QlFGEg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Louis.Rilling-aw0BnHfMbSpBDgjK7y7TUQ@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 10/22/2009 09:14 PM, Michael Kerrisk wrote:
>
> So, sometimes, a number in a system call should be the bit width of
> some arguments(s), sometimes it should be the number of arguments, and
> sometimes (well, just occasionally, as in mmap2() and clone()) -- it
> should be a version number? Does the weather play any part in the
> decision? ;-)
>

The notion is that they are *some* kind of description on how the system 
call has been augmented.  The bitwidths and argument numbers are 
non-overlapping and visually very different, so are not subject to 
confusion.  Your argument makes about as much sense as saying the letter 
"a" should have the same meaning in every context.

	-hpa
