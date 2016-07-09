From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: Introspecting userns relationships to other namespaces?
Date: Fri, 08 Jul 2016 22:13:08 -0500
Message-ID: <87ziprmrln.fsf@x220.int.ebiederm.org>
References: <c2a26220-69f2-f2f5-491a-e43abd9a6f92@gmail.com>
	<87r3b7pxja.fsf@x220.int.ebiederm.org>
	<CAKgNAkgQbxLH-B3N3Xti3LLis+1Y-SJD2h1DEaXao7zTDA7pug@mail.gmail.com>
	<20160706141348.GB20728@mail.hallyn.com>
	<CAKgNAkhtQNg0mVv6ei_JigNz3njo_G3opE+rzd4OtKpa2hQe9g@mail.gmail.com>
	<20160707133631.GA2994@mail.hallyn.com>
	<1467903712.2347.16.camel@HansenPartnership.com>
	<20160709031528.GA25507@odin.tremily.us>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20160709031528.GA25507-q4NCUed9G3sTnwFZoN752g@public.gmane.org> (W. Trevor King's
	message of "Fri, 8 Jul 2016 20:15:28 -0700")
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org>
Cc: criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

"W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org> writes:

> On Thu, Jul 07, 2016 at 08:01:52AM -0700, James Bottomley wrote:
>> In theory, we could get nsfs to show this information as an option
>> (just add a show_options entry to the superblock ops), but the
>> problem is that although each namespace has a parent user_ns,
>> there's no way to get it without digging in the namespace specific
>> structure.  Probably we should restructure to move it into
>> ns_common, then we could display it (and enforce all namespaces
>> having owning user_ns) but it would be a reasonably large (but
>> mechanical) change.
>
> It sounds like everyone is either positive or or neutral on this
> groundwork, even if we haven't decided if/how to expose the
> information to userspace.  I'm happy to work up a patch while the rest
> of the discussion continues.  I'm also happy to let someone else work
> up the patch, if anyone else is chomping at the bit ;).

I am dubious on moving all of the user namespace members into ns_common.

I would happy to be proved wrong but I suspect in the cases where we
actually use that user namespace the code will become uglier.  Making
the ordinary uses uglier to make a rare corner case nicer is the wrong
trade off.

But feel free to try it is certainly worth doing if it doesn't make the
code that uses the user namespaces uglier.

Eric
