From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH 4/4] setns.2: Document the pid, user,
	and mount namespace support.
Date: Thu, 27 Dec 2012 09:40:19 -0800
Message-ID: <87bodftmv0.fsf@xmission.com>
References: <87a9u4rmz0.fsf@xmission.com> <87k3t7q39u.fsf@xmission.com>
	<CAKgNAkiaw5L_oNE8NENjmoBS8Hq_uj+iaEdhyXc1+hje4HdnNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <CAKgNAkiaw5L_oNE8NENjmoBS8Hq_uj+iaEdhyXc1+hje4HdnNQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Michael Kerrisk's message of "Thu, 27 Dec 2012 12:08:51 +0100")
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

"Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:

> Hi Eric,
>
> Some questions below.

A quick note.  Getting the permission checks correct has been a little
more interesting that I would have preferred.

I had to add a nsown_capable(CAP_SYS_ADMIN) check to all of the setns()
install methods except the user namespace.  Not a change in pre 3.8
behavior but a change to my patch, and possibly a documentation change
below.

> On Tue, Nov 27, 2012 at 1:48 AM, Eric W. Biederman
> <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>>
>> Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
>> ---
>>  man2/setns.2 |   41 +++++++++++++++++++++++++++++++++--------
>>  1 files changed, 33 insertions(+), 8 deletions(-)
>>
>> diff --git a/man2/setns.2 b/man2/setns.2
>> index 6aa01e1..63b04dc 100644
>> --- a/man2/setns.2
>> +++ b/man2/setns.2
>> @@ -48,6 +48,18 @@ must refer to a network namespace.
>>  .BR CLONE_NEWUTS
>>  .I fd
>>  must refer to a UTS namespace.
>> +.TP
>> +.BR CLONE_NEWPID
>> +.I fd
>> +must refer to a PID namespace.
>> +.TP
>> +.BR CLONE_NEWUSER
>> +.I fd
>> +must refer to a user namespace.
>> +.TP
>> +.BR CLONE_NEWNS
>> +.I fd
>> +must refer to a mount namespace.
>>  .PP
>>  Specifying
>>  .I nstype
>> @@ -63,6 +75,25 @@ and wants to ensure that the namespace is of a particular type.
>>  .IR fd
>>  if the file descriptor was opened by another process and, for example,
>>  passed to the caller via a UNIX domain socket.)
>> +
>> +The pid namespace is a little different.  Reassociating the calling
>> +thread with a pid namespace only changes the pid namespace that the
>> +child processes will be created in.
>> +
>> +Changing the pid namespace for child processes is only allowed if the
>> +pid namespace specified by
>> +.IR fd
>> +is a child pid namespace of the pid namespace of the current thread.
>
> I assume "current thread" above should be "calling thread", right?

What I mean in "current" from a kernel perspective.

It should be just "caller".

Threads must share a pid namespace so mentioning threads seems wrong.

>> +
>> +A multi-threaded process may not change user namespace with setns.  A
>> +process may not reassociate the thread with the current user
>> +namespace.
>
> What do you mean by "the current user nsamesapce"?

fd = open("/proc/self/ns/user");
setns(fd) -> -EINVAL.

So from a userspace perspective I mean "the callers user namespace".

>> The process reassociating itself with a user namespace
>> +must have CAP_SYS_ADMIN privileges in the target user namespace.
>>
>> +A process may not be reassociated with a new mount namespace if it is
>> +multi-threaded
>
> I tried to verify the precdeing two lines from the kernel source, but
> did not work out where this check is made. Where is it?

kernel/user_namespace.c:userns_install()
fs/namespace.c:mntns_install()

A couple of the security checks have been pushed down into a per
namespace context, because the exact check that makes sense depends on
the namespace.

>> or it does not possess both CAP_SYS_CHROOT privileges
>> +and CAP_SYS_ADMIN rights over the target mount namespace.
>
> Could you please expand/clarify the preceding two lines. As they
> stand, I don't really understand them.

Ugh.  The text is slightly wrong.

The code is:
	if (!ns_capable(mnt_ns->user_ns, CAP_SYS_ADMIN) ||
	    !nsown_capable(CAP_SYS_CHROOT) ||
	    !nsown_capable(CAP_SYS_ADMIN))
		return -EPERM;

Basically you aren't allowed change your mount namespace into
a mount namespace that doesn't see you as the all powerful root
able to mount and unmount filesystems.

You aren't allowed to change your mount namespace unless you possesses
CAP_SYS_CHROOT and CAP_SYS_ADMIN.

>>  .SH RETURN VALUE
>>  On success,
>>  .IR setns ()
>> @@ -94,7 +125,8 @@ for this operation.
>>  The
>>  .BR setns ()
>>  system call first appeared in Linux in kernel 3.0;
>> -library support was added to glibc in version 2.14.
>> +library support was added to glibc in version 2.14;
>> +Support for PID, user and mount namespaces first appeard in Linux in kernel 3.8.
>>  .SH CONFORMING TO
>>  The
>>  .BR setns ()
>> @@ -106,13 +138,6 @@ a new thread is created using
>>  can be changed using
>>  .BR setns ().
>>  .SH BUGS
>> -The PID namespace and the mount namespace are not currently supported.
>> -(See the descriptions of
>> -.BR CLONE_NEWPID
>> -and
>> -.BR CLONE_NEWNS
>> -in
>> -.BR clone (2).)
>>  .SH SEE ALSO
>>  .BR clone (2),
>>  .BR fork (2),
>
> Cheers,
>
> Michael
