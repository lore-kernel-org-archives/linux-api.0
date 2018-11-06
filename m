From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH v6 1/1] ns: add binfmt_misc to the user namespace
Date: Tue, 6 Nov 2018 20:40:57 +0100
Message-ID: <CAG48ez1wz6tt2ZLBWgbkspirHYRUN7bAPmqf21jXgBx09G1K2A@mail.gmail.com>
References: <20181010161430.11633-1-laurent@vivier.eu> <20181010161430.11633-2-laurent@vivier.eu>
 <20181016162245.GA7697@gmail.com> <0fb09ce6-e006-31a2-1f32-f3f6eda44504@vivier.eu>
 <4a1ec0cf-dce7-4193-6946-d46d63398c2d@vivier.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4a1ec0cf-dce7-4193-6946-d46d63398c2d@vivier.eu>
Sender: linux-kernel-owner@vger.kernel.org
To: Laurent Vivier <laurent@vivier.eu>, Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Andrei Vagin <avagin@gmail.com>, kernel list <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, containers@lists.linux-foundation.org, dima@arista.com
List-Id: linux-api@vger.kernel.org

On Tue, Oct 30, 2018 at 9:51 AM Laurent Vivier <laurent@vivier.eu> wrote:
> Le 24/10/2018 =C3=A0 19:15, Laurent Vivier a =C3=A9crit :
> > On 16/10/2018 17:22, Andrei Vagin wrote:
> >> On Wed, Oct 10, 2018 at 06:14:30PM +0200, Laurent Vivier wrote:
> >>> This patch allows to have a different binfmt_misc configuration
> >>> for each new user namespace. By default, the binfmt_misc configuratio=
n
> >>> is the one of the previous level, but if the binfmt_misc filesystem i=
s
> >>> mounted in the new namespace a new empty binfmt instance is created a=
nd
> >>> used in this namespace.
> >>>
> >>> For instance, using "unshare" we can start a chroot of another
> >>> architecture and configure the binfmt_misc interpreter without being =
root
> >>> to run the binaries in this chroot.
> >>>
> >>> Signed-off-by: Laurent Vivier <laurent@vivier.eu>
> >>
> >> Acked-by: Andrei Vagin <avagin@gmail.com>
> >>
> >> Thanks,
> >> Andrei
> >>
> >
> > I don't konw who is the maintainer for this part,

I think Andrew Morton is the right maintainer here.

> > but is there any
> > chance to have this merged in 4.20?
> >
>
> I'd really want to have this merged.
>
> I have some real use cases for this:
>
> 1- to allow a non root user to run a container (with "unshare" for
> instance) with its own binfmt_misc configuration. For instance, like we
> provide a disk image and ask an ordinary user to run it with his
> favorite VM hypervisor, we can provide a tar.gz containing our own
> interpreter and just ask him to unshare+chroot to the exploded file tree,
>
> 2- to allow to run automatic tests of an interpreter on a machine
> without having to change the global configuration of the system. I have
> in mind to add some tests in Avocado to automatically test
> qemu-linux-user in containers, so the interpreter path can depend on the
> build path and possibly run them concurrently,
>
> 3- to select an interpreter by container. For instance, on the
> qemu-devel mailing list, we have a waiting patch to add the bFLT
> interpreter binfmt_misc configuration, but the bFLT doesn't provide the
> CPU type in magic/mask. So it would be interesting to be able to select
> also a bFLT interpreter by container, as we know the CPU architecture we
> have in each chroot/container,
>
> 4- another example to select an interpreter by container is qemu-mips
> and qemu-misn32 share the same magic/mask because only the kernel API
> changes, so we can't configure both on the system (but I agree it's a
> QEMU bug: they should be merged and the kernel API be selected at runtime=
).
