From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Introspecting userns relationships to other namespaces?
Date: Thu, 7 Jul 2016 10:15:20 +0200
Message-ID: <CAKgNAkhtQNg0mVv6ei_JigNz3njo_G3opE+rzd4OtKpa2hQe9g@mail.gmail.com>
References: <c2a26220-69f2-f2f5-491a-e43abd9a6f92@gmail.com>
	<87r3b7pxja.fsf@x220.int.ebiederm.org>
	<CAKgNAkgQbxLH-B3N3Xti3LLis+1Y-SJD2h1DEaXao7zTDA7pug@mail.gmail.com>
	<20160706141348.GB20728@mail.hallyn.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20160706141348.GB20728-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Serge,

On 6 July 2016 at 16:13, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, Jul 06, 2016 at 10:41:48AM +0200, Michael Kerrisk (man-pages) wrote:
>> [Rats! Doing now what I should have down to start with. Looping some
>> lists and CRIU and other possibly relevant people into this
>> conversation]
>>
>> Hi Eric,
>>
>> On 5 July 2016 at 23:47, Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>> > "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
>> >
>> >> Hi Eric,
>> >>
>> >> I have a question. Is there any way currently to discover which
>> >> user namespace a particular nonuser namespace is governed by?
>> >> Maybe I am missing something, but there does not seem to be a
>> >> way to do this. Also, can one discover which userns is the
>> >> parent of a given userns? Again, I can't see a way to do this.
>> >>
>> >> The point here is introspecting so that a process might determine
>> >> what its capabilities are when operating on some resource governed
>> >> by a (nonuser) namespace.
>> >
>> > To the best of my knowledge that there is not an interface to get that
>> > information.  It would be good to have such an interface for no other
>> > reason than the CRIU folks are going to need it at some point.  I am a
>> > bit surprised they have not complained yet.
>
> I don't think they need it.  They do in fact have what they need.  Assume
> you have tasks T1, T2, T1_1 and T2_1;  T1 and T2 are in init_user_ns;  T1
> spawned T1_1 in a new userns;  T2 spawned T2_1 which setns()d to T1_1's ns.
> There's some {handwave} uid mapping, does not matter.
>
> At restart, it doesn't matter which task originally created the new userns.
> criu knows T1_1 and T2_1 are in the same userns;  it creates the userns, sets
> up the mapping, and T1_1 and T2_1 setns() to it.

I'm missing something here. How does the parental relationships
between the user namespaces get reconstructed? Those relationships
will govern what capabilities a process will have in various user
namespaces.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
