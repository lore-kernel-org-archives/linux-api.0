From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH 0/5 RFC] Add an interface to discover relationships
	between namespaces
Date: Thu, 28 Jul 2016 07:56:42 -0500
Message-ID: <87popxkjjp.fsf@x220.int.ebiederm.org>
References: <1515f5f2-5a49-fcab-61f4-8b627d3ba3e2@gmail.com>
	<CANaxB-w8H8Wo8FmtmBBZTpJX-ZDGRQx0rbm9E5c9WbduQ_Ukmw@mail.gmail.com>
	<e2811bf1-4b86-e115-bcdb-301d6f2546eb@gmail.com>
	<87lh0pg8jx.fsf@x220.int.ebiederm.org>
	<44ca0e41-dc92-45b1-2a6c-c41a048a072d@gmail.com>
	<87r3ahepb4.fsf@x220.int.ebiederm.org>
	<20160726025455.GC26206@outlook.office365.com>
	<3390535b-0660-757f-aeba-c03d936b3485@gmail.com>
	<20160726182524.GA328@outlook.office365.com>
	<CAKgNAkjmOu+vfiMDyeYQkkf7wQBH9PVmJ4nH2CTg43GrN-k7eA@mail.gmail.com>
	<20160726203955.GA9415@outlook.office365.com>
	<ca0787a3-b270-e962-46d1-7e63c9335a55@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <ca0787a3-b270-e962-46d1-7e63c9335a55-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> (Michael
	Kerrisk's message of "Thu, 28 Jul 2016 12:45:12 +0200")
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org" <criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

"Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:

> On 07/26/2016 10:39 PM, Andrew Vagin wrote:
>> On Tue, Jul 26, 2016 at 09:17:31PM +0200, Michael Kerrisk (man-pages) wrote:

>> If we want to compare two file descriptors of the current process,
>> it is one of cases for which kcmp can be used. We can call kcmp to
>> compare two namespaces which are opened in other processes.
>
> Is there really a use case there? I assume we're talking about the
> scenario where a process in one namespace opens a /proc/PID/ns/*
> file descriptor and passes that FD to another process via a UNIX
> domain socket. Is that correct?
>
> So, supposing that we want to build a map of the relationships
> between namespaces using the proposed kcmp() API, and there are
> say N namespaces? Does this mena we make (N * (N-1) / 2) calls
> to kcmp()?

Potentially.  The numbers are small enough O(N^2) isn't fatal.

Where kcmp shines is that it allows migration to happen.  Inode numbers
to change (which they very much will today), and still have things work.

We can keep it O(Nlog(N)) by taking advantage of not just the equality
but the ordering relationship.  Although Ugh.  One disadvantage of
kcmp currently is that the way the ordering relationship is defined
the order is not preserved over migration :(

Eric
