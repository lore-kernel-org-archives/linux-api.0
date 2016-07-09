From: James Bottomley <James.Bottomley-RxcU5blhW6jCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [CRIU] Introspecting userns relationships to other namespaces?
Date: Sat, 09 Jul 2016 19:32:04 +0900
Message-ID: <e3fe9c3c-ecae-4795-8dbc-72362f4606a5@email.android.com>
References: <20160706141348.GB20728@mail.hallyn.com>
	<871t36kbvq.fsf@x220.int.ebiederm.org>
	<20160708015758.GA10512@outlook.office365.com>
	<87vb0gy3nr.fsf@x220.int.ebiederm.org>
	<1467988533.2322.118.camel@HansenPartnership.com>
	<20160708203818.GA2602@outlook.office365.com>
	<5e4cc802-f0e0-4f4c-a2f7-585aaaa8feec@email.android.com>
	<87wpkvpu1i.fsf@x220.int.ebiederm.org>
	<1468023332.2390.10.camel@HansenPartnership.com>
	<87bn27o6j5.fsf@x220.int.ebiederm.org>
	<20160709072627.GA7480@outlook.office365.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20160709072627.GA7480-1ViLX0X+lBJGNQ1M2rI3KwRV3xvJKrda@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On July 9, 2016 4:26:28 PM GMT+09:00, Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
>On Fri, Jul 08, 2016 at 10:05:18PM -0500, Eric W. Biederman wrote:
>> James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> writes:
>> 
>> > On Fri, 2016-07-08 at 18:52 -0500, Eric W. Biederman wrote:
>> >> James Bottomley <James.Bottomley-RxcU5blhW6jCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> writes:
>> >> 
>> >> > On July 8, 2016 1:38:19 PM PDT, Andrew Vagin
><avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
>> >> > wrote:
>> >> 
>> >> > > What do you think about the idea to mount nsfs and be able to 
>> >> > > look up any alive namespace by inum:
>> >> > 
>> >> > I think I like it.  It will give us a way to enter any extant
>> >> > namespace.  It will work for Eric's fs namespaces as well. 
>Perhaps 
>> >> > a /process/ns/<inum> Directory?
>> >
>> > As you understood, I meant /proc/ns/<inum> (damn mobile phone
>> > completions).
>> >
>> >> *Shivers*
>> >> 
>> >> That makes it very easy to bypass any existing controls that exist
>
>> >> for getting at namespaces.  It is true that everything of that
>kind 
>> >> is directory based but still.
>> >> 
>> >> Plus I think it would serve as information leak to information 
>> >> outside of the container.
>> >> 
>> >> An operation to get a user namespace file descriptor from some
>kernel
>> >> object sounds reasonably sane.
>> >> 
>> >> A great big list of things sounds about as scary as it can get. 
>This 
>> >> is not the time to be making it easier to escape from containers.
>> >
>> > To be honest, I think this argument is rubbish.  If we're afraid of
>> > giving out a list of all the namespaces, it means we're afraid
>there's
>> > some security bug and we're trying to obscure it by making the list
>> > hard to get.  All we've done is allayed fears about the bug but the
>> > hackers still know the portals to get through.
>> >
>> > If such a bug exists, it will be possible to exploit it by simply
>> > reconstructing the information from the individual process
>directories,
>> > so obscurity doesn't protect us and all it does is give us a false
>> > sense of security.   If such a bug doesn't exist, then all the
>security
>> > mechanisms currently in place (like no re-entry to prior namespace)
>> > should protect us and we can give out the list.
>> >
>> > Let's deal with the world as we'd like it to be (no obscure
>namespace
>> > bugs) and accept the consequences and the responsibility for fixing
>> > them if we turn out to be slightly incorrect.  We'll end up in a
>far
>> > better place than security by obscurity would land us.
>> 
>> No.  That is not the fear.  The permission checks on
>/proc/self/ns/xxx
>> are different than if the namespace is bind mounted somewhere.
>> 
>> That was done deliberately and with a reasonable amount of
>forethought.
>> You are asking to throw those permission checks out.   The answer is
>no.
>> 
>> Furthermore there is a much clearer reason not to go with a list of
>all
>> namespaces. A list of all namespaces breaks CRIU.  As you have
>described
>> it the list will change depending upon which machine you restore a
>> checkpoint on.  I honestly don't know what kind of havoc that will
>cause
>> but it is certainly something we won't be able to checkpoint no
>matter
>> how hard we try.
>
>It's right. I hadn't thought about this.

Me neither.  Sorry for the prior outburst.

I think this means we're back to exposing owning userns in the /proc /<pid >/ns directory. 

>> 
>> A global list of namespaces especially of the kind that you can open
>> and get a handle to the namespace is just not appropriate.
>> 
>> I know inode numbers comes darn close to names but they aren't really
>> names and if it comes to it we can figure out how to preserve an
>> applications view of it all across a checkpoint/restart.  So far it
>> hasn't proven necessary to preserve any inode numbers across
>> checkpoint/restart but again it is theoretically possible if it
>becomes
>> necessary.
>> 
>> Throwing away checkpoint/restart support for the sake of
>> checkpoint/restart is a no-go.
>> 
>> Containers fundamentally imply you don't have global visibility,
>> and that is a good thing.
>
>All these thoughts about security make me thinking that kcmp is what we
>should use here. It's maybe something like this:
>
>kcmp(pid1, pid2, KCMP_NS_USERNS, fd1, fd2)
>
>- to check if userns of the fd1 namepsace is equal to the fd2 userns
>
>kcmp(pid1, pid2, KCMP_NS_PARENT, fd1, fd2)
>
>- to check if a parent namespace of the fd1 pidns is equal to fd pidns.
>
>fd1 and fd2 is file descriptors to namespace files.
>
>So if we want to build a hierarchy, we need to collect all namespaces
>and then enumerate them to check dependencies with help of kcmp.

Sure, but we need a method for opening the filehandles first .. .

James 

>> 
>> Eric


-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity.
