From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH 0/5 RFC] Add an interface to discover relationships
	between namespaces
Date: Tue, 26 Jul 2016 14:38:28 -0500
Message-ID: <87fuqwqjez.fsf@x220.int.ebiederm.org>
References: <1468520419-28220-1-git-send-email-avagin@openvz.org>
	<c9bdaf3d-ec93-d754-81ac-9f524a0d0954@gmail.com>
	<20160721210650.GA10989@outlook.office365.com>
	<1515f5f2-5a49-fcab-61f4-8b627d3ba3e2@gmail.com>
	<CANaxB-w8H8Wo8FmtmBBZTpJX-ZDGRQx0rbm9E5c9WbduQ_Ukmw@mail.gmail.com>
	<e2811bf1-4b86-e115-bcdb-301d6f2546eb@gmail.com>
	<87lh0pg8jx.fsf@x220.int.ebiederm.org>
	<44ca0e41-dc92-45b1-2a6c-c41a048a072d@gmail.com>
	<87r3ahepb4.fsf@x220.int.ebiederm.org>
	<20160726025455.GC26206@outlook.office365.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20160726025455.GC26206-1ViLX0X+lBJGNQ1M2rI3KwRV3xvJKrda@public.gmane.org> (Andrew Vagin's
	message of "Mon, 25 Jul 2016 19:54:56 -0700")
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org" <criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> writes:

> On Mon, Jul 25, 2016 at 09:59:43AM -0500, Eric W. Biederman wrote:
>> "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
>
> [snip]
>
>> [snip]
>> >>> So, from my point of view, the important piece that was missing from
>> >>> your commit message was the note to use readlink("/proc/self/fd/%d")
>> >>> on the returned FDs. I think that detail needs to be part of the
>> >>> commit message (and also the man page text). I think it even be
>> >>> helpful to include the above program as part of the commit message:
>> >>> it helps people more quickly grasp the API.
>> >>
>> >> Please, please make the standard way to compare these things fstat.
>> >> That is much less magic than a symlink, and a little more future proof.
>> >> Possibly even kcmp.
>
> I like the idea to use kcmp to compare namespaces. I am going to add this
> functionality to kcmp and describe all these in the man page.
>
>> >
>> > As in fstat() to get the st_ino field, right?
>> 
>> Both the st_ino and st_dev fields.
>> 
>> The most likely change to support checkpoint/restart in the future is to
>> preserve st_ino across migrations and instantiate a different instance
>> of nsfs to hold the inode numbers from the previous machine.
>
> It sounds tricky. BTW: Actually this is not only one places where we have
> this sort of problem. For example, now mount id-s are not preserved when
> a container is migrated. The same problem is applied to tmpfs, where
> inode numbers are not preserved for files.

Agreed.

Interesting. Interesting. Interesting.

I am not completely convinced that improving kcmp solves it for
everything but improving kcmp sounds good enough to be very interesting
and enough to solve a practical case (migration in migration).  Plus
improving kcmp is cheap and easy.

I would propose:

KCMP_OBJECT
    Check whether a file descriptor idx1 in the process pid1 refers to
    the same underlying object as file descriptor idx2 in the process
    pid2.

The default case would be checking to see if to file descriptors refer
to the same inode.  But for weird cases (like proc pid directories, or
sysfs files) the comparison could look deeper.

Eric
