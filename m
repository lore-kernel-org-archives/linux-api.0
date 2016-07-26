From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH 0/5 RFC] Add an interface to discover relationships
 between namespaces
Date: Tue, 26 Jul 2016 21:17:31 +0200
Message-ID: <CAKgNAkjmOu+vfiMDyeYQkkf7wQBH9PVmJ4nH2CTg43GrN-k7eA@mail.gmail.com>
References: <c9bdaf3d-ec93-d754-81ac-9f524a0d0954@gmail.com>
 <20160721210650.GA10989@outlook.office365.com> <1515f5f2-5a49-fcab-61f4-8b627d3ba3e2@gmail.com>
 <CANaxB-w8H8Wo8FmtmBBZTpJX-ZDGRQx0rbm9E5c9WbduQ_Ukmw@mail.gmail.com>
 <e2811bf1-4b86-e115-bcdb-301d6f2546eb@gmail.com> <87lh0pg8jx.fsf@x220.int.ebiederm.org>
 <44ca0e41-dc92-45b1-2a6c-c41a048a072d@gmail.com> <87r3ahepb4.fsf@x220.int.ebiederm.org>
 <20160726025455.GC26206@outlook.office365.com> <3390535b-0660-757f-aeba-c03d936b3485@gmail.com>
 <20160726182524.GA328@outlook.office365.com>
Reply-To: mtk.manpages@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160726182524.GA328@outlook.office365.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Vagin <avagin@virtuozzo.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Andrey Vagin <avagin@openvz.org>, Serge Hallyn <serge.hallyn@canonical.com>, "criu@openvz.org" <criu@openvz.org>, Linux API <linux-api@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

Hello Andrew,

On 26 July 2016 at 20:25, Andrew Vagin <avagin@virtuozzo.com> wrote:
> On Tue, Jul 26, 2016 at 10:03:25AM +0200, Michael Kerrisk (man-pages) wrote:
>> On 07/26/2016 04:54 AM, Andrew Vagin wrote:
>> > On Mon, Jul 25, 2016 at 09:59:43AM -0500, Eric W. Biederman wrote:
>> > > "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>> >
>> > [snip]
>> >
>> > > [snip]
>> > > > > > So, from my point of view, the important piece that was missing from
>> > > > > > your commit message was the note to use readlink("/proc/self/fd/%d")
>> > > > > > on the returned FDs. I think that detail needs to be part of the
>> > > > > > commit message (and also the man page text). I think it even be
>> > > > > > helpful to include the above program as part of the commit message:
>> > > > > > it helps people more quickly grasp the API.
>> > > > >
>> > > > > Please, please make the standard way to compare these things fstat.
>> > > > > That is much less magic than a symlink, and a little more future proof.
>> > > > > Possibly even kcmp.
>> >
>> > I like the idea to use kcmp to compare namespaces. I am going to add this
>> > functionality to kcmp and describe all these in the man page.
>>
>> Hi Andrey,
>>
>> Can you briefly sketch out the proposed API and how it would be used?
>> I'd find it useful to see that even before the implementation.
>
> Sure. If a process wants to compare two namespaces, it needs to get file
> descriptors for them (open /proc/PID/ns/XXX, use new ioctl-s, find a
> process which has them),
> and then it calls kcmp(pid1, pid2, KCMP_NSFD, ns_fd1, ns_fd2)
>
> For example, if we want to compare pid namespaces for 1 and 2 processes:
>

What's the purpose of the following line, and the use of 'pid' in the
kcmp() call?:

> pid = getpid();
> ns_fd1 = open("/proc/1/ns/pid")
> ns_fd2 = open("/proc/2/ns/pid")
>
> if (!kcmp(pid, pid, KCMP_NSFD, ns_fd1, ns_fd2))
>         printf("Both processes live in the same pid namespace\n");


Thanks,

Michael
