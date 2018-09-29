From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 2/3] namei: implement AT_THIS_ROOT chroot-like path resolution
Date: Sat, 29 Sep 2018 10:25:17 -0700
Message-ID: <F0E08B90-F10B-4897-913D-CA18E99A987D@amacapital.net>
References: <20180929103453.12025-1-cyphar@cyphar.com> <20180929131534.24472-1-cyphar@cyphar.com> <CAG48ez30WJhbsro2HOc_DR7V91M+hNFzBP5ogRMZaxbAORvqzg@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez30WJhbsro2HOc_DR7V91M+hNFzBP5ogRMZaxbAORvqzg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: cyphar@cyphar.com, "Eric W. Biederman" <ebiederm@xmission.com>, jlayton@kernel.org, Bruce Fields <bfields@fieldses.org>, Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, shuah@kernel.org, David Howells <dhowells@redhat.com>, Andy Lutomirski <luto@kernel.org>, christian@brauner.io, Tycho Andersen <tycho@tycho.ws>, kernel list <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>, linux-kselftest@vger.kernel.org, dev@opencontainers.org, containers@lists.linux-foundation.org, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org



> On Sep 29, 2018, at 9:35 AM, Jann Horn <jannh@google.com> wrote:
>=20
> +cc linux-api; please keep them in CC for future versions of the patch
>=20
>> On Sat, Sep 29, 2018 at 4:29 PM Aleksa Sarai <cyphar@cyphar.com> wrote:
>> The primary motivation for the need for this flag is container runtimes
>> which have to interact with malicious root filesystems in the host
>> namespaces. One of the first requirements for a container runtime to be
>> secure against a malicious rootfs is that they correctly scope symlinks
>> (that is, they should be scoped as though they are chroot(2)ed into the
>> container's rootfs) and ".."-style paths. The already-existing AT_XDEV
>> and AT_NO_PROCLINKS help defend against other potential attacks in a
>> malicious rootfs scenario.
>=20
> So, I really like the concept for patch 1 of this series (but haven't
> read the code yet); but I dislike this patch because of its footgun
> potential.
>=20

The code could do it differently: do the path walk and then, before acceptin=
g the result, walk back up and make sure the result is under the starting po=
int.

This is *not* a full solution, though, since a walk above the root gas side e=
ffects on timing, various caches, and possibly network traffic, so it=E2=80=99=
s open to Spectre-like attacks in which a malicious container could use a ru=
ntime-initiated AT_THIS_ROOT to infer the existence of directories outside t=
he container.

But what=E2=80=99s the container usecase?  Any sane container is based on pi=
vot_root or similar, so the runtime can just do the walk in the container co=
ntext. IOW I=E2=80=99m a bit confused as to the exact intended use of the wh=
ole series. Can you elaborate?=
