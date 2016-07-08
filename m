From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Introspecting userns relationships to other namespaces?
Date: Fri, 8 Jul 2016 13:11:42 +0200
Message-ID: <48c8d759-97e7-1de1-16b5-20d9f7bc928d@gmail.com>
References: <c2a26220-69f2-f2f5-491a-e43abd9a6f92@gmail.com>
	<87r3b7pxja.fsf@x220.int.ebiederm.org>
	<CAKgNAkgQbxLH-B3N3Xti3LLis+1Y-SJD2h1DEaXao7zTDA7pug@mail.gmail.com>
	<20160706141348.GB20728@mail.hallyn.com>
	<CAKgNAkhtQNg0mVv6ei_JigNz3njo_G3opE+rzd4OtKpa2hQe9g@mail.gmail.com>
	<20160707133631.GA2994@mail.hallyn.com>
	<1467903712.2347.16.camel@HansenPartnership.com>
	<CAKgNAkg+OiBngdFsdVR0gsSnVhMppuH2DxMBLCNAx8in5C0-zQ@mail.gmail.com>
	<1467919055.2322.36.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1467919055.2322.36.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 07/07/2016 09:17 PM, James Bottomley wrote:
> On Thu, 2016-07-07 at 20:21 +0200, Michael Kerrisk (man-pages) wrote:
>> On 7 July 2016 at 17:01, James Bottomley
>> <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
> [Serge already answered the parenting issue]
>>> On Thu, 2016-07-07 at 08:36 -0500, Serge E. Hallyn wrote:
>>>> Hm.  Probably best-effort based on the process hierarchy.  So
>>>> yeah you could probably get a tree into a state that would be
>>>> wrongly recreated. Create a new netns, bind mount it, exit;  Have
>>>> another task create a new user_ns, bind mount it, exit;  Third
>>>> task setns()s first to the new netns then to the new user_ns.  I
>>>> suspect criu will recreate that wrongly.
>>>
>>> This is a bit pathological, and you have to be root to do it: so
>>> root can set up a nesting hierarchy, bind it and destroy the pids
>>> but I know of no current orchestration system which does this.
>>>
>>> Actually, I have to back pedal a bit: the way I currently set up
>>> architecture emulation containers does precisely this: I set up the
>>> namespaces unprivileged with child mount namespaces, but then I ask
>>> root to bind the userns and kill the process that created it so I
>>> have a permanent handle to enter the namespace by, so I suspect
>>> that when our current orchestration systems get more sophisticated,
>>> they might eventually want to do something like this as well.
>>>
>>> In theory, we could get nsfs to show this information as an option
>>> (just add a show_options entry to the superblock ops), but the
>>> problem is that although each namespace has a parent user_ns,
>>> there's no way to get it without digging in the namespace specific
>>> structure.  Probably we should restructure to move it into
>>> ns_common, then we could display it (and enforce all namespaces
>>> having owning user_ns) but it would be a
>>
>> I'm missing something here. Is it not already the case that all
>> namespaces have an owning user_ns?
>
> Um, yes, I don't believe I said they don't.  The problem I thought you
> were having is that there's no way of seeing what it is.

Your words "and enforce all namespaces having owning user_ns" were
what left me puzzled--it sounded to me that the implication was
that this is not "enforced" right now.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
