From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCHv3 8/8] cgroup: Add documentation for cgroup namespaces
Date: Wed, 11 Feb 2015 00:29:20 -0600
Message-ID: <87twytklkv.fsf@x220.int.ebiederm.org>
References: <20150107224430.GA28414@htj.dyndns.org>
	<878uhe42km.fsf@x220.int.ebiederm.org>
	<20150107230615.GA28630@htj.dyndns.org>
	<87fvbm2nni.fsf@x220.int.ebiederm.org>
	<87y4peyxw5.fsf@x220.int.ebiederm.org>
	<20150107233553.GC28630@htj.dyndns.org>
	<20150211034616.GA25022@mail.hallyn.com>
	<20150211040957.GC21356@htj.duckdns.org>
	<20150211042942.GA27931@mail.hallyn.com>
	<87oap1qbv3.fsf@x220.int.ebiederm.org>
	<20150211051704.GB24897@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20150211051704.GB24897-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org> (Tejun Heo's message of
	"Wed, 11 Feb 2015 00:17:04 -0500")
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:

> Hey,
>
> On Tue, Feb 10, 2015 at 11:02:40PM -0600, Eric W. Biederman wrote:
>> A slightly off topic comment, for where this thread has gone but
>> relevant if we are talking about cgroup namespaces.
>> 
>> If don't implement compatibility with existing userspace, they get a
>> nack.  A backwards-incompatible change should figure out how to remove
>> the need for any namespaces.
>>
>> Because that is what namespaces are about backwards compatibility.
>
> Are you claiming that namespaces are soley about backwards
> compatibility?  ie. to trick userland into scoping without letting it
> notice?  That's a very restricted view and namespaces do provide
> further isolation capabilties in addition to what can be achieved
> otherwise and it is logical to collect simliar funtionalities there.

In principle a namespace is an additional layer of indirection from
names to objects.  A namespace does not invent new kinds of objects.
A namespace takes things that were previously global and gives them a
scope.

In princple after name resolution a namespace should impose no overhead.

In general namespaces are not necessary if your scope of names
already has hierarchy.  Which means that new interfaces can almost
always be designed in such a way that you can support containers without
needing to add any special namespace support.  Which typically results
in more flexible and useful APIs for everyone, with no real code cost.



Further in the cgroup namespace patchset I looked at a while ago, the
only reason for having a cgroup namespace was to provide a measure of
backwards compatibility with existing userspace.  I expect removing the
/proc/<pid>/cgroup file and replacing it with something in cgroupfs
itself would serve just as well if backwards compatibility is not the
objective.  Or possibly replacincg /proc/<pid>/cgroup into a magic
symlink onto somewhere in the unified cgroupfs itself.


I just don't see any point in doing weird silly namespace things to keep
existing userspace working when the existing userspace won't work.

As such if a namespace doesn't implement compatibility with the existing
userspace it gets my nack.

Eric
