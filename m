From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 3/7] vfs: Add a mount-notification facility
Date: Wed, 29 May 2019 10:04:51 -0700
Message-ID: <c95dd6cd-5530-6b70-68f6-4038edd72352@schaufler-ca.com>
References: <CAG48ez2rRh2_Kq_EGJs5k-ZBNffGs_Q=vkQdinorBgo58tbGpg@mail.gmail.com>
 <155905930702.7587.7100265859075976147.stgit@warthog.procyon.org.uk>
 <155905933492.7587.6968545866041839538.stgit@warthog.procyon.org.uk>
 <14347.1559127657@warthog.procyon.org.uk>
 <312a138c-e5b2-4bfb-b50b-40c82c55773f@schaufler-ca.com>
 <CAG48ez2KMrTBFzO9p8GvduXruz+FNLPyhc2YivHePsgViEoT1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez2KMrTBFzO9p8GvduXruz+FNLPyhc2YivHePsgViEoT1g@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, raven@themaw.net, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module <linux-security-module@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, casey@schaufler-ca.com
List-Id: linux-api@vger.kernel.org

On 5/29/2019 9:12 AM, Jann Horn wrote:
> On Wed, May 29, 2019 at 5:53 PM Casey Schaufler <casey@schaufler-ca.com=
> wrote:
>> On 5/29/2019 4:00 AM, David Howells wrote:
>>> Jann Horn <jannh@google.com> wrote:
>>>
>>>>> +void post_mount_notification(struct mount *changed,
>>>>> +                            struct mount_notification *notify)
>>>>> +{
>>>>> +       const struct cred *cred =3D current_cred();
>>>> This current_cred() looks bogus to me. Can't mount topology changes
>>>> come from all sorts of places? For example, umount_mnt() from
>>>> umount_tree() from dissolve_on_fput() from __fput(), which could
>>>> happen pretty much anywhere depending on where the last reference ge=
ts
>>>> dropped?
>>> IIRC, that's what Casey argued is the right thing to do from a securi=
ty PoV.
>>> Casey?
>> You need to identify the credential of the subject that triggered
>> the event. If it isn't current_cred(), the cred needs to be passed
>> in to post_mount_notification(), or derived by some other means.
>>
>>> Maybe I should pass in NULL creds in the case that an event is being =
generated
>>> because an object is being destroyed due to the last usage[*] being r=
emoved.
>> You should pass the cred of the process that removed the
>> last usage. If the last usage was removed by something like
>> the power being turned off on a disk drive a system cred
>> should be used. Someone or something caused the event. It can
>> be important who it was.
> The kernel's normal security model means that you should be able to
> e.g. accept FDs that random processes send you and perform
> read()/write() calls on them without acting as a subject in any
> security checks; let alone close().

Passed file descriptors are an anomaly in the security model
that (in this developer's opinion) should have never been
included. More than one of the "B" level UNIX systems disabled
them outright.=20

>  If you send a file descriptor over
> a unix domain socket and the unix domain socket is garbage collected,
> for example, I think the close() will just come from some random,
> completely unrelated task that happens to trigger the garbage
> collector?

I never said this was going to be easy or pleasant.
Who destroyed the UDS? It didn't just spontaneously become
garbage. Well, not on modern Linux filesystems, anyway.=20

> Also, I think if someone does I/O via io_uring, I think the caller's
> credentials for read/write operations will probably just be normal
> kernel creds?
>
> Here the checks probably aren't all that important, but in other
> places, when people try to use an LSM as the primary line of defense,
> checks that don't align with the kernel's normal security model might
> lead to a bunch of problems.

The kernel does not have a "normal security model". It has a
collection of disparate and almost but not quite contradictory
models for the various objects and mechanisms it implements.
It already has a bunch of problems, we're just used to them.

I can only send a signal to a process with the same UID. Why doesn't
a process have mode bits so that I could get signals from my group?

Why do IPC object have creator bits, while files don't?

Why can I send a file descriptor over a UDS, but not a message queue?

Why can't I set the mode bits on a symlink?

What can go wrong if I don't map groups into a user namespace?

LSMs (SELinux and Smack, which are classic mandatory access control
systems in particular) are more consistent, but still have to deal with
some of these differences. A symlink gets a Smack label, for example.

The point being that it's very easy to add new mechanisms that do
wonderful things but that introduce unforeseen ways to bypass one
or more of the existing protections.
