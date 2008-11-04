From: Michael Kerrisk <mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: [patch 0/3] [RFC] kernel/glibc mismatch of "readlink"
	syscall?
Date: Tue, 04 Nov 2008 11:20:38 -0500
Message-ID: <49107656.2060101@gmail.com>
References: <20081023145054.998439866@marvin.suse.de>
	<cfd18e0f0810241553x77194611o11655a89871dc210@mail.gmail.com>
	<20081031160248.2b95d0e8@desktop.khms.westfalen.de>
	<200810311637.25371.dgollub@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ltp-list-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <200810311637.25371.dgollub-l3A5Bk7waGM@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/ltp-list>,
	<mailto:ltp-list-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=ltp-list>
List-Post: <mailto:ltp-list-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:ltp-list-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/ltp-list>,
	<mailto:ltp-list-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: ltp-list-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Daniel Gollub <dgollub-l3A5Bk7waGM@public.gmane.org>
Cc: ltp-list-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "A.E. Brouwer" <aeb-ek1Qb6IBo2Pz+pZb47iToQ@public.gmane.org>, Kai Henningsen <kai.extern-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Daniel,

Daniel Gollub wrote:
> On Friday 31 October 2008 16:02:48 Kai Henningsen wrote:
>> Am Fri, 24 Oct 2008 17:53:25 -0500
>>
>> schrieb "Michael Kerrisk" <mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>:
>>> Hi Daniel,
>>>
>>> On Thu, Oct 23, 2008 at 9:50 AM, Daniel Gollub <dgollub-l3A5Bk7waGM@public.gmane.org>
>>>
>>> wrote:
>>>> EINVAL bufsiz is not positive.
>>> The EINVAL error was added to man-pages-1.18 in 1997 (even though, as
>>> you note, the type was "size_t").  I suspect (this was well before I
>>> had any association with man-pages) that was done to reflect kernel
>>> reality (since one could bypass glibc invoke the syscall directly),
>>> but obviously it is inconsistent with the prototype.
>> Actually, it's not inconsistent as described, though perhaps that is
>> unintentional. "Not positive" isn't the same as "negative", as zero
>> isn't positive either, and zero is certainly a possible value of an
>> unsigned type
> 
> True.

So, at this stage I don't plan to make any change to man-pages.
(Let me know if you think this is the wrong course.)

> But there is still the problem for the ltp syscall test "readlink03", when 
> using the glibc "readlink" interface, by calling readlink with a buffer size 
> of "-1".
> 
> Calling "-1" seems to be a valid code/error-path in the linux syscall 
> "readlink", since there is a check for less-equal zero.
> 
> But the less zero, condition can't be reached via the glibc "readlink" 
> interface since this would cause fortify-check to fail (when buliding with -
> D_FORITFY_SOURCE=2).
> 
> To "workaround" the fortify check, by not compiling the testcase with -
> D_FORTIFY_SOURCE=2, or trying to test the linux readlink interface by calling 
> directly syscall() in the testcase ... both suggestion are just workarounds - 
> no real solutions.
> 
> We could also just remove the testcase of buffer size "-1".
> 
> The problem is still, how to test the "readlink" syscall in LTP?

I'd say: remove this test.  And add one for bufsiz==0 if there isn't one
already.

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html

-------------------------------------------------------------------------
This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
Build the coolest Linux based applications with Moblin SDK & win great prizes
Grand prize is a trip for two to an Open Source event anywhere in the world
http://moblin-contest.org/redirect.php?banner_id=100&url=/
