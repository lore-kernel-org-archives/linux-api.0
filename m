From: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
Date: Tue, 13 Oct 2009 21:36:07 -0700
Message-ID: <20091014043607.GA32114@us.ibm.com>
References: <20091013044925.GA28181@us.ibm.com>
	<20091013205015.1ED524F7@magilla.sf.frob.com>
	<20091013232736.GA24392@us.ibm.com>
	<20091013235320.E90022746@magilla.sf.frob.com>
	<4AD525B3.2070906@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4AD525B3.2070906-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.linux-foundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linux-foundation.org/pipermail/containers>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linux-foundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Nathan Lynch <nathanl-V7BBcbaFuwjMbYB6QlFGEg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Louis.Rilling-aw0BnHfMbSpBDgjK7y7TUQ@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

H. Peter Anvin [hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org] wrote:
| On 10/13/2009 04:53 PM, Roland McGrath wrote:
| >> My only concern is the support of 64-bit clone flags on 32-bit architectures.
| > 
| > Oy.  I didn't realize there was serious consideration of having more than
| > 32 flags.  IMHO it would be a bad choice, since they could only be used via
| > clone3.  Having high-bit flags work in clone on 64-bit machines but not on
| > 32-bit machines just seems like a wrongly confusing way for things to be.
| > If any high-bits flags are constrained even on 64-bit machines to uses in
| > clone3 calls for sanity purposes, then it seems questionable IMHO to have
| > them be more flags in the same u64 at all.
| > 
| > Since all new features will be via this struct, various new kinds of things
| > could potentially be done by other new struct fields independent of flags.
| > But that would of course require putting enough reserved fields in now and
| > requiring that they be zero-filled now in anticipation of such future uses,
| > which is not very pleasant either.
| > 
| > In short, I guess I really am saying that "clone_flags_high" (or
| > "more_flags" or something) does seem better to me than any of the
| > possibilities for having more than 32 CLONE_* in the current flags word.
| > 
| 
| Overall it seems sane to:
| 
| a) make it an actual 3-argument call;
| b) make the existing flags a u32 forever, and make it a separate
|    argument;
| c) any new expansion can be via the struct, which may want to have
|    an "c3_flags" field first in the structure.

Wouldn't that make it a somewhat awkward interface - applications or
libc have to split the clone flags and specify them in two different
fields ? Do we need to preserve the u32 flags forever ? 

The closest example I can think of is the distinction between signal()
and sigaction(). sigaction() interface makes a lot of sense in part bc
it does not try to look like signal(). And strace seems to be able
decode flags like SA_RESTART and SA_SIGINFO with the pointer to the
sigaction buffer. 

Won't the debug tools be able to do the same with a pointer to
struct clone_args ?

If it needs the new features of clone3(), the application has to be
modified. At that point wouldn't it be easy to write a clone3() wrapper
that calls sys_clone3() if it exists or call sys_clone() if not ?

If clone3() supersedes clone(), all architectures could use the clone3()
interface and it would seem best to make clone3() as simple as possible
without having to preserve the u32 flags.

Would it help to use a type clone_flags_64_t to make the distinction
between types more explicit ?

Sukadev
